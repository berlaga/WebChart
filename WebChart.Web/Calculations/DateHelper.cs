using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChart.Web.Calculations
{
    public class DateHelper
    {
        public static DateTime GetDateMonthStart(int year, int month)
        {
            var firstDay = new DateTime(year, month, 1, 0, 0, 1);

            return firstDay;

        }

        public static DateTime GetDateMonthEnd(int year, int month)
        {
            var lastDay = new DateTime(year, month, DateTime.DaysInMonth(year, month), 23, 59, 59);

            return lastDay;
        }
    
    }
}