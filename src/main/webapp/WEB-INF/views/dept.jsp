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
        <div class="col-md-4">

            <!-- Profile Image -->
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
                <div class="box-body box-profile">
                    <div id="tree"></div>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
        </div>
        <!-- /.col -->
        <div class="col-md-8">
            <div class="box box-primary">
                <!-- /.box-header -->
                <div class="dataTables_filter" id="searchDiv_userRole">
                    <input type="hidden" name="roleId" value="-1" id="roleId"/>
                    <input placeholder="请输入用户名" name="user.name" class="form-control" type="search" likeOption="true"/>
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" data-btn-type="search">查询</button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-btn-type="selectUserRole">选择</button>
                        <button type="button" class="btn btn-default" data-btn-type="deleteUserRole">删除</button>
                    </div>
                </div>
                <div class="box-body">
                    <table id="userRole_table" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <!-- /.box-body -->
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
    var winId = "deptWin";
    var deptInitTree;
    var onNodeSelected;
    var orgCtrl = {
        form: null,

        initForm: function () {
            var self = this;
            this.form = $("#org-form").form();
            //初始化菜单树
            this.initTree(0);
        },
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
            modals.openWin({
                winId: winId,
                title: "新增根部门",
                width: "600px",
                url: "/sys/dept/edit?id=0"
            });


        },
        add: function (action, selectedNode) {
            if (!selectedNode) {
                modals.info('请先选择上级机构');
                return false;
            }
            modals.openWin({
                winId: winId,
                title: "新增下级部门",
                width: "600px",
                url: "/sys/dept/edit?id=1"

            });
        },
        edit: function (action, selectedNode) {
            if (!selectedNode) {
                modals.info('请先选择要编辑的节点');
                return false;
            }
            modals.openWin({
                winId: winId,
                title: "修改部门",
                width: "600px",
                url: "/sys/dept/edit?id=2"

            });
        },
        delete: function (selectedNode) {
            var self = this;
            if (!selectedNode) {
                modals.info('请先选择要删除的节点');
                return false;
            }
            $(".box-header button[data-btn-type='delete']").removeClass("btn-default").addClass("btn-primary");
            if (selectedNode.nodes != null) {
                modals.info('【' + selectedNode.text + '】含有子部门，请先删除子部门');
                return false;
            }
            modals.confirm('是否要删除【' + selectedNode.text + '】', function () {
                ajaxPost(basePath + "/sys/dept/delete?id=" + selectedNode.id, null, function (data) {
                    if (data.ret) {
                        modals.correct('删除成功');
                    } else {
                        modals.info(data.msg);
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
                    onNodeSelected = data;

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

    };




    $(function () {
        //初始化表单及校验
        orgCtrl.initForm();
        //初始化按钮事件
        orgCtrl.initBtnEvent();
        deptInitTree = orgCtrl;

        var config = {
            lengthChange: false,
            pagingType: 'simple_numbers'
        };

        userRoleTable = new CommonTable("userRole_table", "userRole_selected_list", "searchDiv_userRole", config);

        //默认选中第一行


        $('button[data-btn-type]').click(function () {
            var action = $(this).attr('data-btn-type');
            var selectedArr = $("#tree").data("treeview").getSelected();
            var selectedNode = selectedArr.length > 0 ? selectedArr[0] : null;
            var deptId = selectedNode.id;
            switch (action) {
                case 'selectUserRole':
                    if (!deptId) {
                        modals.info('请选择角色');
                        return;
                    }
                    modals.openWin({
                        winId: 'userRoleWin',
                        width: 1000,
                        title: '角色【' + selectedNode.text + '】绑定用户',
                        url: basePath + '/userrole/select?roleId=' + rowId,
                        hideFunc: function () {
                            userRoleTable.reloadData();
                        }
                    });
                    break;
                case 'deleteUserRole':
                    var rowId_ur = userRoleTable.getSelectedRowId();
                    if (!rowId_ur) {
                        modals.info("请选择要删除的用户");
                        return false;
                    }
                    modals.confirm("是否要删除该行数据", function () {
                        ajaxPost(basePath + "/userrole/delete", {ids: rowId_ur}, function (data) {
                            if (data.success) {
                                userRoleTable.reloadData();
                            } else {
                                modals.info(data.message);
                            }
                        })
                    });
                    break;
            }

        });
    })


</script>
