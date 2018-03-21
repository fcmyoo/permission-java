package com.mmall.controller;

import com.mmall.common.JsonData;
import com.mmall.dto.DeptLevelDto;
import com.mmall.model.SysDept;
import com.mmall.model.SysFunction;
import com.mmall.param.DeptParam;
import com.mmall.service.ISysDeptService;
import com.mmall.service.ISysFunctionService;
import com.mmall.service.ISysTreeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sys/dept")
@Slf4j
public class SysDeptController {
    @Resource
    private ISysDeptService iSysDeptService;

    @Resource
    private ISysTreeService iSysTreeService;

    @Resource
    private ISysFunctionService iSysFunctionService;

    @RequestMapping("/list")
    public ModelAndView page() {

        return new ModelAndView("dept");
    }



    @RequestMapping(value = "/treeData")
    @ResponseBody
    public JsonData getTreeData() {
        List<SysFunction> nodeDtoList = iSysFunctionService.getTreeData();

        return JsonData.success(nodeDtoList);
    }

    @RequestMapping("/save")
    @ResponseBody
    public JsonData saveDept(DeptParam param) {
        iSysDeptService.save(param);
        return JsonData.success();
    }


    @RequestMapping("/tree")
    @ResponseBody
    public JsonData tree() {
        List<DeptLevelDto> dtoList = iSysTreeService.getTree();
        return JsonData.success(dtoList);
    }

    @RequestMapping("/update.json")
    @ResponseBody
    public JsonData updateDept(DeptParam param) {
        iSysDeptService.update(param);
        return JsonData.success();
    }

    @RequestMapping("/getId")
    @ResponseBody
    public JsonData getDeptByCode(Integer deptId) {
        List<SysDept> deptList=iSysDeptService.getDeptByCode(deptId);
        return JsonData.success(deptList);
    }

    @RequestMapping("/checkUnique")
    @ResponseBody
    public Map checkUnique(DeptParam param) {
        Map<String, Boolean> map = new HashMap<String, Boolean>();
        boolean list = iSysDeptService.checkUnique(param.getName());
        map.put("valid", list);
        return map;
    }
}
