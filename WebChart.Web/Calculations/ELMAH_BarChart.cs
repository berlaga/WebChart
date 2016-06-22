using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChart.Web.Calculations
{
    public class ELMAH_BarChart
    {
        //ctor
        public ELMAH_BarChart() { }


        public ELMAH_Monthly_Info GetBarDataPerMonth(int month)
        {
            ELMAH_Monthly_Info barPerMonth = new ELMAH_Monthly_Info();
            barPerMonth.Month = month;

            using(var context = new ELMAH_Entities())
            {

                DateTime beginTime = DateHelper.GetDateMonthStart(DateTime.Today.Year, month).ToUniversalTime();
                DateTime endTime = DateHelper.GetDateMonthEnd(DateTime.Today.Year, month).ToUniversalTime();


                //int totalPerMonth = (from x in context.ELMAH_Error
                //                     where x.TimeUtc > beginTime
                //                        && x.TimeUtc < endTime
                //                     select x).Count();

                var groupResult = from x in context.ELMAH_Error
                                  where x.TimeUtc > beginTime && x.TimeUtc < endTime
                                  group x by x.Type into grp
                                  select new
                                  {
                                      TypeName = grp.Key,
                                      Count = grp.Count()
                                  };

                barPerMonth.ExceptionInfo = new List<Tuple<string, int>>();
                     
                foreach(var item in groupResult)
                {
                    Tuple<string, int> t = new Tuple<string, int>(item.TypeName, item.Count);
                    barPerMonth.ExceptionInfo.Add(t);
                }

                barPerMonth.TotalPerMonth = groupResult.Any() ? groupResult.Sum(p => p.Count) : 0; //totalPerMonth;

            }

            return barPerMonth;
        }


    }
}