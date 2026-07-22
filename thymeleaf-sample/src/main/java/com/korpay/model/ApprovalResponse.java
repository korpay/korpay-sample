package com.korpay.model;

// import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.*;

/*
 *******************************************************
 * [중요] 응답 필드 추가에 대한 호환성
 * 결제 응답에 향후 새로운 필드가 추가될 수 있습니다.
 * Jackson(ObjectMapper) 으로 역직렬화하는 경우,
 * 기본 설정(FAIL_ON_UNKNOWN_PROPERTIES=true)에서는
 * 모델에 정의되지 않은 필드가 들어오면 예외가 발생합니다.
 * 아래 @JsonIgnoreProperties(ignoreUnknown = true) 로 항상 무시하도록 합니다.
 * (현재 샘플은 Gson 을 사용하며, Gson 은 알 수 없는 필드를 기본적으로 무시합니다)
 *******************************************************
 */
// @JsonIgnoreProperties(ignoreUnknown = true)
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
     * channelId : 통합 ID 하위 실 결제 Merchant Id (통합 ID 사용 시에만 포함) <br>
     * card : {@link CardResponse} <br>
     * easyPay : {@link EasyPayResponse} (간편결제로 결제한 경우에만 포함) <br>
     * <br>
     * <b>결제 실패 응답</b> <br>
     * resultCode : 결과 코드 <br>
     * message : 결과 메세지 <br>
     *******************************************************
     */

    private String resultCode;
    private String message;

    private String tid;
    private String merchantId;
    private String orderNumber;
    private String productName;
    private String currency;
    private Integer amount;
    private String approvedAt;
    private String payMethod;
    private String reserved;
    private String channelId;

    private CardResponse card;
    private EasyPayResponse easyPay;
}
