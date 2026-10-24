using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Mvc;
using Models.DAO;
using Models.EF;

namespace WebsiteNoiThat.Controllers
{
    // Trang "Theo dõi đơn hàng" (issue #68): nhập mã đơn hàng để xem
    // tiến trình trạng thái + vị trí ước lượng của món hàng trên bản đồ.
    public class OrderController : Controller
    {
        // Tọa độ đáng tin cậy của showroom/xưởng gốc (Bắc Ninh) làm điểm xuất phát
        private const double ShopLat = 21.1861;
        private const double ShopLng = 106.0763;

        public ActionResult Track(int? id)
        {
            ViewBag.DaTraCuu = false;

            if (id.HasValue && id.Value > 0)
            {
                ViewBag.DaTraCuu = true;

                var data = new OrderDao().GetForTrack(id.Value);
                if (data == null)
                {
                    ViewBag.KhongTimThay = true; // đơn không tồn tại
                    return View();
                }

                var model = new TrackViewModel
                {
                    Data = data,
                    Progress = DoTienTrinh(data.Order.StatusId),
                    ShopLat = ShopLat,
                    ShopLng = ShopLng
                };

                // Định vị địa chỉ giao hàng qua OpenStreetMap Nominatim (dịch vụ miễn phí)
                var diem = DinhViDiaChi(data.Order.ShipAddress);
                if (diem != null)
                {
                    model.CusLat = diem.Lat;
                    model.CusLng = diem.Lng;
                }
                ViewBag.Model = model;
            }

            return View();
        }

        // Map StatusId -> phần trăm tiến trình giao hàng (minh họa chuẩn đơn vị giao hàng)
        private static int DoTienTrinh(int statusId)
        {
            switch (statusId)
            {
                case 1: return 15;  // Đã tiếp nhận
                case 2: return 30;  // Đang chờ xử lý
                case 3: return 50;  // Đã xử lý
                case 4: return 75;  // Đang giao hàng
                case 5: return 100; // Đã thanh toán
                default: return 10;
            }
        }

        private Geocode DinhViDiaChi(string diaChi)
        {
            if (string.IsNullOrWhiteSpace(diaChi)) return null;
            try
            {
                // Nominatim yêu cầu khai báo User-Agent rõ ràng
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                using (var wc = new WebClient())
                {
                    wc.Headers[HttpRequestHeader.UserAgent] =
                        "N3PTPMMNM-Demo/1.0 (website ban noi that - muc dich hoc tap)";
                    wc.Encoding = System.Text.Encoding.UTF8;
                    var url = "https://nominatim.openstreetmap.org/search?format=json&limit=1&accept-language=vi&countrycodes=vn&q="
                              + Uri.EscapeDataString(diaChi);
                    var json = wc.DownloadString(url);
                    var arr = Newtonsoft.Json.JsonConvert.DeserializeObject<List<NominatimItem>>(json);
                    var first = arr != null ? arr.FirstOrDefault() : null;
                    if (first == null) return null;

                    double lat, lng;
                    if (double.TryParse(first.lat, System.Globalization.NumberStyles.Any,
                            System.Globalization.CultureInfo.InvariantCulture, out lat) &&
                        double.TryParse(first.lon, System.Globalization.NumberStyles.Any,
                            System.Globalization.CultureInfo.InvariantCulture, out lng))
                    {
                        return new Geocode { Lat = lat, Lng = lng };
                    }
                    return null;
                }
            }
            catch
            {
                return null; // Không định vị được thì bản đồ vẫn hiển thị điểm gốc
            }
        }

        private class NominatimItem
        {
            public string lat { get; set; }
            public string lon { get; set; }
            public string display_name { get; set; }
        }

        private class Geocode
        {
            public double Lat { get; set; }
            public double Lng { get; set; }
        }
    }

    // Dữ liệu view gửi xuống kèm tọa độ bản đồ
    public class TrackViewModel
    {
        public global::Models.DAO.TrackOrderView Data { get; set; }
        public int Progress { get; set; }
        public double ShopLat { get; set; }
        public double ShopLng { get; set; }
        public double? CusLat { get; set; }
        public double? CusLng { get; set; }
    }
}
