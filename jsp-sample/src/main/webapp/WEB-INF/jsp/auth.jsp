<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDate" %>
<%!
    /*
     *******************************************************
     * <인증요청 페이지>
     *
     * 필수 값
     * merchantId : MID
     * merchantKey : MKEY
     * productName : 상품명
     * orderNumber : 주문 번호
     * amount : 결제 요청 금액
     * payMethod : 결제 요청 수단(card 고정)
     * returnUrl : 응답 페이지
     *******************************************************
     */
    String merchantId = "";
    String merchantKey = "";
    String productName = "테스트 상품";
    String orderNumber = "test_order" + LocalDate.now() + (int) (Math.random() * 10000);
    int amount = 1004;
    String payMethod = "card";
    String returnUrl = "http://localhost:8080/confirm";

    /*
     *******************************************************
     * 옵션 값
     * customerName : 구매자 이름
     * customerEmail : 구매자 이메일
     * customerPhone : 구매자 전화번호
     * customerAddress : 구매자 주소
     * customerPost : 구매자 우편번호
     * reserved : 예약 필드
     * language : 언어
     * testMode : 테스트 결제
     * cardCode : 허용 카드사
     * installment : 허용 할부개월
     *******************************************************
     */
    String customerName = "홍길동";
    String customerEmail = "test@korpay.com";
    String customerPhone = "16443475";
    String customerAddress = "서울특별시 성동구 성수일로 77 서울숲IT밸리 608호";
    String customerPost = "04790";
    String reserved = "예약필드 입니다. 결제 성공시 응답값에 포함됩니다.";
    String language = "ko";
    String testMode = "true";
    String cardCode = "01:02:03:04:06:07:08:12:15";
    String installment = "00:02:03:04:05:06:07:08:09:10:11:12";

    /*
     *******************************************************
     * <해쉬암호화>
     * 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *******************************************************
     */
    String ediDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    String hashKey = "전문 PDF를 참고하여 암호화 키를 생성 합니다.";
%>


<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
    <title>결제 TEST</title>

    <script src="https://BASE_URL/js/korpay-sdk.js"></script>

    <style>
        body {
            background-color: #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .checkout-card {
            background: white;
            width: 100%;
            max-width: 380px;
            border-radius: 16px;
            overflow: hidden;
        }

        .card-header {
            padding: 25px;
            text-align: center;
        }

        .card-header h2 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 500;
        }

        .card-header .amount {
            font-size: 2rem;
            font-weight: bold;
            margin-top: 10px;
        }

        .card-body {
            padding: 30px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            color: #555;
            font-size: 0.95rem;
        }

        .info-row span:last-child {
            font-weight: 600;
            color: #333;
        }

        .divider {
            border-top: 1px dashed #ddd;
            margin: 20px 0;
        }

        .pay-btn {
            width: 100%;
            padding: 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .pay-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body style="margin: 0 auto">

<div class="checkout-card">
    <div class="card-header">
        <h2>결제 금액</h2>
        <div class="amount"><%=amount%>원</div>
    </div>
    <div class="card-body">
        <div class="info-row">
            <span>상품명</span>
            <span><%=productName%></span>
        </div>
        <div class="info-row">
            <span>주문번호</span>
            <span><%=orderNumber%></span>
        </div>


        <% if (customerName != null && !customerName.isEmpty()) { %>
            <div class="info-row">
                <span>구매자 명</span>
                <span><%=customerName%></span>
            </div>
        <% } %>

        <% if (customerEmail != null && !customerEmail.isEmpty()) { %>
            <div class="info-row">
                <span>구매자 이메일</span>
                <span><%=customerEmail%></span>
            </div>
        <% } %>

        <% if (customerPhone != null && !customerPhone.isEmpty()) { %>
            <div class="info-row">
                <span>구매자 전화번호</span>
                <span><%=customerPhone%></span>
            </div>
        <% } %>

        <% if (customerAddress != null && !customerAddress.isEmpty()) { %>
            <div class="info-row">
                <span>구매자 주소</span>
                <span><%=customerAddress%></span>
            </div>
        <% } %>

        <% if (customerPost != null && !customerPost.isEmpty()) { %>
            <div class="info-row">
                <span>구매자 우편번호</span>
                <span><%=customerPost%></span>
            </div>
        <% } %>


        <div class="divider"></div>
        <button id="payBtn" class="pay-btn">결제하기</button>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const payBtn = document.getElementById('payBtn');

        payBtn.addEventListener('click', () => {
            const paymentData = {
                merchantId: '<%=merchantId%>',
                productName: '<%=productName%>',
                orderNumber: '<%=orderNumber%>',
                amount: '<%=amount%>',
                payMethod: '<%=payMethod%>',
                returnUrl: '<%=returnUrl%>',
                ediDate: '<%=ediDate%>',
                hashKey: '<%=hashKey%>',

                /* Options */
                customerName: '<%=customerName%>',
                customerEmail: '<%=customerEmail%>',
                customerPhone: '<%=customerPhone%>',
                customerAddress: '<%=customerAddress%>',
                customerPost: '<%=customerPost%>',
                reserved: '<%=reserved%>',
                language: '<%=language%>',
                testMode: '<%=testMode%>',
                cardCode: '<%=cardCode%>',
                installment: '<%=installment%>',
            };

            KorpaySDK.payment("https://BASE_URL", paymentData, {
                onStart: () => {
                    payBtn.disabled = true;
                    payBtn.innerText = "결제창 호출 중...";
                },
                onError: (err) => {
                    alert(err);
                    payBtn.disabled = false;
                    payBtn.innerText = "결제하기";
                },
                onClose: () => {
                    payBtn.disabled = false;
                    payBtn.innerText = "결제하기";
                }
            });
        });
    });
</script>

</body>
</html>