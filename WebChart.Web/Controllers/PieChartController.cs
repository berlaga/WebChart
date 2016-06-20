using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace WebChart.Web.Controllers
{
    public class PieChartController : ApiController
    {
        // GET: api/PieChart/GetChartData?top=5&back=1
        [HttpGet]
        public ChartData GetChartData(int top, int back)
        {
            ChartData d = new ChartData();
            List<int> values = new List<int>();
            List<string> labels = new List<string>();
            List<string> colors = new List<string>();
            List<string> ids = new List<string>();

            using (var context = new ELMAH_Entities())
            {
                var results = context.ELMAH_report(top, back).ToList();
                var random = new Random();

                if (results.Count() == 1 && results[0].Count == 0)
                {
                    d.Labels = new List<string>();
                    d.Values = new List<int>();
                    d.Colors = new List<string>();
                    d.Ids = new List<string>();

                    return d;
                }

                foreach (var item in results)
                {
                    values.Add(item.Count.Value);
                    labels.Add(item.Type);
                    colors.Add(String.Format("#{0:X6}", random.Next(0x1000000)));
                    ids.Add(item.Id.Value.ToString());
                }

                d.Labels = labels;
                d.Values = values;
                d.Colors = colors;
                d.Ids = ids;

                return d;
            }

        }


        // GET: api/PieChart/GetLatestExceptions?top=5
        [HttpGet]
        public IEnumerable<ExceptionInfo> GetLatestExceptions(int top)
        {
            List<ExceptionInfo> list = new List<ExceptionInfo>();

            using (var context = new ELMAH_Entities())
            {
                var result = (from x in context.ELMAH_Error
                             orderby x.TimeUtc descending
                             select new
                             {
                                 ExceptionDate = x.TimeUtc,
                                 ExceptionId = x.ErrorId,
                                 Description = x.Message,
                                 Type = x.Type

                             }).Take(top);

                foreach(var item in result)
                {
                    ExceptionInfo info = new ExceptionInfo { Id = item.ExceptionId.ToString(), Date = item.ExceptionDate.ToLocalTime(), Message = item.Description, Type = item.Type };
                    list.Add(info);
                }


                return list;
            }
        }

        // GET: api/PieChart/GetChartTestData
        [HttpGet]
        public ChartData GetChartTestData()
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
