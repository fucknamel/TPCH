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
                <li class="active">
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
                <li>
                    <a href="/views/jsp/supplier_list.jsp">供货商</a>
                </li>
            </ul>
        </nav>
    </div>
<script type="text/javascript">
</script>
<%!
    public double[][] costlist = new double[20000][4];
    public int p = 0;
%>
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

        ResultSet rsi = stmt.executeQuery("SELECT * FROM partsupp");

        p=0;
        while (rsi.next()){
            costlist[p][0]=rsi.getInt("PS_PARTKEY");
            costlist[p][1]=rsi.getInt("PS_SUPPKEY");
            costlist[p][2]=rsi.getInt("PS_AVAILQTY");
            costlist[p][3]=rsi.getInt("PS_SUPPLYCOST");
            p++;
        }
        rsi.close();

        //执行SQL查询语句，返回结果集
        ResultSet rs = stmt.executeQuery(updateSql);
//        ResultSet rsc = stmt.executeQuery(querySql);
        while (rs.next()) {
%>
    <div class="jumbotron">
        <form class="form-signin" action="/views/jsp/lineitem_change_ok.jsp?rpage=<%=rpage%>" role="form" method="post"
              onsubmit="return check(this)">
            <h2 class="form-signin-heading">请修改信息</h2>
            <input type="hidden" name="L_ORDERKEY" class="form-control" value="<%=rs.getInt("L_ORDERKEY")%>">
            <div class="input-group">
                <span class="input-group-addon">&#12288;零件名称&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="L_PARTKEY" id="par" onchange="mult()" readonly="">
                    <%
                        int len = listPart.size();
                        for (int i = 0; i < len; i++) {
                            if (rs.getObject("L_PARTKEY") != null && listPart.get(i).equals(rs.getInt("L_PARTKEY"))) {
                    %>
                    <option selected value="<%=listPart.get(i)%>"><%=mapPart.get(listPart.get(i))%>
                    </option>
                    <%
                                break;}
                        }
                    %>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#8194;供应商名称&#8194;</span>
                <select class="form-control" style="padding-left: 9px" name="L_SUPPKEY" id="select7" onchange="mult()" readonly>
                    <%
                        int lenSupp = listSupp.size();
                        for (int i = 0; i < lenSupp; i++) {
                            if (rs.getObject("L_SUPPKEY") != null && listSupp.get(i).equals(rs.getInt("L_SUPPKEY"))) {
                    %>
                    <option selected value="<%=listSupp.get(i)%>"><%=mapSupp.get(listSupp.get(i))%>
                    </option>
                    <%
                                break;}
                        }
                    %>
                </select>
            </div>
            <input type="hidden" name="L_LINENUMBER" class="form-control" value="<%=rs.getInt("L_LINENUMBER")%>">
            <p id="biao" style="margin: 0;" >&#12288;</p>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;数量&#12288;&#12288;</span>
                <input type="text" name="L_QUANTITY" class="form-control" id="quantity" oninput="mult()"
                       value="<%=rs.getDouble("L_QUANTITY")%>">
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#8194;总金额&#8194;&#12288;</span>
                <input type="text" name="L_EXTENDEDPRICE" class="form-control" id="all"
                       value="<%=rs.getDouble("L_EXTENDEDPRICE")%>" readonly>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;折扣&#12288;&#12288;</span>
                <select class="form-control" style="padding-left: 9px" name="L_DISCOUNT" id="dis" onchange="mult()" required>
                    <option value="0" <%if (rs.getDouble("L_DISCOUNT")==0){%>selected<%}%>>无折扣</option>
                    <option value="90" <%if (rs.getDouble("L_DISCOUNT")==90){%>selected<%}%>>一折</option>
                    <option value="80" <%if (rs.getDouble("L_DISCOUNT")==80){%>selected<%}%>>二折</option>
                    <option value="70" <%if (rs.getDouble("L_DISCOUNT")==70){%>selected<%}%>>三折</option>
                    <option value="60" <%if (rs.getDouble("L_DISCOUNT")==60){%>selected<%}%>>四折</option>
                    <option value="50" <%if (rs.getDouble("L_DISCOUNT")==50){%>selected<%}%>>五折</option>
                    <option value="40" <%if (rs.getDouble("L_DISCOUNT")==40){%>selected<%}%>>六折</option>
                    <option value="30" <%if (rs.getDouble("L_DISCOUNT")==30){%>selected<%}%>>七折</option>
                    <option value="20" <%if (rs.getDouble("L_DISCOUNT")==20){%>selected<%}%>>八折</option>
                    <option value="10" <%if (rs.getDouble("L_DISCOUNT")==10){%>selected<%}%>>九折</option>
                </select>
            </div>
            <div class="input-group">
                <span class="input-group-addon">&#12288;&#12288;&#8194;税&#8194;&#12288;&#12288;</span>
                <input type="text" name="L_TAX" class="form-control" id="tax" value="<%=rs.getString("L_TAX")%>" oninput="mult()">
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
    var tax = 0;
    var discount = 100;
    var number = 0;
    var total = 0;
    var price = 0;
    var maxnum = 0;
    function check(form) {
        // if (form.C_PHONE.value != '' && checkPhone(form.C_PHONE.value) == false) {
        //     alert("请输入正确的电话号码～");
        //     form.C_PHONE.focus();
        //     return false;
        // }
        if (form.L_TAX.value != '' && isNaN(form.L_TAX.value)) {
            alert("税额必须为数字");
            form.L_TAX.focus();
            return false;
        }
        if (form.L_QUANTITY.value > maxnum){
            alert("库存不足");
            form.L_QUANTITY.focus();
            return false;
        }

        return true;
    }


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
    $('#datetext').attr("value", formatted);
    $('#datetext1').attr("value", formatted);
    $('#datetext2').attr("value", formatted);


    var csArray = new Array();  //先声明一维
    for(var k=0;k<20000;k++){    //一维长度为i,i为变量，可以根据实际情况改变

        csArray[k]=new Array();  //声明二维，每一个一维数组里面的一个元素都是一个数组；

        for(var j=0;j<4;j++){   //一维数组里面每个元素数组可以包含的数量p，p也是一个变量；

            csArray[k][j]="";    //这里将变量初始化，我这边统一初始化为空，后面在用所需的值覆盖里面的值
        }
    }


    <% for (int zz=0;zz<p;zz++){
        for (int xx =0;xx<4;xx++){
    %>
    csArray[<%=zz%>][<%=xx%>] = <%=costlist[zz][xx]%>;
    <%
        }
    }
    %>

    function mult() {
        tax = document.getElementById("tax").value;
        discount = 100 - document.getElementById("dis").value;
        number = document.getElementById("quantity").value;
        if (document.getElementById("par").value == "")
            return false;
        var par = document.getElementById("par").value;
        if (document.getElementById("select7").value == "")
            return false;
        var sup = document.getElementById("select7").value;
        total = 0;
        console.log(tax,discount,number);
        if (isNaN(tax)||isNaN(discount)||isNaN(number)){
            return false;
        }
        for (var i=0;i<<%=p%>;i++){
            if (csArray[i][0]==par && csArray[i][1] ==sup){
                maxnum = csArray[i][2];
                price = csArray[i][3];
                break;
            }
        }

        total = Number(number*price*discount/100)+ Number(tax);
        document.getElementById("all").value = parseFloat(total);
        var pp =document.getElementById("biao");
        pp.innerHTML = "零件库存: "+ parseInt(maxnum) + " 零件价格: " + parseFloat(price);

    }

    window.onload = function() {
        tax = document.getElementById("tax").value;
        discount = 100 - document.getElementById("dis").value;
        number = document.getElementById("quantity").value;
        if (document.getElementById("par").value == "")
            return false;
        var par = document.getElementById("par").value;
        if (document.getElementById("select7").value == "")
            return false;
        var sup = document.getElementById("select7").value;
        total = 0;
        console.log(tax,discount,number);
        if (isNaN(tax)||isNaN(discount)||isNaN(number)){
            return false;
        }
        for (var i=0;i<<%=p%>;i++){
            if (csArray[i][0]==par && csArray[i][1] ==sup){
                maxnum = csArray[i][2];
                price = csArray[i][3];
                break;
            }
        }

        total = Number(number*price*discount/100)+ Number(tax);
        document.getElementById("all").value = parseFloat(total);
        var pp =document.getElementById("biao");
        pp.innerHTML = "零件库存: "+ parseInt(maxnum) + " 零件价格: " + parseFloat(price);

    }
</script>
</html>
