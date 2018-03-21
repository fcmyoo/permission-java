<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>组织机构管理</h1>
    <ol class="breadcrumb">
        <li><a href="${basePath}"><i class="fa fa-dashboard"></i> 首页</a></li>
        <li><a href="#">系统管理</a></li>
        <li class="active">组织机构管理</li>
    </ol>
</section>

<!-- Main content -->
<section class="content">

    <div class="row">
        <div class="col-md-3">

            <!-- Profile Image -->
            <div class="box box-primary">
                <div class="box-body box-profile">
                    <div id="tree"></div>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
        </div>
        <!-- /.col -->
        <div class="col-md-9">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-btn-type="addRoot">
                            <li class="fa fa-plus">&nbsp;新增根机构</li>
                        </button>
                        <button type="button" class="btn btn-default" data-btn-type="add">
                            <li class="fa fa-plus">&nbsp;新增下级机构</li>
                        </button>
                        <button type="button" class="btn btn-default" data-btn-type="edit">
                            <li class="fa fa-edit">&nbsp;编辑当前机构</li>
                        </button>
                        <button type="button" class="btn btn-default" data-btn-type="delete">
                            <li class="fa fa-remove">&nbsp;删除当前机构</li>
                        </button>
                    </div>
                    <!-- /.box-tools -->
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <form class="form-horizontal" id="org-form">
                        <input type="hidden" name="parentId"/>
                        <input type="hidden" name="id"/>
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
                                </label> &nbsp;&nbsp;&nbsp; <label class="control-label"> <input type="radio"
                                                                                                 name="deleted"
                                                                                                 class="square-green"
                                                                                                 value="1"> 禁用
                            </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="remark" class="col-sm-2 control-label">说明</label>

                            <div class="col-sm-9">
                                <textarea class="form-control" id="remark" name="remark" placeholder="说明"></textarea>
                            </div>
                        </div>
                        <div class="box-footer" style="display:none">
                            <div class="text-center">
                                <button type="button" class="btn btn-default" data-btn-type="cancel">
                                    <i class="fa fa-reply">&nbsp;取消</i>
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save">&nbsp;保存</i>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /. box -->
        </div>
    </div>
    <!-- /.row -->

</section>

<script>
    //封装改写
    var orgCtrl = {
        form: null,
        initForm: function () {
            var self = this;
            this.form = $("#org-form").form();
            //初始化菜单树
            this.initTree(0);
            $("#org-form").bootstrapValidator({
                message: '请输入有效值',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                submitHandler: function (validator, orgform, submitButton) {
                    modals.confirm('确认保存？', function () {
                        //Save Data，对应'submit-提交'
                        var params = self.form.getFormSimpleData();
                        ajaxPost(basePath + '/sys/dept/save', params, function (data) {
                            if (data.ret) {
                                var selectedArr = $("#tree").data("treeview").getSelected();
                                var selectedNodeId = selectedArr.length > 0 ? selectedArr[0].nodeId : 0;
                                self.initTree(selectedNodeId);
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
            this.form.initComponent();
        },
        btntype: null,
        initBtnEvent: function () {
            var self = this;
            $('button[data-btn-type]').click(function () {
                var action = $(this).attr('data-btn-type');
                var selectedArr = $("#tree").data("treeview").getSelected();
                var selectedNode = selectedArr.length > 0 ? selectedArr[0] : null;
                switch (action) {
                    case 'addRoot':
                        self.addRoot(action);
                        break;
                    case 'add':
                        self.add(action, selectedNode);
                        break;
                    case 'edit':
                        self.edit(action, selectedNode);
                        break;
                    case 'delete':
                        self.delete(selectedNode);
                        break;
                    case 'cancel':
                        self.cancel(selectedNode);
                        break;
                }
            });
        },

        addRoot: function (action) {
            this.formWritable(action);
            this.form.clearForm();
            //填充上级机构和层级编码
            this.fillParentAndLevelCode(null);
            this.btntype = 'add';
        },
        add: function (action, selectedNode) {
            if (!selectedNode) {
                modals.info('请先选择上级机构');
                return false;
            }
            this.formWritable(action);
            this.form.clearForm();
            //填充上级机构和层级编码
            this.fillParentAndLevelCode(selectedNode);
            this.btntype = 'add';
        },
        edit: function (action, selectedNode) {
            if (!selectedNode) {
                modals.info('请先选择要编辑的节点');
                return false;
            }
            if (this.btntype == 'add') {

                this.fillOrgForm(selectedNode);
            }
            this.formWritable(action);
            this.btntype = 'edit';
        },
        delete: function (selectedNode) {
            var self = this;
            if (!selectedNode) {
                modals.info('请先选择要删除的节点');
                return false;
            }
            if (this.btntype == 'add')
                this.fillOrgForm(selectedNode);
            this.formReadonly();
            $(".box-header button[data-btn-type='delete']").removeClass("btn-default").addClass("btn-primary");
            if (selectedNode.nodes.length > 0) {
                modals.info('该节点含有子节点，请先删除子节点');
                return false;
            }
            modals.confirm('是否删除该节点', function () {
                ajaxPost(basePath + "/sys/dept/delete/" + selectedNode.id, null, function (data) {
                    if (data.ret) {
                        modals.correct('删除成功');
                    } else {
                        modals.info(data.message);
                    }
                    //定位
                    var brothers = $("#tree").data("treeview").getSiblings(selectedNode);
                    if (brothers.length > 0)
                        self.initTree(brothers[brothers.length - 1].nodeId);
                    else {
                        var parent = $("#tree").data("treeview").getParent(selectedNode);
                        self.initTree(parent ? parent.nodeId : 0);
                    }
                });
            });
        },
        cancel: function (selectedNode) {
            if (this.btntype == 'add')
                this.fillOrgForm(selectedNode);
            this.formReadonly();
        },
        //初始化菜单
        initTree: function (selectNodeId) {
            var self = this;
            var treeData = null;
            ajaxPost(basePath + "/sys/dept/tree", null, function (data) {
                if (data.ret) {
                    treeData = data.data;
                }

            });
            $("#tree").treeview({
                data: treeData,
                showBorder: true,
                expandIcon: "glyphicon glyphicon-stop",
                collapseIcon: "glyphicon glyphicon-unchecked",
                levels: 3,
                onNodeSelected: function (event, data) {
                    self.fillOrgForm(data);
                    self.formReadonly();
                }
            });
            if (treeData.length == 0)
                return;
            //默认选中第一个节点
            selectNodeId = selectNodeId || 0;
            $("#tree").data('treeview').selectNode(selectNodeId);
            $("#tree").data('treeview').expandNode(selectNodeId);
            $("#tree").data('treeview').revealNode(selectNodeId);
        },
        //新增时，带入父级机构名称id,自动生成levelcode
        fillParentAndLevelCode: function (selectedNode) {
            $("input[name='parentName']").val(selectedNode ? selectedNode.text : '组织机构');
            $("input[name='deleted'][value='0']").prop("checked", "checked");
            if (selectedNode) {
                $("input[name='parentId']").val(selectedNode.id);
                var nodes = selectedNode.nodes;
                var levelCode = nodes ? nodes[nodes.length - 1].levelCode : null;
                $("input[name='levelCode']").val(getNextCode(selectedNode.levelCode, levelCode, 6));
            } else {
                var parentNode = $("#tree").data("treeview").getNode(0);
                var levelCode = "000000";
                if (parentNode) {
                    var brothers = $("#tree").data("treeview").getSiblings(0);
                    levelCode = brothers[brothers.length - 1].levelCode;
                }
                $("input[name='levelCode']").val(getNextCode("", levelCode, 6));
            }
        },
        //填充form
        fillOrgForm: function (node) {
            var self = this;
            this.form.clearForm();
            ajaxPost(basePath + "/sys/dept/getId?deptId=" + node.id, null, function (data) {
                self.form.initFormData(data.data[0]);
            })
        },
        //设置form为只读
        formReadonly: function () {
            //所有文本框只读
            $("input[name],textarea[name]").attr("readonly", "readonly");
            //隐藏取消、保存按钮
            $("#org-form .box-footer").hide();
            //还原新增、编辑、删除按钮样式
            $(".box-header button").removeClass("btn-primary").addClass("btn-default");
            //还原校验框
            if ($("#org-form").data('bootstrapValidator'))
                $("#org-form").data('bootstrapValidator').resetForm();
        },
        formWritable: function (action) {
            $("input[name],textarea[name]").removeAttr("readonly");
            $("#org-form .box-footer").show();
            $(".box-header button").removeClass("btn-primary").addClass("btn-default");
            if (action)
                $(".box-header button[data-btn-type='" + action + "']").removeClass("btn-default").addClass("btn-primary");
        }
    };
    $(function () {
        //初始化表单及校验
        orgCtrl.initForm();
        //初始化按钮事件
        orgCtrl.initBtnEvent();
    })


</script>