package com.mmall.service.Impl;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Multimap;
import com.mmall.dto.DeptLevelDto;
import com.mmall.dao.SysDeptMapper;
import com.mmall.model.SysDept;
import com.mmall.service.ISysTreeService;
import com.mmall.util.LevelUtil;
import com.mmall.util.TreeUtil;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Service;


import javax.annotation.Resource;
import java.util.*;

@Service("iSysTreeService")
public class SysTreeService implements ISysTreeService {

    public Comparator<DeptLevelDto> deptSeqComparator = new Comparator<DeptLevelDto>() {
        public int compare(DeptLevelDto o1, DeptLevelDto o2) {
            return o1.getSeq() - o2.getSeq();
        }
    };
    @Resource
    private SysDeptMapper sysDeptMapper;

    public List<DeptLevelDto> getTree(){
        List<DeptLevelDto> tnList = null;
        if (tnList != null) {
            return null;
        } else {
            List<SysDept> deptList = sysDeptMapper.getAllDept();
            Map<Integer, DeptLevelDto> nodeList = new LinkedHashMap<Integer,DeptLevelDto>();
            for (SysDept dept : deptList) {
                DeptLevelDto dto = new DeptLevelDto();
                dto.setName(dept.getName());
                dto.setId(dept.getId());
                dto.setText(dept.getName());
                dto.setParentId(dept.getParentId());
                nodeList.put(dto.getId(), dto);
            }

            tnList = TreeUtil.getNodeList(nodeList);
            return tnList;
        }


    }

    public List<DeptLevelDto> deptTree() {
        List<SysDept> deptList = sysDeptMapper.getAllDept();
        List<DeptLevelDto> dtoList = Lists.newArrayList();
        for (SysDept dept : deptList) {
            DeptLevelDto dto = DeptLevelDto.adapt(dept);
            dtoList.add(dto);
        }
        return deptListToTree(dtoList);
    }

    public List<DeptLevelDto> deptListToTree(List<DeptLevelDto> deptLevelList) {
        if (CollectionUtils.isEmpty(deptLevelList)) {
            return Lists.newArrayList();
        }
        //level => [dept1,dept2,....] Multimap:Map<String,List<Object>>
        Multimap<String, DeptLevelDto> levelDtoMultimap = ArrayListMultimap.create();
        List<DeptLevelDto> rootList = Lists.newArrayList();
        for (DeptLevelDto dto : deptLevelList) {
            levelDtoMultimap.put(dto.getLevel(), dto);
            if (LevelUtil.ROOT.equals(dto.getLevel())) {
                rootList.add(dto);
            }
        }
        //按照seq从小到大排序
        Collections.sort(rootList, new Comparator<DeptLevelDto>() {
            public int compare(DeptLevelDto o1, DeptLevelDto o2) {
                return o1.getSeq() - o2.getSeq();
            }
        });
        //递归
        transformDeptTree(rootList, LevelUtil.ROOT, levelDtoMultimap);
        return rootList;
    }

    //level:0,0,all 0=>0.1,0.2
    //level:0.1
    //level:0.2
    public void transformDeptTree(List<DeptLevelDto> deptLevelDtoList, String level, Multimap<String, DeptLevelDto> map) {
        for (int i = 0; i < deptLevelDtoList.size(); i++) {
            //遍历该层的每一个元素
            DeptLevelDto deptLevelDto = deptLevelDtoList.get(i);
            deptLevelDto.setText(deptLevelDto.getName());
            //处理当前层级元素
            String nextLevel = LevelUtil.calculateLevel(level, deptLevelDto.getId());

            //处理下一层
            List<DeptLevelDto> tempDeptList = (List<DeptLevelDto>) map.get(nextLevel);
            //更新集合parentName的值(数据库已经更新字段)
            for (int j=0; j<tempDeptList.size();j++) {
                tempDeptList.get(j).setParentName(deptLevelDto.getName());

            }
            deptLevelDto.getNodes();
            if (CollectionUtils.isNotEmpty(tempDeptList)) {
                //排序
                Collections.sort(tempDeptList, deptSeqComparator);

                //设置下一层部门
                deptLevelDto.setNodes(tempDeptList);

                //进入下一层处理
                transformDeptTree(tempDeptList, nextLevel, map);
            }
        }
    }

}
