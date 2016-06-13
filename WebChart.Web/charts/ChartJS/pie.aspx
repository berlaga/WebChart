<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pie.aspx.cs" Inherits="WebChart.Web.charts.ChartJS.pie" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chart JS</title>

    <script src="../../Scripts/jquery-2.2.3.js"></script>
    <script src="../../Scripts/jquery-ui-1.11.4.js"></script>
    <script src="../../Scripts/knockout-3.4.0.js"></script>
    <script src="js/Chart.bundle.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%">
            <div id="canvas-holder" style="width: 50%; float:left;">
                <canvas id="chart-area" width="400" height="400" />
            </div>
            <div style="width: 50%; float:right;">
                aaaa
            </div>
        </div>

        <script>
 

            var config = {
                type: 'pie',
                data: {
                    datasets: [{
                        data: [],
                        backgroundColor: [
                            "#F7464A",
                            "#46BFBD",
                            "#FDB45C",
                            "#949FB1",
                            "#4D5360",
                            "#1D5360",
                        ]

                    }],
                    labels: [
                        "Red",
                        "Green",
                        "Yellow",
                        "Grey",
                        "Dark Grey",
                        "Test",
                    ]
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


            $(function () {

                var requestUrl = "<%= GetServiceRootUrl()%>api/chart/Get";


                $.getJSON(requestUrl, function (data) {

                    config.data.datasets[0].data = data.Values;
                    config.data.datasets[0].backgroundColor = data.Colors;
                    config.data.labels = data.Labels;


                    var ctx = document.getElementById("chart-area").getContext("2d");
                    window.myPie = new Chart(ctx, config);

                });




            });

   
        </script>
    </form>
</body>
</html>
