package com.korpay.controller;

import com.korpay.model.ApprovalResponse;
import com.korpay.model.AuthRequest;
import com.korpay.model.AuthResponse;
import com.korpay.service.ExampleService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


@Controller
@RequiredArgsConstructor
public class ExampleController {

    private final ExampleService exampleService;

    @GetMapping("/auth")
    public String auth(HttpServletResponse httpResponse, Model model) {
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setHeader("Expires", "0");

        /*
            인증 요청 파라미터는 AuthRequest 를 확인해 주세요.
         */
        model.addAttribute("auth", new AuthRequest());

        return "auth";
    }

    @PostMapping("/confirm")
    public String confirm(
            /*
                인증 응답 파라미터는 AuthResponse 를 확인해 주세요.
             */
            @ModelAttribute AuthResponse authResponse
    ) {

        /*
         *******************************************************
         * 인증 성공 여부 체크 및 데이터 변조 검증
         *******************************************************
         */

        String orderNumber = authResponse.getOrderNumber();
        if (!authResponse.isAuthSuccess()) {
            return "redirect:/fail?orderNumber=" + orderNumber;
        }

        /*
         *******************************************************
         * 3. [중요] DB 중복 결제 방지 로직
         *******************************************************
         * 사용자가 '뒤로가기' 후 다시 들어왔을 때를 대비하여
         * 승인 API를 날리기 전에 이미 처리된 주문인지 확인합니다.
         * 또는 PRG 패턴을 적용합니다. ( 해당 샘플 파일에서는 PRG 패턴이 적용되어있습니다. )

            String dbStatus = orderTableDao.selectStatus(orderNumber);
            // 이미 결제된 건이면 승인 요청 건너뛰고 바로 성공 페이지로
            if ("PAID".equals(dbStatus)) {
               return "redirect:/success?orderNumber=" + orderNumber;
            }

         */

        /*
            승인 응답 파라미터는 ApprovalResponse 를 확인해주세요.
         */
        ApprovalResponse result = exampleService.sendPaymentRequest(authResponse.getPaymentKey());

        System.out.println("===== API RESPONSE =====");
        System.out.println(result.toString());
        System.out.println("========================");

        boolean isApiSuccess = !result.getResultCode().isBlank() && "3001".equals(result.getResultCode());
        if (isApiSuccess) {
            /**
             * [DB INSERT / UPDATE]
             * 여기서 결제 완료 처리를 수행합니다.
             * 예: UPDATE orderTable SET status = 'PAID', amount = $result['amount'] ...  WHERE order_no = '$result['orderNumber']' ...
             */
            return "redirect:/success?orderNumber=" + orderNumber;
        }

        else {
            return "redirect:/fail?orderNumber=" + orderNumber;
        }

    }

    @GetMapping("/success")
    public String success(@RequestParam("orderNumber") String orderNumber) {
        return "success";
    }

    @GetMapping("/fail")
    public String fail(@RequestParam("orderNumber") String orderNumber) {
        return "fail";
    }
}
