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
    String orderId = request.getParameter("orderId");
    String lineId = request.getParameter("lineId");
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
        String updateSql = "SELECT * FROM lineitem WHERE L_ORDERKEY='" + orderId + "' AND L_LINENUMBER = '" + lineId + "'";
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
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/lineitem_change_ok.jsp?rpage=<%=rpage%>" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请修改信息</h2>
            <input type="hidden" name="L_ORDERKEY" class="form-control" value="<%=rs.getInt("L_ORDERKEY")%>">
            <div class="input-group">
                <span class="input-group-addon">&#12288;零件名称&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="L_PARTKEY" disabled>
                    <option value="">无</option>
                    <%
                        int len = listPart.size();
                        for (int i = 0; i < len; i++) {
                    %>
                    <option value="<%=listPart.get(i)%>"
                            <%if (rs.getObject("L_PARTKEY") != null && listPart.get(i).equals(rs.getInt("L_PARTKEY"))){%>selected<%}%>><%=mapPart.get(listPart.get(i))%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#8194;供应商名称&#8194;</span>
                <select class="form-control" style="padding-left: 9px" name="L_SUPPKEY" disabled>
                    <option value="">无</option>
                    <%
                        int lenSupp = listSupp.size();
                        for (int i = 0; i < lenSupp; i++) {
                    %>
                    <option value="<%=listSupp.get(i)%>"
                            <%if (rs.getObject("L_SUPPKEY") != null && listSupp.get(i).equals(rs.getInt("L_SUPPKEY"))){%>selected<%}%>><%=mapSupp.get(listSupp.get(i))%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>
            <input type="hidden" name="L_LINENUMBER" class="form-control" value="<%=rs.getInt("L_LINENUMBER")%>">
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;数量&#12288;&#12288;</span>
                <input type="text" name="L_QUANTITY" class="form-control"
                       value="<%=rs.getDouble("L_QUANTITY")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#8194;总金额&#8194;&#12288;</span>
                <input type="text" name="L_EXTENDEDPRICE" class="form-control"
                       value="<%=rs.getDouble("L_EXTENDEDPRICE")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;折扣&#12288;&#12288;</span>
                <input type="text" name="L_DISCOUNT" class="form-control"
                       value="<%=rs.getDouble("L_DISCOUNT")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;&#8194;税&#8194;&#12288;&#12288;</span>
                <input type="text" name="L_TAX" class="form-control"
                       value="<%=rs.getString("L_TAX")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;是否退货&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="L_RETURNFLAG" required>
                    <option value="否">未退货</option>
                    <option value="是" <%if (rs.getString("L_RETURNFLAG").equals("是")){%>selected<%}%>>已退货</option>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;明细状态&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="L_LINESTATUS" required>
                    <option value="否">未退货</option>
                    <option value="是" <%if (rs.getString("L_LINESTATUS").equals("是")){%>selected<%}%>>已退货</option>
                </select>
            </div>
            <div class='input-group date' id='datetimepicker1'>
                <span class="input-group-addon">&#12288;运输日期&#12288;</span>
                <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                <input type='text' class="form-control" name="L_SHIPDATE" value="<%=rs.getString("L_SHIPDATE")%>">
            </div>
            <div class='input-group date' id='datetimepicker'>
                <span class="input-group-addon">&#12288;交付日期&#12288;</span>
                <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                <input type='text' class="form-control" name="L_COMMITDATE" value="<%=rs.getString("L_COMMITDATE")%>">
            </div>
            <div class='input-group date' id='datetimepicker2'>
                <span class="input-group-addon">&#12288;收货日期&#12288;</span>
                <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                <input type='text' class="form-control" name="L_RECEIPTDATE" value="<%=rs.getString("L_RECEIPTDATE")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;运输单位&#12288;</span>
                <input type="text" name="L_SHIPINSTRUCT" class="form-control"
                       value="<%=rs.getString("L_SHIPINSTRUCT")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;运输方式&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="L_SHIPMODE" required>
                    <option <%if (rs.getString("L_SHIPMODE").equals("陆运")){%>selected<%}%>>陆运</option>
                    <option <%if (rs.getString("L_SHIPMODE").equals("海运")){%>selected<%}%>>海运</option>
                    <option <%if (rs.getString("L_SHIPMODE").equals("空运")){%>selected<%}%>>空运</option>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;备注&#12288;&#12288;</span>
                <input type="text" name="L_COMMENT" class="form-control"
                       value="<%=rs.getString("L_COMMENT")%>">
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