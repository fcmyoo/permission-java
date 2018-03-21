package com.mmall.controller;

import com.mmall.common.ApplicationContextHelper;
import com.mmall.common.JsonData;
import com.mmall.excption.ParamException;
import com.mmall.dao.SysAclModuleMapper;
import com.mmall.model.SysAclModule;
import com.mmall.param.TestVo;
import com.mmall.util.BeanValidator;
import com.mmall.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/test")
@Slf4j
public class testController {

    @RequestMapping("/hello.json")
    @ResponseBody
    public JsonData hello() {
        log.info("hello");
//        return JsonData.success("hello.permission");
        throw new RuntimeException("test exception");
    }

    @RequestMapping("/validate.json")
    @ResponseBody
    public JsonData validate(TestVo vo) throws ParamException {
        log.info("validate");
        SysAclModuleMapper moduleMapper = ApplicationContextHelper.popBean(SysAclModuleMapper.class);
        SysAclModule model = moduleMapper.selectByPrimaryKey(1);
        log.info(JsonMapper.obj2String(model));


        BeanValidator.check(vo);
//        try {
//            Map<String, String> map = BeanValidator.validateObject(vo);
////            引入工具类后变为MapUtils
////            if (map != null && map.entrySet().size() > 0)
//            if (MapUtils.isNotEmpty(map))
//            {
//                for (Map.Entry<String, String> entry : map.entrySet()) {
//                    log.info("{}=>{}", entry.getKey(), entry.getValue());
//                }
//            }
//        } catch (Exception e) {
//
//        }
        return JsonData.success("hello.validate");
//        throw new RuntimeException("test exception");
    }


}
