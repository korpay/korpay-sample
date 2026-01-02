import {NextRequest} from "next/server";
import {redirect} from "next/navigation";

export async function POST(request: NextRequest) {

    const localUrl = `http://localhost:3000/`;

    /*
    *******************************************************
    * 1. 파라미터 수신
    *
    * resultCode : 결과코드
    * message : 결과 메세지
    * merchantId : MID
    * orderNumber : 주문번호
    * amount : 결제 요청 금액
    * reserved : 예약 필드
    * paymentKey : 실 결제에 필요한 결제 암호화 키
    *******************************************************
    */

    const data = Object.fromEntries(await request.formData()) as Record<string, string>

    const {
        resultCode = 'E999',
        message = '인증 실패',
        merchantId = '',
        orderNumber = '',
        amount = '',
        paymentKey = ''
    } = data

    /*
    *******************************************************
    * 2. 인증 성공 여부 체크 및 데이터 변조 검증
    *******************************************************
    */

    const isAuthSuccess = (resultCode === '0000' && paymentKey);
    if (!isAuthSuccess) {
        console.error(message);
        const redirectUrl = `${localUrl}fail?orderNumber=${orderNumber}`;
        return redirect(redirectUrl);
    }

    /*
    *******************************************************
    * 3. [중요] DB 중복 결제 방지 로직
    *******************************************************
    * 사용자가 '뒤로가기' 후 다시 들어왔을 때를 대비하여
    * 승인 API를 날리기 전에 이미 처리된 주문인지 확인합니다.
    * 또는 PRG 패턴을 적용합니다. ( 해당 샘플 파일에서는 PRG패턴이 적용되어있습니다. )


        const [rows , fields] = await pool.query('SELECT status FROM orderTable WHERE order_no = ?',[orderNumber]);
        // 이미 결제된 건이면 승인 요청 건너뛰고 바로 성공 페이지로
        if (rows.length > 0 && rows[0].status === 'PAID') {
            const redirectUrl = `${baseUrl}fail?orderNumber=${orderNumber}`;
            return res.redirect(redirectUrl);
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
    * resultCode : 결과 코드
    * message : 결과 메세지
    * tid : 결제 고유 번호
    * merchantId : MID
    * orderNumber : 주문번호
    * productName : 상품명
    * currency : 결제 통화
    * amount : 승인 금액
    * approvedAt : 승인 일시
    * payMethod : 결제 수단
    * reserved : 예약 필드
    * card :
            {
                approvalCode : 발급사 코드
                installment : 승인 할부개월
                approvalNumber : 승인 번호
                usePointAmt : 사용 포인트
                remainPointAmt : 잔액 포인트
            }

    * 결제 실패 응답
    * resultCode : 결과 코드
    * message : 결과 메세지
    *******************************************************
    */

    const paymentUrl = 'https://BASE_URL/payments/confirm';

    let httpCode;
    let result;

    try {
        const response = await fetch(paymentUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                paymentKey,
            })
        });

        httpCode = response.status;

        const text = await response.text();
        result = JSON.parse(text);
    } catch (err) {
        result = err;
        console.error('fetch error:', err);
    }

    console.log('===== API RESPONSE =====');
    console.log(result);
    console.log('========================');

    const isApiSuccess = (httpCode === 200 && result?.resultCode === '3001');

    if (isApiSuccess) {
        /**
         * [DB INSERT / UPDATE]
         * 여기서 결제 완료 처리를 수행합니다.
         * 예: UPDATE orderTable SET status = 'PAID', amount = `${result.amount}` ...  WHERE order_no = `${result.orderNumber}` ...
         */
        return redirect(`${localUrl}/success?orderNumber=${orderNumber}`);
    } else {
        return redirect(`${localUrl}/fail?orderNumber=${orderNumber}`);
    }
}