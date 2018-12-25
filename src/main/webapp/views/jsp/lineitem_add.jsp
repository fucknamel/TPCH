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
    public int c = 0;
    public int[][] itemlist = new int[2000][1000];
    public double[][] costlist = new double[20000][4];
    public int k = 3;
    public int p = 0;
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

        c=0;
        p=0;
        if (rs.next()){
            costlist[0][0]=rs.getInt("PS_PARTKEY");
            costlist[0][1]=rs.getInt("PS_SUPPKEY");
            costlist[0][2]=rs.getInt("PS_AVAILQTY");
            costlist[0][3]=rs.getInt("PS_SUPPLYCOST");
            itemlist[c][0] = rs.getInt("PS_PARTKEY");
            itemlist[c][2] = rs.getInt("PS_SUPPKEY");
            itemlist[c][1] = 2;
            p++;
        }
        k = 3;
        while (rs.next()){
            costlist[p][0]=rs.getInt("PS_PARTKEY");
            costlist[p][1]=rs.getInt("PS_SUPPKEY");
            costlist[p][2]=rs.getInt("PS_AVAILQTY");
            costlist[p][3]=rs.getInt("PS_SUPPLYCOST");
            p++;
            if (itemlist[c][0] == rs.getInt("PS_PARTKEY")){
                itemlist[c][k] = rs.getInt("PS_SUPPKEY");
                itemlist[c][1] = k;
                k++;
            }
            else{
                c++;
                k = 2;
                itemlist[c][0] = rs.getInt("PS_PARTKEY");
                itemlist[c][2] = rs.getInt("PS_SUPPKEY");
                itemlist[c][1] = k;
                k++;
            }
        }

%>
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
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_PARTKEY" id="par" onchange="change(this);mult();" required>
                <option value="" selected disabled style="color: #8e8e8e;">零件名称</option>
                <%
                    for (Map.Entry<Integer, String> entry : mapPart.entrySet()) {
                %>
                <option value="<%=entry.getKey()%>" style="color: black;"><%=entry.getValue()%>
                </option>
                <%
                    }
                %>
            </select>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_SUPPKEY" id="select7" onchange="changecolor(this);mult();" required disabled>
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
            <p id="biao" style="margin: 0;display: none;" >零件库存： 零件价格：</p>
            <input type="text" name="L_QUANTITY" class="form-control" placeholder="数量" id="quantity" oninput="mult()" autofocus>
            <input type="text" name="L_EXTENDEDPRICE" class="form-control" placeholder="总金额" id="all" readonly autofocus>
            <select class="form-control" style="padding-left: 9px;color: #8e8e8e;" name="L_DISCOUNT" id="dis"
                    onchange="changecolor(this);mult()">
                <option value="0" selected disabled style="color: #8e8e8e;">折扣</option>
                <option value="0" style="color: black;">无折扣</option>
                <option value="90" style="color: black;">一折</option>
                <option value="80" style="color: black;">二折</option>
                <option value="70" style="color: black;">三折</option>
                <option value="60" style="color: black;">四折</option>
                <option value="50" style="color: black;">五折</option>
                <option value="40" style="color: black;">六折</option>
                <option value="30" style="color: black;">七折</option>
                <option value="20" style="color: black;">八折</option>
                <option value="10" style="color: black;">九折</option>
            </select>
            <input type="text" name="L_TAX" class="form-control" placeholder="税" id="tax" autofocus oninput="mult()">
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

    function changecolor(me){
        if (me.selectedIndex == 0){
            me.style.cssText = "padding-left: 9px;color: #8e8e8e;";
        }
        else {
            me.style.cssText = "padding-left: 9px;color: black;";
        }
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

    var psArray = new Array();  //先声明一维
    for(var k=0;k<2000;k++){    //一维长度为i,i为变量，可以根据实际情况改变

        psArray[k]=new Array();  //声明二维，每一个一维数组里面的一个元素都是一个数组；

        for(var j=0;j<1000;j++){   //一维数组里面每个元素数组可以包含的数量p，p也是一个变量；

            psArray[k][j]="";    //这里将变量初始化，我这边统一初始化为空，后面在用所需的值覆盖里面的值
        }
    }

    var csArray = new Array();  //先声明一维
    for(var k=0;k<20000;k++){    //一维长度为i,i为变量，可以根据实际情况改变

        csArray[k]=new Array();  //声明二维，每一个一维数组里面的一个元素都是一个数组；

        for(var j=0;j<4;j++){   //一维数组里面每个元素数组可以包含的数量p，p也是一个变量；

            csArray[k][j]="";    //这里将变量初始化，我这边统一初始化为空，后面在用所需的值覆盖里面的值
        }
    }

    <% for (int zz=0;zz<=c;zz++){
        for (int xx =0;xx<=itemlist[zz][1];xx++){
    %>
    psArray[<%=zz%>][<%=xx%>] = <%=itemlist[zz][xx]%>;
    <%
        }
    }
    %>

    <% for (int zz=0;zz<p;zz++){
        for (int xx =0;xx<4;xx++){
    %>
    csArray[<%=zz%>][<%=xx%>] = <%=costlist[zz][xx]%>;
    <%
        }
    }
    %>

    function change(me){
        me.style.cssText = "padding-left: 9px;color: black;";

        var partkey = me.options[me.selectedIndex].value;
        var meselect = document.getElementById("select7");
        meselect.style.cssText = "padding-left: 9px;color: black;";
        meselect.removeAttribute("disabled");
        meselect.options[0].removeAttribute("selected");
        meselect.options[1].selected= true;
        var slength = meselect.options.length;
        me.options[0].style.display="none";
        for (var i = 0;i<slength;i++){
            meselect.options[i].style.display="none";
            //meselect.options.remove(i);
        }
        var cc = 0;
        for (var i = 0;i <= <%=c%>;i++){
            if (psArray[i][0] == partkey){
                cc = i;
                break;
            }
        }
        for (var i = 0;i< slength;i++){
            for (var j = 2;j <= psArray[cc][1];j++){
                if (meselect.options[i].value == psArray[cc][j]){
                    meselect.options[i].style.display="list-item";
                }
            }
        }
    }
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
        pp.style.display="block";
        pp.innerHTML = "零件库存: "+ parseInt(maxnum) + " 零件价格: " + parseFloat(price);

    }
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
