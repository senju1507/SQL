USE CTYMAILINH;
GO

-- 1. Danh sách xe và loại xe
CREATE VIEW V_DanhSachXe AS
SELECT X.MaXe, X.HangXe, X.BienSoXe, L.MaLoai, L.SoCho
FROM Xe X
JOIN LoaiXe L ON X.MaLoai = L.MaLoai;
GO

SELECT * FROM V_DanhSachXe;

-- 2. Danh sách khách hàng
CREATE VIEW V_DanhSachKhach AS
SELECT MaKhach, TenKhach, DienThoai FROM Khach;
GO

SELECT * FROM V_DanhSachKhach;

-- 3. Danh sách tuyến đường
CREATE VIEW V_DanhSachTuyen AS
SELECT MaTuyen, DiemDen, QuangDuong FROM Tuyen;
GO

SELECT * FROM V_DanhSachTuyen;

-- 4. Hợp đồng thuê chi tiết
CREATE VIEW V_HopDongChiTiet AS
SELECT H.SoHD, K.TenKhach, T.DiemDen, L.SoCho, H.SoLuongXe, H.NgayDi, H.NgayVe
FROM HopDongThue H
JOIN Khach K ON H.MaKhach = K.MaKhach
JOIN Tuyen T ON H.MaTuyen = T.MaTuyen
JOIN LoaiXe L ON H.MaLoai = L.MaLoai;
GO

SELECT * FROM V_HopDongChiTiet;

-- 5. Danh sách hợp đồng theo khách hàng
CREATE VIEW V_HopDongKhachHang AS
SELECT K.MaKhach, K.TenKhach, H.SoHD, T.DiemDen, H.NgayDi, H.NgayVe
FROM HopDongThue H
JOIN Khach K ON H.MaKhach = K.MaKhach
JOIN Tuyen T ON H.MaTuyen = T.MaTuyen;
GO

SELECT * FROM V_HopDongKhachHang;

-- 6. Danh sách hợp đồng theo tuyến đường
CREATE VIEW V_HopDongTuyen AS
SELECT T.MaTuyen, T.DiemDen, COUNT(H.SoHD) AS SoLuongHopDong
FROM HopDongThue H
JOIN Tuyen T ON H.MaTuyen = T.MaTuyen
GROUP BY T.MaTuyen, T.DiemDen;
GO

SELECT * FROM V_HopDongTuyen;

-- 7. Tổng số lượng xe thuê theo loại xe
CREATE VIEW V_TongXeTheoLoai AS
SELECT L.MaLoai, L.SoCho, SUM(H.SoLuongXe) AS TongXeThue
FROM HopDongThue H
JOIN LoaiXe L ON H.MaLoai = L.MaLoai
GROUP BY L.MaLoai, L.SoCho;
GO

SELECT * FROM V_TongXeTheoLoai;

-- 8. Thông tin giá thuê theo tuyến đường
CREATE VIEW V_GiaThueTuyen AS
SELECT T.DiemDen, L.SoCho, G.GiaThue
FROM GiaThue G
JOIN Tuyen T ON G.MaTuyen = T.MaTuyen
JOIN LoaiXe L ON G.MaLoai = L.MaLoai;
GO

SELECT * FROM V_GiaThueTuyen;

-- 9. Hợp đồng có thời gian dài nhất
CREATE VIEW V_HopDongDaiNhat AS
SELECT SoHD, MaKhach, MaTuyen, MaLoai, SoLuongXe, NgayDi, NgayVe
FROM HOPDONGTHUE;

SELECT TOP 1 * FROM V_HopDongDaiNhat;


-- 10. Danh sách hợp đồng với tổng chi phí thuê xe
CREATE VIEW V_TongChiPhiHopDong AS
SELECT H.SoHD, K.TenKhach, T.DiemDen, SUM(H.SoLuongXe * G.GiaThue) AS TongChiPhi
FROM HopDongThue H
JOIN Khach K ON H.MaKhach = K.MaKhach
JOIN Tuyen T ON H.MaTuyen = T.MaTuyen
JOIN GiaThue G ON H.MaLoai = G.MaLoai AND H.MaTuyen = G.MaTuyen
GROUP BY H.SoHD, K.TenKhach, T.DiemDen;
GO

SELECT * FROM V_TongChiPhiHopDong;
