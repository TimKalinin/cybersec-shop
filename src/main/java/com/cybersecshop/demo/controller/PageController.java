package com.cybersecshop.demo.controller;

import java.security.Principal;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String landing(Model model, Principal principal) {
        model.addAttribute("user", principal);
        return "landing";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, @AuthenticationPrincipal OidcUser principal) {
        model.addAttribute("user", principal);
        model.addAttribute("email", principal != null ? principal.getEmail() : "");
        return "dashboard";
    }

    @GetMapping("/admin")
    public String admin(Model model, @AuthenticationPrincipal OidcUser principal) {
        model.addAttribute("user", principal);
        return "admin";
    }
}
