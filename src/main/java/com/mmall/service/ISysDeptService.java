package com.mmall.service;

import com.mmall.model.SysDept;
import com.mmall.param.DeptParam;

import java.util.List;

public interface ISysDeptService {
    void save(DeptParam param);

    void update(DeptParam param);

    List<SysDept> getDeptByCode(Integer deptId);

    boolean checkUnique(String deptName);
}
