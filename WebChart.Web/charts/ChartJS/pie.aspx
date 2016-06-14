<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pie.aspx.cs" Inherits="WebChart.Web.charts.ChartJS.pie" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chart JS</title>

    <script src="../../Scripts/jquery-2.2.3.js"></script>
    <script src="../../Scripts/jquery-ui-1.11.4.js"></script>
    <script src="../../Scripts/knockout-3.4.0.js"></script>
    <script src="js/Chart.bundle.js"></script>


    <link href="../../Content/bootstrap.css" rel="stylesheet" />

    <style type="text/css">
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 1.3em;
        }

        #tableStatistics td span {
            color: white;
            background-color: black;
        }

        #rightPane {
            float: right;
            width: 50%;
            margin-top: 20px;
        }

        #leftPane {
            float: left;
            width: 50%;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%">
            <div id="leftPane">
                <canvas id="chart-area" width="400" height="400" />
            </div>
            <div id="rightPane" class="container-fluid">
                <div class="row" style="margin-bottom: 10px;">
                    <div class="col-md-4">
                        <label for="paramTop">"Top" parameter</label>
                        <select data-bind="value: paramTop" id="paramTop">
                            <option selected="selected" value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                        </select>
                    </div>
                    <div class="col-md-5">
                        <label for="paramDate">"Days back" parameter</label>
                        <select data-bind="value: paramBack" id="paramDate">
                            <option selected="selected" value="1">1</option>
                            <option value="2">3</option>
                            <option value="3">week</option>
                            <option value="4">month</option>
                            <option value="0">year</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <button id="btnApply" class="btn btn-primary" type="button">Apply</button>
                    </div>
                </div>

                <table id="tableStatistics" class="table table-bordered table-responsive">
                    <thead>
                        <tr>
                            <th>Exception Count</th>
                            <th>Exception Type</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: chartData">
                        <tr>
                            <td style="text-align: right;" data-bind="style: { 'background-color': backColor }">
                                <span data-bind="text: value + ' ( ' + percent() + '% )'"></span>
                            </td>
                            <td data-bind="text: label"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <script type="text/javascript">

            var chartModel = null;
            var pieChart = null;
            var requestUrl = "";

            var config = {
                type: 'pie',
                data: {
                    datasets: [{
                        data: [],
                        backgroundColor: []
                    }],
                    labels: []
                },
                options: {
                    responsive: true,
                    title: {
                        display: true,
                        text: 'ELMAH exceptions'
                    },

                    tooltips: {
                        callbacks: {
                            label: function (tooltipItem, data) {
                                var allData = data.datasets[tooltipItem.datasetIndex].data;
                                var tooltipLabel = data.labels[tooltipItem.index];
                                var tooltipData = allData[tooltipItem.index];
                                var total = 0;
                                for (var i in allData) {
                                    total += allData[i];
                                }
                                var tooltipPercentage = ((tooltipData / total) * 100).toFixed(2);//Math.round((tooltipData / total) * 100);
                                return tooltipLabel + ': ' + tooltipData + ' (' + tooltipPercentage + '%)';
                            }
                        }
                    }
                }
            };


            function ChartData(value, label, color, total) {
                self = this;

                self.value = value;
                self.label = label;
                self.backColor = color;
                self.percent = ko.computed(function () {

                    var percentage = (value * 100 / total).toFixed(2);

                    return percentage;
                }, this);

            }


            function ChartViewModel() {
                self = this;

                self.chartData = ko.observableArray([]);
                self.paramTop = ko.observable(5);
                self.paramBack = ko.observable(1);
            }


            $(function () {

                //init knokout model
                chartModel = new ChartViewModel();
                ko.applyBindings(chartModel, document.getElementById("rightPane"));

                requestUrl = "<%= GetServiceRootUrl()%>api/chart/Get?top=" + chartModel.paramTop() + "&back=" + chartModel.paramBack();

                $.getJSON(requestUrl, function (data) {

                    config.data.datasets[0].data = data.Values;
                    config.data.datasets[0].backgroundColor = data.Colors;
                    config.data.labels = data.Labels;

                    var total = 0;

                    for (var i = 0; i < data.Values.length; i++) {
                        total = total + data.Values[i];
                    }

                    var chartData = new Array();

                    for (var i = 0; i < data.Values.length; i++) {
                        var d = new ChartData(data.Values[i], data.Labels[i], data.Colors[i], total);
                        chartData.push(d);
                    }

                    chartModel.chartData(chartData);

                    var ctx = document.getElementById("chart-area").getContext("2d");
                    pieChart = new Chart(ctx, config);

                });

                $("#btnApply").click(function () {

                    requestUrl = "<%= GetServiceRootUrl()%>api/chart/Get?top=" + chartModel.paramTop() + "&back=" + chartModel.paramBack();

                    $.getJSON(requestUrl, JsonCallback);
  
                });



            });



            function JsonCallback(data)
            {
                config.data.datasets[0].data = data.Values;
                config.data.datasets[0].backgroundColor = data.Colors;
                config.data.labels = data.Labels;

                var total = 0;

                for (var i = 0; i < data.Values.length; i++) {
                    total = total + data.Values[i];
                }

                var chartData = new Array();

                for (var i = 0; i < data.Values.length; i++) {
                    var d = new ChartData(data.Values[i], data.Labels[i], data.Colors[i], total);
                    chartData.push(d);
                }


                chartModel.chartData(chartData);

                pieChart.destroy();

                var ctx = document.getElementById("chart-area").getContext("2d");
                pieChart = new Chart(ctx, config);

            }


        </script>
    </form>
</body>
</html>
