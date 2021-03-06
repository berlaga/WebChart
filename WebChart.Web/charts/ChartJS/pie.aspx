﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pie.aspx.cs" Inherits="WebChart.Web.charts.ChartJS.pie" %>

<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chart JS: Pie</title>

    <script src="../../Scripts/jquery-2.2.3.js"></script>
    <script src="../../Scripts/jquery-ui-1.11.4.js"></script>
    <script src="../../Scripts/knockout-3.4.0.js"></script>
    <script src="js/Chart.bundle.js"></script>
    <script src="../../Scripts/moment.js"></script>

    <link href="../../Content/bootstrap.css" rel="stylesheet" />

    <style type="text/css">
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 1.3em;
        }

        h1 {
            font-size: 2em;
        }

        h2 {
            font-size: 1.8em;
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

        #error-message {
            margin-top: 20px;
            margin-left: 40px;
            width: 50%;
        }

        #filterRow {
            margin-bottom: 10px;
            margin-top: 20px;
        }

        #latest-exceptions {
            margin-top: 20px;
        }

        #lastUpdated {
            margin-left: 5px;
            font-style: italic;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">

        <div id="container" style="width: 100%">

            <div class="alert alert-danger" style="display:none;" id="error-message" data-bind="visible: isServerError, text: serverErrorMessage">error</div>
            <div style="text-align:center;" data-bind="visible: !isServerError()" id="leftPane">
                <canvas id="chart-area" width="400" height="400" />
            </div>
            <div data-bind="visible: !isServerError()" id="rightPane" class="container-fluid">
                <h1>ELMAH exceptions statatistics for XXXX</h1>

                <div id="filterRow" class="row">
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
                            <option selected="selected" value="0">Today</option>
                            <option value="1">24 hours</option>
                            <option value="2">3 days</option>
                            <option value="3">1 week</option>
                            <option value="4">1 month</option>
                            <option value="5">1 year</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <button id="btnApply" title="Click to refresh chart" class="btn btn-primary" type="button">Apply</button>
                    </div>
                </div>

                <div data-bind="visible: chartData().length > 0" class="row">
                    <div class="col-md-12">
                        <table id="tableStatistics" class="table table-bordered table-responsive table-striped ">
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
                                    <td>
                                        <a data-bind="text: label, attr: { href: id == '00000000-0000-0000-0000-000000000000' ? '#' : 'elmah.axd/detail?id=' + id }" 
                                            href="#" title="Click to see exception details"></a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- ko stopBinding: true -->
                <div id="latest-exceptions" class="row">
                    <div class="col-md-12">
                        <h2 style="display: inline;">10 latest exceptions</h2>
                        <span id="lastUpdated" data-bind="text: '(Last updated: ' + moment().format('YYYY-MM-DD, hh:mm:ss a') + ')'"></span>
                        <table id="tableRecent" class="table table-bordered table-responsive table-striped table-condensed">
                            <thead>
                                <tr>
                                    <th>Exception Type</th>
                                    <th>Exception Date</th>
                                    <th>Exception Description</th>
                                </tr>
                            </thead>
                            <tbody data-bind="foreach: latestExceptions">
                                <tr>
                                    <td>
                                        <a data-bind="text: type, attr: { href: 'elmah.axd/detail?id=' + id, title: 'Click to see exception details' }" href="#"></a>
                                    </td>
                                    <td data-bind="text: moment(date).format('YYYY-MM-DD, hh:mm:ss a') "></td>
                                    <td data-bind="text: message.substring(0, 50) + '..'"></td>

                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- /ko -->
            </div>


        </div>

        <script type="text/javascript">

            var chartModel = null;
            var pieChart = null;
            var latestExceptionsViewModel = null;

            var requestUrlChart = "";

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
                        text: 'Legend: exception types'
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


            function ChartData(value, label, color, id, total) {
                self = this;

                self.value = value;
                self.label = label;
                self.backColor = color;
                self.id = id;
                self.percent = ko.computed(function () {

                    var percentage = (value * 100 / total).toFixed(2);

                    return percentage;
                }, this);

            }


            function ChartViewModel() {
                self = this;

                self.chartData = ko.observableArray([]);
                self.paramTop = ko.observable(5);
                self.paramBack = ko.observable(0);

                self.isServerError = ko.observable(false);
                self.serverErrorMessage = ko.observable("");

            }


            function ExceptionData(data) {
                self = this;

                self.id = data.Id;
                self.date = data.Date;
                self.message = data.Message;
                self.type = data.Type;
            }


            function LatestExeptionViewModel() {
                self = this;

                self.latestExceptions = ko.observableArray([]);
                self.numberOfExceptions = ko.observable(10);
            }





            $(function () {

               //allow multiple model binding
                ko.bindingHandlers.stopBinding = {
                    init: function () {
                        return { controlsDescendantBindings: true };
                    }
                };
                ko.virtualElements.allowedBindings.stopBinding = true;
                //allow multiple model binding

                //init knockout models
                chartModel = new ChartViewModel();
                ko.applyBindings(chartModel, document.getElementById("container"));

                latestExceptionsViewModel = new LatestExeptionViewModel();
                ko.applyBindings(latestExceptionsViewModel, document.getElementById("latest-exceptions"));
                //init knockout models

                var requestUrlLatestExceptions = "<%= GetServiceRootUrl()%>api/PieChart/GetLatestExceptions?top=" + latestExceptionsViewModel.numberOfExceptions();
                //get server data, initial load of chart
                $.getJSON(requestUrlLatestExceptions, JsonCallbackExceptions)
                 .fail(function () {
                     console.log("Request " + requestUrlLatestExceptions + " failed");
                 });


                requestUrlChart = "<%= GetServiceRootUrl()%>api/PieChart/GetChartData?top=" + chartModel.paramTop() + "&back=" + chartModel.paramBack();

                //get server data, initial load of chart
                $.getJSON(requestUrlChart, JsonCallbackChart)
                 .fail(function () {
                     console.log("Request " + requestUrlChart + " failed");
                     chartModel.isServerError(true);
                     chartModel.serverErrorMessage("Request " + requestUrlChart + " failed");
                 });

                //apply button handler
                $("#btnApply").click(function () {

                    requestUrlChart = "<%= GetServiceRootUrl()%>api/PieChart/GetChartData?top=" + chartModel.paramTop() + "&back=" + chartModel.paramBack();

                    //get server data, refresh graph
                    $.getJSON(requestUrlChart, JsonCallbackChart)
                        .fail(function (result) {
                            console.log("Request " + requestUrlChart + " failed");
                            chartModel.isServerError(true);
                            chartModel.serverErrorMessage("Request " + requestUrlChart + " failed");
                        });

                });

            });


            //Json callback function
            function JsonCallbackExceptions(data) {

                for (var i = 0; i < data.length; i++) {
                    latestExceptionsViewModel.latestExceptions.push(new ExceptionData(data[i]));
                }

            }


            //Json callback function
            function JsonCallbackChart(data) {
                //assign data to chart config 
                config.data.datasets[0].data = data.Values;
                config.data.datasets[0].backgroundColor = data.Colors;
                config.data.labels = data.Labels;

                var total = 0;

                for (var i = 0; i < data.Values.length; i++) {
                    total = total + data.Values[i];
                }

                var chartData = new Array();

                for (var i = 0; i < data.Values.length; i++) {
                    var d = new ChartData(data.Values[i], data.Labels[i], data.Colors[i], data.Ids[i], total);
                    chartData.push(d);
                }


                chartModel.chartData(chartData);

                if (pieChart != null)
                    pieChart.destroy();

                var ctx = document.getElementById("chart-area").getContext("2d");
                var canvas = document.getElementById("chart-area");

                if (chartData.length == 0) {
                    ctx.font = "30px Tahoma";
                    ctx.fillStyle = "red";
                    ctx.textAlign = "center";
                    ctx.fillText("No data available", canvas.width / 2, canvas.height / 2);
                }
                else
                    pieChart = new Chart(ctx, config);


            }


        </script>
    </form>
</body>
</html>
