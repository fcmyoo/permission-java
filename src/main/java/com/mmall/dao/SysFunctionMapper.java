package com.mmall.dao;

import com.mmall.model.SysFunction;

import java.util.List;

public interface SysFunctionMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(SysFunction record);

    int insertSelective(SysFunction record);

    SysFunction selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(SysFunction record);

    int updateByPrimaryKeyWithBLOBs(SysFunction record);

    int updateByPrimaryKey(SysFunction record);

    List<SysFunction> getAllFunction();
}