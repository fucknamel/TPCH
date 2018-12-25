<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-22
  Time: 13:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<html>
<html>
<head>
    <title>Title</title>
    <%-- Bootstrap --%>
    <link href="/views/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <%-- Custom styles for this template --%>
    <link href="/views/css/justified-nav.css" rel="stylesheet">
    <link href="/views/fonts/favicon.ico" rel="icon">
</head>
<body>
<div class="container">
    <div class="masthead">
        <h3 class="text-muted">TPC-H</h3>
        <nav>
            <ul class="nav nav-justified">
                <li>
                    <a href="/views/jsp/customer_list.jsp?curPage=1">消费者</a>
                </li>
                <li>
                    <a href="/views/jsp/lineitem_list.jsp">订单明细</a>
                </li>
                <li>
                    <a href="/views/jsp/nation_list.jsp">国家</a>
                </li>
                <li class="active">
                    <a href="/views/jsp/orders_list.jsp?curPage=1">订单</a>
                </li>
                <li>
                    <a href="/views/jsp/part_list.jsp?curPage=1">零件</a>
                </li>
                <li>
                    <a href="/views/jsp/partsupp_list.jsp">供应商的零件</a>
                </li>
                <li>
                    <a href="/views/jsp/region_list.jsp?curPage=1">地区</a>
                </li>
                <li>
                    <a href="/views/jsp/supplier_list.jsp">供货商</a>
                </li>
            </ul>
        </nav>
    </div>
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

        StringBuilder insertSql = new StringBuilder("UPDATE orders SET ");
        insertSql.append("O_CUSTKEY=");
        if(StringUtils.isBlank(request.getParameter("O_CUSTKEY"))){
            insertSql.append("null" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_CUSTKEY") + "', ");
        }
        insertSql.append("O_ORDERSTATUS=");
        if(StringUtils.isBlank(request.getParameter("O_ORDERSTATUS"))){
            insertSql.append("'否'" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_ORDERSTATUS") + "', ");
        }
        insertSql.append("O_TOTALPRICE=");
        if(StringUtils.isBlank(request.getParameter("O_TOTALPRICE"))){
            insertSql.append("0" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_TOTALPRICE") + "', ");
        }
        insertSql.append("O_ORDERDATE=");
        if(StringUtils.isBlank(request.getParameter("O_ORDERDATE"))){
            insertSql.append("'2008-08-08'" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_ORDERDATE") + "', ");
        }
        insertSql.append("O_ORDERPRIORITY=");
        if(StringUtils.isBlank(request.getParameter("O_ORDERPRIORITY"))){
            insertSql.append("默认" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_ORDERPRIORITY") + "', ");
        }
        insertSql.append("O_CLERK=");
        if(StringUtils.isBlank(request.getParameter("O_CLERK"))){
            insertSql.append("'某员工'" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_CLERK") + "', ");
        }
        insertSql.append("O_SHIPPRIORITY=");
        if(StringUtils.isBlank(request.getParameter("O_SHIPPRIORITY"))){
            insertSql.append("3" + ",");
        }else {
            insertSql.append("'" + request.getParameter("O_SHIPPRIORITY") + "', ");
        }
        insertSql.append("O_COMMENT=");
        if(StringUtils.isBlank(request.getParameter("O_COMMENT"))){
            insertSql.append("''");
        }else {
            insertSql.append("'" + request.getParameter("O_COMMENT") + "'");
        }
        insertSql.append("WHERE O_ORDERKEY='"+ request.getParameter("O_ORDERKEY") + "'");
        //执行SQL查询语句，返回结果集
        stmt.executeUpdate(insertSql.toString());
        //关闭数据库
        stmt.close();
        conn.close();
%>
    <div class="jumbotron">
        <div class="alert alert-success">
            <h2 class="text-center">
                数据修改成功！
            </h2>
            <a href="/views/jsp/orders_list.jsp?curPage=<%=rpage%>" class="btn btn-primary " style="margin: 0px auto;display: table;" role="button">返回</a>
        </div>
    </div>
</div>
<%
} catch (SQLException sqlexception) {
    sqlexception.printStackTrace();
%>
    <div class="jumbotron">
        <div class="alert alert-success">
            <h2 class="text-center">
                数据修改失败
            </h2>
            <a href="/views/jsp/orders_list.jsp?curPage=<%=rpage%>" class="btn btn-primary " style="margin: 0px auto;display: table;" role="button">返回</a>
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
