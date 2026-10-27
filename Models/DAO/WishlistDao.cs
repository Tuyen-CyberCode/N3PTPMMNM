using System;
using System.Collections.Generic;
using System.Linq;
using Models.EF;

namespace Models.DAO
{
    // Danh sach yeu thich (issue #105)
    public class WishlistDao : IDisposable
    {
        private readonly DBNoiThat db = new DBNoiThat();

        // Bam lan 1 them vao, bam lan nua bo ra. Tra ve true = dang yeu thich, false = da bo
        public bool Toggle(int userId, int productId)
        {
            // San pham khong ton tai thi khong thuc hien gi (tran danh muc chua FK Product)
            if (!db.Products.Any(p => p.ProductId == productId))
            {
                return false;
            }

            var item = db.Wishlists.FirstOrDefault(w => w.UserId == userId && w.ProductId == productId);
            if (item != null)
            {
                db.Wishlists.Remove(item);
                db.SaveChanges();
                return false;
            }

            db.Wishlists.Add(new Wishlist
            {
                UserId = userId,
                ProductId = productId,
                CreatedDate = DateTime.Now
            });
            db.SaveChanges();
            return true;
        }

        public bool IsFavorite(int userId, int productId)
        {
            return db.Wishlists.Any(w => w.UserId == userId && w.ProductId == productId);
        }

        public int CountByUser(int userId)
        {
            return db.Wishlists.Count(w => w.UserId == userId);
        }

        // Danh sach san pham yeu thich cua mot user, moi nhat len dau
        public List<Product> ListByUser(int userId)
        {
            var query = (from w in db.Wishlists
                         join p in db.Products on w.ProductId equals p.ProductId
                         where w.UserId == userId
                         orderby w.CreatedDate descending
                         select p);
            return query.ToList();
        }

        public void Dispose()
        {
            db.Dispose();
        }
    }
}
