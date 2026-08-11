<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
     * payMethod : 결제 요청 수단 ( card , easyPay , unified )
     * returnUrl : 응답 페이지
     *******************************************************
     */
    String merchantId = "";
    String merchantKey = "";
    String productName = "테스트 상품";
    String orderNumber = "testOrder" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + (int) (Math.random() * 10000);
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
     * card.code : 결제창에 표시할 카드사 (배열)
     * card.installment : 결제창에 표시할 할부개월 (배열)
     * card.visible : 카드 결제 섹션 표시 여부 (통합결제 시 사용)
     * card.direct : 카드 다이렉트 모드 여부
     * easyPay.code : 결제창에 표시할 간편결제사 (배열) — NAVERPAY, KAKAOPAY, TOSSPAY
     * easyPay.installment : 결제창에 표시할 할부개월 (배열)
     * easyPay.visible : 간편결제 섹션 표시 여부 (통합결제 시 사용)
     * easyPay.direct : 간편결제 다이렉트 모드 여부
     * ※ direct(다이렉트 모드)는 card / easyPay 중 하나에만 true로 설정할 수 있습니다.
     * subMerchant : 간편결제 시 필수 (List<Object>) — 통합결제 시 하위 MID에 간편결제가 있으면 필수
     *   businessNumber(종사업자 번호) / name(상호) / address(주소) / postalCode(우편번호)
     *   ※ 유상 포인트 간편결제 시, 현금영수증 발행 사업자 번호는 subMerchant의 마지막 인덱스 사업자 번호로 발행
     *   ※ 하위 가맹점을 관리하는 경우, 간편결제 시 전자금융거래법 제37조 제5항에 따라 하위 가맹점 정보를 함께 전송해야 합니다.
     *      하위 가맹점이 또 다른 하위 가맹점을 두는 다단계 구조라면, 상위 가맹점부터 최하위 종사업자까지 모든 단계의
     *      사업자 정보를 순서대로 subMerchant 배열에 담아야 하며, 최하위 종사업자가 마지막 인덱스에 오도록 구성합니다.
     *      단, 하위 가맹점 없이 직접 쇼핑몰을 운영하는 경우에는 쇼핑몰 사업자 정보를 입력합니다.
     *******************************************************
     */
    String customerName = "홍길동";
    String customerEmail = "test@korpay.com";
    String customerPhone = "16443475";
    String customerAddress = "서울특별시 성동구 성수일로 77 서울숲IT밸리 608호";
    String customerPost = "04790";
    String reserved = "예약필드 입니다. 결제 성공시 응답값에 포함됩니다.";
    String language = "ko";

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
                /*
                // card 옵션 (아래 [기본]/[다이렉트] 중 하나만 사용)
                // [기본] 카드사 목록 노출
                card: {
                    code: ['01', '02', '03', '04', '06', '07', '08', '12', '15'],
                    installment: [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                    visible: true,   // 통합결제(unified) 시 카드 섹션 표시 여부
                },
                // [다이렉트] 특정 카드사로 바로 진입 (code·installment는 단일 값, visible 없음)
                card: { direct: true, code: '04', installment: 0 },
                // easyPay 옵션 (아래 [기본]/[다이렉트] 중 하나만 사용)
                // [기본] 간편결제사 목록 노출
                easyPay: {
                    code: ['NAVERPAY', 'KAKAOPAY', 'TOSSPAY'],
                    installment: [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                    visible: true,   // 통합결제(unified) 시 간편결제 섹션 표시 여부
                },
                // [다이렉트] 특정 간편결제사로 바로 진입
                easyPay: { direct: true, code: 'TOSSPAY', installment: 0 },
                // ※ direct(다이렉트 모드)는 card / easyPay 중 하나에만 true로 설정할 수 있습니다.
                // subMerchant : 간편결제 시 필수! 통합결제(unified)여도 하위에 간편결제 MID가 포함되어 있으면 필수입니다.
                //   - 하위 가맹점을 관리하면 그 하위 가맹점의 사업자 정보도 함께 코페이로 전송해야 합니다.
                //   - 다단계 구조라면 상위부터 최하위 종사업자까지 모든 단계의 정보를 순서대로 담습니다. (최하위 종사업자 = 마지막 인덱스)
                //   - 하위 가맹점 없이 직접 가맹점을 운영한다면 가맹점 사업자 정보를 입력합니다.
                //   ※ 마지막 인덱스의 사업자 번호로 현금영수증이 발행됩니다.
                // 단일 사업자면 1개만, 다단계면 상위→최하위 순서로 여러 개 (아래는 2단계 예시)
                subMerchant: [
                    {
                        businessNumber: '1112223333',   // 상위 가맹점 (본사)
                        name: '상위 사업자 상호',
                        address: '상위 사업자 주소',
                        postalCode: '11111',
                    },
                    {
                        businessNumber: '4445556666',   // 최하위 종사업자 → 현금영수증 발행 대상 (마지막 인덱스)
                        name: '하위 사업자 상호',
                        address: '하위 사업자 주소',
                        postalCode: '22222',
                    },
                ],
                */
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