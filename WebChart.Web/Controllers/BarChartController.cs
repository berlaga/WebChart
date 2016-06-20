using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using WebChart.Web.Calculations;

namespace WebChart.Web.Controllers
{
    public class BarChartController : ApiController
    {
        // GET: api/BarChart
        public BarData GetData()
        {
            BarData barData = new BarData();

            ELMAH_BarChart chartManager = new ELMAH_BarChart();

            ELMAH_Monthly_Info infoApril = chartManager.GetBarDataPerMonth(4);

            ELMAH_Monthly_Info infoMay = chartManager.GetBarDataPerMonth(5);

            ELMAH_Monthly_Info infoJune = chartManager.GetBarDataPerMonth(6);

            barData.BarInfo.Add(infoApril);
            barData.BarInfo.Add(infoMay);
            barData.BarInfo.Add(infoJune);

            return barData;
        }

  
    }
}
