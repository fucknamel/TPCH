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
  Time: 19:30
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
                    <a href="#">在线商品</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/nation_list?curPage=1.jsp">国家</a>
                </li>
                <li class="dropdown">
                    <a href="#">订单</a>
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
                <li class="active"><a>地区<span class="sr-only">(current)</span></a></li>
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
        String updateSql = "SELECT * FROM region WHERE R_REGIONKEY=" + id;
//        String querySql = "SELECT * FROM nation";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
//        ResultSet rsc = stmt.executeQuery(querySql);
//        List<Integer> list = new ArrayList<>();
//        Map<Integer, String> map = new HashMap<Integer, String>();
//        while (rsc.next()) {
//            map.put(rsc.getInt("N_NATIONKEY"), rsc.getString("N_NAME"));
//            list.add(rsc.getInt("N_NATIONKEY"));
//        }
//        rsc.close();
        //执行SQL查询语句，返回结果集
        ResultSet rs = stmt.executeQuery(updateSql);
//        ResultSet rsc = stmt.executeQuery(querySql);
        while (rs.next()) {
%>
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/region_change_ok.jsp?rpage=<%=rpage%>" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请修改信息</h2>
            <input type="hidden" name="R_REGIONKEY" class="form-control" value="<%=rs.getInt("R_REGIONKEY")%>">
            <div class="input-group">
                <span class="input-group-addon">&#12288;名称&#12288;</span>
                <input type="text" name="R_NAME" class="form-control"
                       value="<%=rs.getString("R_NAME")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;备注&#12288;</span>
                <input type="text" name="R_COMMENT" class="form-control"
                       value="<%=rs.getString("R_COMMENT")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">供应价格</span>
                <input type="text" name="PS_SUPPLYCOST" class="form-control"
                       value="<%=rs.getString("PS_SUPPLYCOST")%>">
            </div>
            <%--<input type="text" class="form-control" name="C_NATIONKEY" value="<%=rs.getInt("C_NATIONKEY")%>">--%>
            <%--<div class="input-group">--%>
                <%--<span class="input-group-addon">&#12288;供应价格&#12288;</span>--%>
                <%--<select class="form-control" style="padding-left: 8px" name="PS_SUPPLYCOST">--%>
                    <%--<%--%>
                        <%--int len = list.size();--%>
                        <%--for (int i = 0; i < len; i++) {--%>
                    <%--%>--%>
                    <%--<option value="<%=list.get(i)%>"--%>
                            <%--<%if (list.get(i).equals(rs.getInt("C_NATIONKEY"))){%>selected<%}%>><%=map.get(list.get(i))%>--%>
                    <%--</option>--%>
                    <%--<%--%>
                        <%--}--%>
                    <%--%>--%>
                <%--</select>--%>
            <%--</div>--%>
            <div class="input-group">
                <span class="input-group-addon">&#12288;备注&#12288;</span>
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
