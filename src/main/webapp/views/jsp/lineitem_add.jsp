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
    <link href="/views/css/navbar-fixed-top.css" rel="stylesheet">
    <link href="/views/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
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
                <li class="active"><a>供应商的零件<span class="sr-only">(current)</span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
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
        rs = stmt.executeQuery("SELECT O_ORDERKEY FROM orders");
        List<Integer> orderkeys = new ArrayList<>();
        while (rs.next()) {
            orderkeys.add(rs.getInt("O_ORDERKEY"));
        }
        rs = stmt.executeQuery("SELECT * FROM partsupp");

%>
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/lineitem_add_ok.jsp"  role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请填写信息</h2>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_ORDERKEY" onchange="changecolor(this)" required>
                <option value="" selected style="color: #8e8e8e;">订单号</option>
                <%
                    int len = orderkeys.size();
                    for (int i=0;i<len;i++) {
                %>
                <option style="color: black;"><%=orderkeys.get(i)%>
                </option>
                <%
                    }
                %>
            </select>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_PARTKEY" onchange="changecolor(this)" requied>
                <option value="" disabled selected style="color: #8e8e8e;">零件名称</option>
                <%
                    for (Map.Entry<Integer, String> entry : mapPart.entrySet()) {
                %>
                <option value="<%=entry.getKey()%>" style="color: black;"><%=entry.getValue()%>
                </option>
                <%
                    }
                %>
            </select>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_SUPPKEY" id="select7" onchange="changecolor(this)" required>
                <option value="" disabled selected style="color: #8e8e8e;">供应商名称</option>
                <%
                    for (Map.Entry<Integer, String> entry : mapSupp.entrySet()) {
                %>
                <option value="<%=entry.getKey()%>" style="color: black;"><%=entry.getValue()%>
                </option>
                <%
                    }
                %>
            </select>
            <input type="text" name="L_LINENUMBER" class="form-control" placeholder="明细编号" autofocus required>
            <input type="text" name="L_QUANTITY" class="form-control" placeholder="数量" autofocus>
            <input type="text" name="L_EXTENDEDPRICE" class="form-control" placeholder="总金额" autofocus>
            <input type="text" name="L_DISCOUNT" class="form-control" placeholder="折扣" autofocus>
            <input type="text" name="L_TAX" class="form-control" placeholder="税" autofocus>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_RETURNFLAG"
                    onchange="changecolor(this)">
                <option value="否" selected style="color: #8e8e8e;">是否退货</option>
                <option value="否" style="color: black;">否</option>
                <option value="是" style="color: black;">是</option>
            </select>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_LINESTATUS"
                    onchange="changecolor(this)">
                <option value="否" selected style="color: #8e8e8e;">明细状态</option>
                <option value="否" style="color: black;">未完成</option>
                <option value="是" style="color: black;">已完成</option>
            </select>
            <div class='input-group date' id='datetimepicker1'>
                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                <span class="input-group-addon">&#12288;运输日期&#12288;</span>
                <input type='text' class="form-control" name="L_SHIPDATE" id="datetext1">
            </div>
            <div class='input-group date' id='datetimepicker'>
                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                <span class="input-group-addon">&#12288;交付日期&#12288;</span>
                <input type='text' class="form-control" name="L_COMMITDATE" id="datetext">
            </div>
            <div class='input-group date' id='datetimepicker2'>
                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                <span class="input-group-addon">&#12288;收货日期&#12288;</span>
                <input type='text' class="form-control" name="L_RECEIPTDATE" id="datetext2">
            </div>
            <input type="text" name="L_SHIPINSTRUCT" class="form-control" placeholder="运输单位" autofocus>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_SHIPMODE"
                    onchange="changecolor(this)">
                <option value="陆运" selected disabled style="color: #8e8e8e;">运送方式</option>
                <option value="陆运" style="color: black;">陆运</option>
                <option value="海运" style="color: black;">海运</option>
                <option value="空运" style="color: black;">空运</option>
            </select>
            <input type="text" name="L_COMMENT" class="form-control" placeholder="备注" autofocus>
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
    $(function () {
        var picker1 = $('#datetimepicker1').datetimepicker({
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
        var picker2 = $('#datetimepicker2').datetimepicker({
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
        picker1.on('changeDate', function (e) {
            $('#datetimepicker2').datetimepicker('setStartDate', e.date);
        });
        picker2.on('changeDate', function (e) {
            $('#datetimepicker1').datetimepicker('setEndDate', e.date);
        });
    });

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
    $('#datetext').attr("placeholder", formatted);
    $('#datetext1').attr("placeholder", formatted);
    $('#datetext2').attr("placeholder", formatted);
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
