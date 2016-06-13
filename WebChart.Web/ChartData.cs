using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChart.Web
{
    public class ChartData
    {
        public List<int> Values { set; get; }
        public List<string> Labels { set; get; }
        public List<string> Colors { set; get; }

    }
}