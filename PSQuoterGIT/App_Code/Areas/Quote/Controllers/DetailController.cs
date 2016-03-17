using System;
using System.Web.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Repositories;
using ControllerBase = UI.Abstracts.ControllerBase;

namespace Areas.Quote.Controllers {
    public class DetailController : ControllerBase {
        public ActionResult Summary() {
            ModuleTitle = "Quote Details - Summary";

            return View();
        }
    }
}