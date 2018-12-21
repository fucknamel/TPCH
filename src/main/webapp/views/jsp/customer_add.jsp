<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-21
  Time: 23:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Title</title>
    <%-- Bootstrap --%>
    <link href="/views/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <%-- Custom styles for this template --%>
    <link href="/views/css/navbar-fixed-top.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/TPCH/views/jsp/customer_add_ok.jsp" method="post">
            <h2 class="form-signin-heading">请填写信息</h2>
            <input type="text" name="C_CUSTKEY" class="form-control" placeholder="编号" autofocus>
            <input type="text" name="C_NAME" class="form-control" placeholder="姓名" autofocus>
            <input type="text" name="C_ADDRESS" class="form-control" placeholder="地址" autofocus>
            <input type="text" name="C_NATIONKEY" class="form-control" placeholder="国家" autofocus>
            <input type="text" name="C_PHONE" class="form-control" placeholder="电话" autofocus>
            <input type="text" name="C_ACCTBAL" class="form-control" placeholder="可用余额" autofocus>
            <input type="text" name="C_MKTSEGMENT" class="form-control" placeholder="市场" autofocus>
            <input type="text" name="C_COMMENT" class="form-control" placeholder="备注" autofocus>
            <div class="span12"><br></div>
            <button class="btn btn-lg btn-primary btn-block" type="submit">添加</button>
        </form>
    </div>
</div>
</body>
</html>
