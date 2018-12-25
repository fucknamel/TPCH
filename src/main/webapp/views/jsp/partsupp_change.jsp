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
  Time: 16:38
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
<script type="text/javascript">
    function check(form) {
        // if (form.PS_AVAILQTY.value != '' && checkPhone(form.PS_AVAILQTY.value) == false) {
        //     alert("请输入正确的电话号码～");
        //     form.PS_AVAILQTY.focus();
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
</script>
<%
    request.setCharacterEncoding("UTF-8");
    String partId = request.getParameter("partId");
    String suppId = request.getParameter("suppId");
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
        String updateSql = "SELECT * FROM partsupp WHERE PS_PARTKEY='" + partId + "' AND PS_SUPPKEY = '" + suppId + "'";
        String querySql = "SELECT * FROM part";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        ResultSet rsp = stmt.executeQuery(querySql);
        List<Integer> listPart = new ArrayList<>();
        Map<Integer, String> mapPart = new HashMap<>();
        while (rsp.next()) {
            mapPart.put(rsp.getInt("P_PARTKEY"), rsp.getString("P_NAME"));
            listPart.add(rsp.getInt("P_PARTKEY"));
        }
        rsp.close();
        querySql = "SELECT * FROM supplier";
        ResultSet rss = stmt.executeQuery(querySql);
        List<Integer> listSupp = new ArrayList<>();
        Map<Integer, String> mapSupp = new HashMap<>();
        while (rss.next()) {
            mapSupp.put(rss.getInt("S_SUPPKEY"), rss.getString("S_NAME"));
            listSupp.add(rss.getInt("S_SUPPKEY"));
        }
        //执行SQL查询语句，返回结果集
        ResultSet rs = stmt.executeQuery(updateSql);
//        ResultSet rsc = stmt.executeQuery(querySql);
        while (rs.next()) {
%>
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/partsupp_change_ok.jsp?rpage=<%=rpage%>" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请修改信息</h2>
            <div class="input-group">
                <span class="input-group-addon">&#12288;零件名称&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="PS_PARTKEY" readonly>
                    <%
                        int len = listPart.size();
                        for (int i = 0; i < len; i++) {
                            if (rs.getObject("PS_PARTKEY") != null && listPart.get(i).equals(rs.getInt("PS_PARTKEY"))) {
                    %>
                    <option selected value="<%=listPart.get(i)%>"><%=mapPart.get(listPart.get(i))%>
                    </option>
                    <%
                            break;}
                        }
                    %>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#8194;供应商名称&#8194;</span>
                <select class="form-control" style="padding-left: 9px" name="PS_SUPPKEY" readonly>
                    <%
                        int lenSupp = listSupp.size();
                        for (int i = 0; i < lenSupp; i++) {
                            if (rs.getObject("PS_SUPPKEY") != null && listSupp.get(i).equals(rs.getInt("PS_SUPPKEY"))) {
                    %>
                    <option selected value="<%=listSupp.get(i)%>"><%=mapSupp.get(listSupp.get(i))%>
                    </option>
                    <%
                                break;}
                        }
                    %>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;供应数量&#12288;</span>
                <input type="text" name="PS_AVAILQTY" class="form-control"
                       value="<%=rs.getInt("PS_AVAILQTY")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;供应价格&#12288;</span>
                <input type="text" name="PS_SUPPLYCOST" class="form-control"
                       value="<%=rs.getDouble("PS_SUPPLYCOST")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;备注&#12288;&#12288;</span>
                <input type="text" name="PS_COMMENT" class="form-control"
                       value="<%=rs.getString("PS_COMMENT")%>">
            </div>
            <div class="span12"><br></div>
            <button class="btn btn-lg btn-primary btn-block" type="submit">修改</button>
        </form>
    </div>
</div>
<%
        }
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
