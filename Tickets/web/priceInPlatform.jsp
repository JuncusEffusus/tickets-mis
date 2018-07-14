<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tickets</title>
    <link href="./dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">
                <img alt="Brand" src="img/brand.jpg" style="height: 20px; border-radius: 5px; margin-bottom: 15px">
            </a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="active"><a href="<s:url action="systemStatistics"/>">网站统计<span
                        class="sr-only">(current)</span></a></li>
                <li><a href="<s:url action="checkInfo"/>">审批信息</a></li>
                <li><a href="<s:url action="settleFinance"/>">财务结算</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="/index.jsp">退出</a></li>
            </ul>
        </div>
    </div>
</nav>

<div style="padding-top: 50px;">
    <ul class="nav nav-tabs">
        <li role="presentation"><a href="<s:url action="systemStatistics"/>">场馆统计</a></li>
        <li role="presentation"><a href="<s:url action="memberStatistics"/>">会员统计</a></li>
        <li role="presentation"><a href="<s:url action="financeStatistics"/>">财务状况</a></li>
        <li role="presentation" class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">分析<span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a href="<s:url action="memberLikeVenue"/>">会员偏好的场馆分析</a></li>
                <li><a href="<s:url action="memberLikeCity"/>">会员常去的城市分析</a></li>
                <li><a href="<s:url action="memberLikeTimeInPlatform"/>">会员喜爱看演出的时间分析</a></li>
                <li><a href="<s:url action="priceInPlatform"/>">分析场馆各年、各月的订单总额/平均票价</a></li>
                <li><a href="<s:url action="typePercentInPlatform"/>">各类型演出订单数的比例分析，重点宣传受欢迎的演出类型</a></li>
                <li><a href="<s:url action="soldOutPercentInPlatform"/>">平台售票率分析</a>
            </ul>
        </li>
    </ul>
</div>

<div>
    <ul>
        <li  style="margin:10px;">
            <label for="countType"></label>
            <select class="chosen-select" id="countType" onchange="getDataInfo()" >
                <option value="year">按年统计</option>
                <option value="month" >按月统计</option>
            </select>
        </li>
    </ul>
</div>

<div>
    <div id="xd"></div>
    <div id="yd"></div>
    <div id="total"
         style="width: 800px; height: 430px; margin: 0 auto;"></div>
    <div id="xa"></div>
    <div id="ya"></div>
    <div id="average"
         style="width: 800px; height: 430px; margin: 0 auto; padding-top: 100px"></div>
</div>

<script src="dist/js/jquery.min.js"></script>
<script src="dist/js/highcharts.js"></script>
<script src="dist/js/bootstrap.js"></script>
<script type="text/javascript">

    function getDataInfo() {
        var countType = $("#countType").val();

        $.post("/getPrice.action", {"countType": countType}, function (data) {

            var x = $('#xd').html(data).find('#x_total').html();
            var y = $('#yd').html(data).find('#y_total').html();
            var x_total = x.split(',');
            var y_total = y.split(',');
            y_total = y_total.map(function(data){
                return +data;
            });

            $('#total').highcharts({
                chart: {
                    type: 'column'
                },

                title: {
                    text: '分析场馆各年、各月的订单总额'
                },

                credits: {
                    enabled: false
                },

                xAxis: {
                    categories: x_total
                },

                yAxis: {
                    min: 0,
                    title: false,
                    allowDecimals: false,
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },

                tooltip: {
                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },

                plotOptions: {
                    column: {
                        pointPadding: 0.3,
                        borderWidth: 0
                    }
                },

                legend: {
                    enabled: false
                },

                series: [{
                    name: '分析场馆各年、各季度、各月的订单总额',
                    data: y_total
                }]
            });

            var _x = $('#xa').html(data).find('#x_average').html();
            var _y = $('#ya').html(data).find('#y_average').html();
            var x_average = _x.split(',');
            var y_average = _y.split(',');
            y_average = y_average.map(function(data){
                return +data;
            });

            $('#average').highcharts({
                chart: {
                    type: 'column'
                },

                title: {
                    text: '分析场馆各年、各月的平均票价'
                },

                credits: {
                    enabled: false
                },

                xAxis: {
                    categories: x_average
                },

                yAxis: {
                    min: 0,
                    title: false,
                    allowDecimals: false,
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },

                tooltip: {
                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },

                plotOptions: {
                    column: {
                        pointPadding: 0.3,
                        borderWidth: 0
                    }
                },

                legend: {
                    enabled: false
                },

                series: [{
                    name: '分析场馆各年、各季度、各月的平均票价',
                    data: y_average
                }]
            });

            $('#xd').html('');
            $('#yd').html('');
            $('#xa').html('');
            $('#ya').html('');

        });

    }

</script>
</body>
</html>