using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace WebChart.Web.Controllers
{
    public class ChartController : ApiController
    {
        // GET: api/Test
        [HttpGet]
        public ChartData Get(int top, int back)
        {

            ChartData d = new ChartData();
            List<int> values = new List<int>();
            List<string> labels = new List<string>();
            List<string> colors = new List<string>();

            using (var context = new ELMAH_Entities())
            {
                var results = context.ELMAH_report(top, back);
                var random = new Random();

                foreach (var item in results)
                {
                    values.Add(item.Count.Value);
                    labels.Add(item.Type);
                    colors.Add(String.Format("#{0:X6}", random.Next(0x1000000)));
                }

                d.Labels = labels;
                d.Values = values;
                d.Colors = colors;

                return d;
            }

            //return new int[] { 10,4,5,1,7,8 };
        }

        // GET: api/Test
        [HttpGet]
        public ChartData GetChartData()
        {
            ChartData data = new ChartData();


            data.Colors = new List<string> {
                                                "#F7464A",
                                                "#46BFBD",
                                                "#FDB45C",
                                                "#949FB1",
                                                "#4D5360",
                                                "#1D5360"};

            data.Labels = new List<string> {
                                                "One",
                                                "Two",
                                                "Three",
                                                "Four",
                                                "Five",
                                                "Six"};

            data.Values = new List<int> {
                                                2,
                                                6,
                                                66,
                                                13,
                                                23,
                                                19};


            return data;
        }

    }
}
