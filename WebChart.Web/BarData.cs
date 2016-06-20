using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChart.Web
{
    public class BarData
    {
        public BarData() { }



    }


    public class ELMAH_Monthly_Info
    {
        private int _month;

        public ELMAH_Monthly_Info(int month) 
        {
            _month = month;
        }

        int TotalPerMonth { get; set; }

        Tuple<string, int> ExceptionInfo { get; set; }
    }


}