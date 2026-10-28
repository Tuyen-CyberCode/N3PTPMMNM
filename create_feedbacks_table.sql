-- Tạo bảng Feedbacks cho tính năng đánh giá sản phẩm (issue #76)
-- Chạy lệnh này trong SQL Server Management Studio (SSMS)
-- Database: DBNoiThat

USE DBNoiThat;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Feedbacks' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Feedbacks (
        FeedbackId  INT             IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ProductId   INT             NOT NULL,
        UserId      INT             NOT NULL,
        Rate        INT             NOT NULL CHECK (Rate >= 1 AND Rate <= 5),
        Content     NVARCHAR(500)   NOT NULL,
        Time        DATETIME        NOT NULL DEFAULT GETDATE(),

        CONSTRAINT FK_Feedbacks_Product FOREIGN KEY (ProductId)
            REFERENCES dbo.Product(ProductId) ON DELETE CASCADE,

        CONSTRAINT FK_Feedbacks_User FOREIGN KEY (UserId)
            REFERENCES dbo.[User](UserId) ON DELETE CASCADE
    );

    PRINT 'Bảng Feedbacks đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Feedbacks đã tồn tại, không cần tạo lại.';
END
GO

