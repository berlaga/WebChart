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

    public class ChartData1
    {
        public ChartAxisData Data { set; get; }
        public List<string> Labels { set; get; }
        public List<string> Colors { set; get; }

    }


    public class ChartAxisData
    {
        public string Label { set; get; }
        public List<int> Values { set; get; }
    }
}