package com.korpay.service;

import com.google.gson.Gson;
import com.korpay.model.ApprovalResponse;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ClassicHttpRequest;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.io.support.ClassicRequestBuilder;
import org.springframework.stereotype.Service;
import org.apache.hc.core5.net.URIBuilder;
import java.net.URI;
import java.nio.charset.StandardCharsets;

@Service
public class ExampleService {

    private static final Gson gson = new Gson();
    private static final String paymentUrl = "https://BASE_URL/payments/confirm";

    public ApprovalResponse sendPaymentRequest(String paymentKey) {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {

            URI uri = new URIBuilder(paymentUrl)                                                                                           
                        .addParameter("paymentKey", paymentKey)
                        .build();
            ClassicHttpRequest httpPost = ClassicRequestBuilder.post(uri).build();

            return httpClient.execute(httpPost, response -> {
                String responseString = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
                return gson.fromJson(responseString, ApprovalResponse.class);
            });

        } catch (Exception e) {
            e.printStackTrace();
            return ApprovalResponse.builder()
                    .resultCode("E999")
                    .message("API 통신 오류")
                    .build();

        }
    }
}
