package com.mmall.dto;

import com.mmall.model.SysFunction;
import lombok.Getter;
import lombok.Setter;

import java.util.List;


@Getter
@Setter
public class TreeNodeDto extends SysFunction {

    private String text;

    private List<String> tags;

    private Integer id;

    private String parentId;

    private String levelCode;

    private String icon;

    private List<TreeNodeDto> nodes;

}

