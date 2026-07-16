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
 * $channelId : 통합 ID 하위 실 결제 Merchant Id (통합 ID 사용 시에만 포함)
 * $card :
        {
            $cardNumber : 카드 번호
            $approvalCode : 매입사 코드
            $installment : 승인 할부개월
            $approvalNumber : 승인 번호
            $cardAmount : 카드 사용 금액
        }
 * $easyPay : (간편결제로 결제한 경우에만 포함)
        {
            $moneyAmount : 간편결제 머니 사용 금액
            $pointAmount : 간편결제 포인트 사용 금액
            $provider : 간편결제 제공자 (NAVERPAY, KAKAOPAY, TOSSPAY)
        }

 * 결제 실패 응답
 * $resultCode : 결과 코드
 * $message : 결과 메세지
 *******************************************************
 */

/*
 *******************************************************
 * [결제 흐름 커스터마이징 안내]
 * 인증 성공 후 결제 승인(confirm) API를 곧바로 호출하는 것은 필수가 아닙니다.
 * 이 지점에서 고객사 정책에 맞게 결제 흐름을 자유롭게 구성할 수 있습니다.
 *   - (현재 샘플) 인증 직후 바로 승인 API를 호출하여 원스텝(one-step)으로 결제 완료
 *   - 고객사 자체 페이지를 노출하여 고객에게 최종 결제 의사를 한 번 더 확인(컨펌)한 뒤 승인 요청
 *   - 승인 처리 중 로딩(대기) 페이지를 노출한 뒤 승인 요청
 *
 * [중요 - 보안]
 * 결제 승인(confirm) 요청은 절대 클라이언트(브라우저/앱)에서 코페이로 직접 호출하지 마십시오.
 * 반드시 고객사 서버로 요청을 전달한 뒤, 고객사 서버 ↔ 코페이 간
 * 서버-투-서버(Server-to-Server) 통신으로 승인을 진행해야 합니다.
 * (클라이언트에서 직접 호출 시 결제 키·응답 위변조 등 보안 위험이 있습니다.)
 *
 * 단, 어떤 방식이든 실제 결제는 승인 API 응답으로 확정되며,
 * 금액 등 후속 처리는 반드시 승인 응답 데이터를 기준으로 해야 합니다.
 *******************************************************
 */

$paymentUrl = "https://BASE_URL/payments/confirm";

$ch = curl_init();
$queryString = http_build_query(['paymentKey' => $paymentKey]);
curl_setopt($ch, CURLOPT_URL, $paymentUrl . '?' . $queryString);
curl_setopt($ch, CURLOPT_POST, true);


// 개발환경 SSL 검증 무시
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

// 웹 방화벽 으로 인하여 User Agent 설정은 필수 입니다.
curl_setopt($ch, CURLOPT_USERAGENT, 'Korpay-Sample-PHP-Client');

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

/*
 * [Read Timeout 설정 안내]
 * 결제 승인(confirm) API 호출 시 Read Timeout 설정을 권장합니다.
 * 네트워크 지연 등으로 응답이 늦어질 때 무한 대기를 방지하기 위함입니다.
 * 권장 값: 60초
 * 단, 타임아웃이 발생하더라도 실제 승인은 정상 완료되었을 수 있으므로,
 * 타임아웃 시에는 결제 상태 조회 등으로 최종 결과를 반드시 확인해야 합니다.
 */
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);

//curl_close($ch);


$result = json_decode($response, true);

error_log("===== CURL DEBUG =====");
error_log("HTTP CODE : " . $httpCode);
error_log("CURL ERROR : " . $curlError);
error_log("Raw Response : " . $response);
error_log("===== API RESPONSE =====");
error_log(print_r($result, true));
error_log("========================");

$isApiSuccess = (!$curlError && $httpCode === 200 && isset($result['resultCode']) && $result['resultCode'] === '3001');

if (!$isApiSuccess) {
    header("Location: fail.php?orderNumber=" . $orderNumber);
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
