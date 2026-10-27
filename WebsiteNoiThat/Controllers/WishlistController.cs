using System.Web.Mvc;
using Models.DAO;
using WebsiteNoiThat.Common;

namespace WebsiteNoiThat.Controllers
{
    // Danh sach yeu thich (issue #105): chua dang nhap thi dua ve trang dang nhap
    public class WishlistController : Controller
    {
        // GET /danh-sach-yeu-thich
        public ActionResult Index()
        {
            var session = (UserLogin)Session[Commoncontent.user_sesion];
            if (session == null)
            {
                return Redirect("/dang-nhap");
            }

            var dao = new WishlistDao();
            ViewBag.Count = dao.CountByUser(session.UserId);
            var model = dao.ListByUser(session.UserId);
            return View(model);
        }

        // GET /Wishlist/Toggle/123 - bam lan 1 them vao yeu thich, bam lan nua bo ra
        public ActionResult Toggle(int id)
        {
            var session = (UserLogin)Session[Commoncontent.user_sesion];
            if (session == null)
            {
                return Redirect("/dang-nhap");
            }

            var dao = new WishlistDao();
            dao.Toggle(session.UserId, id);

            // Quay ve trang truoc do neu biet, khong thi ve trang danh sach
            var referrer = Request != null ? Request.UrlReferrer : null;
            if (referrer != null && !string.IsNullOrEmpty(referrer.AbsolutePath))
            {
                return Redirect(referrer.PathAndQuery);
            }
            return Redirect("/danh-sach-yeu-thich");
        }
    }
}
