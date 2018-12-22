<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/views/jsp/customer_list.jsp">TPC-H</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li class="dropdown">
                    <a href="/views/jsp/customer_list.jsp" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">消费者</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">在线商品</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">国家</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">订单</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">零件</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">供应商的零件</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">地区</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">供货商</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a>消费者<span class="sr-only">(current)</span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
<script type="text/javascript">
    function check(form){
        if (form.C_PHONE.value != '' && checkPhone(form.C_PHONE.value)==false){
            alert("请输入正确的电话号码～");
            form.C_PHONE.focus();
            return false;
        }
        if (form.C_ACCTBAL.value !='' && isNaN(form.C_ACCTBAL.value)){
            alert("金额必须为数字");
            form.C_ACCTBAL.focus();
            return false;
        }

        return true;
    }
</script>
<%
    //连接数据库，用jdbc驱动加载mysql
    try {
        Class.forName(PropertiesUtil.getProperty("db.name"));
    } catch (ClassNotFoundException classnotfoundexception) {
        classnotfoundexception.printStackTrace();
    }
    try {
        //连接数据库
        String URL = PropertiesUtil.getProperty("db.url");
        String USER = PropertiesUtil.getProperty("db.username");
        String PASSWORD = PropertiesUtil.getProperty("db.password");
        String querySql = "SELECT * FROM nation";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(querySql);
        List<String> list = new ArrayList<>();
        Map map = new HashMap();
        while (rs.next()) {
            map.put(rs.getInt("N_NATIONKEY"), rs.getString("N_NAME"));
            list.add(rs.getString("N_NAME"));
        }
%>
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/customer_add_ok.jsp" method="post" onsubmit="return check(this)">
            <h2 class="form-signin-heading">请填写信息</h2>
            <input type="text" name="C_CUSTKEY" class="form-control" placeholder="编号" required autofocus>
            <input type="text" name="C_NAME" class="form-control" placeholder="姓名" autofocus>
            <input type="text" name="C_ADDRESS" class="form-control" placeholder="地址" autofocus>
            <input type="text" name="C_NATIONKEY" class="form-control" placeholder="国家" autofocus>
            <div class="input-group">
                <div class="input-group-addon">国家</div>
                <%--<input type="text" class="form-control" name="C_NATIONKEY" value="<%=rs.getInt("C_NATIONKEY")%>">--%>
                <select class="form-control" name="C_NATIONKEY">
                    <%
                        int len = list.size();
                        for (int i = 0; i < len; i++) {
                    %>
                    <option><%=list.get(i)%></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <input type="text" name="C_PHONE" class="form-control" placeholder="电话" autofocus>
            <input type="text" name="C_ACCTBAL" class="form-control" placeholder="可用余额" autofocus>
            <input type="text" name="C_MKTSEGMENT" class="form-control" placeholder="市场" autofocus>
            <input type="text" name="C_COMMENT" class="form-control" placeholder="备注" autofocus>
            <div class="span12"><br></div>
            <button class="btn btn-lg btn-primary btn-block" type="submit">添加</button>
        </form>
    </div>
</div>
<%
        rs.close();
        stmt.close();
        conn.close();
    } catch (SQLException sqlexception) {
        sqlexception.printStackTrace();
    }
%>
</body>
<script>
    function checkPhone(phone){
        if(!(/^1[34578]\d{9}$/.test(phone))){
            return false;
        }
        return true;
    }
</script>
</html>
