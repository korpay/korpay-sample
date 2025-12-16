package com.korpay.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.util.StringUtils;

@Getter
@Setter
@NoArgsConstructor
public class AuthResponse {

    /**
     *******************************************************
     * <b>인증 응답 파라미터</b> <br>
     * resultCode : 결과코드 <br>
     * message : 결과 메세지 <br>
     * merchantId : MID <br>
     * orderNumber : 주문번호 <br>
     * amount : 결제 요청 금액 <br>
     * reserved : 예약 필드 <br>
     * paymentKey : 실 결제에 필요한 결제 암호화 키 <br>
     *******************************************************
     */

    String resultCode = "E999";
    String message = "인증 실패";
    String merchantId = "";
    String orderNumber = "";
    String amount = "";
    String reserved = "";
    String paymentKey = "";


    /*
     *******************************************************
     * 인증 성공 여부 체크 및 데이터 변조 검증
     *******************************************************
     */

    public boolean isAuthSuccess() {
        return "0000".equals(resultCode) && StringUtils.hasText(paymentKey);
    }

}
