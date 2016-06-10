﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pie.aspx.cs" Inherits="WebChart.Web.charts.ChartJS.pie" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chart JS</title>

    <script src="../../Scripts/jquery-2.2.3.js"></script>
    <script src="../../Scripts/jquery-ui-1.11.4.js"></script>
    <script src="js/Chart.bundle.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="canvas-holder" style="width: 50%">
            <canvas id="chart-area" width="300" height="300" />
        </div>
        <button id="randomizeData">Randomize Data</button>
        <button id="addDataset">Add Dataset</button>
        <button id="removeDataset">Remove Dataset</button>
        <script>
            var randomScalingFactor = function () {
                return Math.round(Math.random() * 100);
            };
            var randomColorFactor = function () {
                return Math.round(Math.random() * 255);
            };
            var randomColor = function (opacity) {
                return 'rgba(' + randomColorFactor() + ',' + randomColorFactor() + ',' + randomColorFactor() + ',' + (opacity || '.3') + ')';
            };

            var config = {
                type: 'pie',
                data: {
                    datasets: [{
                        data: [
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                        ],
                        backgroundColor: [
                            "#F7464A",
                            "#46BFBD",
                            "#FDB45C",
                            "#949FB1",
                            "#4D5360",
                        ],
                    }, {
                        data: [
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                        ],
                        backgroundColor: [
                            "#F7464A",
                            "#46BFBD",
                            "#FDB45C",
                            "#949FB1",
                            "#4D5360",
                        ],
                    }, {
                        data: [
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                            randomScalingFactor(),
                        ],
                        backgroundColor: [
                            "#F7464A",
                            "#46BFBD",
                            "#FDB45C",
                            "#949FB1",
                            "#4D5360",
                        ],
                    }],
                    labels: [
                        "Red",
                        "Green",
                        "Yellow",
                        "Grey",
                        "Dark Grey"
                    ]
                },
                options: {
                    responsive: true
                }
            };

            window.onload = function () {
                var ctx = document.getElementById("chart-area").getContext("2d");
                window.myPie = new Chart(ctx, config);
            };

            $('#randomizeData').click(function () {
                $.each(config.data.datasets, function (i, piece) {
                    $.each(piece.data, function (j, value) {
                        config.data.datasets[i].data[j] = randomScalingFactor();
                        config.data.datasets[i].backgroundColor[j] = randomColor(0.7);
                    });
                });
                window.myPie.update();
            });

            $('#addDataset').click(function () {
                var newDataset = {
                    backgroundColor: [randomColor(0.7), randomColor(0.7), randomColor(0.7), randomColor(0.7), randomColor(0.7)],
                    data: [randomScalingFactor(), randomScalingFactor(), randomScalingFactor(), randomScalingFactor(), randomScalingFactor()]
                };

                config.data.datasets.push(newDataset);
                window.myPie.update();
            });

            $('#removeDataset').click(function () {
                config.data.datasets.splice(0, 1);
                window.myPie.update();
            });
    </script>
    </form>
</body>
</html>
