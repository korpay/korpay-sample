<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Optional" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ page import="java.net.*, java.io.*, java.nio.charset.StandardCharsets, java.util.*" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.hc.client5.http.impl.classic.CloseableHttpClient" %>
<%@ page import="org.apache.hc.client5.http.impl.classic.HttpClients" %>
<%@ page import="org.apache.hc.core5.net.URIBuilder" %>
<%@ page import="org.apache.hc.core5.http.io.entity.EntityUtils" %>
<%@ page import="org.apache.hc.core5.http.io.support.ClassicRequestBuilder" %>
<%@ page import="org.apache.hc.core5.http.ClassicHttpRequest" %>

<%!
    private static final Gson gson = new Gson();

    public JsonObject sendPaymentRequest(String apiUrl, String paymentKey) {
        /*
         * [Read Timeout 설정 안내]
         * 결제 승인(confirm) API 호출 시 Read Timeout 설정을 권장합니다.
         * 네트워크 지연 등으로 응답이 늦어질 때 무한 대기를 방지하기 위함입니다.
         * 권장 값: 60초
         * 단, 타임아웃이 발생하더라도 실제 승인은 정상 완료되었을 수 있으므로,
         * 타임아웃 시에는 결제 상태 조회 등으로 최종 결과를 반드시 확인해야 합니다.
         */
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {

            URI uri = new URIBuilder(apiUrl)                                                                                               
                        .addParameter("paymentKey", paymentKey)
                        .build();                                                                                                              
            ClassicHttpRequest httpPost = ClassicRequestBuilder.post(uri).build();

            JsonObject execute = httpClient.execute(httpPost, response -> {
                String responseString = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
                JsonObject json = gson.fromJson(responseString, JsonObject.class);

                return json;
            });

            return execute;

        } catch (Exception e) {
            e.printStackTrace();
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("resultCode", "E999");
            jsonObject.addProperty("message", "API 통신 오류");
            return jsonObject;
        }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    /*
     *******************************************************
     * 1. 인증 응답 파라미터 수신
     *
     * resultCode : 결과코드
     * message : 결과 메세지
     * merchantId : MID
     * orderNumber : 주문번호
     * amount : 결제 요청 금액
     * reserved : 예약 필드
     * paymentKey : 실 결제에 필요한 결제 암호화 키
     *******************************************************
     */

    String resultCode = Optional.ofNullable(request.getParameter("resultCode")).orElse("E999");
    String message = Optional.ofNullable(request.getParameter("message")).orElse("인증 실패");
    String merchantId = Optional.ofNullable(request.getParameter("merchantId")).orElse("");
    String orderNumber = Optional.ofNullable(request.getParameter("orderNumber")).orElse("");
    String amount = Optional.ofNullable(request.getParameter("amount")).orElse("");
    String reserved = Optional.ofNullable(request.getParameter("reserved")).orElse("");
    String paymentKey = Optional.ofNullable(request.getParameter("paymentKey")).orElse("");


    /*
     *******************************************************
     * 2. 인증 성공 여부 체크 및 데이터 변조 검증
     *******************************************************
     */

    boolean isAuthSuccess = "0000".equals(resultCode) && StringUtils.hasText(paymentKey);
    if (!isAuthSuccess) {
        System.out.println(message);
        response.sendRedirect("fail?orderNumber=" + orderNumber);
        return;
    }

    /*
     *******************************************************
     * 3. [중요] DB 중복 결제 방지 로직
     *******************************************************
     * 사용자가 '뒤로가기' 후 다시 들어왔을 때를 대비하여
     * 승인 API를 날리기 전에 이미 처리된 주문인지 확인합니다.
     * 또는 PRG 패턴을 적용합니다. ( 해당 샘플 파일에서는 PRG 패턴이 적용되어있습니다. )

        String dbStatus = orderTableDao.selectStatus(orderNumber);
        // 이미 결제된 건이면 승인 요청 건너뛰고 바로 성공 페이지로
        if ("PAID".equals(dbStatus)) {
            response.sendRedirect("success?orderNumber=" + orderNumber);
            return;
        }

     */

    /*
     *******************************************************
     * [결제 흐름 커스터마이징 안내]
     * 인증 성공 후 결제 승인(confirm) API를 곧바로 호출하는 것은 필수가 아닙니다.
     * 이 지점에서 고객사 정책에 맞게 결제 흐름을 자유롭게 구성할 수 있습니다.
     *   - (현재 샘플) 인증 직후 바로 승인 API를 호출하여 원스텝(one-step)으로 결제 완료
     *   - 고객사 자체 페이지를 노출하여 고객에게 최종 결제 의사를 한 번 더 확인(컨펌)한 뒤 승인 요청
     *   - 승인 처리 중 로딩(대기) 페이지를 노출한 뒤 승인 요청
     *
     * [중요 - 보안]
     * 결제 승인(confirm) 요청은 절대 클라이언트(브라우저/앱)에서 코페이로 직접 호출하지 마십시오.
     * 반드시 고객사 서버로 요청을 전달한 뒤, 고객사 서버 ↔ 코페이 간
     * 서버-투-서버(Server-to-Server) 통신으로 승인을 진행해야 합니다.
     * (클라이언트에서 직접 호출 시 결제 키·응답 위변조 등 보안 위험이 있습니다.)
     *
     * 단, 어떤 방식이든 실제 결제는 승인 API 응답으로 확정되며,
     * 금액 등 후속 처리는 반드시 승인 응답 데이터를 기준으로 해야 합니다.
     *******************************************************
     */

    /*
     *******************************************************
     * 4. 결제 승인 API 요청
     *
     * [중요]
     * 데이터 위·변조 방지를 위해
     * 금액 처리 등 후속 처리 시에는
     * 인증 응답 데이터가 아닌 승인 응답 데이터를 사용해야 합니다.
     *
     * 결제 성공 응답
     * resultCode : 결과 코드
     * message : 결과 메세지
     * tid : 결제 고유 번호
     * merchantId : MID
     * orderNumber : 주문번호
     * productName : 상품명
     * currency : 결제 통화
     * amount : 승인 금액
     * approvedAt : 승인 일시
     * payMethod : 결제 수단
     * reserved : 예약 필드
     * card :
            {
                cardNumber : 카드 번호
                approvalCode : 매입사 코드
                installment : 승인 할부개월
                approvalNumber : 승인 번호
                usePointAmt : 사용 포인트
                remainPointAmt : 잔액 포인트
            }

     * 결제 실패 응답
     * resultCode : 결과 코드
     * message : 결과 메세지
     *******************************************************
     */

    String paymentUrl = "https://BASE_URL/payments/confirm";

    JsonObject result = sendPaymentRequest(paymentUrl, paymentKey);

    System.out.println("===== API RESPONSE =====");
    System.out.println(result.toString());
    System.out.println("========================");

    boolean isApiSuccess = result.has("resultCode") && "3001".equals(result.get("resultCode").getAsString());

    if (!isApiSuccess) {
        response.sendRedirect("fail?orderNumber=" + orderNumber);
        return;
    }

    
    /**
     * [DB INSERT / UPDATE]
     * 여기서 결제 완료 처리를 수행합니다.
     * 예: UPDATE orderTable SET status = 'PAID', amount = $result['amount'] ...  WHERE order_no = '$result['orderNumber']' ...
     */
    response.sendRedirect("success?orderNumber=" + orderNumber);
    
%>

