package com.korpay.model;

import lombok.Getter;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.concurrent.ThreadLocalRandom;

@Getter
public class AuthRequest {

    /**
     *******************************************************
     * <b>인증 요청 파라미터</b> <br>
     * <br>
     * <b>필수 값</b> <br>
     * merchantId : MID <br>
     * merchantKey : MKEY <br>
     * productName : 상품명 <br>
     * orderNumber : 주문 번호 <br>
     * amount : 결제 요청 금액 <br>
     * payMethod : 결제 요청 수단 ( card , easyPay , unified ) <br>
     * returnUrl : 응답 페이지 <br>
     *******************************************************
     */
    private String merchantId = "";
    private String merchantKey = "";
    private String productName = "테스트 상품";
    private String orderNumber = "testOrder" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ThreadLocalRandom.current().nextInt(1000);
    private int amount = 1004;
    private String payMethod = "card";
    private String returnUrl = "http://localhost:8080/confirm";

    /**
     *******************************************************
     * <b>옵션 값</b> <br>
     * customerName : 구매자 이름 <br>
     * customerEmail : 구매자 이메일 <br>
     * customerPhone : 구매자 전화번호 <br>
     * customerAddress : 구매자 주소 <br>
     * customerPost : 구매자 우편번호 <br>
     * reserved : 예약 필드 <br>
     * language : 언어 <br>
     * card.code : 결제창에 표시할 카드사 <br>
     * card.installment : 결제창에 표시할 할부개월 <br>
     * card.visible : 카드 결제 섹션 표시 여부 (통합결제 시 사용) <br>
     * card.direct : 카드 다이렉트 모드 여부 <br>
     * easyPay.code : 결제창에 표시할 간편결제사 (NAVERPAY, KAKAOPAY, TOSSPAY) <br>
     * easyPay.installment : 결제창에 표시할 할부개월 <br>
     * easyPay.visible : 간편결제 섹션 표시 여부 (통합결제 시 사용) <br>
     * easyPay.direct : 간편결제 다이렉트 모드 여부 <br>
     * ※ direct(다이렉트 모드)는 card / easyPay 중 하나에만 true로 설정할 수 있습니다. <br>
     * subMerchant : 간편결제 시 필수 (List&lt;Object&gt;) — 통합결제 시 하위 MID에 간편결제가 있으면 필수 <br>
     *   businessNumber(종사업자 번호) / name(상호) / address(주소) / postalCode(우편번호) <br>
     *   ※ 유상 포인트 간편결제 시, 현금영수증 발행 사업자 번호는 subMerchant의 마지막 인덱스 사업자 번호로 발행 <br>
     *   ※ 하위 가맹점을 관리하는 경우, 간편결제 시 전자금융거래법 제37조 제5항에 따라 하위 가맹점 정보를 함께 전송해야 합니다. <br>
     *      하위 가맹점이 또 다른 하위 가맹점을 두는 다단계 구조라면, 상위 가맹점부터 최하위 종사업자까지 모든 단계의 <br>
     *      사업자 정보를 순서대로 subMerchant 배열에 담아야 하며, 최하위 종사업자가 마지막 인덱스에 오도록 구성합니다. <br>
     *      단, 하위 가맹점 없이 직접 쇼핑몰을 운영하는 경우에는 쇼핑몰 사업자 정보를 입력합니다. <br>
     *******************************************************
     */
    private String customerName = "홍길동";
    private String customerEmail = "test@korpay.com";
    private String customerPhone = "16443475";
    private String customerAddress = "서울특별시 성동구 성수일로 77 서울숲IT밸리 608호";
    private String customerPost = "04790";
    private String reserved = "예약필드 입니다. 결제 성공시 응답값에 포함됩니다.";
    private String language = "ko";
    
    /*
    // ※ direct(다이렉트 모드)는 card / easyPay 중 하나에만 true로 설정할 수 있습니다.
    CardOptions card = new CardOptions();
    EasyPayOptions easyPay = new EasyPayOptions();

    // subMerchant : 간편결제 시 필수! 통합결제(unified)여도 하위에 간편결제 MID가 포함되어 있으면 필수입니다.
    //   - 하위 가맹점을 관리하면 그 하위 가맹점의 사업자 정보도 함께 코페이로 전송해야 합니다.
    //   - 다단계 구조라면 상위부터 최하위 종사업자까지 모든 단계의 정보를 순서대로 담습니다. (최하위 종사업자 = 마지막 인덱스)
    //   - 하위 가맹점 없이 직접 가맹점을 운영한다면 가맹점 사업자 정보를 입력합니다.
    //   ※ 마지막 인덱스의 사업자 번호로 현금영수증이 발행됩니다.
    // 단일 사업자면 1개만, 다단계면 상위→최하위 순서로 여러 개 (아래는 2단계 예시)
    List<SubMerchant> subMerchant = Arrays.asList(
        new SubMerchant(1112223333, "상위 사업자 상호", "상위 사업자 주소", 11111),   // 상위 가맹점 (본사)
        new SubMerchant(4445556666, "하위 사업자 상호", "하위 사업자 주소", 22222)    // 최하위 종사업자 → 현금영수증 발행 대상 (마지막 인덱스)
    );

    @Getter
    public static class CardOptions {
        private List<String> code = Arrays.asList("01", "02", "03", "04", "06", "07", "08", "12", "15");
        private List<Integer> installment = Arrays.asList(0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
        private Boolean visible = true;   // 통합결제(unified) 시 카드 섹션 표시 여부
        private Boolean direct = false;   // 카드 다이렉트 모드
    }

    @Getter
    public static class EasyPayOptions {
        private List<String> code = Arrays.asList("NAVERPAY", "KAKAOPAY", "TOSSPAY");
        private List<Integer> installment = Arrays.asList(0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
        private Boolean visible = true;   // 통합결제(unified) 시 간편결제 섹션 표시 여부
        private Boolean direct = false;   // 간편결제 다이렉트 모드
    }

    @Getter
    @AllArgsConstructor
    public static class SubMerchant {
        private Integer businessNumber;   // 종사업자 번호
        private String name;              // 상호
        private String address;           // 주소
        private Integer postalCode;       // 종사업자 우편번호
    }
    */

    /*
     *******************************************************
     * <해쉬암호화> (수정하지 마세요)
     * SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *******************************************************
     */
    private String ediDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    private String hashKey = "전문 PDF를 참고하여 암호화 키를 생성 합니다.";
}
