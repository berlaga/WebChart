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
        public BarData GetData(int baseMonth, int monthToShow)
        {
            BarData barData = new BarData();

            ELMAH_BarChart chartManager = new ELMAH_BarChart();

            List<int> howManyMonth = new List<int>();

            switch(monthToShow)
            {
                case 3:
                    howManyMonth.Add(DateTime.Today.Month - 2);
                    howManyMonth.Add(DateTime.Today.Month - 1);
                    howManyMonth.Add(DateTime.Today.Month);
                    break;
                case 5:
                    howManyMonth.Add(DateTime.Today.Month - 4);
                    howManyMonth.Add(DateTime.Today.Month - 3);
                    howManyMonth.Add(DateTime.Today.Month - 2);
                    howManyMonth.Add(DateTime.Today.Month - 1);
                    howManyMonth.Add(DateTime.Today.Month);
                    break;
                default:
                    howManyMonth.Add(DateTime.Today.Month);
                    break;

            }


            for (int i = 0; i < howManyMonth.Count(); i++)
            {
                ELMAH_Monthly_Info infoMonth = chartManager.GetBarDataPerMonth(howManyMonth[i]);
                barData.BarInfo.Add(infoMonth);

            }


            return barData;
        }

  
    }
}
