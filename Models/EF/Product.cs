namespace Models.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Product")]
    public partial class Product
    {
        //[DatabaseGenerated(DatabaseGeneratedOption.None)]
        [DisplayName("Mã sản phẩm")]
        public int ProductId { get; set; }

        [StringLength(50)]
        [DisplayName("Tên sản phẩm")]
        public string Name { get; set; }

        [NotMapped]
        public string DisplayName
        {
            get
            {
                var suffix = " #" + ProductId;
                return !string.IsNullOrEmpty(Name) && Name.EndsWith(suffix, StringComparison.Ordinal)
                    ? Name.Substring(0, Name.Length - suffix.Length)
                    : Name;
            }
        }

        [NotMapped]
        public string DisplayCode
        {
            get
            {
                return !string.IsNullOrEmpty(Name) && Name.EndsWith(" #" + ProductId, StringComparison.Ordinal)
                    ? "#" + ProductId
                    : null;
            }
        }

        [DisplayName("Mô tả")]
        public string Description { get; set; }

        [DisplayName("Giá")]
        public int? Price { get; set; }

        [DisplayName("Số lượng")]
        public int? Quantity { get; set; }

        [DisplayName("Mã nhà cung cấp")]
        public int? ProviderId { get; set; }

        [DisplayName("Mã danh mục sản phẩm")]
        public int? CateId { get; set; }

        [DisplayName("Ảnh sản phẩm")]
        public string Photo { get; set; }

        [Column(TypeName = "date")]
        [DisplayName("Ngày bắt đầu KM")]
        public DateTime? StartDate { get; set; }

        [Column(TypeName = "date")]
        [DisplayName("Ngày kết thúc khuyến mại")]
        public DateTime? EndDate { get; set; }

        [DisplayName("Giảm giá (%)")]
        public int? Discount { get; set; }
    }
}
