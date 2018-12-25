<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.sql.*" %>
<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-23
  Time: 19:10
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
                <li>
                    <a href="/views/jsp/partsupp_list.jsp">供应商零件</a>
                </li>
                <li class="active">
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
    function changecolor(me){
        me.style.cssText="padding-left: 9px;color: black;";
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
//        Map<Integer, String> map = new HashMap<Integer, String>();
//        List<String> list = new ArrayList<>();
//        while (rs.next()) {
//            map.put(rs.getInt("N_NATIONKEY"), rs.getString("N_NAME"));
//            list.add(rs.getString("N_NAME"));
//        }
%>
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/region_add_ok.jsp"  role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请填写信息</h2>
            <input type="text" name="R_REGIONKEY" class="form-control" placeholder="编号" required autofocus>
            <input type="text" name="R_NAME" class="form-control" placeholder="名称" autofocus>
            <input type="text" name="R_COMMENT" class="form-control"  placeholder="备注" autofocus>
            <%--<input type="text" class="form-control" name="C_NATIONKEY" value="<%=rs.getInt("C_NATIONKEY")%>">--%>
            <input type="text" name="PS_SUPPLYCOST" class="form-control"  placeholder="供应价格" autofocus>
            <%--<input type="text" class="form-control" name="C_NATIONKEY" value="<%=rs.getInt("C_NATIONKEY")%>">--%>
            <%--<select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="C_NATIONKEY" onchange="changecolor(this)" required>--%>
                <%--<option value="" disabled selected style="display: none;">供应价格</option>--%>
                <%--<%--%>
                    <%--for (Map.Entry<Integer, String> entry : map.entrySet()) {--%>
                <%--%>--%>
                <%--<option value="<%=entry.getKey()%>" style="color: black;"><%=entry.getValue()%>--%>
                <%--</option>--%>
                <%--<%--%>
                    <%--}--%>
                <%--%>--%>
            <%--</select>--%>
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
