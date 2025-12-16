package com.korpay.model;

import lombok.Getter;

@Getter
public class CancelRequest {

    /**
     *******************************************************
     * <b>취소 요청 파라미터</b> <br>
     * <br>
     * <b>필수 값</b> <br>
     * tid : 결제 고유 번호 <br>
     * mid : MID <br>
     * canAmt : 취소 요청 금액 <br>
     * partCanFlg : 부분 취소 여부 [ 0 : 전체 , 1 : 부분 ] <br>
     * payMethod : 결제 수단 <br>
     *******************************************************
     */
    String tid = "";
    String mid = "";
    String canAmt = "1004";
    String partCanFlg = "0";
    String payMethod = "card";

    /**
     *******************************************************
     * <b>옵션 값</b> <br>
     * canId : 취소자 ID <br>
     * canNm : 취소자 이름 <br>
     * canMsg : 취소 사유 <br>
     *******************************************************
     */
    String canId = "CancelTest";
    String canNm = "취소테스트";
    String canMsg = "고객요청";

    String cancelApiUrl = "https://pgapi.korpay.com/cancelTransJson.do";
}
