import AuthClient from './components/auth'
import { getCurrentDateTime, random } from "@/functionUtils";
import type { PaymentData } from "@korpay/sdk";

function getPaymentInfo(): PaymentData {
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

    const merchantId = '';
    const merchantKey = '';
    const productName = '테스트 상품';
    const orderNumber = `testOrder${getCurrentDateTime()}${random()}`
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
     * card.code : 결제창에 표시할 카드사 (배열)
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
        // card,
        // easyPay,
        // subMerchant,
    }
}

export default function AuthPage() {
    const paymentData = getPaymentInfo()

    return <AuthClient initData={paymentData} />
}