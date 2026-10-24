using Models.EF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.DAO
{
  public  class OrderDao : IDisposable
    {
       DBNoiThat db = null;
        public OrderDao()
        {
            db = new DBNoiThat();
        }
        public void Dispose()
        {
            if (db != null)
            {
                db.Dispose();
                db = null;
            }
            GC.SuppressFinalize(this);
        }
        public int Insert(Order order)
        {
            db.Orders.Add(order);
            db.SaveChanges();
            return order.OrderId;
        }

        // Lấy thông tin đơn hàng phục vụ trang "Theo dõi đơn hàng" (issue #68)
        public TrackOrderView GetForTrack(int orderId)
        {
            var order = db.Orders.FirstOrDefault(o => o.OrderId == orderId);
            if (order == null) return null;

            var details = db.OrderDetails.Where(d => d.OrderId == orderId).ToList();
            var ids = details.Select(d => d.ProductId.HasValue ? d.ProductId.Value : 0).Distinct().ToList();
            var products = db.Products
                             .Where(p => ids.Contains(p.ProductId))
                             .ToDictionary(p => p.ProductId, p => p.Name);

            var view = new TrackOrderView
            {
                Order = order,
                StatusName = null,
                Items = details.Select(d =>
                {
                    var name = "(sản phẩm đã bị xóa)";
                    if (d.ProductId.HasValue && products.ContainsKey(d.ProductId.Value))
                        name = products[d.ProductId.Value];
                    return new TrackOrderItem
                    {
                        ProductName = name,
                        Price = d.Price ?? 0,
                        Quantity = d.Quantity ?? 0
                    };
                }).ToList()
            };

            var st = db.Status.FirstOrDefault(s => s.StatusId == order.StatusId);
            view.StatusName = st == null ? ("Trạng thái " + order.StatusId) : st.Name;
            view.Total = view.Items.Sum(x => x.Price * x.Quantity);
            return view;
        }
    }

    // Dữ liệu hiển thị trang theo dõi đơn hàng (issue #68)
    public class TrackOrderView
    {
        public Order Order { get; set; }
        public string StatusName { get; set; }
        public List<TrackOrderItem> Items { get; set; }
        public int Total { get; set; }
    }

    public class TrackOrderItem
    {
        public string ProductName { get; set; }
        public int Price { get; set; }
        public int Quantity { get; set; }
        public int SubTotal
        {
            get { return Price * Quantity; }
        }
    }
}
