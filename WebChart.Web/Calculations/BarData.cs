using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChart.Web
{
    public class BarData
    {
        public BarData() 
        {
            this.BarInfo = new List<ELMAH_Monthly_Info>();
        }

        public List<ELMAH_Monthly_Info> BarInfo { get; set; }

    }


    public class ELMAH_Monthly_Info
    {
        public int Month { get; set; }

        public ELMAH_Monthly_Info() 
        {
        }

        public int TotalPerMonth { get; set; }

        public List<Tuple<string, int>> ExceptionInfo { get; set; }
    }


}