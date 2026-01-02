package com.korpay.model;

import lombok.*;

@Getter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ApprovalResponse {

    /**
     *******************************************************
     * <b>결제 승인 API 요청</b> <br>
     * <br>
     * <b>
     *  [중요] <br>
     *  데이터 위·변조 방지를 위해 <br>
     *  금액 처리 등 후속 처리 시에는 <br>
     *  인증 응답 데이터가 아닌 승인 응답 데이터를 사용해야 합니다. <br>
     * </b>
     * <br>
     * <b>결제 성공 응답</b> <br>
     * resultCode : 결과 코드 <br>
     * message : 결과 메세지 <br>
     * tid : 결제 고유 번호 <br>
     * merchantId : MID <br>
     * orderNumber : 주문번호 <br>
     * productName : 상품명 <br>
     * currency : 결제 통화 <br>
     * amount : 승인 금액 <br>
     * approvedAt : 승인 일시 <br>
     * payMethod : 결제 수단 <br>
     * reserved : 예약 필드 <br>
     * card : {@link CardResponse} <br>
     * <br>
     * <b>결제 실패 응답</b> <br>
     * resultCode : 결과 코드 <br>
     * message : 결과 메세지 <br>
     *******************************************************
     */

    String resultCode = "";
    String message;

    String tid;
    String merchantId;
    String orderNumber;
    String productName;
    String currency;
    Integer amount;
    String approvedAt;
    String payMethod;
    String reserved;

    CardResponse card;
}
