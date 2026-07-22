package com.korpay.model;

// import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.util.StringUtils;

// 응답에 새 필드가 추가되어도 Jackson 역직렬화 시 예외가 나지 않도록 알 수 없는 필드는 무시합니다.
// @JsonIgnoreProperties(ignoreUnknown = true)
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

    private String resultCode = "E999";
    private String message = "인증 실패";
    private String merchantId = "";
    private String orderNumber = "";
    private String amount = "";
    private String reserved = "";
    private String paymentKey = "";


    /*
     *******************************************************
     * 인증 성공 여부 체크 및 데이터 변조 검증
     *******************************************************
     */

    public boolean isAuthSuccess() {
        return "0000".equals(resultCode) && StringUtils.hasText(paymentKey);
    }

}
