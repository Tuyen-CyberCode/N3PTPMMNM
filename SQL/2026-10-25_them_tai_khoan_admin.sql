-- 2026-10-25: Khoi tao tai khoan quan tri mac dinh cho he thong (issue #95)
-- Chay: sqlcmd -S . -E -d DBNoiThat -f 65001 -i SQL\2026-10-25_them_tai_khoan_admin.sql
-- Chu y: script AN TOAN chay lap lai (idempotent) - chi chen khi chua ton tai.
-- Tai khoan: admin / admin (MD5). Yeu cau doi mat khau ngay sau khi dua vao san xuat.

SET NOCOUNT ON;

-- ========== 1. Nhom nguoi dung ==========
IF NOT EXISTS (SELECT 1 FROM UserGroups WHERE GroupId = 'ADMIN')
    INSERT INTO UserGroups (GroupId, Name) VALUES (N'ADMIN', N'Quản trị');
IF NOT EXISTS (SELECT 1 FROM UserGroups WHERE GroupId = 'MOD')
    INSERT INTO UserGroups (GroupId, Name) VALUES (N'MOD', N'Quản lý');
IF NOT EXISTS (SELECT 1 FROM UserGroups WHERE GroupId = 'USER')
    INSERT INTO UserGroups (GroupId, Name) VALUES (N'USER', N'Người dùng');

-- ========== 2. Cac quyen he thong ==========
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'ADD_ADMIN')    INSERT INTO [Role] (RoleId, Name) VALUES ('ADD_ADMIN',    N'thêm quản trị');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'UPDATE_ADMIN') INSERT INTO [Role] (RoleId, Name) VALUES ('UPDATE_ADMIN', N'cập nhật quản trị');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'DELETE_ADMIN') INSERT INTO [Role] (RoleId, Name) VALUES ('DELETE_ADMIN', N'xóa quản trị');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'VIEW_ADMIN')   INSERT INTO [Role] (RoleId, Name) VALUES ('VIEW_ADMIN',   N'hiển thị quản trị');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'ADD_CATE')     INSERT INTO [Role] (RoleId, Name) VALUES ('ADD_CATE',     N'thêm loại sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'UPDATE_CATE')  INSERT INTO [Role] (RoleId, Name) VALUES ('UPDATE_CATE',  N'cập nhật loại sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'DELETE_CATE')  INSERT INTO [Role] (RoleId, Name) VALUES ('DELETE_CATE',  N'xóa loại sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'VIEW_CATE')    INSERT INTO [Role] (RoleId, Name) VALUES ('VIEW_CATE',    N'hiển thị loại sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'ADD_PROVIDER')     INSERT INTO [Role] (RoleId, Name) VALUES ('ADD_PROVIDER',     N'thêm nhà cung cấp');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'UPDATE_PROVIDER')  INSERT INTO [Role] (RoleId, Name) VALUES ('UPDATE_PROVIDER',  N'cập nhật nhà cung cấp');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'DELETE_PROVIDER')  INSERT INTO [Role] (RoleId, Name) VALUES ('DELETE_PROVIDER',  N'xóa nhà cung cấp');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'VIEW_PROVIDER')    INSERT INTO [Role] (RoleId, Name) VALUES ('VIEW_PROVIDER',    N'hiển thị nhà cung cấp');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'ADD_NEWS')     INSERT INTO [Role] (RoleId, Name) VALUES ('ADD_NEWS',     N'Thêm tin tức');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'UPDATE_NEWS')  INSERT INTO [Role] (RoleId, Name) VALUES ('UPDATE_NEWS',  N'Cập nhật tin tức');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'DELETE_NEWS')  INSERT INTO [Role] (RoleId, Name) VALUES ('DELETE_NEWS',  N'xóa tin tức');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'VIEW_NEWS')    INSERT INTO [Role] (RoleId, Name) VALUES ('VIEW_NEWS',    N'hiển thị tin tức');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'ADD_PRODUCT')     INSERT INTO [Role] (RoleId, Name) VALUES ('ADD_PRODUCT',     N'thêm sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'UPDATE_PRODUCT')  INSERT INTO [Role] (RoleId, Name) VALUES ('UPDATE_PRODUCT',  N'cập nhật sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'DELETE_PRODUCT')  INSERT INTO [Role] (RoleId, Name) VALUES ('DELETE_PRODUCT',  N'xóa sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'VIEW_PRODUCT')    INSERT INTO [Role] (RoleId, Name) VALUES ('VIEW_PRODUCT',    N'hiển thị sản phẩm');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'SHOW_ORDER')     INSERT INTO [Role] (RoleId, Name) VALUES ('SHOW_ORDER',     N'hiển thị hóa đơn');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'MANAGER_ORDER')  INSERT INTO [Role] (RoleId, Name) VALUES ('MANAGER_ORDER',  N'quản lý hóa đơn');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'SATISTIC_ORDER') INSERT INTO [Role] (RoleId, Name) VALUES ('SATISTIC_ORDER', N'thống kê hóa đơn');
IF NOT EXISTS (SELECT 1 FROM [Role] WHERE RoleId = 'PRINT_ORDER')    INSERT INTO [Role] (RoleId, Name) VALUES ('PRINT_ORDER',    N'in hóa đơn');

-- ========== 3. Gan quyen cho nhom ADMIN va MOD ==========
DECLARE @rows TABLE (UserGroupId varchar(10), RoleId varchar(30));
INSERT INTO @rows VALUES
('ADMIN','VIEW_PRODUCT'),('ADMIN','ADD_PRODUCT'),('ADMIN','UPDATE_PRODUCT'),('ADMIN','DELETE_PRODUCT'),
('ADMIN','VIEW_CATE'),('ADMIN','ADD_CATE'),('ADMIN','UPDATE_CATE'),('ADMIN','DELETE_CATE'),
('ADMIN','VIEW_PROVIDER'),('ADMIN','ADD_PROVIDER'),('ADMIN','UPDATE_PROVIDER'),('ADMIN','DELETE_PROVIDER'),
('ADMIN','VIEW_NEWS'),('ADMIN','ADD_NEWS'),('ADMIN','UPDATE_NEWS'),('ADMIN','DELETE_NEWS'),
('ADMIN','SHOW_ORDER'),('ADMIN','MANAGER_ORDER'),('ADMIN','SATISTIC_ORDER'),('ADMIN','PRINT_ORDER'),
('ADMIN','VIEW_USER'),('ADMIN','ADD_USER'),('ADMIN','UPDATE_USER'),('ADMIN','DELETE_USER'),
('ADMIN','VIEW_ADMIN'),('ADMIN','ADD_ADMIN'),('ADMIN','UPDATE_ADMIN'),('ADMIN','DELETE_ADMIN'),
('MOD','VIEW_PRODUCT'),('MOD','ADD_PRODUCT'),('MOD','UPDATE_PRODUCT'),('MOD','DELETE_PRODUCT'),
('MOD','VIEW_CATE'),('MOD','ADD_CATE'),('MOD','UPDATE_CATE'),('MOD','DELETE_CATE'),
('MOD','VIEW_PROVIDER'),('MOD','ADD_PROVIDER'),('MOD','UPDATE_PROVIDER'),('MOD','DELETE_PROVIDER'),
('MOD','VIEW_NEWS'),('MOD','ADD_NEWS'),('MOD','UPDATE_NEWS'),('MOD','DELETE_NEWS'),
('MOD','SHOW_ORDER'),('MOD','MANAGER_ORDER'),('MOD','SATISTIC_ORDER'),('MOD','PRINT_ORDER'),
('MOD','VIEW_USER'),('MOD','ADD_USER'),('MOD','UPDATE_USER'),('MOD','DELETE_USER');

INSERT INTO Credentials (UserGroupId, RoleId)
SELECT r.UserGroupId, r.RoleId FROM @rows r
WHERE NOT EXISTS (SELECT 1 FROM Credentials c WHERE c.UserGroupId = r.UserGroupId AND c.RoleId = r.RoleId);

-- ========== 4. Tai khoan quan tri mac dinh ==========
IF NOT EXISTS (SELECT 1 FROM [User] WHERE Username = 'admin')
BEGIN
    INSERT INTO [User] (Name, Username, Password, Status, GroupId)
    VALUES (N'Quản trị viên', 'admin', '21232f297a57a5a743894a0e4a801fc3', 1, N'ADMIN'); -- MD5('admin')
    PRINT N'Da tao tai khoan admin (admin / admin) - hay doi mat khau ngay!';
END
ELSE
    PRINT N'Tai khoan admin da ton tai - khong chen lai.';

GO
