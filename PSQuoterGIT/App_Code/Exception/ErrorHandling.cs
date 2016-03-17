using System;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Text;
using X.Web.Security;
using X.Configuration;
using System.Reflection;
using System.Net.Mail;
using X.Web;
using System.Configuration;
using System.Security;

namespace ExceptionHandling
{
    /// <summary>
    /// Summary description for ErrorHandling
    /// </summary>
    public static class ExceptionHandler
    {
        public static void Log(string friendlyMessage, Exception excep, bool clearError = true)
        {
            Log(ref friendlyMessage, excep, clearError);
        }

        public static void Log(ref string friendlyMessage, Exception excep, bool clearError = true)
        {
            HttpContext context = HttpContext.Current;

            string emailTo = string.Empty;
            string adminContacts = System.Configuration.ConfigurationManager.AppSettings["contact.sysAdmins"];
            string[] contacts = adminContacts.Split('|');

            foreach (string contact in contacts) {
                string[] info = contact.Split(';');
                string contactEmail;

                contactEmail = info.Length == 2 ? info[1] : info[0];

                if (!String.IsNullOrWhiteSpace(contactEmail))
                    emailTo += contactEmail + ",";
            }

            if (emailTo.Length != 0)
            {
                // http status code
                string httpStatusCode = null;

                if (excep != null)
                {
                    switch (excep.GetType().ToString())
                    {
                        case "System.Web.HttpException":
                            HttpException httpExcep = excep as HttpException;
                            int httpCode = httpExcep.GetHttpCode();
                            httpStatusCode = " [" + httpCode + "]";

                            switch (httpCode)
                            {
                                case 404:
                                    friendlyMessage = "The page has been moved or it doesn't exist.";
                                    break;
                            }
                            break;
                        case "System.Security.SecurityException":
                            SecurityException securityExcep = excep as SecurityException;

                            if (securityExcep.Message != null && securityExcep.Message.Length > 0)
                                friendlyMessage = String.Format("<span style=\"color:red;font-weight:bold;\">{0}</span>", context.Server.HtmlEncode(securityExcep.Message));
                            else
                                friendlyMessage = "Access denied.";
                            break;
                    }

                    if(clearError) context.Server.ClearError();
                }

                // dump all inner exceptions
                StringBuilder sbExceptions = new StringBuilder();

                #region Loop through each exception class in the chain of exception objects

                const string TEXT_SEPARATOR = "*********************************************";

                // Loop through each exception class in the chain of exception objects.
                Exception currentException = excep; // Temp variable to hold InnerException object during the loop.
                int intExceptionCount = 1; // Count variable to track the number of exceptions in the chain.
                while (currentException != null)
                {
                    // Write title information for the exception object.
                    sbExceptions.AppendFormat("{0}{0}{1}) Exception Information{0}{2}", Environment.NewLine, intExceptionCount.ToString(), TEXT_SEPARATOR);
                    sbExceptions.AppendFormat("{0}Exception Type: {1}", Environment.NewLine, currentException.GetType().FullName);

                    #region Loop through the public properties of the exception object and record their value

                    // Loop through the public properties of the exception object and record their value.
                    PropertyInfo[] aryPublicProperties = currentException.GetType().GetProperties();
                    foreach (PropertyInfo p in aryPublicProperties)
                    {
                        // Do not log information for the InnerException or StackTrace. This information is
                        // captured later in the process.
                        if (p.Name != "InnerException" && p.Name != "StackTrace")
                        {
                            if (p.GetValue(currentException, null) == null)
                            {
                                sbExceptions.AppendFormat("{0}{1}: NULL", Environment.NewLine, p.Name);
                            }
                            else
                            {
                                sbExceptions.AppendFormat("{0}{1}: {2}", Environment.NewLine, p.Name, p.GetValue(currentException, null));
                            }
                        }
                    }

                    #endregion

                    #region Record the Exception StackTrace

                    // Record the StackTrace with separate label.
                    if (currentException.StackTrace != null)
                    {
                        sbExceptions.AppendFormat("{0}{0}StackTrace Information{0}{1}", Environment.NewLine, TEXT_SEPARATOR);
                        sbExceptions.AppendFormat("{0}{1}", Environment.NewLine, currentException.StackTrace);
                    }

                    #endregion

                    // Reset the temp exception object and iterate the counter.
                    currentException = currentException.InnerException;
                    intExceptionCount++;
                }

                #endregion

                StringBuilder sbEmailMsg = new StringBuilder();

                // app name
                sbEmailMsg.AppendFormat("App Name: {1}{0}App ID: {2}{0}{0}",
                    Environment.NewLine,
                    WebContext.Current.Application.ApplicationName,
                    WebContext.Current.Application.ApplicationID
                );

                // user info
                sbEmailMsg.AppendFormat("User Login Name:{1}{0}",
                     Environment.NewLine,
                     context.User.Identity.Name
                );
                if (WebContext.Current.User != null && WebContext.Current.User.Identity != null)
                {
                    sbEmailMsg.AppendFormat("User Full Name: {1} {2}{0}User Email: {3}{0}User ID:{4}{0}{0}",
                         Environment.NewLine,
                         WebContext.Current.User.IdentityEx.FirstName, // 1
                         WebContext.Current.User.IdentityEx.LastName, // 2
                         WebContext.Current.User.IdentityEx.EMail, // 3
                         WebContext.Current.User.IdentityEx.UserID // 4
                    );
                }

                // friendly message
                sbEmailMsg.AppendFormat("{0}{1}{1}", friendlyMessage, Environment.NewLine);

                // page requested
                sbEmailMsg.AppendFormat("Page Requested: {0}{1}{1}", context.Request.RawUrl, Environment.NewLine);

                // time stamp
                sbEmailMsg.AppendFormat("Occurred: {1:f}{0}",
                    Environment.NewLine,
                    DateTime.Now
                    );

                // Form data
                if (context.Request.Form.Count >= 0)
                {
                    sbEmailMsg.AppendFormat("{0}{0}==== Form Collection Dump ===={0}", Environment.NewLine);

                    foreach (string key in context.Request.Form.Keys)
                    {
                        string[] values = context.Request.Form.GetValues(key);

                        if (values == null || key == "__VIEWSTATE" || key == "__EVENTVALIDATION")
                        {
                            continue;
                        }

                        string valuesDisplay = String.Join(", ", values);

                        /*Limiter
                        if (valuesDisplay.Length > 70)
                        {
                            valuesDisplay = valuesDisplay.Substring(0, 70) + "...";
                        }
                        */ 

                        sbEmailMsg.AppendFormat("{1}: {2}{0}", Environment.NewLine, key, valuesDisplay);
                    }
                }

                // dump exception
                if (sbExceptions.Length > 0)
                {
                    sbEmailMsg.AppendFormat("{0}{0}==== Exceptions Dump ====", Environment.NewLine);
                    sbEmailMsg.Append(sbExceptions.ToString());
                }

                string loginName = context.User.Identity.Name;
                if (loginName != null)
                {
                    loginName = loginName.Replace('/', '\\');
                    if (loginName.IndexOf('\\') != -1)
                    {
                        loginName = loginName.Substring(loginName.IndexOf('\\') + 1);
                    }
                }

                SmtpClient mail = new SmtpClient(System.Configuration.ConfigurationManager.AppSettings["mail.smtpServer"]);
                emailTo = emailTo.Trim();
                if (emailTo.EndsWith(",")) emailTo = emailTo.Substring(0, emailTo.Length - 1);
                mail.Send(ConfigurationManager.AppSettings["mail.from"], emailTo, loginName + ":" + httpStatusCode + " - ASP.NET error generated on " + context.Request.Url.Host, sbEmailMsg.ToString());
            }
        }
    }
}