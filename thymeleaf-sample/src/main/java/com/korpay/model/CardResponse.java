package com.korpay.model;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CardResponse {

    /**
     * <b>카드 응답 파라미터</b> <br>
     * approvalCode : 발급사 코드 <br>
     * installment : 승인 할부개월 <br>
     * approvalNumber : 승인 번호 <br>
     * usePointAmt : 사용 포인트 <br>
     * remainPointAmt : 잔액 포인트 <br>
     */
    
    String approvalCode;
    String installment;
    String approvalNumber;
    String usePointAmt;
    String remainPointAmt;
}
