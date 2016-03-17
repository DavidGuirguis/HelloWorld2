using System;
using System.Diagnostics.CodeAnalysis;
using System.Web.Mvc;
using System.Web.WebPages;
using Helpers;
using X.Web.Mvc;

namespace UI.Abstracts {
    public abstract class WebViewPageBase<TModel, TViewDataContainer> : global::X.Web.Mvc.WebViewPageBase<TModel, TViewDataContainer> {
        protected override void InitializePage() {
            base.InitializePage();

            Theme = LayoutHelper.GetThemeName();
        }

        public override string FormatPageTitle() {
            return LayoutHelper.FormatTitle(pageTitle: PageTitle, moduleTitle: ModuleTitle);
        }
    }
}