USE CTYMAILINH;
GO

-- 1️⃣ KIỂM TRA & XÓA RÀNG BUỘC TRƯỚC KHI XÓA CỘT
DECLARE @ConstraintName NVARCHAR(200);

-- Tìm ràng buộc UNIQUE hoặc CHECK trên cột DienThoai
SELECT @ConstraintName = name 
FROM sys.objects 
WHERE parent_object_id = OBJECT_ID('Khach') 
AND type_desc LIKE '%CONSTRAINT%' 
AND name LIKE 'UQ%'; -- Tìm UNIQUE CONSTRAINT

-- Nếu có ràng buộc, xóa nó
IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Khach DROP CONSTRAINT ' + @ConstraintName);
END
GO

-- XÓA RÀNG BUỘC FOREIGN KEY (NẾU CÓ)
DECLARE @FKName NVARCHAR(200);

SELECT @FKName = name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('Khach');

IF @FKName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Khach DROP CONSTRAINT ' + @FKName);
END
GO

-- 2️⃣ TẠO MASTER KEY & CERTIFICATE
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MatKhauMaster123';
END
GO

IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'Cert_Encryption')
BEGIN
    CREATE CERTIFICATE Cert_Encryption WITH SUBJECT = 'Column Encryption';
END
GO

-- 3️⃣ TẠO SYMMETRIC KEY
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'SymKey_ColumnEncryption')
BEGIN
    CREATE SYMMETRIC KEY SymKey_ColumnEncryption  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE Cert_Encryption;
END
GO

-- 4️⃣ THÊM CỘT MÃ HÓA (NẾU CHƯA CÓ)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Khach' AND COLUMN_NAME = 'DienThoai_Encrypted')
BEGIN
    ALTER TABLE Khach ADD DienThoai_Encrypted VARBINARY(MAX);
END
GO

-- 5️⃣ MÃ HÓA DỮ LIỆU TỪ `DienThoai` -> `DienThoai_Encrypted`
OPEN SYMMETRIC KEY SymKey_ColumnEncryption  
DECRYPTION BY CERTIFICATE Cert_Encryption;

UPDATE Khach  
SET DienThoai_Encrypted = EncryptByKey(Key_GUID('SymKey_ColumnEncryption'), CONVERT(VARBINARY, DienThoai))
WHERE DienThoai_Encrypted IS NULL;

CLOSE SYMMETRIC KEY SymKey_ColumnEncryption;
GO

-- 6️⃣ XÓA CỘT `DienThoai` NẾU NÓ TỒN TẠI
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Khach' AND COLUMN_NAME = 'DienThoai')
BEGIN
    ALTER TABLE Khach DROP COLUMN DienThoai;
END
GO

-- 7️⃣ HƯỚNG DẪN GIẢI MÃ DỮ LIỆU
-- Mở khóa & truy vấn dữ liệu giải mã
OPEN SYMMETRIC KEY SymKey_ColumnEncryption  
DECRYPTION BY CERTIFICATE Cert_Encryption;

SELECT MaKhach, TenKhach, 
       CONVERT(NVARCHAR(15), DecryptByKey(DienThoai_Encrypted)) AS DienThoai
FROM Khach;

CLOSE SYMMETRIC KEY SymKey_ColumnEncryption;
GO




