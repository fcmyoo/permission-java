package com.mmall.service.Impl;

import com.google.common.collect.Lists;
import com.mmall.dao.SysFunctionMapper;
import com.mmall.model.SysFunction;
import com.mmall.service.ISysFunctionService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("iSysFunctionService")
public class SysFunctionService implements ISysFunctionService {

    @Resource
    private SysFunctionMapper sysFunctionMapper;

    public List<SysFunction> getTreeData() {
        List<SysFunction> funList = sysFunctionMapper.getAllFunction();
//        List<FunctionDto> funDto = Lists.newArrayList();
//        for (SysFunction fun : funList) {
//            FunctionDto dto = FunctionDto.adapt(fun);
//            funDto.add(dto);
//        }
        return funList;
    }


}
