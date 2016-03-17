using X.Web.UI;

namespace UI.Abstracts.UserControls {
	/// <summary>
	/// Summary description for UserControlBase.
	/// </summary>
	public abstract class MultiIntanceUserControl : UserControlBase {
		#region Member fields
		private object _isFirstInstance = null;
		private string _firstInstanceKey = null;
		#endregion

		#region Properties
		protected bool IsFirstInstance {
			get { 
				if(this.Visible == false) return false;

				if(_isFirstInstance == null) {
					if(Context.Items[_firstInstanceKey] == null) {
						_isFirstInstance	= true;

						Context.Items[_firstInstanceKey] = false;
					}
					else {
						_isFirstInstance	= false;
					}
				}

				return (bool) _isFirstInstance; 
			}
		}

		#endregion

		#region _ctor
		protected MultiIntanceUserControl() {
			_isFirstInstance = null;

			// design mode
			if(this.Visible == false || Context == null) return;

			_firstInstanceKey = this.GetType().Name + ":firstInst";
		}
		#endregion
	}
}
