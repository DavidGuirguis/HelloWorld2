using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.UI;
using Areas;
using X;
using X.Web.UI;

namespace Helpers {
    public static class UrlHelper {
        public static string GetRouteUrl(this UserControl ctrl, AreaRoutes routeName, object routeParameters) {
            return ctrl.GetRouteUrl(routeName.ToString(), routeParameters);
        }

        public static string GetRouteUrl(this UserControl ctrl, AreaRoutes routeName, RouteValueDictionary routeParameters) {
            return ctrl.GetRouteUrl(routeName.ToString(), routeParameters);
        }

        public static string GetRouteUrl(this IPage page, AreaRoutes routeName, object routeParameters) {
            if (!(routeParameters is RouteValueDictionary)) {
                routeParameters = new RouteValueDictionary(routeParameters);
            }

            return GetRouteUrl(page, routeName, (RouteValueDictionary)routeParameters);
        }

        public static string GetRouteUrl(this IPage page, AreaRoutes routeName, RouteValueDictionary routeParameters) {
            if (page.IsWebFormPage)
                return page.WebFormPage.GetRouteUrl(routeName.ToString(), routeParameters);

            VirtualPathData data = RouteTable.Routes.GetVirtualPath(page.Context.Request.RequestContext, routeName.ToString(), routeParameters);
            if (data != null) {
                return data.VirtualPath;
            }
            return null;
        }
    }
}