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
<html>
<head>
    <title>Title</title>
    <%-- Bootstrap --%>
    <link href="/views/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <%-- Custom styles for this template --%>
    <link href="/views/css/justified-nav.css" rel="stylesheet">
    <link href="/views/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
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
        if (form.O_TOTALPRICE.value != '' && isNaN(form.O_TOTALPRICE.value)) {
            alert("金额必须为数字");
            form.O_TOTALPRICE.focus();
            return false;
        }

        return true;
    }

    function changecolor(me) {
        if (me.selectedIndex == 0) {
            me.style.cssText = "padding-left: 9px;color: #8e8e8e;";
        } else {
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
        String querySql = "SELECT * FROM customer";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(querySql);
        Map<Integer, String> map = new HashMap<Integer, String>();
        List<String> list = new ArrayList<>();
        while (rs.next()) {
            map.put(rs.getInt("C_CUSTKEY"), rs.getString("C_NAME"));
        }
%>
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/orders_add_ok.jsp" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请填写信息</h2>
            <div class="row">
                <div class="col-lg-6">
            <input type="text" name="O_ORDERKEY" class="form-control" placeholder="编号" required autofocus>
                </div>
                <div class="col-lg-6">
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="O_CUSTKEY"
                    onchange="changecolor(this)">
                <option value="" selected style="color: #8e8e8e;">顾客</option>
                <%
                    for (Map.Entry<Integer, String> entry : map.entrySet()) {
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
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="O_ORDERSTATUS"
                    onchange="changecolor(this)">
                <option value="否" selected style="color: #8e8e8e;">订单状态</option>
                <option value="否" style="color: black;">未完成</option>
                <option value="是" style="color: black;">已完成</option>
            </select>
                </div>
                <div class="col-lg-6">
            <input type="text" name="O_TOTALPRICE" class="form-control" placeholder="订单金额" readonly>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-6">
            <div class='input-group date' id='datetimepicker'>
                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                <input type='text' class="form-control" name="O_ORDERDATE" id="datetext">
            </div>
                </div>
                <div class="col-lg-6">
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="O_ORDERPRIORITY"
                    onchange="changecolor(this)">
                <option value="中" selected style="color: #8e8e8e;">优先级</option>
                <option style="color: black;">低</option>
                <option style="color: black;">中</option>
                <option style="color: black;">高</option>
            </select>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-6">
            <input type="text" name="O_CLERK" class="form-control" placeholder="制单员" autofocus>
                </div>
                <div class="col-lg-6">
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="O_SHIPPRIORITY"
                    onchange="changecolor(this)">
                <option value="3" selected style="color: #8e8e8e;">运输优先级</option>
                <option style="color: black;">0</option>
                <option style="color: black;">1</option>
                <option style="color: black;">2</option>
                <option style="color: black;">3</option>
                <option style="color: black;">4</option>
                <option style="color: black;">5</option>
                <option style="color: black;">6</option>
            </select>
                </div>
            </div>
            <input type="text" name="O_COMMENT" class="form-control" placeholder="备注" autofocus>
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
<script src="/views/js/jquery-3.3.1.min.js"></script>
<script src="/views/js/bootstrap.min.js"></script>
<script src="/views/js/bootstrap-datetimepicker.min.js"></script>
<script src="/views/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">
    $('#datetimepicker').datetimepicker({
        format: 'yyyy-mm-dd',
        weekStart: 0,
        startView: 3,
        language: 'zh-CN',
        autoclose: 1,
        minView: 2,
        maxView: 4,
        forceParse: true,
        todayBtn: true,
        todayHighlight: true
    });
    var date = $("#datetimepicker").data("datetimepicker").getDate();
    formatted = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
    $('#datetext').attr("value", formatted);
</script>
<script>
    function checkPhone(phone) {
        if (!(/^1[34578]\d{9}$/.test(phone))) {
            return false;
        }
        return true;
    }
</script>
</html>
