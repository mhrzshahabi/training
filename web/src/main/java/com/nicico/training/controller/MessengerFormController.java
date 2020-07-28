
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.nicico.training.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/messenger"})
public class MessengerFormController {
    public MessengerFormController() {
    }

    @GetMapping({"/show-form"})
    public String showGroupForm() {
        return "messenger/MLanding";
    }
}
