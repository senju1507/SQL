USE CTYMAILINH;
GO
-- 1. Index duy nhất cho biển số xe (Tăng tốc tìm kiếm xe theo biển số)
CREATE UNIQUE INDEX IX_XE_BienSoXe ON Xe(BienSoXe);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Xe');
GO
-- 2. Index cho điểm đến trong bảng tuyến (Tối ưu truy vấn theo địa điểm)
CREATE INDEX IX_TUYEN_DiemDen ON Tuyen(DiemDen);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Tuyen');
GO
-- 3. Index cho tên khách hàng (Hỗ trợ tìm kiếm khách nhanh hơn)
CREATE INDEX IX_KHACH_TenKhach ON Khach(TenKhach);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Khach');
GO
-- 4. Index trên MaKhach trong HopDongThue (Nhanh hơn khi tra cứu hợp đồng theo khách hàng)
CREATE INDEX IX_HOPDONGTHUE_MaKhach ON HopDongThue(MaKhach);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('HopDongThue');
GO
-- 5. Index trên MaTuyen trong HopDongThue (Tăng tốc tìm hợp đồng theo tuyến đường)
CREATE INDEX IX_HOPDONGTHUE_MaTuyen ON HopDongThue(MaTuyen);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('HopDongThue');
GO
-- 6. Index trên NgayDi trong HopDongThue (Cải thiện truy vấn hợp đồng theo ngày đi)
CREATE INDEX IX_HOPDONGTHUE_NgayDi ON HopDongThue(NgayDi);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('HopDongThue');
GO
-- 7. Index trên MaLoai trong GiaThue (Giúp lấy giá thuê theo loại xe nhanh hơn)
CREATE INDEX IX_GIATHUE_MaLoai ON GiaThue(MaLoai);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('GiaThue');
GO
-- 8. Index trên MaTuyen trong GiaThue (Tối ưu truy vấn giá thuê theo tuyến)
CREATE INDEX IX_GIATHUE_MaTuyen ON GiaThue(MaTuyen);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('GiaThue');
GO
-- 9. Index trên HangXe trong Xe (Nhanh hơn khi lọc xe theo hãng sản xuất)
CREATE INDEX IX_XE_HangXe ON Xe(HangXe);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Xe');
GO
-- 10. Index kết hợp trên MaLoai và MaTuyen trong GiaThue 
-- (Tối ưu truy vấn liên quan đến cả loại xe và tuyến đường)
CREATE INDEX IX_GIATHUE_MaLoai_MaTuyen ON GiaThue(MaLoai, MaTuyen);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('GiaThue');
GO