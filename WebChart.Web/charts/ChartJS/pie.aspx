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

</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%">
            <div id="canvas-holder" style="width: 50%; float:left;">
                <canvas id="chart-area" width="400" height="400" />
            </div>
            <div class="container-fluid" style="width: 50%; float:right; margin-top:20px;">
                <table class="table table-bordered table-responsive">
                    <thead>
                        <tr>
                            <th>Exception Count</th>
                            <th>Exception Type</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: chartData">
                        <tr>
                            <td style="text-align:right;" data-bind="text: value"></td>
                            <td data-bind="text: label"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <script type="text/javascript">
 

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


            function ChartData(value, label)
            {
                self = this;

                self.value = value;
                self.label = label;

            }


            function ChartViewModel()
            {
                self = this;

                self.chartData = ko.observableArray([]);
            }


            $(function () {


                var chartModel = new ChartViewModel();
                ko.applyBindings(chartModel);

                var requestUrl = "<%= GetServiceRootUrl()%>api/chart/Get";


                $.getJSON(requestUrl, function (data) {

                    config.data.datasets[0].data = data.Values;
                    config.data.datasets[0].backgroundColor = data.Colors;
                    config.data.labels = data.Labels;

                    var chartData = new Array();

                    for (var i = 0; i < data.Values.length; i++)
                    {
                        var d = new ChartData(data.Values[i], data.Labels[i]);
                        chartData.push(d);
                    }
                    
                    chartModel.chartData(chartData);

                    var ctx = document.getElementById("chart-area").getContext("2d");
                    window.myPie = new Chart(ctx, config);

                });



            });

   
        </script>
    </form>
</body>
</html>
