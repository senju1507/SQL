USE CTYMAILINH;
GO

--1.Lấy danh sách tất cả các xe (Không tham số)
CREATE PROCEDURE sp_GetAllXe
AS
BEGIN
    SELECT * FROM Xe;
END;

EXEC sp_GetAllXe;
--2.Lấy danh sách các tuyến đường  (Không tham số)
CREATE PROCEDURE sp_GetAllTuyen
AS
BEGIN
    SELECT * FROM Tuyen;
END;

EXEC sp_GetAllTuyen;
--3.Lấy danh sách hợp đồng thuê  (Không tham số)
CREATE PROCEDURE sp_GetAllHopDong
AS
BEGIN
    SELECT * FROM HopDongThue;
END;

EXEC sp_GetAllHopDong;
--4.Lấy danh sách khách hàng theo mã  (Có tham số)
CREATE PROCEDURE sp_GetKhachByMaKhach
    @MaKhach NVARCHAR(10)
AS
BEGIN
    SELECT * FROM Khach WHERE MaKhach = @MaKhach;
END;

EXEC sp_GetKhachByMaKhach 'KH01';
--5.Lấy danh sách xe theo hãng  (Có tham số)
CREATE PROCEDURE sp_GetXeByHangXe
    @HangXe NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Xe WHERE HangXe = @HangXe;
END;

EXEC sp_GetXeByHangXe 'Toyota';
--6.Cập nhật số lượng xe thuê trong hợp đồng  (Có tham số)
CREATE PROCEDURE sp_UpdateSoLuongXe
    @SoHD NVARCHAR(10),
    @SoLuongXe INT
AS
BEGIN
    UPDATE HopDongThue 
    SET SoLuongXe = @SoLuongXe 
    WHERE SoHD = @SoHD;
END;

EXEC sp_UpdateSoLuongXe 'HD01', 5;
--7.Thêm khách hàng mới  (Có tham số)
CREATE PROCEDURE sp_InsertKhach
    @MaKhach NVARCHAR(10),
    @TenKhach NVARCHAR(100),
    @DienThoai NVARCHAR(15)
AS
BEGIN
    INSERT INTO Khach (MaKhach, TenKhach, DienThoai)
    VALUES (@MaKhach, @TenKhach, @DienThoai);
END;

EXEC sp_InsertKhach 'KH12', 'Công ty DEF', '999888777';
--8.Tính tổng số xe thuê theo hợp đồng  (Có OUTPUT)
CREATE PROCEDURE sp_GetTongXeThue
    @SoHD NVARCHAR(10),
    @TongXeThue INT OUTPUT
AS
BEGIN
    SELECT @TongXeThue = SUM(SoLuongXe) 
    FROM HopDongThue
    WHERE SoHD = @SoHD;
END;

DECLARE @TongXeThue INT;
EXEC sp_GetTongXeThue 'HD01', @TongXeThue OUTPUT;
PRINT 'Tổng số xe thuê: ' + CAST(@TongXeThue AS NVARCHAR);
--9.Kiểm tra giá thuê xe theo mã loại & tuyến đường  (Có OUTPUT)
CREATE PROCEDURE sp_GetGiaThue
    @MaLoai NVARCHAR(10),
    @MaTuyen NVARCHAR(10),
    @GiaThue INT OUTPUT
AS
BEGIN
    SELECT @GiaThue = GiaThue
    FROM GiaThue
    WHERE MaLoai = @MaLoai AND MaTuyen = @MaTuyen;
END;

DECLARE @GiaThue INT;
EXEC sp_GetGiaThue 'L01', 'T01', @GiaThue OUTPUT;
PRINT @GiaThue;
--10.Xóa hợp đồng thuê  (Có tham số)
CREATE PROCEDURE sp_DeleteHopDong
    @SoHD NVARCHAR(10)
AS
BEGIN
    DELETE FROM HopDongThue WHERE SoHD = @SoHD;
END;

EXEC sp_DeleteHopDong 'HD05';


