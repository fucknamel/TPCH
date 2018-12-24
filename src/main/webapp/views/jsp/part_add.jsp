<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.sql.*" %>
<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-24
  Time: 09:46
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
                    <a href="#">供应商的零件</a>
                </li>
                <li class="dropdown">
                    <a href="/views/jsp/region_list.jsp?curPage=1">地区</a>
                </li>
                <li class="dropdown">
                    <a href="#">供货商</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a>零件<span class="sr-only">(current)</span></a></li>
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
        if (form.P_RETAILPRICE.value != '' && isNaN(form.P_RETAILPRICE.value)) {
            alert("金额必须为数字");
            form.P_RETAILPRICE.focus();
            return false;
        }
        if (form.P_SIZE.value != '' && isNaN(form.P_SIZE.value)) {
            alert("尺寸必须为数字");
            form.P_SIZE.focus();
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
//        String querySql = "SELECT * FROM nation";
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //out.print("Successfully connect to the databass!<br>");
        Statement stmt = conn.createStatement();
//        ResultSet rs = stmt.executeQuery(querySql);
//        Map<Integer, String> map = new HashMap<Integer, String>();
//        List<String> list = new ArrayList<>();
//        while (rs.next()) {
//            map.put(rs.getInt("N_NATIONKEY"), rs.getString("N_NAME"));
//            list.add(rs.getString("N_NAME"));
//        }
%>
<div class="container">
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/part_add_ok.jsp"  role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请填写信息</h2>
            <input type="text" name="P_PARTKEY" class="form-control" placeholder="编号" required autofocus>
            <input type="text" name="P_NAME" class="form-control" placeholder="名称" autofocus>
            <input type="text" name="P_MFGR" class="form-control"  placeholder="制造商" autofocus>
            <input type="text" name="P_BRAND" class="form-control" placeholder="品牌" autofocus>
            <input type="text" name="P_TYPE" class="form-control" placeholder="型号" autofocus>
            <input type="text" name="P_SIZE" class="form-control" placeholder="尺寸" autofocus>
            <input type="text" name="P_CONTAINER" class="form-control" placeholder="包装容器" autofocus>
            <input type="text" name="P_RETAILPRICE" class="form-control" placeholder="零售价" autofocus>
            <input type="text" name="P_COMMENT" class="form-control" placeholder="备注" autofocus>
            <%--<input type="text" class="form-control" name="C_NATIONKEY" value="<%=rs.getInt("C_NATIONKEY")%>">--%>
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
            <div class="span12"><br></div>
            <button class="btn btn-lg btn-primary btn-block" type="submit">添加</button>
        </form>
    </div>
</div>
<%
//        rs.close();
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
