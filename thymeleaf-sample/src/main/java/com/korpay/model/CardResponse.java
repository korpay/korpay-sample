package com.korpay.model;

// import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.NoArgsConstructor;

// 응답에 새 필드가 추가되어도 Jackson 역직렬화 시 예외가 나지 않도록 알 수 없는 필드는 무시합니다.
// @JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@NoArgsConstructor
public class CardResponse {

    /**
     * <b>카드 응답 파라미터</b> <br>
     * cardNumber : 카드 번호 <br>
     * approvalCode : 매입사 코드 <br>
     * installment : 승인 할부개월 <br>
     * approvalNumber : 승인 번호 <br>
     * usePointAmt : 사용 포인트 <br>
     * remainPointAmt : 잔액 포인트 <br>
     * cardAmount : 카드 사용 금액 <br>
     */

    String cardNumber;
    String approvalCode;
    String installment;
    String approvalNumber;
    String usePointAmt;
    String remainPointAmt;
    Integer cardAmount;
}
