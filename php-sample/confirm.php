<?php
header("Content-Type:text/html; charset=utf-8;");
/*
 *******************************************************
 * 1. 인증 응답 파라미터 수신
 *
 * $resultCode : 결과코드
 * $message : 결과 메세지
 * $merchantId : MID
 * $orderNumber : 주문번호
 * $amount : 결제 요청 금액
 * reserved : 예약 필드
 * $paymentKey : 실 결제에 필요한 결제 암호화 키
 *******************************************************
 */
$resultCode = $_POST['resultCode'] ?? 'E999';
$message = $_POST['message'] ?? '인증 실패';
$merchantId = $_POST['merchantId'] ?? '';
$orderNumber = $_POST['orderNumber'] ?? '';
$amount = $_POST['amount'] ?? '';
$reserved = $_POST['reserved'] ?? '';
$paymentKey = $_POST['paymentKey'] ?? '';

/*
 *******************************************************
 * 2. 인증 성공 여부 체크
 *******************************************************
 */
$isAuthSuccess = ($resultCode === '0000' && !empty($paymentKey));

if (!$isAuthSuccess) {
    error_log(print_r($message, true));
    header("Location: fail.php?orderNumber=" . $orderNumber);
    exit;
}

/*
 *******************************************************
 * 3. [중요] DB 중복 결제 방지 로직
 *******************************************************
 * 사용자가 '뒤로가기' 후 다시 들어왔을 때를 대비하여
 * 승인 API를 날리기 전에 이미 처리된 주문인지 확인합니다.
 * 또는 PRG 패턴을 적용합니다. ( 해당 샘플 파일에서는 PRG 패턴이 적용되어있습니다. )

     $dbOrder = $db->query("SELECT status,amount FROM orderTable WHERE order_no = '$orderNumber'");
     // 이미 결제된 건이면 승인 요청 건너뛰고 바로 성공 페이지로
     if ($dbOrder['status'] === 'PAID') {
         header("Location: success.php?orderNumber=" . $orderNumber);
         exit;
     }

 */

/*
 *******************************************************
 * 4. 결제 승인 API 요청
 *
 * [중요]
 * 데이터 위·변조 방지를 위해
 * 금액 처리 등 후속 처리 시에는
 * 인증 응답 데이터가 아닌 승인 응답 데이터를 사용해야 합니다.
 *
 * 결제 성공 응답
 * $resultCode : 결과 코드
 * $message : 결과 메세지
 * $tid : 결제 고유 번호
 * $merchantId : MID
 * $orderNumber : 주문번호
 * $productName : 상품명
 * $currency : 결제 통화
 * $amount : 승인 금액
 * $approvedAt : 승인 일시
 * $payMethod : 결제 수단
 * $reserved : 예약 필드
 * $card :
        {
            $approvalCode : 발급사 코드
            $installment : 승인 할부개월
            $approvalNumber : 승인 번호
            $usePointAmt : 사용 포인트
            $remainPointAmt : 잔액 포인트
        }

 * 결제 실패 응답
 * $resultCode : 결과 코드
 * $message : 결과 메세지
 *******************************************************
 */

$paymentUrl = "https://BASE_URL/payments/confirm";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $paymentUrl);
curl_setopt($ch, CURLOPT_POST, true);

// 개발환경 SSL 검증 무시
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);


curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
        'paymentKey' => $paymentKey,
]));
// 웹 방화벽 으로 인하여 User Agent 설정은 필수 입니다.
curl_setopt($ch, CURLOPT_USERAGENT, 'Korpay-Sample-PHP-Client');

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);

//curl_close($ch);


$result = json_decode($response, true);

error_log("===== API RESPONSE =====");
error_log(print_r($result, true));
error_log("========================");

$isApiSuccess = (!$curlError && $httpCode === 200 && isset($result['resultCode']) && $result['resultCode'] === '3001');

if (!$isApiSuccess) {
    header("Location: fail.php?orderNumber=" . $orderNumber);
    exit;
}

/*
*******************************************************
* 5. [중요] 테스트 결제 여부 체크 및 데이터 변조 검증
*******************************************************
*/
$approvalNumber = $result['card']['approvalNumber'] ?? '';
if ($approvalNumber === '00000000') {
    header("Location: success.php?orderNumber=" . $orderNumber . "&test=true");
    exit;
}

/**
 * [DB INSERT / UPDATE]
 * 여기서 결제 완료 처리를 수행합니다.
 * 예: UPDATE orderTable SET status = 'PAID', amount = $result['amount'] ...  WHERE order_no = '$result['orderNumber']' ...
 */

header("Location: success.php?orderNumber=" . $orderNumber);
exit;

?>
