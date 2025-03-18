USE CTYMAILINH;
GO

-- 1. Tạo đăng nhập cho các tài khoản quản lý
CREATE LOGIN AdminUser WITH PASSWORD = 'Admin@2025', DEFAULT_DATABASE = CTYMAILINH, CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;
CREATE LOGIN StaffUser WITH PASSWORD = 'Staff@2025', DEFAULT_DATABASE = CTYMAILINH, CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;
CREATE LOGIN AccountantUser WITH PASSWORD = 'Acc@2025', DEFAULT_DATABASE = CTYMAILINH, CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;
GO

-- 2. Tạo người dùng trong database CTYMAILINH
USE CTYMAILINH;
GO

CREATE USER AdminUser FOR LOGIN AdminUser;
CREATE USER StaffUser FOR LOGIN StaffUser;
CREATE USER AccountantUser FOR LOGIN AccountantUser;
GO

-- 3. Gán quyền cho từng nhóm người dùng
-- AdminUser có toàn quyền trên database
ALTER ROLE db_owner ADD MEMBER AdminUser;

-- StaffUser có quyền quản lý xe và hợp đồng
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Xe TO StaffUser;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.LoaiXe TO StaffUser;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Tuyen TO StaffUser;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HopDongThue TO StaffUser;

-- AccountantUser chỉ có quyền xem dữ liệu
GRANT SELECT ON dbo.GiaThue TO AccountantUser;
GRANT SELECT ON dbo.HopDongThue TO AccountantUser;
GO

-- 4. Kiểm tra danh sách user trong database
SELECT name AS UserName, type_desc AS UserType
FROM sys.database_principals
WHERE type IN ('S', 'U') AND name NOT IN ('dbo', 'guest', 'public');

-- 5. Kiểm tra quyền đã cấp cho user
SELECT 
    dpr.name AS UserName,        
    dpr.type_desc AS UserType,   
    dp.permission_name,
    dp.state_desc
FROM sys.database_permissions dp
JOIN sys.database_principals dpr ON dp.grantee_principal_id = dpr.principal_id
WHERE dpr.name IN ('AdminUser', 'StaffUser', 'AccountantUser');
GO

-- 6. Sao lưu cơ sở dữ liệu vào thư mục mặc định của SQL Server
BACKUP DATABASE CTYMAILINH
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\CTYMAILINH_Backup.bak'
WITH FORMAT, MEDIANAME = 'CTYMAILINH_Backup', NAME = 'Full Backup of CTYMAILINH';

-- Kiểm tra kết quả sao lưu
IF @@ERROR = 0
    PRINT 'Backup completed successfully.';
ELSE
    PRINT 'Backup failed with error: ' + CAST(@@ERROR AS NVARCHAR);
GO

-- 7. Xem lịch sử sao lưu cơ sở dữ liệu
SELECT 
    database_name,
    backup_start_date,
    backup_finish_date,
    physical_device_name
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE database_name = 'CTYMAILINH';
GO

-- 8. Kiểm tra quyền truy cập bằng cách chạy thử với user AccountantUser
EXECUTE AS USER = 'AccountantUser';
SELECT * FROM dbo.GiaThue;
REVERT;
GO
