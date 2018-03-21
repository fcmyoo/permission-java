package com.mmall.util;

import com.mmall.dto.DeptLevelDto;
import com.mmall.dto.TreeNodeDto;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TreeUtil {
    public static List<DeptLevelDto> getNodeList(Map<Integer, DeptLevelDto> nodelist) {
        List<DeptLevelDto> tnlist=new ArrayList<DeptLevelDto>();
        for (Integer id : nodelist.keySet()) {
            DeptLevelDto node = nodelist.get(id);
            String prentId= String.valueOf(node.getParentId());
            if (node.getParentId()==0) {
                tnlist.add(node);
            } else {
                if (nodelist.get(node.getParentId()).getNodes() == null)
                    nodelist.get(node.getParentId()).setNodes(new ArrayList<DeptLevelDto>());
                nodelist.get(node.getParentId()).getNodes().add(node);
            }
        }
        return tnlist;
    }
}
