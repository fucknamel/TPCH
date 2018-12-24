<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-24
  Time: 13:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.tpch.util.PropertiesUtil" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
<%!
    public static final int PAGESIZE = 10;
    String searchPart = null;
    String searchSupp = null;
    int curPage=1;
    int pageCount=0;
%>
<%
    searchPart = request.getParameter("searchPart");
    searchSupp = request.getParameter("searchSupp");
    if (!(searchPart != null && !searchPart.equals("null") && !searchPart.equals(""))){
        searchPart = "";
    }
    if (!(searchSupp != null && !searchSupp.equals("null") && !searchSupp.equals(""))){
        searchSupp = "";
    }
%>
<div class="container">
    <div class="jumbotron">
        <div class="input-group">
            <input id="search" type="text" class="form-control" placeholder="搜索零件或供应商名称..." value="<%
            if(searchPart.equals("")){%><%=searchSupp%><%}else{%><%=searchPart%><%}
            %>" onkeypress="isenter(event)">
            <div class="input-group-btn">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">冲! <span class="caret"></span></button>
                <ul class="dropdown-menu dropdown-menu-right">
                    <li><a onclick="window.location.href='/views/jsp/partsupp_list.jsp?searchPart='+document.getElementById('search').value">零件名称</a></li>
                    <li><a onclick="window.location.href='/views/jsp/partsupp_list.jsp?searchSupp='+document.getElementById('search').value">供应商名称</a></li>
                </ul>
            </div>
            <%--<span class="input-group-btn">--%>
            <%--<button class="btn btn-default" type="submit" onclick="window.location.href='/views/jsp/partsupp_list.jsp?search='+document.getElementById('search').value">冲!</button>--%>
            <%--</span>--%>
        </div>
        <%
            request.setCharacterEncoding("UTF-8");
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
                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                //out.print("Successfully connect to the databass!<br>");
                Statement stmt = conn.createStatement();
                ResultSet rsp = stmt.executeQuery("SELECT * FROM part");
                Map mapPart = new HashMap();
                while (rsp.next()) {
                    mapPart.put(rsp.getInt("P_PARTKEY"), rsp.getString("P_NAME"));
                }
                rsp.close();
                ResultSet rss = stmt.executeQuery("SELECT * FROM supplier");
                Map mapSupp = new HashMap();
                while (rss.next()) {
                    mapSupp.put(rss.getInt("S_SUPPKEY"), rss.getString("S_NAME"));
                }
                rss.close();
                //执行SQL查询语句，返回结果集
                int count = 0;
                ResultSet rsc = null;
                if (!searchPart.equals("") || !searchSupp.equals("")) {
                    rsc = stmt.executeQuery("SELECT COUNT(*) totalCount FROM partsupp WHERE PS_PARTKEY IN (" +
                            "SELECT P_PARTKEY FROM part WHERE P_NAME LIKE '%" + searchPart + "%') AND PS_SUPPKEY IN(" +
                            "SELECT S_SUPPKEY FROM supplier WHERE S_NAME LIKE '%"+ searchSupp +"%')");
                }
                else{
                    searchPart = "";
                    searchSupp = "";
                    rsc = stmt.executeQuery("SELECT COUNT(*) totalCount FROM partsupp");
                }
                if (rsc.next()){
                    count = rsc.getInt("totalCount");
                }
                if (request.getParameter("curPage")!= null){
                    curPage = Integer.parseInt(request.getParameter("curPage"));
                }
                else{
                    curPage = 1;
                }
                pageCount = (count%PAGESIZE==0)?(count/PAGESIZE):(count/PAGESIZE+1);
                if (pageCount<1)
                    pageCount = 1;
                if (curPage>pageCount){
                    curPage = pageCount;
                }
                if (curPage<1)
                {
                    curPage = 1;
                }
                rsc.close();
                ResultSet rs = null;
                if (!searchPart.equals("") || !searchSupp.equals("")) {
                    rs = stmt.executeQuery("SELECT * FROM partsupp WHERE PS_PARTKEY IN (" +
                            "SELECT P_PARTKEY FROM part WHERE P_NAME LIKE '%" + searchPart + "%') AND PS_SUPPKEY IN (" +
                            "SELECT S_SUPPKEY FROM supplier WHERE S_NAME LIKE '%" + searchSupp + "%') LIMIT " + (curPage - 1) * PAGESIZE + ", " + PAGESIZE);
                }
                else{
                    rs = stmt.executeQuery("SELECT * FROM partsupp LIMIT " + (curPage-1)*PAGESIZE + ", " + PAGESIZE);
                }
                //成功则循环输出信息
        %>
        <table class="table table-bordered" align="center" width="800" border="1">
            <th align="center" colspan="6">
                <h2 class="text-center">详细数据信息</h2>
            </th>
            <tr align="center">
                <td>
                    <p>
                        <strong>
                            零件名称
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            供应商名称
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            供应数量
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            供应价格
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            备注
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            操作
                        </strong>
                    </p>
                </td>
            </tr>
            <%
                while (rs.next()) {
            %>
            <tr align="center">
                <td>
                    <p>
                        <%if (rs.getObject("PS_PARTKEY")!=null){%><%=mapPart.get(rs.getInt("PS_PARTKEY"))%><%}%>
                    </p>
                </td>
                <td>
                    <p>
                        <%if (rs.getObject("PS_SUPPKEY")!=null){%><%=mapSupp.get(rs.getInt("PS_SUPPKEY"))%><%}%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("PS_AVAILQTY")%>
                    </p>
                </td>
                <%--<td>--%>
                    <%--<p>--%>
                        <%--<%if (rs.getObject("S_NATIONKEY")!=null){%><%=map.get(rs.getInt("S_NATIONKEY"))%><%}%>--%>
                    <%--</p>--%>
                <%--</td>--%>
                <td>
                    <p>
                        <%=rs.getString("PS_SUPPLYCOST")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("PS_COMMENT")%>
                    </p>
                </td>
                <td>
                    <a class="btn btn-mini btn-success"
                       href="/views/jsp/partsupp_change.jsp?partId=<%=rs.getInt("PS_PARTKEY")%>&suppId=<%=rs.getInt("PS_SUPPKEY")%>&rpage=<%=curPage%>">修改</a>
                    <a class="btn btn-mini btn-danger"
                       href="/views/jsp/partsupp_delete.jsp?partId=<%=rs.getInt("PS_PARTKEY")%>&suppId=<%=rs.getInt("PS_SUPPKEY")%>&rpage=<%=curPage%>">删除</a>
                </td>
            </tr>
            <%
                }
            %>
            <th colspan="9">
                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-primary"
                                onclick="window.location.href='/views/jsp/partsupp_add.jsp'">添加
                        </button>
                    </div>
                </div>
            </th>
        </table>

        <%
                //关闭数据库
                rs.close();
                stmt.close();
                conn.close();
                //out.print("Successfully close the database!");
            } catch (SQLException sqlexception) {
                sqlexception.printStackTrace();
            }
        %>

        <nav aria-label="Page navigation" style="text-align: center">
            <ul class="pagination">
                <%
                    if (curPage == 1){
                %>
                <li class="disabled">
                    <span>
                        <span aria-hidden="true">&laquo;</span>
                    </span>
                </li>
                <%
                }
                else{
                %>
                <li>
                    <a href="/views/jsp/partsupp_list.jsp?curPage=1&<%
            if(searchPart.equals("")){%>searchPart=<%=searchPart%><%}else{%>searchSupp=<%=searchSupp%><%}%>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <%
                    }
                %>

                <%
                    if (curPage<2){
                %>
                <li class="disabled">
                    <span>上一页</span>
                </li>
                <%
                }
                else{
                %>
                <li><a href="/views/jsp/partsupp_list.jsp?curPage=<%=curPage-1%>&<%
            if(searchPart.equals("")){%>searchPart=<%=searchPart%><%}else{%>searchSupp=<%=searchSupp%><%}%>">上一页</a></li>
                <%
                    }
                %>
                <%
                    int cs = 0;
                    for (int i = curPage - 2;cs < 5;i++){
                        if (i<1){
                            continue;
                        }
                        if (i>pageCount){
                            break;
                        }
                        cs++;
                        if (i == curPage){
                %>
                <li class="active">
                    <span><%=curPage%> <span class="sr-only">(current)</span></span>
                </li>
                <%
                }
                else{
                %>
                <li><a href="/views/jsp/partsupp_list.jsp?curPage=<%=i%>&<%
            if(searchPart.equals("")){%>searchPart=<%=searchPart%><%}else{%>searchSupp=<%=searchSupp%><%}%>"><%=i%></a></li>
                <%
                        }
                    }
                %>

                <%
                    if (curPage+1>pageCount){
                %>
                <li class="disabled">
                    <span>下一页</span>
                </li>
                <%
                }
                else{
                %>
                <li><a href="/views/jsp/partsupp_list.jsp?curPage=<%=curPage+1%>&<%
            if(searchPart.equals("")){%>searchPart=<%=searchPart%><%}else{%>searchSupp=<%=searchSupp%><%}%>">下一页</a></li>
                <%
                    }
                %>

                <%
                    if (curPage == pageCount){
                %>
                <li class="disabled">
                    <span>
                        <span aria-hidden="true">&raquo;</span>
                    </span>
                </li>
                <%
                }
                else{
                %>
                <li>
                    <a href="/views/jsp/partsupp_list.jsp?curPage=<%=pageCount%>&<%
            if(searchPart.equals("")){%>searchPart=<%=searchPart%><%}else{%>searchSupp=<%=searchSupp%><%}
            %>" aria-label="Previous">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
                <%
                    }
                %>

            </ul>
        </nav>

    </div>
</div>
<%-- Bootstrap --%>
<script src="/views/js/jquery-3.3.1.min.js"></script>
<script src="/views/js/bootstrap.min.js"></script>
</body>
<script>
    function isenter(event){
        if (event.keyCode == 13){
            <%
            if (searchPart.equals("")){
            %>window.location.href='/views/jsp/partsupp_list.jsp?searchPart='+document.getElementById('search').value;<%}else{
                %>window.location.href='/views/jsp/partsupp_list.jsp?searchSupp='+document.getElementById('search').value;<%
            }
            %>
        }
    }
</script>
</html>
