USE CTYMAILINH;
GO
-- Thêm loại xe
INSERT INTO LOAIXE (MaLoai, SoCho)
VALUES 
('L01', 4),
('L02', 7),
('L03', 16),
('L04', 30),
('L05', 45),
('L06', 50),
('L07', 60),
('L08', 70),
('L09', 25),
('L10', 12);

-- Thêm xe
INSERT INTO XE (MaXe, HangXe, BienSoXe, MaLoai)
VALUES 
('X01', 'Toyota', '29D-0578', 'L01'),
('X02', 'Hyundai', '30A-1234', 'L02'),
('X03', 'Ford', '31B-5678', 'L03'),
('X04', 'Mercedes', '32C-9876', 'L04'),
('X05', 'Thaco', '33D-5432', 'L05'),
('X06', 'Toyota', '34E-6789', 'L01'),
('X07', 'Hyundai', '35F-2468', 'L02'),
('X08', 'VinFast', '36G-1357', 'L06'),
('X09', 'KIA', '37H-9876', 'L07'),
('X10', 'Honda', '38I-4321', 'L08');


-- Thêm tuyến
INSERT INTO TUYEN (MaTuyen, DiemDen, QuangDuong)
VALUES 
('T01', 'Hạ Long', 150),
('T02', 'Hải Phòng', 100),
('T03', 'Yên Tử', 120),
('T04', 'Sapa', 350),
('T05', 'Ninh Bình', 90),
('T06', 'Đà Nẵng', 800),
('T07', 'Nha Trang', 900),
('T08', 'Đà Lạt', 950),
('T09', 'Vũng Tàu', 1200),
('T10', 'Cần Thơ', 1350);
-- Thêm khách hàng
INSERT INTO KHACH (MaKhach, TenKhach, DienThoai)
VALUES 
('KH01', 'Trường ĐH Thăng Long', '5581234'),
('KH02', 'Công ty ABC', '1234567'),
('KH03', 'Nguyễn Văn A', '0987654321'),
('KH04', 'Công ty XYZ', '2345678'),
('KH05', 'Trường ĐH Bách Khoa', '5678901'),
('KH06', 'Nguyễn Thị B', '0123456789'),
('KH07', 'Công ty DEF', '9876543'),
('KH08', 'Trường ĐH Xây Dựng', '3456789'),
('KH09', 'Lê Văn C', '4567890'),
('KH10', 'Công ty GHI', '5678902');

-- Thêm hợp đồng thuê
INSERT INTO HOPDONGTHUE (SoHD, MaKhach, MaTuyen, MaLoai, SoLuongXe, NgayDi, NgayVe)
VALUES 
('HD01', 'KH01', 'T01', 'L04', 3, '2025-04-30', '2025-05-02'),
('HD02', 'KH02', 'T02', 'L02', 2, '2025-03-15', '2025-03-16'),
('HD03', 'KH03', 'T03', 'L03', 1, '2025-03-20', '2025-03-21'),
('HD04', 'KH04', 'T04', 'L05', 4, '2025-05-10', '2025-05-12'),
('HD05', 'KH05', 'T05', 'L01', 5, '2025-04-05', '2025-04-07'),
('HD06', 'KH06', 'T06', 'L06', 2, '2025-06-10', '2025-06-12'),
('HD07', 'KH07', 'T07', 'L07', 3, '2025-07-15', '2025-07-18'),
('HD08', 'KH08', 'T08', 'L08', 1, '2025-08-20', '2025-08-22'),
('HD09', 'KH09', 'T09', 'L09', 2, '2025-09-25', '2025-09-27'),
('HD10', 'KH10', 'T10', 'L10', 4, '2025-10-30', '2025-11-02');
-- Thêm giá thuê xe
INSERT INTO GIATHUE (MaLoai, MaTuyen, GiaThue)
VALUES 
('L01', 'T01', 850000),
('L02', 'T01', 1000000),
('L03', 'T01', 1300000),
('L04', 'T02', 1200000),
('L05', 'T03', 1500000),
('L01', 'T04', 1800000),
('L02', 'T05', 1100000),
('L06', 'T06', 2000000),
('L07', 'T07', 2200000),
('L08', 'T08', 2500000);
