using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;



namespace WebChart.Web.Calculations
{
    public class ELMAH_PieChart
    {
        //ctor
        public ELMAH_PieChart() { }

        IEnumerable <ChartData> CalculateChartStatistics(int topParam, int daybackParam)
        {
            List<ChartData> chartData = new List<ChartData>();

            /*
             * 
             * 
select @sumTotal = 
	(
		select sum([Count]) from
		(
			select count ([Type]) as [Count] from [dbo].[ELMAH_Error] as a
			where 
			(   @DaysBack = 1 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(hh, -24, GETDATE())) OR
				@DaysBack = 2 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -3, GETDATE())) OR	--3 days
				@DaysBack = 3 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -7, GETDATE())) OR	--1 week
				@DaysBack = 4 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -1, GETDATE())) OR	--1 month
				@DaysBack = 5 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -12, GETDATE())) OR    --1 year
				@DaysBack = 0 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= dbo.getCurrentDateStartString())  -- today
			)     
			group by [Type]
		) as a
	)             
             * */

            using(var context = new ELMAH_Entities())
            {

                int hours = 0;


                switch(daybackParam)
                {
                    case 0:
                        hours = -24;
                        break;
                    case 1:
                        hours = -24;
                        break;
                    case 2:
                        hours = -24 * 3;
                        break;
                    case 3:
                        hours = -24 * 7;
                        break;
                    case 4:
                        hours = -24 * 30;
                        break;
                    case 5:
                        hours = -24 * 365;
                        break;

                }

                var result = from x in context.ELMAH_Error
                             where x.TimeUtc.ToLocalTime() >= x.TimeUtc.ToLocalTime().AddHours(hours)
                                group x by x.Type into newGroup
                                select new 
                                {
                                    Count = newGroup.Count()
                                };

           

                int totalExceptions = result.Sum(p => p.Count);


            }

            return chartData;
        }

    }
}