using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(DockerDemo.Startup))]
namespace DockerDemo
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
