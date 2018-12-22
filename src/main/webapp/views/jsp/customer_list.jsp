<%--
  Created by IntelliJ IDEA.
  User: lkh
  Date: 2018-12-21
  Time: 20:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.tpch.util.PropertiesUtil" %>
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
                    <a href="/views/jsp/customer_list.jsp?curPage=1" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">消费者</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">在线商品</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">国家</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">订单</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">零件</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">供应商的零件</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">地区</a>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">供货商</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a>消费者<span class="sr-only">(current)</span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
<div class="container">
    <div class="jumbotron">
        <%!
            public static final int PAGESIZE = 10;
            int curPage=1;
            int pageCount=0;
        %>
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
                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                //out.print("Successfully connect to the databass!<br>");
                Statement stmt = conn.createStatement();
                //执行SQL查询语句，返回结果集
                int count = 0;
                ResultSet rsc=stmt.executeQuery("SELECT COUNT(*) totalCount FROM customer");
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
                ResultSet rs = stmt.executeQuery("SELECT * FROM customer LIMIT " + (curPage-1)*PAGESIZE + ", " + PAGESIZE);
                //成功则循环输出信息
        %>
        <table class="table table-bordered" align="center" width="800" border="1">
            <th align="center" colspan="9">
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
                            姓名
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
                            可用余额
                        </strong>
                    </p>
                </td>
                <td>
                    <p>
                        <strong>
                            市场
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
                        <%=rs.getInt("C_CUSTKEY")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("C_NAME")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("C_ADDRESS")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getInt("C_NATIONKEY")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("C_PHONE")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getDouble("C_ACCTBAL")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("C_MKTSEGMENT")%>
                    </p>
                </td>
                <td>
                    <p>
                        <%=rs.getString("C_COMMENT")%>
                    </p>
                </td>
                <td>
                    <a class="btn btn-mini btn-success"
                       href="/views/jsp/customer_change.jsp?id=<%=rs.getInt("C_CUSTKEY")%>">修改</a>
                    <a class="btn btn-mini btn-danger"
                       href="/views/jsp/customer_delete.jsp?id=<%=rs.getInt("C_CUSTKEY")%>">删除</a>
                </td>
            </tr>
            <%
                }
            %>
            <th colspan="9">
                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-primary"
                                onclick="window.location.href='/views/jsp/customer_add.jsp'">添加
                        </button>
                    </div>
                </div>
            </th>
        </table>

        <%
                //关闭数据库
                stmt.close();
                conn.close();
                //out.print("Successfully close the databass!");
            } catch (SQLException sqlexception) {
                sqlexception.printStackTrace();
            }
        %>

        <nav aria-label="Page navigation">
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
                    <a href="/views/jsp/customer_list.jsp?curPage=1" aria-label="Previous">
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
                <li><a href="/views/jsp/customer_list.jsp?curPage=<%=curPage-1%>">上一页</a></li>
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
                <li><a href="/views/jsp/customer_list.jsp?curPage=<%=i%>"><%=i%></a></li>
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
                <li><a href="/views/jsp/customer_list.jsp?curPage=<%=curPage+1%>">下一页</a></li>
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
                    <a href="/views/jsp/customer_list.jsp?curPage=<%=pageCount%>" aria-label="Previous">
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
</html>
