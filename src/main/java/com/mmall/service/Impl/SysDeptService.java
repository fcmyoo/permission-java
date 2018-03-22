package com.mmall.service.Impl;

import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import com.mmall.excption.ParamException;
import com.mmall.dao.SysDeptMapper;
import com.mmall.model.SysDept;
import com.mmall.param.DeptParam;
import com.mmall.service.ISysDeptService;
import com.mmall.util.BeanValidator;
import com.mmall.util.LevelUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.FastArrayList;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service("iSysDeptService")
public class SysDeptService implements ISysDeptService {

    @Resource
    private SysDeptMapper sysDeptMapper;

    public void save(DeptParam param) {
        BeanValidator.check(param);
        if (sysDeptMapper.countById(param.getId())>0) {
            update(param);
        }else {
            if (checkExist(param.getParentId(), param.getName(), param.getId())) {
                throw new ParamException("同一层级下存在相同名称的部门");
            }

            SysDept dept = SysDept.builder().name(param.getName()).parentId(param.getParentId()).seq(param.getSeq()).remark(param.getRemark()).parentName(param.getParentName()).build();
            dept.setLevel(LevelUtil.calculateLevel(getLevel(param.getParentId()), param.getParentId()));
            dept.setOperator("system");//TODO:
            dept.setOperateIp("127.0.0.1");//TODO:
            dept.setOperateTime(new Date());
            sysDeptMapper.insertSelective(dept);
        }
    }

    public void update(DeptParam param) {
        BeanValidator.check(param);
//        if (checkExist(param.getParentId(), param.getName(), param.getId())) {
//            throw new ParamException("同一层级下存在相同名称的部门");
//        }
        SysDept before = sysDeptMapper.selectByPrimaryKey(param.getId());
        Preconditions.checkNotNull(before, "待更新的部门不存在");
//        if (checkExist(param.getParentId(), param.getName(), param.getId())) {
//            throw new ParamException("同一层级下存在相同名称的部门");
//        }
        SysDept after = SysDept.builder().id(param.getId()).name(param.getName()).parentId(param.getParentId()).parentName(param.getParentName()).seq(param.getSeq()).remark(param.getRemark()).build();
        after.setLevel(LevelUtil.calculateLevel(getLevel(param.getParentId()), param.getParentId()));
        after.setOperator("system-update");//TODO:
        after.setOperateIp("127.0.0.1");//TODO:
        after.setOperateTime(new Date());
        updateWithChild(before, after);
    }

    @Transactional
    public void updateWithChild(SysDept before, SysDept after) {
        String newLevelPrefix = after.getLevel();
        String oldLevelPrefix = before.getLevel();
        if (!after.getLevel().equals(before.getLevel())) {
            List<SysDept> deptList = sysDeptMapper.getChildDeptListByLevel(before.getLevel());
            if (CollectionUtils.isNotEmpty(deptList)) {
                for (SysDept dept : deptList) {
                    String level = dept.getLevel();
                    if (level.indexOf(oldLevelPrefix) == 0) {
                        level = newLevelPrefix + level.substring(oldLevelPrefix.length());
                        dept.setLevel(level);
                    }
                }
            }
            sysDeptMapper.batchUpdateLevel(deptList);
        }
        sysDeptMapper.updateByPrimaryKey(after);
    }

    public boolean checkExist(Integer parentId, String deptName, Integer deptId) {
        //TODO:
        return sysDeptMapper.countByNameAndParentId(deptName, parentId, deptId) > 0;
    }


    public boolean checkUnique(String deptName) {
        return sysDeptMapper.countByName(deptName) == 0;
    }

    public String getLevel(Integer deptId) {
        SysDept dept = sysDeptMapper.selectByPrimaryKey(deptId);
        if (dept == null) {
            return null;
        }
        return dept.getLevel();
    }

    public List<SysDept> getDeptByCode(Integer deptId) {
        SysDept deptList = sysDeptMapper.selectByPrimaryKey(deptId);
        List<SysDept> dept = Lists.newArrayList(deptList);

        if (deptList == null) {
            return null;
        }
        return dept;
    }

    public void delDeptById(Integer deptId) {
        SysDept dept = sysDeptMapper.selectByPrimaryKey(deptId);
        Preconditions.checkNotNull(dept, "待删除的部门不存在，无法删除");
        sysDeptMapper.deleteByPrimaryKey(deptId);




    }
}
