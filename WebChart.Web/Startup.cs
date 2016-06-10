using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(WebChart.Web.Startup))]
namespace WebChart.Web
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
