using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Routing;
using Entities;
using Entities.AppState;
using Enums;
using Helpers;
using Repositories;
using X;
using X.Configuration;
using X.Extensions;
using X.Web.Extensions;
using X.Web.Globalization;

/// <summary>
/// Summary description for AppContext
/// </summary>

namespace Canam
{
	public class AppContext {
    private static readonly object syncRoot = new object();
    private static AppContext s_anonymousAppContext;
    private const string sessionItemKey = "SL:AppContext";
    private const string accountInfoItemKey = "appCtx:AcctInfo";

    private ExecutionStageEnum _executionStage;
    private ApplicationSettings _appSettings;
    private Dictionary<int, BusinessEntityItem> _businessEntities;
    private BusinessEntityItem _businessEntity;
    private string _divisionCode;

    private enum ExecutionStageEnum {
        SessionInit = 1
        ,SessionPostInit
        ,RequestInit
        ,RequestPostInit
    }

    private AppContext(bool isAuthenticated) {
        _executionStage = ExecutionStageEnum.SessionInit;

        this.Language = GlobalizationContext.Current.Language;

        this.ApplicationId = (int) global::WebContext.Current.Application.ApplicationID;

        // Business Entity
        this._businessEntities = new Dictionary<int, BusinessEntityItem>();

        //TODO:get entity
        this.BusinessEntity = new BusinessEntityItem {DivisionCode = "G", BusinessEntityId = 1, BusinessEntityName = "Toromont CAT", Selected = true};

        // Division info
        this.Divisions = new Dictionary<string, DivisionInfo>(StringComparer.InvariantCultureIgnoreCase);

        // User info
        this.User = new UserInfo(isAuthenticated);

        if (!isAuthenticated) {
            var businessEntity = new BusinessEntityItem { BusinessEntityId = 0 };
            _businessEntities.Add(businessEntity.BusinessEntityId, businessEntity);
            this.BusinessEntity = businessEntity;
        }

        _executionStage = ExecutionStageEnum.SessionPostInit;
    }

    //== Properties
    public static AppContext Current {
        get {
            var httpContext = global::System.Web.HttpContext.Current;
            AppContext appContext;

            if (httpContext.Session == null) {
                appContext = s_anonymousAppContext ?? (s_anonymousAppContext = new AppContext(isAuthenticated: false));
            } else {
                appContext = (AppContext)httpContext.Session[sessionItemKey];
            }

            if (appContext == null) {
                lock (syncRoot) {
                    if (appContext == null) {
                        appContext = new AppContext(isAuthenticated: true);

                        httpContext.Session[sessionItemKey] = appContext;
                    }
                }
            }
            return appContext;
        }
    }

    public HttpContextBase Context {
        get {
            var httpContext = (HttpContextBase) global::System.Web.HttpContext.Current.Items["_httpContext"];
            if (httpContext == null) {
                httpContext = new HttpContextWrapper(global::System.Web.HttpContext.Current);
                global::System.Web.HttpContext.Current.Items["_httpContext"] = httpContext;
            }

            return httpContext;
        }
    }

    public Language Language { get; private set; }

    public int LanguageId { get { return Language.LanguageId; } }

    public UserInfo User { get; private set; }

    /// <summary>
    /// App settings according to current data system, division.
    /// </summary>
    public ApplicationSettings AppSettings {
        get {
            if (_appSettings == null) {
                var appConfigWrapper = (AppConfigurationWrapper)HttpRuntime.Cache["app.configuration"];

                if (appConfigWrapper == null) {
                    var repository = new Repositories.AppStateRepository(this);
                    appConfigWrapper = repository.GetAppConfiguration();

                    HttpRuntime.Cache["app.configuration"] = appConfigWrapper;
                }

                _appSettings = new ApplicationSettings(appConfigWrapper.AppSettings);
            }

            return _appSettings;
        }
    }

    public int BusinessEntityId {
        get { return BusinessEntity.BusinessEntityId; }
    }

    public BusinessEntityItem BusinessEntity {
        get { return _businessEntity; }
        private set {
            _businessEntity = value;

            if (_businessEntity == null) throw new ArgumentNullException("BusinessEntity");

            _businessEntity.Selected = true;
        }
    }

    public int ApplicationId { get; private set; }

    public Dictionary<int, BusinessEntityItem> BusinessEntities {
        get { return _businessEntities; }
    }

    public string DivisionCode {
        get { return _divisionCode; }
        set {
            _divisionCode = value;

            if (_divisionCode == Consts.DivCode_All) {
                DivisionInfo = DivisionInfo.CreateAllDivision(Context);
            }
            else {
                if (!Divisions.ContainsKey(value))
                    throw new KeyNotFoundException(String.Format("Division '{0}' is not found.", value));

                DivisionInfo = this.Divisions[_divisionCode];
            }
        }
    }

    public DivisionInfo DivisionInfo { get; private set; }
    public IDictionary<string, DivisionInfo> Divisions { get; private set; }

    public int SystemId {
        //get { return  DivisionInfo.SystemId; }
        get { return 1; }
    }

    public ModuleInfo ModuleInfo { get; private set; }
    
    public static void OneTimeInit(IDictionary<string, IEnumerable<DataRow>> appStartUpData) {
        var routes = RouteTable.Routes;
        string homePageUrl = null;

        // Routes
        homePageUrl = "~/modules/Quote/Quote_list.aspx";
        
        // Home page
        if (!String.IsNullOrWhiteSpace(homePageUrl))
            routes.MapPageRoute(
                "homePage",
                Consts.UrlHomePage,
                homePageUrl
        );
    }

    public void InitializeRequest() {
        _executionStage = ExecutionStageEnum.RequestInit;

       // if (!GlobalizationContext.RequestInitialized) return;

        this.Language = GlobalizationContext.Current.Language;

        // Url info//TODO:uncomment?
        //DivisionCode = Context.Request.QueryString[Consts.DivisionCodeUrlKey].AsNullIfWhiteSpace(trim:true)
        //    ?? User.Viewer.DivisionCode
        //    ?? BusinessEntity.DivisionCode;

        // Module Info
        ModuleInfo = new ModuleInfo();

        // User Info
        User.InitializeRequest();

        _executionStage = ExecutionStageEnum.RequestPostInit;
    }

    public void Initialize(DataSet appData, bool isImpersonating = false) {
        if(appData == null) throw new ArgumentNullException("appData");

        // User Init
        User.Initialize(appData, isImpersonating);
    }

    public void Impersonate(int impersonateeUserID) {
        var repository = new AppStateRepository(this);
        var sessionStartUpData = repository.GetSessionStartUpData(impersonateeUserID, true);

        Initialize(sessionStartUpData, true);
    }

    public void UpdateBusinessEntity(int businessEntityId) {
        if (businessEntityId == BusinessEntityId) return;

        BusinessEntity = BusinessEntities.Values.SingleOrDefault(item => item.BusinessEntityId == businessEntityId);

        var repository = new AppStateRepository(this);
        var sessionStartUpData = repository.GetSessionStartUpData();

        Initialize(sessionStartUpData);
    }
}
}
