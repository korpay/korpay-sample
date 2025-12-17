import AuthClient from './components/auth'
import {getCurrentDateTime, random} from "@/functionUtils";
import {RequestData} from "@korpay/sdk";


function getPaymentInfo() : RequestData {
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
     * payMethod : 결제 요청 수단(card 고정)
     * returnUrl : 응답 페이지
     *******************************************************
    */

    const merchantId = '';
    const merchantKey = '';
    const productName = '테스트 상품';
    const orderNumber = `test_order${getCurrentDateTime()}${random()}`
    const amount = 1004;
    const payMethod = 'card';
    const returnUrl = 'http://localhost:3000/confirm';

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
     * testMode : 테스트 결제
     * cardCode : 허용 카드사
     * installment : 허용 할부개월
     *******************************************************
    */
    const customerName = '홍길동';
    const customerEmail = 'test@korpay.com';
    const customerPhone = '16443475';
    const customerAddress = '서울특별시 성동구 성수일로 77 서울숲IT밸리 608호';
    const customerPost = '04790';
    const reserved = '예약필드 입니다. 응답값에 포함됩니다.';
    const language = 'ko';
    const testMode = true;
    const cardCode = '01:02:03:04:06:07:08:12:15';
    const installment = '00:02:03:04:05:06:07:08:09:10:11:12';

    /*
     *******************************************************
     * <해쉬암호화>
     * 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *******************************************************
    */

    const ediDate = getCurrentDateTime();
    const hashKey = '전문 PDF를 참고하여 암호화 키를 생성 합니다.';

    return {
        merchantId,
        productName,
        orderNumber,
        amount,
        payMethod,
        returnUrl,
        ediDate,
        hashKey,
        customerName,
        customerEmail,
        customerPhone,
        customerAddress,
        customerPost,
        reserved,
        language,
        testMode,
        cardCode,
        installment,
    }
}

export default function AuthPage() {
    const paymentData = getPaymentInfo()

    return <AuthClient initData={paymentData} />
}