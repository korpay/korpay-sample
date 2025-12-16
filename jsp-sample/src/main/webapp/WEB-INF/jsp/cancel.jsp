<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    /*
     *******************************************************
     * <취소요청 페이지>
     *
     * 필수 값
     * tid : 결제 고유 번호
     * mid : MID
     * canAmt : 취소 요청 금액
     * partCanFlg : 부분 취소 여부 [ 0 : 전체 , 1 : 부분 ]
     * payMethod : 결제 수단
     *******************************************************
     */
    String tid = "";
    String mid = "";
    String canAmt = "1004";
    String partCanFlg = "0";
    String payMethod = "card";

    /*
     *******************************************************
     * 옵션 값
     * canId : 취소자 ID
     * canNm : 취소자 이름
     * canMsg : 취소 사유
     *******************************************************
     */
    String canId = "CancelTest";
    String canNm = "취소테스트";
    String canMsg = "고객요청";

    String cancelApiUrl = "https://pgapi.korpay.com/cancelTransJson.do";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
    <title>결제 취소 요청</title>
    <style>
        body { background-color: #ddd; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; }
        .checkout-card { background: white; width: 100%; max-width: 450px; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); margin: 20px; }

        .card-header { padding: 10px; text-align: center; }
        .card-header h1 { margin: 0; font-size: 2rem; }

        .card-body { padding: 30px; }

        .form-group { margin-bottom: 15px; }
        .form-label { display: block; font-size: 0.9rem; color: #555; margin-bottom: 5px; font-weight: 600; }
        .form-input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; font-size: 1rem; box-sizing: border-box; transition: 0.2s; }

        .divider { border-top: 1px dashed #ddd; margin: 25px 0; }
        .section-title { font-size: 0.85rem; color: #888; margin-bottom: 15px; text-transform: uppercase; letter-spacing: 1px; font-weight: bold; }

        .cancel-btn { width: 100%; padding: 16px; background-color: #dc3545; color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .cancel-btn:hover { background-color: #a71d2a; }
        .cancel-btn:disabled { background-color: #ccc; cursor: not-allowed; }

    </style>
</head>
<body>

<div class="checkout-card">
    <div class="card-header">
        <h1>결제 취소</h1>
    </div>

    <div class="card-body">
        <form id="cancelForm">
            <div class="section-title">기본 정보</div>

            <div class="form-group">
                <label for="tid" class="form-label">TID (거래번호)</label>
                <input type="text" id="tid" name="tid" class="form-input" value="<%= tid %>" placeholder="TID 입력" required>
            </div>

            <div class="form-group">
                <label for="mid" class="form-label">MID (상점ID)</label>
                <input type="text" id="mid" name="mid" class="form-input" value="<%= mid %>" maxlength="10">
            </div>

            <div class="form-group">
                <label for="canAmt" class="form-label">취소 금액</label>
                <input type="number" id="canAmt" name="canAmt" class="form-input" value="<%= canAmt %>">
            </div>

            <div class="divider"></div>

            <div class="section-title">옵션 설정</div>

            <div class="divider"></div>
            <div class="section-title">취소 사유</div>

            <div class="form-group">
                <label for="canId" class="form-label">취소자 ID</label>
                <input type="text" id="canId" name="canId" class="form-input" value="<%= canId %>" maxlength="20">
            </div>

            <div class="form-group">
                <label for="canNm" class="form-label">취소자 이름</label>
                <input type="text" id="canNm" name="canNm" class="form-input" value="<%= canNm %>">
            </div>

            <div class="form-group">
                <label for="canMsg" class="form-label">취소 사유</label>
                <input type="text" id="canMsg" name="canMsg" class="form-input" value="<%= canMsg %>" maxlength="100">
            </div>

            <button type="button" id="cancelBtn" class="cancel-btn">취소하기</button>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const cancelBtn = document.getElementById('cancelBtn');
        const form = document.getElementById('cancelForm');

        const API_URL = "<%= cancelApiUrl %>";
        const partCanFlg = "<%= partCanFlg %>"; // 부분 취소 여부 [ 0 : 전체 , 1 : 부분 ]
        const payMethod = "<%= payMethod %>"; // 결제수단


        cancelBtn.addEventListener('click', async () => {
            const formData = new FormData(form);
            if (!formData.get('tid')) {
                alert('TID를 입력해주세요.');
                return;
            }

            formData.append('partCanFlg', partCanFlg);
            formData.append('payMethod', payMethod);

            cancelBtn.disabled = true;
            cancelBtn.innerText = "처리 중...";

            try {
                const params = new URLSearchParams(formData);

                const response = await fetch(API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const data = await response.json();

                if (data) {
                    console.log("취소 결과:", data);

                    const cancelDate = data?.CancelDate ?? ''; // 취소 날짜
                    const cancelTime = data?.CancelTime ?? ''; // 취소 시간
                    const cancelNum = data?.CancelNum ?? ''; // 빈값
                    const cancelYN = data?.cancelYN ?? ''; // 취소 여부
                    const errorCd = data?.errorCd ?? ''; // 에러 코드
                    const errorMsg = data?.errorMsg ?? ''; // 에러 메세지 또는 성공 상세 메세지
                    const errorSys = data?.errorSys ?? ''; // PG 고정값
                    const ordNo = data?.ordNo ?? ''; // 주문번호
                    const payMethod = data?.payMethod ?? ''; // 결제수단
                    const resultCd = data?.resultCd ?? ''; // 결과코드
                    const resultMsg = data?.resultMsg ?? ''; // 결과메세지
                    const returnUrl = data?.returnUrl ?? ''; // 빈값
                    const tid = data?.tid ?? ''; // 거래ID
                    const trxCd = data?.trxCd ?? ''; // 0 일반 , 1 에스크로
                    alert(JSON.stringify(data,null,2));
                }

            } catch (error) {
                console.error('Cancel Error:', error);
                alert('취소 요청 중 오류가 발생했습니다.\n' + error.message);
            } finally {
                cancelBtn.disabled = false;
                cancelBtn.innerText = "취소하기";
            }
        });
    });
</script>

</body>
</html>