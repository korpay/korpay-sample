package com.korpay.model;

// import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.NoArgsConstructor;

// 응답에 새 필드가 추가되어도 Jackson 역직렬화 시 예외가 나지 않도록 알 수 없는 필드는 무시합니다.
// @JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@NoArgsConstructor
public class EasyPayResponse {

    /**
     * <b>간편결제 응답 파라미터</b> (간편결제로 결제한 경우에만 포함) <br>
     * moneyAmount : 유상 포인트 결제 금액 <br>
     * pointAmount : 무상 포인트 결제 금액 <br>
     * provider : 간편결제사 코드 (NAVERPAY, KAKAOPAY, TOSSPAY) <br>
     */

    private Integer moneyAmount;
    private Integer pointAmount;
    private String provider;
}
