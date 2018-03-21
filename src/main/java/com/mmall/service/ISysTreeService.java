package com.mmall.service;

import com.mmall.dto.DeptLevelDto;

import java.util.List;

public interface ISysTreeService {

    List<DeptLevelDto> deptTree();

    List<DeptLevelDto> getTree();

}
