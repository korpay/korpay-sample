import { createFileRoute } from "@tanstack/react-router";
import KorpaySDK from "@korpay/sdk";
import type { RequestData } from "@korpay/sdk";
import { useEffect, useState } from "react";
import "./Auth.css";

export const Route = createFileRoute("/auth")({
  component: RouteComponent,
});

function RouteComponent() {
  const [paymentData, setPaymentData] = useState<RequestData>();
  const [btnDisabled, setBtnDisabled] = useState<boolean>(false);

  useEffect(() => {
    preparePayment();
  }, []);

  const preparePayment = async () => {
    const res = await fetch("http://localhost:3001/api/payment/info", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
    });
    const data = await res.json();
    setPaymentData(data);
  };

  const handlePayment = () => {
    if (!paymentData) {
      alert("데이터를 확인해 주세요.");
      return;
    }

    KorpaySDK.payment("https://BASE_URL", paymentData, {
      onStart: () => {
        setBtnDisabled(true);
      },
      onError: (err: string) => {
        alert(err);
        setBtnDisabled(false);
      },
      onClose: () => {
        setBtnDisabled(false);
      },
    });
  };

  if (!paymentData) {
    return <div>데이터가 없습니다.</div>;
  }

  return (
    <div className="checkout-card">
      <div className="card-header">
        <h2>결제 금액</h2>
        <div className="amount">{paymentData.amount.toLocaleString()}원</div>
      </div>

      <div className="card-body">
        <div className="info-row">
          <span>상품명</span>
          <span>{paymentData.productName}</span>
        </div>

        <div className="info-row">
          <span>주문번호</span>
          <span>{paymentData.orderNumber}</span>
        </div>

        {paymentData.customerName && (
          <div className="info-row">
            <span>구매자 명</span>
            <span>{paymentData.customerName}</span>
          </div>
        )}

        {paymentData.customerEmail && (
          <div className="info-row">
            <span>구매자 이메일</span>
            <span>{paymentData.customerEmail}</span>
          </div>
        )}

        {paymentData.customerPhone && (
          <div className="info-row">
            <span>구매자 전화번호</span>
            <span>{paymentData.customerPhone}</span>
          </div>
        )}

        {paymentData.customerAddress && (
          <div className="info-row">
            <span>구매자 주소</span>
            <span>{paymentData.customerAddress}</span>
          </div>
        )}

        {paymentData.customerPost && (
          <div className="info-row">
            <span>구매자 우편번호</span>
            <span>{paymentData.customerPost}</span>
          </div>
        )}

        <div className="divider"></div>

        <button
          id="payBtn"
           className={`pay-btn ${btnDisabled ? "loading" : ""}`}
          onClick={handlePayment}
          disabled={btnDisabled}
          
        >
          결제하기
        </button>
      </div>
    </div>
  );
}
