<html>
<head>
    <script src="/webjars/jquery/jquery.min.js"></script>
    <script src="/webjars/bootstrap/js/bootstrap.min.js"></script>
    <script src="/webjars/bootstrap-paginator/src/bootstrap-paginator.js"></script>
    <title>Regcovery服务注册中心控制台</title>
    <link rel="stylesheet" href="/webjars/bootstrap/css/bootstrap.min.css"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<nav class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <img src="/images/spring-boot.png" height="60" width="60">
        <img src="/images/logo.png" width="500">

    </div>
    <div>
        <a class="navbar-brand" href="/regcovery-ui.html">HOME</a>
        <ul class="nav navbar-nav">
            <li class="active"><a href="https://microcmpt.github.io/" target="_blank">Document</a></li>
        </ul>
    </div>
</nav>
<div class="container"><br/>
<#-- 系统状态 -->
    <div class="table-responsive">
        <h3><strong>System Info</strong></h3>
        <table class="table">
            <thead>
            <tr class="active">
                <th>Name</th>
                <th>Value</th>
            </tr>
            </thead>
            <tbody id="systemInfoTbody" class="table-striped">
            </tbody>
        </table>
    </div>
<#-- 服务注册信息 -->
    <div class="table-responsive">
        <h3><strong>Services currently registered with Regcovery</strong></h3>
        <table class="table">
            <thead>
            <tr class="active">
                <th>Service Name</th>
                <th>Service Address</th>
            </tr>
            </thead>
            <tbody class="table-striped">
            <#list map.data as service>
            <tr>
                <td>${service.childNode!''}</td>
                <td>${service.serviceAddrs!''}</td>
            </tr>
            </#list>
            </tbody>
        </table>
    </div>
</div>
</body>
<script type="application/javascript">
    $(document).ready(function () {
        $.ajax({
            type: "Get",
            url: "/health",
            dataType: "json",
            success: function (data) {
                var tmp = "";
                $.each(data, function (_key) {
                    tmp += "<tr><td>" + _key + "</td><td>" + data[_key] + "</td></tr>";
                });
                $('#systemInfoTbody').append(tmp);
            },
            error: function () {
                alert("网络异常！")
            }
        })
    })

</script>
</html>