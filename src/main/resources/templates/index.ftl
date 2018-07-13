<html>
<head>
    <script src="/webjars/jquery/jquery.min.js"></script>
    <script src="/webjars/bootstrap/js/bootstrap.min.js"></script>
    <script src="/webjars/bootstrap-paginator/src/bootstrap-paginator.js"></script>
    <title>服务注册中心控制台</title>
    <link rel="stylesheet" href="/webjars/bootstrap/css/bootstrap.min.css"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="container"><br/>
    <div>
        <img src="/images/spring-boot.jpg" height="60" width="60">
        <img src="/images/logo.png">
    </div>
    <br/>
    <div>
        <button type="button" class="btn btn-primary" onclick="showJobModal()">新增</button>
    </div>
    <br/>
    <div class="table-responsive">
        <table class="table">
            <thead>
            <tr class="active">
                <th>根节点</th>
                <th>服务名称</th>
                <th>服务地址目录</th>
                <th>服务地址</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody class="table-striped">
            <#list map.data as service>
            <tr>
                <td>${service.rootNode!''}</td>
                <td>${service.childNode!''}</td>
                <td>${service.subChildNode!''}</td>
                <td>${service.serviceAddr!''}</td>
                <td>
                    <div>
                        <button type="button" class="btn btn-primary" onclick="">编辑</button>
                        <button type="button" class="btn btn-primary" onclick="">删除</button>
                    </div>
                </td>
            </tr>
            </#list>
            </tbody>
        </table>

        <ul class="pagination" id="page"></ul>
    </div>
</div>

<!-- 新增service div-->
<div class="modal fade" id="jobModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">新增</h4>
            </div>
            <form role="form">
                <div class="modal-body">
                    <label>服务名称(示例：com.msa.sample.api.HelloRpc4jService):</label>
                    <input id="name" type="text" class="form-control" required placeholder="输入服务名称">
                    <label>服务地址(示例：192.168.4.1:8080):</label>
                    <input id="serviceAddr" type="text" class="form-control" required placeholder="输入服务地址">
                </div>
                <div class="modal-footer">
                    <button id="saveBtn" type="button" class="btn btn-primary" onclick="addJob()">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--消息提示框-->
<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
     data-dismiss="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="messageLabel">提示</h4>
            </div>
            <div class="modal-body">确认删除这条服务记录？</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="delJob()">确认</button>
            </div>
        </div>
    </div>
</div>

<!--隐藏job,jobGroup-->
<input id="job" type="hidden"/>
<input id="jobGroup" type="hidden"/>

</body>

<script type="text/javascript">
    /* 显示jobModal*/
    function showJobModal() {
        $('#myModalLabel').html("新增");
        $('.modal-body input').val("");
        $("#jobName").removeAttr("disabled");
        $("#jobGroupName").removeAttr("disabled");
        $('#saveBtn').attr("onclick", "addJob()");
        $('#jobModal').modal();
    }

    /*添加服务*/
    function addService() {
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "/api/v1/add",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(jobJson()),
            success: function (result) {
                console.log(result);
                $('.modal-body input').val("");
                $('#jobModal').modal('hide');
                alert(result.message);
                if (result.status == "ok") {
                    getJobs();
                }
            },
            error: function () {
                $('.modal-body input').val("");
                $('#jobModal').modal('hide');
                alert("系统异常！");
            }
        });
    }

    /*更新job*/
    function updateJob() {
        $.ajax({
            type: "PUT",
            dataType: "json",
            url: "/api/v1/update",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(jobJson()),
            success: function (result) {
                console.log(result);
                $('.modal-body input').val("");
                $('#jobModal').modal('hide');
                alert(result.message);
                if (result.status == "ok") {
                    getJobs();
                }
            },
            error: function () {
                $('.modal-body input').val("");
                $('#jobModal').modal('hide');
                alert("系统异常！");
            }
        });
    }

    /*删除确认*/
    function delConfirm(job, jobGroup) {
        $('#job').val(job);
        $('#jobGroup').val(jobGroup);
        $('#messageModal').modal();
    }

    /*删除job*/
    function delJob() {
        var job = $('#job').val();
        var jobGroup = $('#jobGroup').val();
        $.ajax({
            type: "DELETE",
            dataType: "json",
            url: "/api/v1/delete/job/" + job + "/group/" + jobGroup,
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                console.log(result);
                $('#messageModal').modal('hide');
                alert(result.message);
                if (result.status == "ok") {
                    getJobs();
                }
            },
            error: function () {
                $('#messageModal').modal('hide');
                alert("系统异常！");
            }
        });
    }

    /*加载job详情*/
    function load(job, jobGroup) {
        $('#jobModal').modal();
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "/api/v1/load/job/" + job + "/group/" + jobGroup,
            success: function (result) {
                if (result.status == "ok") {
                    $('#myModalLabel').html("编辑");
                    $('#jobName').val(result.data.jobName);
                    $('#jobGroupName').val(result.data.jobGroupName);
                    $('#triggerName').val(result.data.triggerName);
                    $('#triggerGroupName').val(result.data.triggerGroupName);
                    $("#jobName").attr("disabled", "disabled");
                    $("#jobGroupName").attr("disabled", "disabled");
                    $("#triggerName").attr("disabled", "disabled");
                    $("#triggerGroupName").attr("disabled", "disabled");
                    $('#cron').val(result.data.cron);
                    $('#priority').val(result.data.priority);
                    if (result.data.misfire == -1) {
                        $('#misfire').val("-1");
                    } else if (result.data.misfire == 1) {
                        $('#misfire').val("1");
                    } else {
                        $('#misfire').val("2");
                    }
                    $('#applicationId').val(result.data.applicationId);
                    $('#uri').val(result.data.uri);
                    $('#url').val(result.data.url);
                    $('#jobDescription').val(result.data.jobDescription);
                    $('#triggerDescription').val(result.data.triggerDescription);
                    $('#saveBtn').attr("onclick", "updateJob()");
                } else {
                    alert("Warn:" + result.message);
                }
            },
            error: function () {
                alert("系统异常！");
            }
        });

    }

    /*获取json*/
    function jobJson() {
        var json = {
            "jobName": $("#jobName").val(),
            "jobGroupName": $("#jobGroupName").val(),
            "triggerName": $("#triggerName").val(),
            "triggerGroupName": $("#triggerGroupName").val(),
            "cron": $("#cron").val(),
            "priority": $("#priority").val(),
            "misfire": $("#misfire").val(),
            "applicationId": $("#applicationId").val(),
            "uri": $("#uri").val(),
            "url": $("#url").val(),
            "jobDescription": $("#jobDescription").val(),
            "triggerDescription": $("#triggerDescription").val()
        };
        return json;
    }
</script>
</html>