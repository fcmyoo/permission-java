package com.mmall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@RequestMapping("/sys")
@Controller
public class SysMainController {

    @RequestMapping("/")
    public ModelAndView index() {
        //首页加载邮件消息 message/count  user/getAvatar

        return new ModelAndView("main");
    }

    @RequestMapping("/homepage")
    public ModelAndView homePage() {

        return new ModelAndView("homePage");
    }
}
