USE CTYMAILINH;
GO

--1.Truy vấn select
--Lấy danh sách tất cả khách hàng
SELECT * FROM KHACH;
--Lấy thông tin tất cả hợp đồng thuê có số lượng xe lớn hơn 2
SELECT * FROM HOPDONGTHUE WHERE SoLuongXe > 2;
--Lấy danh sách các loại xe có hơn 10 chỗ ngồi
SELECT * FROM LOAIXE WHERE SoCho > 10;
--Lấy thông tin các tuyến có quãng đường lớn hơn 150 km
SELECT * FROM TUYEN WHERE QuangDuong > 150;
--Lấy thông tin khách hàng có số điện thoại bắt đầu bằng '09'
SELECT * FROM KHACH WHERE DienThoai LIKE '09%';

--2.Truy vấn Insert
--. Thêm một khách hàng mới
INSERT INTO KHACH (MaKhach, TenKhach, DienThoai) 
VALUES ('KH11', 'Công ty QKA', '0999888777');
--. Thêm một loại xe mới vào bảng LOAIXE
INSERT INTO LOAIXE (MaLoai, SoCho) 
VALUES ('L11', 50);
--. Thêm một tuyến đường mới vào bảng TUYEN
INSERT INTO TUYEN (MaTuyen, DiemDen, QuangDuong) 
VALUES ('T11', 'KonTum', 200);
--. Thêm một xe mới vào bảng XE
INSERT INTO XE (MaXe, HangXe, BienSoXe, MaLoai) 
VALUES ('X11', 'Limouse', '36G-5432', 'L02');
--. Thêm một hợp đồng thuê xe mới
INSERT INTO HOPDONGTHUE (SoHD, MaKhach, MaTuyen, MaLoai, SoLuongXe, NgayDi, NgayVe) 
VALUES ('HD11', 'KH02', 'T04', 'L02', 2, '2025-06-12', '2025-06-17');

--3.Truy vấn Uppdate
--Cập nhật số điện thoại của khách hàng KH03
UPDATE KHACH SET DienThoai = '03737909570' WHERE MaKhach = 'KH03';

--Cập nhật giá thuê xe của loại xe L05 trên tuyến T03 lên 1.700.000
UPDATE GIATHUE SET GiaThue = 1700000 WHERE MaLoai = 'L05' AND MaTuyen = 'T03';

--Cập nhật số lượng xe của loại L01 thành 12 xe
UPDATE XE SET SoLuong = 12 WHERE MaLoai = 'L01';

--Cập nhật quãng đường của tuyến T02 thành 120km
UPDATE TUYEN SET QuangDuong = 120 WHERE MaTuyen = 'T02';

--Cập nhật tên khách hàng KH04 thành "Công ty ABC XYZ"
UPDATE KHACH SET TenKhach = 'Công ty ABC XYZ' WHERE MaKhach = 'KH04';

--Tạo thêm cột SoLuong cho bảng Xe và cập nhật số lượng vào từng MaLoaiXe
ALTER TABLE Xe ADD SoLuong INT NOT NULL DEFAULT 1;
UPDATE Xe SET SoLuong = 10 WHERE MaLoai = 'L01';
UPDATE Xe SET SoLuong = 8 WHERE MaLoai = 'L02';
UPDATE Xe SET SoLuong = 5 WHERE MaLoai = 'L03';
UPDATE Xe SET SoLuong = 3 WHERE MaLoai = 'L04';
UPDATE Xe SET SoLuong = 2 WHERE MaLoai = 'L05';
UPDATE Xe SET SoLuong = 7 WHERE MaLoai = 'L06';
UPDATE Xe SET SoLuong = 6 WHERE MaLoai = 'L07';
UPDATE Xe SET SoLuong = 4 WHERE MaLoai = 'L08';
UPDATE Xe SET SoLuong = 5 WHERE MaLoai = 'L09';
UPDATE Xe SET SoLuong = 9 WHERE MaLoai = 'L10';


--4.Truy vấn delete
--Xóa một xe cụ thể không có trong hợp đồng thuê
DELETE FROM XE 
WHERE MaXe = 'X10';

DELETE FROM XE 
WHERE MaXe = 'X11';

DELETE FROM XE 
WHERE MaXe = 'X09';
--Xóa giá thuê của một tuyến cụ thể
DELETE FROM GIATHUE 
WHERE MaLoai = 'L08' AND MaTuyen = 'T08';

DELETE FROM GIATHUE 
WHERE MaLoai = 'L02' AND MaTuyen = 'T05';

--Truy vấn nâng cao
--Liệt kê danh sách hợp đồng thuê xe kèm theo thông tin khách hàng
SELECT HD.SoHD, KH.TenKhach, KH.DienThoai, HD.NgayDi, HD.NgayVe
FROM HOPDONGTHUE HD
INNER JOIN KHACH KH ON HD.MaKhach = KH.MaKhach;

--Tính tổng số xe đã thuê theo từng loại xe
SELECT MaLoai, SUM(SoLuongXe) AS TongXeThue
FROM HOPDONGTHUE
GROUP BY MaLoai;

--Tìm các loại xe có tổng số lượt thuê >= 2
SELECT MaLoai, COUNT(*) AS SoLuotThue
FROM HOPDONGTHUE
GROUP BY MaLoai
HAVING COUNT(*) >= 2;

--Tìm khách hàng đã từng thuê xe có giá thuê cao nhất
SELECT KH.MaKhach, KH.TenKhach 
FROM KHACH KH
WHERE KH.MaKhach IN (
    SELECT HD.MaKhach 
    FROM HOPDONGTHUE HD
    INNER JOIN GIATHUE GT ON HD.MaLoai = GT.MaLoai AND HD.MaTuyen = GT.MaTuyen
    WHERE GT.GiaThue = (SELECT MAX(GiaThue) FROM GIATHUE)
);

--Danh sách hợp đồng thuê có số lượng xe lớn hơn trung bình số lượng xe thuê
SELECT * FROM HOPDONGTHUE
WHERE SoLuongXe > (SELECT AVG(SoLuongXe) FROM HOPDONGTHUE);



