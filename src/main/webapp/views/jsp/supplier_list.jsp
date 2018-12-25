<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-24
  Time: 11:12
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
                    <a href="/views/jsp/partsupp_list.jsp">供应商的零件</a>
                </li>
                <li>
                    <a href="/views/jsp/region_list.jsp?curPage=1">地区</a>
                </li>
                <li class="active">
                    <a href="/views/jsp/supplier_list.jsp">供货商</a>
                </li>
            </ul>
        </nav>
    </div>
<%!
    public static final int PAGESIZE = 10;
    String search = null;
    int curPage=1;
    int pageCount=0;
%>
<%
    search = request.getParameter("search");
    if (!(search != null && !search.equals("null") && !search.equals(""))){
        search = "";
    }
%>
    <div class="jumbotron">
        <div class="input-group input-group-lg">
            <input id="search" type="text" class="form-control" placeholder="搜索名称..." value="<%=search%>" onkeypress="isenter(event)">
            <span class="input-group-btn">
            <button class="btn btn-default" type="submit" onclick="window.location.href='/views/jsp/supplier_list.jsp?search='+document.getElementById('search').value">冲!</button>
            </span>
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
                ResultSet rsq = stmt.executeQuery("SELECT * FROM nation");
                Map map = new HashMap();
                while (rsq.next()) {
                    map.put(rsq.getInt("N_NATIONKEY"), rsq.getString("N_NAME"));
                }
                rsq.close();
                //执行SQL查询语句，返回结果集
                int count = 0;
                ResultSet rsc = null;
                if (!search.equals("")) {
                    rsc = stmt.executeQuery("SELECT COUNT(*) totalCount FROM supplier WHERE S_NAME LIKE '%" + search + "%' ");
                }
                else{
                    search = "";
                    rsc = stmt.executeQuery("SELECT COUNT(*) totalCount FROM supplier");
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
                if (!search.equals("")) {
                    rs = stmt.executeQuery("SELECT * FROM supplier WHERE S_NAME LIKE '%" + search + "%' LIMIT " + (curPage - 1) * PAGESIZE + ", " + PAGESIZE);
                }
                else{
                    rs = stmt.executeQuery("SELECT * FROM supplier LIMIT " + (curPage-1)*PAGESIZE + ", " + PAGESIZE);
                }
                //成功则循环输出信息
        %>
        <table class="table table-bordered" align="center" width="800" border="1">
            <th align="center" colspan="8">
                <h2 class="text-center">详细数据信息</h2>
            </th>
            <tr align="center">
                <td>
                    <p>
                        <strong>
                            编号
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            名称
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            地址
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            国家
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            电话
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            账户余额
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
                        <%=rs.getInt("S_SUPPKEY")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("S_NAME")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("S_ADDRESS")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%if (rs.getObject("S_NATIONKEY")!=null){%><%=map.get(rs.getInt("S_NATIONKEY"))%><%}%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("S_PHONE")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getDouble("S_ACCTBAL")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("S_COMMENT")%>
                    </p>
                </td>
                <td>
                    <a class="btn btn-mini btn-success"
                       href="/views/jsp/supplier_change.jsp?id=<%=rs.getInt("S_SUPPKEY")%>&rpage=<%=curPage%>">修改</a>
                    <a class="btn btn-mini btn-danger"
                       href="/views/jsp/supplier_delete.jsp?id=<%=rs.getInt("S_SUPPKEY")%>&rpage=<%=curPage%>">删除</a>
                </td>
            </tr>
            <%
                }
            %>
            <th colspan="9">
                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-primary"
                                onclick="window.location.href='/views/jsp/supplier_add.jsp'">添加
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
                    <a href="/views/jsp/supplier_list.jsp?curPage=1&search=<%=search%>" aria-label="Previous">
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
                <li><a href="/views/jsp/supplier_list.jsp?curPage=<%=curPage-1%>&search=<%=search%>">上一页</a></li>
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
                <li><a href="/views/jsp/supplier_list.jsp?curPage=<%=i%>&search=<%=search%>"><%=i%></a></li>
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
                <li><a href="/views/jsp/supplier_list.jsp?curPage=<%=curPage+1%>&search=<%=search%>">下一页</a></li>
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
                    <a href="/views/jsp/supplier_list.jsp?curPage=<%=pageCount%>&search=<%=search%>" aria-label="Previous">
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
            window.location.href='/views/jsp/supplier_list.jsp?search='+document.getElementById('search').value;
        }
    }
</script>
</html>
