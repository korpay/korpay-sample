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
     * moneyAmount : 간편결제 머니 사용 금액 <br>
     * pointAmount : 간편결제 포인트 사용 금액 <br>
     * provider : 간편결제 제공자 (NAVERPAY, KAKAOPAY, TOSSPAY) <br>
     */

    Integer moneyAmount;
    Integer pointAmount;
    String provider;
}
