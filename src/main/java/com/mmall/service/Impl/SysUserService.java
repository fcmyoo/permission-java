package com.mmall.service.Impl;

import com.mmall.dao.SysUserMapper;
import com.mmall.excption.ParamException;
import com.mmall.param.UserParam;
import com.mmall.service.ISysUserService;
import com.mmall.util.BeanValidator;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysUserService implements ISysUserService {
    @Resource
    private SysUserMapper sysUserMapper;

    public void save(UserParam param) {
        BeanValidator.check(param);
        if (checkEmailExist(param.getMail(), param.getId())) {
            throw new ParamException("Email被占用");
        }
        if (checkPhoneExist(param.getTelephone(), param.getId())) {
            throw new ParamException("电话被占用");
        }

    }

    public boolean checkEmailExist(String mail, Integer userId) {
        return false;
    }

    public boolean checkPhoneExist(String phone, Integer userId) {
        return false;
    }
}
