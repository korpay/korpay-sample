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
        /*
         * [Read Timeout 설정 안내]
         * 결제 승인(confirm) API 호출 시 Read Timeout 설정을 권장합니다.
         * 네트워크 지연 등으로 응답이 늦어질 때 무한 대기를 방지하기 위함입니다.
         * 권장 값: 60초
         * 단, 타임아웃이 발생하더라도 실제 승인은 정상 완료되었을 수 있으므로,
         * 타임아웃 시에는 결제 상태 조회 등으로 최종 결과를 반드시 확인해야 합니다.
         */
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
