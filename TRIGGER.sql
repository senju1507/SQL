USE CTYMAILINH;
GO

/*1.Trigger kiểm tra ngày thuê không nhỏ hơn ngày hiện tại.
Trigger này ngăn chặn việc nhập hợp đồng có ngày đi trước ngày hiện tại.*/
CREATE TRIGGER trg_CheckNgayDi
ON HopDongThue
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted WHERE NgayDi < CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR('Ngày đi không thể nhỏ hơn ngày hiện tại!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

INSERT INTO HopDongThue (SoHD, MaKhach, MaLoai, SoLuongXe, MaTuyen, NgayDi, NgayVe)
VALUES ('HD10', 'KH02', 'L03', 2, 'T05', '2026-01-01', '2026-01-10');  -- Lỗi nếu ngày đi < hôm nay

/*2.Trigger tự động cập nhật số lượng xe sau khi thuê.
Trigger này giảm số lượng xe có sẵn sau khi lập hợp đồng thuê xe.*/
CREATE TRIGGER trg_UpdateSoLuongXe
ON HopDongThue
AFTER INSERT
AS
BEGIN
    UPDATE Xe
    SET Xe.SoLuong = Xe.SoLuong - i.SoLuongXe
    FROM Xe
    INNER JOIN inserted i ON Xe.MaLoai = i.MaLoai;
END;


INSERT INTO HopDongThue (SoHD, MaKhach, MaLoai, SoLuongXe, MaTuyen, NgayDi, NgayVe)
VALUES ('HD11', 'KH05', 'L02', 1, 'T05', '2025-05-01', '2025-05-10');

SELECT * FROM Xe WHERE MaLoai = 'L02';  -- Kiểm tra số lượng xe có giảm hay không
/*3.rigger không cho xóa khách hàng khi còn hợp đồng thuê
Trigger này ngăn chặn việc xóa khách hàng nếu họ còn hợp đồng thuê xe.*/
CREATE TRIGGER trg_CheckKhachHangBeforeDelete
ON Khach
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM HopDongThue WHERE MaKhach IN (SELECT MaKhach FROM deleted)
    )
    BEGIN
        RAISERROR('Không thể xóa khách hàng vì còn hợp đồng thuê xe!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM Khach WHERE MaKhach IN (SELECT MaKhach FROM deleted);
    END
END;


DELETE FROM Khach WHERE MaKhach = 'KH01';  -- Lỗi nếu KH01 có hợp đồng
/*4.Trigger kiểm soát số lượng xe thuê không vượt quá số lượng có sẵn
Trigger này đảm bảo không thể thuê nhiều xe hơn số lượng có sẵn trong kho.*/
CREATE TRIGGER trg_CheckSoLuongXeThue
ON HopDongThue
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Xe x ON i.MaLoai = x.MaLoai
        WHERE i.SoLuongXe > x.SoLuong
    )
    BEGIN
        RAISERROR('Số lượng xe thuê vượt quá số lượng có sẵn!', 16, 1);
        
    END
END;


INSERT INTO HopDongThue (SoHD, MaKhach, MaLoai, SoLuongXe, MaTuyen, NgayDi, NgayVe)
VALUES ('HD12', 'KH03', 'L01', 20, 'T04', '2025-06-01', '2025-06-05'); -- Lỗi nếu số lượng > số lượng xe có sẵn
/* 5.Trigger tự động ghi log khi có hợp đồng mới
Trigger này ghi lại thông tin hợp đồng mới vào bảng LogHopDong.*/
CREATE TABLE LogHopDong (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    SoHD NVARCHAR(10),
    MaKhach NVARCHAR(10),
    NgayTao DATETIME DEFAULT GETDATE(),
    HanhDong NVARCHAR(50)
);
GO 
CREATE TRIGGER trg_LogHopDong
ON HopDongThue
AFTER INSERT
AS
BEGIN
    INSERT INTO LogHopDong (SoHD, MaKhach, HanhDong)
    SELECT SoHD, MaKhach, 'Tạo hợp đồng mới' FROM inserted;
END;

INSERT INTO HopDongThue (SoHD, MaKhach, MaLoai, SoLuongXe, MaTuyen, NgayDi, NgayVe)
VALUES ('HD4', 'KH05', 'L04', 2, 'T03', '2025-07-01', '2025-07-10');

SELECT * FROM LogHopDong;  -- Kiểm tra log có ghi nhận hợp đồng mới không
