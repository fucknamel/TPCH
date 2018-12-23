<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-22
  Time: 17:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.tpch.util.PropertiesUtil" %>
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
                    <a href="/views/jsp/customer_list.jsp?curPage=1">消费者</a>
                </li>
                <li class="dropdown">
                    <a href="#">在线商品</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/nation_list.jsp">国家</a>
                </li>
                <li class="dropdown">
                    <a href="#">订单</a>
                </li>
                <li class="dropdown">
                    <a href="#">零件</a>
                </li>
                <li class="dropdown">
                    <a href="#">供应商的零件</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/region_list.jsp?curPage=1">地区</a>
                </li>
                <li class="dropdown">
                    <a href="#">供货商</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a>消费者<span class="sr-only">(current)</span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
<%
    String id = request.getParameter("id");
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
        String deleteSql = "DELETE FROM customer WHERE C_CUSTKEY = " + id;
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        //执行SQL查询语句，返回结果集
        stmt.executeUpdate(deleteSql);
%>
<div class="container">
    <div class="jumbotron">
        <div class="alert alert-success">
            <h2 class="text-center">
                数据删除成功！
            </h2>
        </div>
    </div>
</div>
<%
    stmt.close();
    conn.close();
} catch (SQLException sqlexception) {
    sqlexception.printStackTrace();
%>
<div class="container">
    <div class="jumbotron">
        <div class="alert alert-success">
            <h2 class="text-center">
                数据删除失败
            </h2>
        </div>
    </div>
</div>
<%
    }
%>
<%-- Bootstrap --%>
<script src="/views/js/jquery-3.3.1.min.js"></script>
<script src="/views/js/bootstrap.min.js"></script>
</body>
</html>
