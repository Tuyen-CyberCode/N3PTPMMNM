using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteNoiThat.Common;
using Models.EF;
using Models.DAO;

namespace WebsiteNoiThat.Common
{
   

        public class HasCredentialAttribute : AuthorizeAttribute
        {
            public string RoleId { get; set; }
            protected override bool AuthorizeCore(HttpContextBase httpContext)
            {
                var session = (WebsiteNoiThat.UserLogin)HttpContext.Current.Session[Common.Commoncontent.user_sesion_admin];
                if (session == null)
                {
                    var clientSession = (WebsiteNoiThat.UserLogin)HttpContext.Current.Session[Common.Commoncontent.user_sesion];
                    if (clientSession != null)
                    {
                        using (var db = new DBNoiThat())
                        {
                            var user = db.Users.Find(clientSession.UserId);
                            if (user != null && user.GroupId != "USER")
                            {
                                session = new UserLogin
                                {
                                    UserId = user.UserId,
                                    Username = user.Username,
                                    GroupId = user.GroupId
                                };
                                HttpContext.Current.Session[Common.Commoncontent.user_sesion_admin] = session;
                            }
                        }
                    }
                }

                if (session == null)
                {
                    return false;
                }

                List<string> privilegeLevels = this.GetCredentialByLoggedInUser(session.Username);
                bool isProductAction = this.RoleId != null && this.RoleId.IndexOf("PRODUCT", StringComparison.OrdinalIgnoreCase) >= 0;
                if (session.GroupId == CommonConstant.ADMIN_GROUP || (isProductAction && (session.GroupId == CommonConstant.ADMIN_GROUP || session.GroupId == CommonConstant.MOD_GROUP)) || (privilegeLevels != null && privilegeLevels.Contains(this.RoleId)))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
            {
                filterContext.Result = new ViewResult
                {
                    ViewName = "~/Areas/Admin/Views/Shared/401.cshtml"
                };
            }
            private List<string> GetCredentialByLoggedInUser(string userName)
            {
                var credentials = (List<string>)HttpContext.Current.Session[Common.Commoncontent.SESSION_CREDENTIALS];
                if (credentials == null && !string.IsNullOrEmpty(userName))
                {
                    try
                    {
                        var dao = new UserDao();
                        credentials = dao.GetListCredentials(userName);
                        HttpContext.Current.Session[Common.Commoncontent.SESSION_CREDENTIALS] = credentials;
                    }
                    catch
                    {
                        credentials = new List<string>();
                    }
                }
                return credentials ?? new List<string>();
            }
        }
    }
