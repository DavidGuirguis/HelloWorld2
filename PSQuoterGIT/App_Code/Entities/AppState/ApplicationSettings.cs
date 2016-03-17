using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Helpers;
using X;

namespace Entities.AppState {
    public class ApplicationSettings {
        #region Member fields

        private List<AppSettingItem> _items;
        #endregion

        #region ctor
        public ApplicationSettings(List<AppSettingItem> items) {
            //TODO:change to System sense
            _items = items;
        }
        #endregion

        public string this[string key] {
            get {
                if (String.IsNullOrEmpty(key)) throw new ArgumentNullException("key");

                key = key.ToLower();

                var items = _items.FindAll(i => i.Key.ToLower() == key);

                if (items.Count > 1)
                    throw new InvalidOperationException(String.Format("Configuration key '{0}' has more than one value returned.", key));//TODO:move the checking to ApplicationSettings ctor

                return items.Count == 0 ? null : items[0].Value;
            }
        }

        public AppSettingItem GetItem(string key) {
            return _items.SingleOrDefault(item => 0 == String.Compare(item.Key, key, StringComparison.InvariantCultureIgnoreCase));
        }

        public bool ContainsKey(string key) {
            return _items.Exists(item => 0 == String.Compare(item.Key, key, StringComparison.InvariantCultureIgnoreCase));
        }

        public bool IsTrue(string key, bool defaultValue) {
            return BitMaskBoolean.IsTrue(this[key], defaultValue);
        }

        public bool IsTrue(string key) {
            return BitMaskBoolean.IsTrue(this[key], defaultValue:false);
        }
    }
}