package com.korpay.model;

import lombok.Getter;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;

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
     * payMethod : 결제 요청 수단 (card 고정) <br>
     * returnUrl : 응답 페이지 <br>
     *******************************************************
     */
    String merchantId = "";
    String merchantKey = "";
    String productName = "테스트 상품";
    String orderNumber = "testOrder" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ThreadLocalRandom.current().nextInt(1000);
    int amount = 1004;
    String payMethod = "card";
    String returnUrl = "http://localhost:8080/confirm";

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
     * testMode : 테스트 결제 <br>
     * cardCode : 허용 카드사 <br>
     * installment : 허용 할부개월 <br>
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
     * <해쉬암호화> (수정하지 마세요)
     * SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *******************************************************
     */
    String ediDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    String hashKey = "전문 PDF를 참고하여 암호화 키를 생성 합니다.";
}
