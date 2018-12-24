<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-24
  Time: 17:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
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
                    <a href="/views/jsp/lineitem_list.jsp">订单明细</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/nation_list.jsp">国家</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/orders_list.jsp?curPage=1">订单</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/part_list.jsp?curPage=1">零件</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/partsupp_list.jsp">供应商的零件</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/region_list.jsp?curPage=1">地区</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/supplier_list.jsp">供货商</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a>订单明细<span class="sr-only">(current)</span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
<%
    request.setCharacterEncoding("UTF-8");
    int rpage = Integer.parseInt(request.getParameter("rpage"));
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
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        Statement stmt = conn.createStatement();

        StringBuilder insertSql = new StringBuilder("UPDATE lineitem SET ");

        insertSql.append("L_QUANTITY=");
        if(StringUtils.isBlank(request.getParameter("L_QUANTITY"))){
            insertSql.append("0" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_QUANTITY") + "', ");
        }
        insertSql.append("L_EXTENDEDPRICE=");
        if(StringUtils.isBlank(request.getParameter("L_EXTENDEDPRICE"))){
            insertSql.append("0" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_EXTENDEDPRICE") + "', ");
        }
        insertSql.append("L_DISCOUNT=");
        if(StringUtils.isBlank(request.getParameter("L_DISCOUNT"))){
            insertSql.append("0" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_DISCOUNT") + "', ");
        }
        insertSql.append("L_TAX=");
        if(StringUtils.isBlank(request.getParameter("L_TAX"))){
            insertSql.append("0" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_TAX") + "', ");
        }
        insertSql.append("L_RETURNFLAG=");
        if(StringUtils.isBlank(request.getParameter("L_RETURNFLAG"))){
            insertSql.append("''" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_RETURNFLAG") + "', ");
        }
        insertSql.append("L_LINESTATUS=");
        if(StringUtils.isBlank(request.getParameter("L_LINESTATUS"))){
            insertSql.append("''" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_LINESTATUS") + "', ");
        }
        insertSql.append("L_SHIPDATE=");
        if(StringUtils.isBlank(request.getParameter("L_SHIPDATE"))){
            insertSql.append("'2008-08-08'" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_SHIPDATE") + "', ");
        }
        insertSql.append("L_COMMITDATE=");
        if(StringUtils.isBlank(request.getParameter("L_COMMITDATE"))){
            insertSql.append("'2008-08-08'" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_COMMITDATE") + "', ");
        }
        insertSql.append("L_RECEIPTDATE=");
        if(StringUtils.isBlank(request.getParameter("L_RECEIPTDATE"))){
            insertSql.append("'2008-08-08'" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_RECEIPTDATE") + "', ");
        }
        insertSql.append("L_SHIPINSTRUCT=");
        if(StringUtils.isBlank(request.getParameter("L_SHIPINSTRUCT"))){
            insertSql.append("''" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_SHIPINSTRUCT") + "', ");
        }
        insertSql.append("L_SHIPMODE=");
        if(StringUtils.isBlank(request.getParameter("L_SHIPMODE"))){
            insertSql.append("''" + ",");
        }else {
            insertSql.append("'" + request.getParameter("L_SHIPMODE") + "', ");
        }
        insertSql.append("L_COMMENT=");
        if(StringUtils.isBlank(request.getParameter("L_COMMENT"))){
            insertSql.append("''");
        }else {
            insertSql.append("'" + request.getParameter("L_COMMENT") + "'");
        }

        insertSql.append("WHERE L_ORDERKEY='"+ request.getParameter("L_ORDERKEY") + "' AND L_LINENUMBER = '" + request.getParameter("L_LINENUMBER") + "'");
        System.out.println(insertSql.toString());
        //执行SQL查询语句，返回结果集
        stmt.executeUpdate(insertSql.toString());
        //关闭数据库
        stmt.close();
        conn.close();
%>
<div class="container">
    <div class="jumbotron">
        <div class="alert alert-success">
            <h2 class="text-center">
                数据修改成功！
            </h2>
            <a href="/views/jsp/lineitem_list.jsp?curPage=<%=rpage%>" class="btn btn-primary " style="margin: 0px auto;display: table;" role="button">返回</a>
        </div>
    </div>
</div>
<%
} catch (SQLException sqlexception) {
    sqlexception.printStackTrace();
%>
<div class="container">
    <div class="jumbotron">
        <div class="alert alert-success">
            <h2 class="text-center">
                数据修改失败
            </h2>
            <a href="/views/jsp/lineitem_list.jsp?curPage=<%=rpage%>" class="btn btn-primary " style="margin: 0px auto;display: table;" role="button">返回</a>
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
