
using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
namespace Helpers
{
    public class JSONObject
    {
        public static JSONObject CreateFromString(string s)
        {
            object o = null;
            JavaScriptSerializer js = new JavaScriptSerializer();
            try
            {
                o = js.DeserializeObject(s);
            }
            catch (ArgumentException)
            {

            }
            return Create(o);
        }

        public bool IsDictionary
        {
            get
            {
                return _dictData != null;
            }
        }

        public bool IsArray
        {
            get
            {
                return _arrayData != null;
            }
        }

        public bool IsString
        {
            get
            {
                return _stringData != null;
            }
        }

        public bool IsInteger
        {
            get
            {
                Int64 tmp;
                return Int64.TryParse(_stringData, out tmp);
            }
        }

        public bool IsBoolean
        {
            get
            {
                bool tmp;
                return bool.TryParse(_stringData, out tmp);
            }
        }

        public Dictionary<string, JSONObject> Dictionary
        {
            get
            {
                return _dictData;
            }
        }

        public JSONObject[] Array
        {
            get
            {
                return _arrayData;
            }
        }

        public string String
        {
            get
            {
                return _stringData;
            }
        }

        public Int64 Integer
        {
            get
            {
                return Convert.ToInt64(_stringData);
            }
        }

        public bool Boolean
        {
            get
            {
                return Convert.ToBoolean(_stringData);
            }
        }

        public string ToDisplayableString()
        {
            StringBuilder sb = new StringBuilder();
            RecursiveObjectToString(this, sb, 0);
            return sb.ToString();
        }

        #region Private Members

        private string _stringData;
        private JSONObject[] _arrayData;
        private Dictionary<string, JSONObject> _dictData;

        private JSONObject()
        { }

        private static JSONObject Create(object o)
        {
            JSONObject obj = new JSONObject();
            if (o is object[])
            {
                object[] objArray = o as object[];
                obj._arrayData = new JSONObject[objArray.Length];
                for (int i = 0; i < obj._arrayData.Length; ++i)
                {
                    obj._arrayData[i] = Create(objArray[i]);
                }
            }
            else if (o is Dictionary<string, object>)
            {
                obj._dictData = new Dictionary<string, JSONObject>();
                Dictionary<string, object> dict =
                    o as Dictionary<string, object>;
                foreach (string key in dict.Keys)
                {
                    obj._dictData[key] = Create(dict[key]);
                }
            }
            else if (o != null)
            {
                obj._stringData = o.ToString();
            }

            return obj;
        }

        private static void RecursiveObjectToString(JSONObject obj, StringBuilder sb, int level)
        {
            if (obj.IsDictionary)
            {
                sb.AppendLine();
                RecursiveDictionaryToString(obj, sb, level + 1);
            }
            else if (obj.IsArray)
            {
                foreach (JSONObject o in obj.Array)
                {
                    RecursiveObjectToString(o, sb, level);
                    sb.AppendLine();
                }
            }
            else
            {
                sb.Append(obj.String);
            }
        }
    
        private static void RecursiveDictionaryToString(JSONObject obj, StringBuilder sb, int level)
        {
            foreach (KeyValuePair<string, JSONObject> kvp in obj.Dictionary)
            {
                sb.Append(' ', level * 2);
                sb.Append(kvp.Key);
                sb.Append(" => ");
                RecursiveObjectToString(kvp.Value, sb, level);
                sb.AppendLine();
            }
        }

        #endregion

    }

}