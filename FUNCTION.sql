USE CTYMAILINH;
GO

--1. Lấy số chỗ của một loại xe
CREATE FUNCTION fn_GetSoChoXe (@MaLoai NVARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @SoCho INT;
    SELECT @SoCho = SoCho FROM LoaiXe WHERE MaLoai = @MaLoai;
    RETURN @SoCho;
END;

SELECT dbo.fn_GetSoChoXe('L03') AS SoCho;
--2. Lấy giá thuê của một loại xe trên tuyến cụ thể
CREATE FUNCTION fn_GetGiaThue (@MaLoai NVARCHAR(10), @MaTuyen NVARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @GiaThue INT;
    SELECT @GiaThue = GiaThue FROM GiaThue WHERE MaLoai = @MaLoai AND MaTuyen = @MaTuyen;
    RETURN @GiaThue;
END;

SELECT dbo.fn_GetGiaThue('L02', 'T05') AS GiaThue;
--3. Tính tổng số lượng xe đã thuê theo hợp đồng
CREATE FUNCTION fn_TongSoLuongXeThue (@SoHD NVARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @TongSoLuong INT;
    SELECT @TongSoLuong = SUM(SoLuongXe) FROM HopDongThue WHERE SoHD = @SoHD;
    RETURN @TongSoLuong;
END;

SELECT dbo.fn_TongSoLuongXeThue('HD02') AS TongSoLuongXe;
--4. Danh sách xe theo hãng xe
CREATE FUNCTION fn_GetXeByHang (@HangXe NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT MaXe, BienSoXe, MaLoai 
    FROM Xe 
    WHERE HangXe = @HangXe
);

SELECT * FROM dbo.fn_GetXeByHang('Toyota');
--5. Danh sách khách hàng theo số điện thoại
CREATE FUNCTION fn_GetKhachByPhone (@DienThoai NVARCHAR(15))
RETURNS TABLE
AS
RETURN
(
    SELECT MaKhach, TenKhach 
    FROM Khach 
    WHERE DienThoai = @DienThoai
);

SELECT * FROM dbo.fn_GetKhachByPhone('0987654321');
--6. Lấy danh sách hợp đồng thuê theo tuyến
CREATE FUNCTION fn_GetHopDongByTuyen (@MaTuyen NVARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT SoHD, MaKhach, MaLoai, SoLuongXe, NgayDi, NgayVe
    FROM HopDongThue
    WHERE MaTuyen = @MaTuyen
);

SELECT * FROM dbo.fn_GetHopDongByTuyen('T02');
--7. Lấy danh sách hợp đồng có ngày đi trong khoảng thời gian
CREATE FUNCTION fn_GetHopDongByNgay (@TuNgay DATE, @DenNgay DATE)
RETURNS @Result TABLE (
    SoHD NVARCHAR(10),
    MaKhach NVARCHAR(10),
    NgayDi DATE,
    NgayVe DATE
)
AS
BEGIN
    INSERT INTO @Result
    SELECT SoHD, MaKhach, NgayDi, NgayVe
    FROM HopDongThue
    WHERE NgayDi BETWEEN @TuNgay AND @DenNgay;
    RETURN;
END;

SELECT * FROM dbo.fn_GetHopDongByNgay('2025-03-01', '2025-03-31');
--8. Lấy danh sách xe của một loại xe cụ thể
CREATE FUNCTION fn_GetXeByLoai (@MaLoai NVARCHAR(10))
RETURNS @Result TABLE (
    MaXe NVARCHAR(10),
    HangXe NVARCHAR(50),
    BienSoXe NVARCHAR(20)
)
AS
BEGIN
    INSERT INTO @Result
    SELECT MaXe, HangXe, BienSoXe FROM Xe WHERE MaLoai = @MaLoai;
    RETURN;
END;

SELECT * FROM dbo.fn_GetXeByLoai('L02');
--9. Lấy danh sách tuyến có quãng đường lớn hơn giá trị nhập vào
CREATE FUNCTION fn_GetTuyenByQuangDuong (@MinQuangDuong INT)
RETURNS @Result TABLE (
    MaTuyen NVARCHAR(10),
    DiemDen NVARCHAR(100),
    QuangDuong INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT MaTuyen, DiemDen, QuangDuong 
    FROM Tuyen 
    WHERE QuangDuong >= @MinQuangDuong;
    RETURN;
END;

SELECT * FROM dbo.fn_GetTuyenByQuangDuong(100);
--10. Lấy danh sách khách hàng có thuê xe từ ngày X trở đi
CREATE FUNCTION fn_GetKhachHangByNgayThue (@NgayThue DATE)
RETURNS @Result TABLE (
    MaKhach NVARCHAR(10),
    TenKhach NVARCHAR(100),
    NgayDi DATE
)
AS
BEGIN
    INSERT INTO @Result
    SELECT DISTINCT k.MaKhach, k.TenKhach, h.NgayDi
    FROM Khach k
    JOIN HopDongThue h ON k.MaKhach = h.MaKhach
    WHERE h.NgayDi >= @NgayThue;
    RETURN;
END;

SELECT * FROM dbo.fn_GetKhachHangByNgayThue('2025-04-01');
