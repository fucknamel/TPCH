<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-23
  Time: 21:51
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
                <li class="active">
                    <a href="/views/jsp/nation_list.jsp">国家</a>
                </li>
                <li>
                    <a href="/views/jsp/orders_list.jsp?curPage=1">订单</a>
                </li>
                <li>
                    <a href="/views/jsp/part_list.jsp?curPage=1">零件</a>
                </li>
                <li>
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
    String id = request.getParameter("id");
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
        String updateSql = "SELECT * FROM nation WHERE N_NATIONKEY=" + id;
        String querySql = "SELECT * FROM region";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        ResultSet rsc = stmt.executeQuery(querySql);
        List<Integer> list = new ArrayList<>();
        Map<Integer, String> map = new HashMap<>();
        while (rsc.next()) {
            map.put(rsc.getInt("R_REGIONKEY"), rsc.getString("R_NAME"));
            list.add(rsc.getInt("R_REGIONKEY"));
        }
        rsc.close();
        //执行SQL查询语句，返回结果集
        ResultSet rs = stmt.executeQuery(updateSql);
//        ResultSet rsc = stmt.executeQuery(querySql);
        while (rs.next()) {
%>
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/nation_change_ok.jsp?rpage=<%=rpage%>" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请修改信息</h2>
            <input type="hidden" name="N_NATIONKEY" class="form-control" value="<%=rs.getInt("N_NATIONKEY")%>">
            <div class="row">
                <div class="col-lg-6">
            <div class="input-group">
                <span class="input-group-addon">&#12288;名称&#12288;</span>
                <input type="text" name="N_NAME" class="form-control"
                       value="<%=rs.getString("N_NAME")%>">
            </div>
                </div>
                <div class="col-lg-6">
            <div class="input-group">
                <span class="input-group-addon">所属地区</span>
                <select class="form-control" style="padding-left: 9px" name="N_REGIONKEY">
                    <option value="">无</option>
                    <%
                        int len = list.size();
                        for (int i = 0; i < len; i++) {
                    %>
                    <option value="<%=list.get(i)%>"
                            <%if (rs.getObject("N_REGIONKEY") != null && list.get(i).equals(rs.getInt("N_REGIONKEY"))){%>selected<%}%>><%=map.get(list.get(i))%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>
                </div>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;备注&#12288;</span>
                <input type="text" name="N_COMMENT" class="form-control"
                       value="<%=rs.getString("N_COMMENT")%>">
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
