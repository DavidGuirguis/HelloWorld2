using System.Web.Mvc;

namespace Areas.Quote {
    public class QuoteAreaRegistration : AreaRegistration {
        public override string AreaName {
            get {
                return "Quote";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) {
            context.MapRoute(
                AreaRoutes.Quote.ToString(),
                "Modules/Quote/{controller}/{action}/{id}",
                new { action = "Summary", id = UrlParameter.Optional }
            );
        }
    }
}
