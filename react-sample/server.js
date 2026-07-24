import express from 'express';
import cors from 'cors';
import { getCurrentDateTime, random } from './functionUtils.js';

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.post('/api/payment/info', (_, res) => {

    /*
     *******************************************************
     * <인증요청 데이터 준비>
     *
     * 필수 값
     * merchantId : MID
     * merchantKey : MKEY
     * productName : 상품명
     * orderNumber : 주문 번호
     * amount : 결제 요청 금액
     * payMethod : 결제 요청 수단 ( card , easyPay , unified )
     * returnUrl : 응답 페이지
     *******************************************************
    */

    const merchantId = ''
    const merchantKey = '';
    const productName = '테스트 상품';
    const orderNumber = `testOrder${getCurrentDateTime()}${random()}`
    const amount = 1004;
    const payMethod = 'card';
    const returnUrl = 'http://localhost:3001/confirm';

    /*
     ******************************************************
      옵션 값
     * customerName : 구매자 이름
     * customerEmail : 구매자 이메일
     * customerPhone : 구매자 전화번호
     * customerAddress : 구매자 주소
     * customerPost : 구매자 우편번호
     * reserved : 예약 필드
     * language : 언어
     * card.code : 결제창에 표시할 카드사 (배열))
     * card.installment : 결제창에 표시할 할부개월 (배열)
     * card.visible : 카드 결제 섹션 표시 여부 (통합결제 시 사용)
     * card.direct : 카드 다이렉트 모드 여부
     * easyPay.code : 결제창에 표시할 간편결제사 (배열) — NAVERPAY, KAKAOPAY, TOSSPAY
     * easyPay.installment : 결제창에 표시할 할부개월 (배열)
     * easyPay.visible : 간편결제 섹션 표시 여부 (통합결제 시 사용)
     * easyPay.direct : 간편결제 다이렉트 모드 여부
     * ※ direct(다이렉트 모드)는 card / easyPay 중 하나에만 true로 설정할 수 있습니다.
     * subMerchant : 간편결제 시 필수 (List<Object>) — 통합결제 시 하위 MID에 간편결제가 있으면 필수
     *   businessNumber(종사업자 번호) / name(상호) / address(주소) / postalCode(우편번호)
     *   ※ 유상 포인트 간편결제 시, 현금영수증 발행 사업자 번호는 subMerchant의 마지막 인덱스 사업자 번호로 발행
     *   ※ 하위 가맹점을 관리하는 경우, 간편결제 시 전자금융거래법 제37조 제5항에 따라 하위 가맹점 정보를 함께 전송해야 합니다.
     *      하위 가맹점이 또 다른 하위 가맹점을 두는 다단계 구조라면, 상위 가맹점부터 최하위 종사업자까지 모든 단계의
     *      사업자 정보를 순서대로 subMerchant 배열에 담아야 하며, 최하위 종사업자가 마지막 인덱스에 오도록 구성합니다.
     *      단, 하위 가맹점 없이 직접 쇼핑몰을 운영하는 경우에는 쇼핑몰 사업자 정보를 입력합니다.
     *******************************************************
    */
    const customerName = '홍길동';
    const customerEmail = 'test@korpay.com';
    const customerPhone = '16443475';
    const customerAddress = '서울특별시 성동구 성수일로 77 서울숲IT밸리 608호';
    const customerPost = '04790';
    const reserved = '예약필드 입니다. 응답값에 포함됩니다.';
    const language = 'ko';

    /*
    const card = {
        code: ['01', '02', '03', '04', '06', '07', '08', '12', '15'],
        installment: [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        visible: true,   // 통합결제(unified) 시 카드 섹션 표시 여부
        direct: false,   // 카드 다이렉트 모드
    };

    const easyPay = {
        code: ['NAVERPAY', 'KAKAOPAY', 'TOSSPAY'],
        installment: [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        visible: true,   // 통합결제(unified) 시 간편결제 섹션 표시 여부
        direct: false,   // 간편결제 다이렉트 모드
    };

    // ※ direct(다이렉트 모드)는 card / easyPay 중 하나에만 true로 설정할 수 있습니다.
    // subMerchant : 간편결제 시 필수! 통합결제(unified)여도 하위에 간편결제 MID가 포함되어 있으면 필수입니다.
    //   - 하위 가맹점을 관리하면 그 하위 가맹점의 사업자 정보도 함께 코페이로 전송해야 합니다.
    //   - 다단계 구조라면 상위부터 최하위 종사업자까지 모든 단계의 정보를 순서대로 담습니다. (최하위 종사업자 = 마지막 인덱스)
    //   - 하위 가맹점 없이 직접 가맹점을 운영한다면 가맹점 사업자 정보를 입력합니다.
    //   ※ 마지막 인덱스의 사업자 번호로 현금영수증이 발행됩니다.
    // 단일 사업자면 1개만, 다단계면 상위→최하위 순서로 여러 개 (아래는 2단계 예시)
    const subMerchant = [
        {
            businessNumber: '1112223333',   // 상위 가맹점 (본사)
            name: '상위 사업자 상호',
            address: '상위 사업자 주소',
            postalCode: '11111',
        },
        {
            businessNumber: '4445556666',   // 최하위 종사업자 → 현금영수증 발행 대상 (마지막 인덱스)
            name: '하위 사업자 상호',
            address: '하위 사업자 주소',
            postalCode: '22222',
        },
    ];
    */

    /*
     *******************************************************
     * <해쉬암호화>
     * 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *******************************************************
    */

    const ediDate = getCurrentDateTime();
    const hashKey = '전문 PDF를 참고하여 암호화 키를 생성 합니다.';


    return res.json({
        merchantId,
        productName,
        orderNumber,
        amount,
        payMethod,
        returnUrl,
        ediDate,
        hashKey,

        /* Options */
        customerName,
        customerEmail,
        customerPhone,
        customerAddress,
        customerPost,
        reserved,
        language,
        // card,
        // easyPay,
        // subMerchant,
    });
});

app.post('/confirm', async (req, res) => {

    const localUrl = `http://localhost:5173`;
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

    const {
        resultCode = 'E999',
        message = '인증 실패',
        merchantId = '',
        orderNumber = '',
        amount = '',
        reserved = '',
        paymentKey = ''
    } = req.body;


    /*
    *******************************************************
    * 2. 인증 성공 여부 체크 및 데이터 변조 검증
    *******************************************************
    */

    const isAuthSuccess = (resultCode === '0000' && paymentKey);
    if (!isAuthSuccess) {
        console.error(message);
        const redirectUrl = `${localUrl}/fail?orderNumber=${orderNumber}`;
        return res.redirect(redirectUrl);
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
    * channelId : 통합 ID 하위 실 결제 Merchant Id (통합 ID 사용 시에만 포함)
    * card :
            {
                cardNumber : 카드 번호
                approvalCode : 매입사 코드
                installment : 승인 할부개월
                approvalNumber : 승인 번호
                cardAmount : 카드 사용 금액
                usePointAmt : 사용 포인트 금액 (다음 버전 v1.4에서 삭제 예정 / 해당 필드 사용 금지)
                remainPointAmt : 잔여 포인트 금액 (다음 버전 v1.4에서 삭제 예정 / 해당 필드 사용 금지)
            }
    * easyPay : (간편결제로 결제한 경우에만 포함)
            {
                moneyAmount : 유상 포인트 결제 금액
                pointAmount : 무상 포인트 결제 금액
                provider : 간편결제사 코드 (NAVERPAY, KAKAOPAY, TOSSPAY)
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
        const query = new URLSearchParams({
                paymentKey,
            }).toString();
        /*
         * [Read Timeout 설정 안내]
         * 결제 승인(confirm) API 호출 시 Read Timeout 설정을 권장합니다.
         * 네트워크 지연 등으로 응답이 늦어질 때 무한 대기를 방지하기 위함입니다.
         * 권장 값: 60초
         * 단, 타임아웃이 발생하더라도 실제 승인은 정상 완료되었을 수 있으므로,
         * 타임아웃 시에는 결제 상태 조회 등으로 최종 결과를 반드시 확인해야 합니다.
         */
        const response = await fetch(`${paymentUrl}?${query}`, {
            method: 'POST'
        });

        httpCode = response.status;

        const text = await response.text();
        /*
         * [응답 필드 추가 호환성]
         * 결제 응답에는 향후 새로운 필드가 추가될 수 있습니다.
         * JSON.parse 는 모델/스키마 개념이 없어 알 수 없는 필드가 와도 그대로 보존하며 에러가 나지 않습니다.
         * 만약 Zod 등 검증 라이브러리를 도입한다면, 추가 필드를 허용하도록 설정해야 합니다.
         *   - Zod  : .strict() 사용 금지 → 기본(strip) 또는 .passthrough() 사용
         *   - Joi  : .unknown(true) 또는 { stripUnknown: true }
         *   - class-validator : forbidNonWhitelisted: true 사용 금지
         */
        result = JSON.parse(text);
    } catch (err) {
        result = err;
        console.error('fetch error:', err);
    }

    console.log('===== API RESPONSE =====');
    console.log(result);
    console.log('========================');

    const isApiSuccess = (httpCode === 200 && result?.resultCode === '3001');

    if (!isApiSuccess) {
        return res.redirect(`${localUrl}/fail?orderNumber=${orderNumber}`);
    }



    /**
     * [DB INSERT / UPDATE]
     * 여기서 결제 완료 처리를 수행합니다.
     * 예: UPDATE orderTable SET status = 'PAID', amount = `${result.amount}` ...  WHERE order_no = `${result.orderNumber}` ...
     */
    return res.redirect(`${localUrl}/success?orderNumber=${orderNumber}`);
});

app.listen(PORT, () => {
    console.log(`RUN :: http://localhost:${PORT}`);
});