<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="bar.aspx.cs" Inherits="WebChart.Web.charts.ChartJS.bar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Chart JS: Bar</title>

    <script src="../../Scripts/jquery-2.2.3.js"></script>
    <script src="../../Scripts/jquery-ui-1.11.4.js"></script>
    <script src="../../Scripts/knockout-3.4.0.js"></script>
    <script src="../../Scripts/knockout.mapping-latest.debug.js"></script>
    <script src="js/Chart.bundle.js"></script>
    <script src="../../Scripts/moment.js"></script>

    <link href="../../Content/bootstrap.css" rel="stylesheet" />



    <script type="text/javascript">

        var barChart = null;


        function BarChartModel() {
            self = this;

            self.requestData = function () {

                var requestUrlLatestExceptions = "<%= GetServiceRootUrl()%>api/BarChart/GetData?baseMonth=5&monthToShow=5";
                //get server data, initial load of chart
                $.getJSON(requestUrlLatestExceptions, function (data) {
                    //console.log(data);

                    var labels = new Array();

                    var dataset = { backgroundColor: "#0080ff", data: [] };

                    for (var i = 0; i < data.BarInfo.length; i++) {
                        labels.push(data.BarInfo[i].MonthName)
                        dataset.data.push(data.BarInfo[i].TotalPerMonth);
                    }

                    barChartData.datasets.push(dataset);
                    barChartData.labels = labels;

                    var ctx = document.getElementById("chart-area").getContext("2d");
                    barChart = new Chart(ctx, {
                        type: 'bar',
                        data: barChartData,
                        options: {
                            title: {
                                display: true,
                                text: "Total exceptions per month"
                            },
                            legend: {
                                display: false,
                            },
                            tooltips: {
                                mode: 'label',
                              
                            },
                            responsive: true,
                            scales: {
                                xAxes: [{
                                    stacked: false,
                                }],
                                yAxes: [{
                                    stacked: true,
                                }]
                            }
                        }
                    });



                })
                 .fail(function () {
                     console.log("Request " + requestUrlLatestExceptions + " failed");
                 });



            };

            self.processClick = toggleButtonClick;

            self.onCanvasClick = OnCanvasClick;
            self.onCanvasMouseMove = OnCanvasMouseMove;

  
        }

        var barChartData = {
            labels: [],
            datasets: []

        };


        function toggleButtonClick()
        {
            var ctx = document.getElementById("chart-area").getContext("2d");


            if (barChart.chart.config.type == "line") {
                barChart.destroy();
                barChart = new Chart(ctx, {
                    type: 'bar',
                    data: barChartData,
                    options: {
                        title: {
                            display: true,
                            text: "Total exceptions per month"
                        },
                        legend: {
                            display: false,
                        },
                        tooltips: {
                            mode: 'label'
                        },
                        responsive: true,
                        scales: {
                            xAxes: [{
                                stacked: false,
                            }],
                            yAxes: [{
                                stacked: true,
                            }]
                        }
                    }
                });
            }
            else {

                barChart.destroy();

                barChartData.datasets[0].fill = false;
                barChartData.datasets[0].borderColor = "rgba(75,192,192,1)";
                barChartData.datasets[0].pointBorderColor = "rgba(255,12,192,1)";
                barChartData.datasets[0].pointBackgroundColor = "#fff";
                barChartData.datasets[0].pointRadius = 5;

                barChart = new Chart(ctx, {
                    type: 'line',
                    data: barChartData,
                    options: {
                        title: {
                            display: true,
                            text: "Total exceptions per month"
                        },
                        legend: {
                            display: false,
                        },
                        tooltips: {
                            mode: 'label'
                        },
                        responsive: true,
                        scales: {
                            xAxes: [{
                                stacked: false,
                            }],
                            yAxes: [{
                                stacked: true,
                            }]
                        }
                    }
                });

            }
        }

        function OnCanvasClick(data, event)
        {
            var activeBars = barChart.getElementsAtEvent(event);
            if (activeBars.length == 0)
                return;
            // console.log(activeBars[0]);
            // console.log(activeBars[0]._model.label);
            if (activeBars[0]._model.label) {
                alert(activeBars[0]._model.label);
            }

        }


        function OnCanvasMouseMove(data, event)
        {
            var activeBars = barChart.getElementsAtEvent(event);
            if (activeBars.length == 0) {
                $("#chart-area").attr("style", "cursor:default;")
            }
            else
                $("#chart-area").attr("style", "cursor:pointer;")

            return true;

        }


        $(function () {

            var viewModel = new BarChartModel();
            ko.applyBindings(viewModel);

            viewModel.requestData();


        });

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div style="width: 75%; float: left;">
                <canvas data-bind="event: { click: onCanvasClick, mousemove: onCanvasMouseMove }" id="chart-area"></canvas>
            </div>
            <div style="float: right;width: 20%">
                <button class="btn btn-primary" data-bind="click: processClick" style="margin-top:20px;" type="button" id="b1">Toggle bar / line graph</button>
            </div>
        </div>
    </form>
</body>
</html>
