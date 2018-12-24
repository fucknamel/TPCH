<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-22
  Time: 11:28
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
                <li class="active"><a>订单<span class="sr-only">(current)</span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
<script type="text/javascript">
    function check(form) {
        if (form.O_TOTALPRICE.value != '' && isNaN(form.O_TOTALPRICE.value)) {
            alert("金额必须为数字");
            form.O_TOTALPRICE.focus();
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
        String updateSql = "SELECT * FROM orders WHERE O_ORDERKEY=" + id;
        String querySql = "SELECT * FROM customer";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
        ResultSet rsc = stmt.executeQuery(querySql);
        List<Integer> list = new ArrayList<>();
        Map<Integer, String> map = new HashMap<Integer, String>();
        while (rsc.next()) {
            map.put(rsc.getInt("C_CUSTKEY"), rsc.getString("C_NAME"));
            list.add(rsc.getInt("C_CUSTKEY"));
        }
        rsc.close();
        //执行SQL查询语句，返回结果集
        ResultSet rs = stmt.executeQuery(updateSql);
//        ResultSet rsc = stmt.executeQuery(querySql);
        while (rs.next()) {
%>
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/orders_change_ok.jsp?rpage=<%=rpage%>" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请修改信息</h2>
            <input type="hidden" name="O_ORDERKEY" class="form-control" value="<%=rs.getInt("O_ORDERKEY")%>">
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;顾客&#12288;&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="O_CUSTKEY" required>
                    <%
                        int len = list.size();
                        for (int i = 0; i < len; i++) {
                    %>
                    <option value="<%=list.get(i)%>"
                            <%if (rs.getObject("O_CUSTKEY") != null && list.get(i).equals(rs.getInt("O_CUSTKEY"))){%>selected<%}%>><%=map.get(list.get(i))%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;订单状态&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="O_ORDERSTATUS" required>
                    <option value="否">未完成</option>
                    <option value="是" <%if (rs.getString("O_ORDERSTATUS").equals("是")){%>selected<%}%>>已完成</option>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;订单金额&#12288;</span>
                <input type="text" name="O_TOTALPRICE" class="form-control"
                       value="<%=rs.getDouble("O_TOTALPRICE")%>" disabled>
            </div>
            <div class='input-group date' id='datetimepicker'>
                <span class="input-group-addon">&#12288;订单日期&#12288;</span>
                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                    </span>
                <input type='text' class="form-control" name="O_ORDERDATE" value="<%=rs.getString("O_ORDERDATE")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#8194;优先级&#8194;&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="O_ORDERPRIORITY" required>
                    <option <%if (rs.getString("O_ORDERPRIORITY").equals("低级")){%>selected<%}%>>低级</option>
                    <option <%if (rs.getString("O_ORDERPRIORITY").equals("默认")){%>selected<%}%>>默认</option>
                    <option <%if (rs.getString("O_ORDERPRIORITY").equals("顶级")){%>selected<%}%>>顶级</option>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#8194;制单员&#8194;&#12288;</span>
                <input type="text" name="O_CLERK" class="form-control"
                       value="<%=rs.getString("O_CLERK")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#8194;运输优先级&#8194;</span>
                <select class="form-control" style="padding-left: 9px" name="O_SHIPPRIORITY" required>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("0")){%>selected<%}%>>0</option>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("1")){%>selected<%}%>>1</option>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("2")){%>selected<%}%>>2</option>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("3")){%>selected<%}%>>3</option>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("4")){%>selected<%}%>>4</option>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("5")){%>selected<%}%>>5</option>
                    <option <%if (rs.getString("O_SHIPPRIORITY").equals("6")){%>selected<%}%>>6</option>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;备注&#12288;&#12288;</span>
                <input type="text" name="O_COMMENT" class="form-control"
                       value="<%=rs.getString("O_COMMENT")%>">
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
