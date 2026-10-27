namespace Models.EF
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    // Danh sach yeu thich (issue #105): moi (UserId, ProductId) chi ton tai mot dong
    // Tuong ung bang [dbo].[Wishlists] tao boi SQL\2026-10-27_tao_bang_wishlist.sql
    [Table("Wishlists")]
    public partial class Wishlist
    {
        public int WishlistId { get; set; }

        public int ProductId { get; set; }

        public int UserId { get; set; }

        public DateTime CreatedDate { get; set; }
    }
}
