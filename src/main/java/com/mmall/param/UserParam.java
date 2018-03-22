package com.mmall.param;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;

@Getter
@Setter
public class UserParam {

    private Integer id;

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "电话不能为空")
    private String telephone;

    @NotBlank(message = "邮箱不能为空")
    @Length(min = 5,max = 50,message = "邮箱长度必须在5-50之间")
    private String mail;

    @NotBlank(message = "必须提供用户所在部门")
    private Integer deptId;

    @NotBlank(message = "必须指定用户状态")
    @Min(value = 0,message = "用户状态不合法")
    @Max(value = 2,message = "用户状态不合法")
    private Integer status;

    private String remark="";


}
