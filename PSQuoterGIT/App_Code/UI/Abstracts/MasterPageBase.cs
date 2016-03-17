using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace UI.Abstracts
{
	/// <summary>
	/// Summary description for MasterPageBase
	/// </summary>
	public abstract class MasterPageBase : X.Web.UI.MasterPageBase<WebContext> {
        #region Member fields
        #region Layout
        private Pane _htmlHeader;
        private Pane _headerPane;
        private Pane _topPane;
        private Pane _searchPane;
        private Pane _detailPane;
        private Pane _leftPane;
        private Pane _modulePane;
        private Pane _rightPane;
        private Pane _bottomPane;
        #endregion

        private Panel _messagePane;
        #endregion

        #region Properties
        #region Layout

        public override Pane HtmlHeader {
            get {
                if (_htmlHeader == null)
                    _htmlHeader = new Pane(FindControlManual("cntHH") as ContentPlaceHolder, "HtmlHeader");

                return _htmlHeader;
            }
        }

        public override Pane HeaderPane {
            get {
                if (_headerPane == null)
                    _headerPane = new Pane(FindControlManual("cntHP") as ContentPlaceHolder, "HeaderPane");

                return _headerPane;
            }
        }

        public override Pane TopPane {
            get {
                if (_topPane == null)
                    _topPane = new Pane(FindControlManual("cntTP") as ContentPlaceHolder, "TopPane");

                return _topPane;
            }
        }
        public override Pane SearchPane {
            get {
                if (_searchPane == null)
                    _searchPane = new Pane(FindControlManual("cntSP") as ContentPlaceHolder, "SearchPane");

                return _searchPane;
            }
        }
        public override Pane DetailPane {
            get {
                if (_detailPane == null)
                    _detailPane = new Pane(FindControlManual("cntDP") as ContentPlaceHolder, "DetailPane");

                return _detailPane;
            }
        }

        public override Pane LeftPane {
            get {
                if (_leftPane == null)
                    _leftPane = new Pane(FindControlManual("cntLP") as ContentPlaceHolder, "LeftPane");

                return _leftPane;
            }
        }

        public override Pane ModulePane {
            get {
                if (_modulePane == null)
                    _modulePane = new Pane(FindControlManual("cntMP") as ContentPlaceHolder, "ModulePane");

                return _modulePane;
            }
        }

        public override Pane RightPane {
            get {
                if (_rightPane == null)
                    _rightPane = new Pane(FindControlManual("cntRP") as ContentPlaceHolder, "RightPane");

                return _rightPane;
            }
        }

        public override Pane BottomPane {
            get {
                if (_bottomPane == null)
                    _bottomPane = new Pane(FindControlManual("cntBP") as ContentPlaceHolder, "BottomPane");

                return _bottomPane;
            }
        }

        #endregion

        #region MessagePane
        public override Panel MessagePane {
            get {
                if (_messagePane == null) {
                    _messagePane = WebContext.MasterPage.FindControlManual("MsgHolder") as Panel;
                    if (_messagePane == null) throw new ArgumentNullException("MsgHolder", "The panel control 'MsgHolder' could not be found.");
                }

                return _messagePane;
            }
        }
        #endregion

        #endregion
    }
}