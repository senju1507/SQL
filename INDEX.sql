USE CTYMAILINH;
GO
-- 1. Index duy nhất cho biển số xe (Tăng tốc tìm kiếm xe theo biển số)
CREATE UNIQUE INDEX IX_XE_BienSoXe ON Xe(BienSoXe);

-- 2. Index cho điểm đến trong bảng tuyến (Tối ưu truy vấn theo địa điểm)
CREATE INDEX IX_TUYEN_DiemDen ON Tuyen(DiemDen);

-- 3. Index cho tên khách hàng (Hỗ trợ tìm kiếm khách nhanh hơn)
CREATE INDEX IX_KHACH_TenKhach ON Khach(TenKhach);

-- 4. Index trên MaKhach trong HopDongThue (Nhanh hơn khi tra cứu hợp đồng theo khách hàng)
CREATE INDEX IX_HOPDONGTHUE_MaKhach ON HopDongThue(MaKhach);

-- 5. Index trên MaTuyen trong HopDongThue (Tăng tốc tìm hợp đồng theo tuyến đường)
CREATE INDEX IX_HOPDONGTHUE_MaTuyen ON HopDongThue(MaTuyen);

-- 6. Index trên NgayDi trong HopDongThue (Cải thiện truy vấn hợp đồng theo ngày đi)
CREATE INDEX IX_HOPDONGTHUE_NgayDi ON HopDongThue(NgayDi);

-- 7. Index trên MaLoai trong GiaThue (Giúp lấy giá thuê theo loại xe nhanh hơn)
CREATE INDEX IX_GIATHUE_MaLoai ON GiaThue(MaLoai);

-- 8. Index trên MaTuyen trong GiaThue (Tối ưu truy vấn giá thuê theo tuyến)
CREATE INDEX IX_GIATHUE_MaTuyen ON GiaThue(MaTuyen);

-- 9. Index trên HangXe trong Xe (Nhanh hơn khi lọc xe theo hãng sản xuất)
CREATE INDEX IX_XE_HangXe ON Xe(HangXe);

-- 10. Index kết hợp trên MaLoai và MaTuyen trong GiaThue 
-- (Tối ưu truy vấn liên quan đến cả loại xe và tuyến đường)
CREATE INDEX IX_GIATHUE_MaLoai_MaTuyen ON GiaThue(MaLoai, MaTuyen);
