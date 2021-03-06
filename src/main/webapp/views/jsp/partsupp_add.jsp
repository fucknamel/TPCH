<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-24
  Time: 15:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
                <li>
                    <a href="/views/jsp/orders_list.jsp?curPage=1">订单</a>
                </li>
                <li>
                    <a href="/views/jsp/part_list.jsp?curPage=1">零件</a>
                </li>
                <li class="active">
                    <a href="/views/jsp/partsupp_list.jsp">供应商零件</a>
                </li>
                <li>
                    <a href="/views/jsp/region_list.jsp?curPage=1">地区</a>
                </li>
                <li>
                    <a href="/views/jsp/supplier_list.jsp">供应商</a>
                </li>
            </ul>
        </nav>
    </div>
<script type="text/javascript">
    function check(form) {
        // if (form.C_PHONE.value != '' && checkPhone(form.C_PHONE.value) == false) {
        //     alert("请输入正确的电话号码～");
        //     form.C_PHONE.focus();
        //     return false;
        // }
        if (form.PS_AVAILQTY.value != '' && isNaN(form.PS_AVAILQTY.value)) {
            alert("金额必须为数字");
            form.PS_AVAILQTY.focus();
            return false;
        }
        if (form.PS_SUPPLYCOST.value != '' && isNaN(form.PS_SUPPLYCOST.value)) {
            alert("金额必须为数字");
            form.PS_SUPPLYCOST.focus();
            return false;
        }

        return true;
    }
    function changecolor(me){
        if (me.selectedIndex == 0){
            me.style.cssText = "padding-left: 9px;color: #8e8e8e;";
        }
        else {
            me.style.cssText = "padding-left: 9px;color: black;";
        }
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
        String querySql = "SELECT * FROM part";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(querySql);
        Map<Integer, String> mapPart = new HashMap<>();
        while (rs.next()) {
            mapPart.put(rs.getInt("P_PARTKEY"), rs.getString("P_NAME"));
        }
        rs.close();
        querySql = "SELECT * FROM supplier";
        rs = stmt.executeQuery(querySql);
        Map<Integer, String> mapSupp = new HashMap<>();
        while (rs.next()) {
            mapSupp.put(rs.getInt("S_SUPPKEY"), rs.getString("S_NAME"));
        }
%>
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/partsupp_add_ok.jsp"  role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请填写信息</h2>
            <div class="row">
                <div class="col-lg-6">
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="PS_PARTKEY" onchange="changecolor(this)" required>
                <option value="" selected style="color: #8e8e8e;">零件名称</option>
                <%
                    for (Map.Entry<Integer, String> entry : mapPart.entrySet()) {
                %>
                <option value="<%=entry.getKey()%>" style="color: black;"><%=entry.getValue()%>
                </option>
                <%
                    }
                %>
            </select>
                </div>
                <div class="col-lg-6">
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="PS_SUPPKEY" onchange="changecolor(this)" required>
                <option value="" selected style="color: #8e8e8e;">供应商名称</option>
                <%
                    for (Map.Entry<Integer, String> entry : mapSupp.entrySet()) {
                %>
                <option value="<%=entry.getKey()%>" style="color: black;"><%=entry.getValue()%>
                </option>
                <%
                    }
                %>
            </select>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-6">
            <input type="text" name="PS_AVAILQTY" class="form-control" placeholder="供应数量" autofocus>
                </div>
                <div class="col-lg-6">
            <input type="text" name="PS_SUPPLYCOST" class="form-control" placeholder="供应价格" autofocus>
                </div>
            </div>
            <input type="text" name="PS_COMMENT" class="form-control" placeholder="备注" autofocus>
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
    function checkPhone(phone) {
        if (!(/^1[34578]\d{9}$/.test(phone))) {
            return false;
        }
        return true;
    }
</script>
</html>
