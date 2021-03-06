<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
        <li class="fa fa-remove"></li>
    </button>
    <h5 class="modal-title"></h5>
</div>

<div class="modal-body">

    <form class="form-horizontal bv-form" id="org-form1" name="org-form1">
        <input type="hidden" name="parentId"/>
        <input type="hidden" name="id"/>
        <div class="box-body">
            <div class="form-group">
                <label for="parentName" class="col-sm-2 control-label">上级</label>

                <div class="col-sm-9">
                    <input type="text" class="form-control" disabled="disabled" id="parentName"
                           name="parentName" placeholder="上级">
                </div>
            </div>

            <div class="form-group">
                <label for="name" class="col-sm-2 control-label">名称</label>

                <div class="col-sm-9">
                    <input type="text" class="form-control" id="name" name="name" placeholder="名称">
                </div>
            </div>
            <div class="form-group">
                <label for="seq" class="col-sm-2 control-label">顺序</label>

                <div class="col-sm-9">
                    <input type="text" class="form-control" id="seq" name="seq" placeholder="顺序">
                </div>
            </div>

            <div class="form-group">
                <label for="level" class="col-sm-2 control-label">层级编码</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="level" name="level"
                           placeholder="层级编码">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">是否可用</label>
                <div class="col-sm-9">
                    <label class="control-label"> <input type="radio" name="deleted" class="square-green"
                                                         checked="checked"
                                                         value="0"> 启用
                    </label> &nbsp;&nbsp;&nbsp; <label class="control-label">
                    <input type="radio" name="deleted" class="square-green" value="1"> 禁用
                </label>
                </div>
            </div>
            <div class="form-group">
                <label for="remark" class="col-sm-2 control-label">说明</label>

                <div class="col-sm-9">
                    <textarea class="form-control" id="remark" name="remark" placeholder="说明"></textarea>
                </div>
            </div>
        </div>
        <div class="box-footer text-right">
            <button type="button" class="btn btn-default" data-btn-type="cancel" data-dismiss="modal">取消</button>
            <button type="submit" class="btn btn-primary" data-btn-type="save">提交</button>
        </div>
    </form>

</div>

<script>
    //tableId,queryId,conditionContainer
    var form = null;
    var id = "${id?default(0)}";
    $(function () {
        //初始化控件
        form = $("#org-form1").form();

        //数据校验
        $("#org-form1").bootstrapValidator({
            message: '请输入有效值',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            submitHandler: function (validator, orgform, submitButton) {
                modals.confirm('确认保存？', function () {
                    var params = form.getFormSimpleData();
                    ajaxPost(basePath + '/sys/dept/save', params, function (data) {
                        if (data.ret) {
                            modals.closeWin(winId);
                            deptInitTree.initForm();

                        }

                    });
                });
            },
            fields: {
                name: {
                    validators: {
                        notEmpty: {
                            message: '请输入名称'
                        },
                        remote: {
                            url: basePath + "/sys/dept/checkUnique",
                            message: '该名称已被使用'
                        }
                    },
                    threshold: 4 //位置应该与validators同级
                }

            }
        });
        form.initComponent();
        //回填id
        if (id == "2") {
            ajaxPost(basePath + "/sys/dept/getId?deptId=" + onNodeSelected.id, null, function (data) {
                if (data.ret) {
                    fillOrgForm(data.data[0])
                }
            });
        } else if (id == "1") {
            ajaxPost(basePath + "/sys/dept/getId?deptId=" + onNodeSelected.id, null, function (data) {
                if (data.ret) {
                    $("input[name='parentName']").val(data.data[0].name);
                    $("input[name='parentId']").val(data.data[0].id);
                }

            });

        }
    });


    function resetForm() {
        form.clearForm();
        $("#org-form1").data('bootstrapValidator').resetForm();
    }

    function fillOrgForm(node) {
        var self = this;
        ajaxPost(basePath + "/sys/dept/getId?deptId=" + node.id, null, function (data) {
            self.form.initFormData(data.data[0]);
        })
    }
</script>