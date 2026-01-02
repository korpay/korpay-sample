package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;


@Controller
public class ExampleController {

    @GetMapping("/auth")
    public String auth(HttpServletResponse httpResponse) {
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setHeader("Expires", "0");
        return "auth";
    }

    @PostMapping("/confirm")
    public String confirm() {
        return "confirm";
    }

    @GetMapping("/success")
    public String success(@RequestParam String orderNumber) {
        return "success";
    }

    @GetMapping("/fail")
    public String fail(@RequestParam String orderNumber) {
        return "fail";
    }
}
