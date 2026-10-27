-- 2026-10-27: Tao bang Wishlists cho tinh nang danh sach yeu thich (issue #105)
-- Moi (UserId, ProductId) chi ton tai mot dong duy nhat.
-- Lenh chay: sqlcmd -S . -E -d DBNoiThat -f 65001 -i SQL\2026-10-27_tao_bang_wishlist.sql

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = N'Wishlists')
BEGIN
    PRINT 'Wishlists da ton tai - bo qua.';
END
ELSE
BEGIN
    CREATE TABLE [dbo].[Wishlists](
        [WishlistId]  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [ProductId]   INT               NOT NULL,
        [UserId]      INT               NOT NULL,
        [CreatedDate] DATETIME          NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_Wishlist_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId]),
        CONSTRAINT [FK_Wishlist_User]    FOREIGN KEY ([UserId])    REFERENCES [dbo].[User] ([UserId])
    );

    -- Khong cho mot user yeu thich trung mot san pham
    CREATE UNIQUE INDEX [UX_Wishlist_UserId_ProductId]
        ON [dbo].[Wishlists] ([UserId], [ProductId]);

    PRINT 'Da tao bang Wishlists.';
END
GO
