--View

CREATE VIEW v_DanhSachKhachHang AS
SELECT KhachHangID, TenKhachHang, SoDienThoai, Email, DiaChi
FROM KhachHang;

SELECT * FROM v_DanhSachKhachHang;

CREATE VIEW v_TongSoLuongTon AS
SELECT LoaiSanPham, SUM(SoLuongTon) AS TongSoLuong
FROM SanPham
GROUP BY LoaiSanPham;

SELECT * FROM v_TongSoLuongTon;

CREATE VIEW v_HoaDonVIP AS
SELECT hd.HoaDonID, kh.TenKhachHang, hd.NgayMua, hd.TongTien
FROM HoaDon hd
JOIN KhachHang kh ON hd.KhachHangID = kh.KhachHangID
WHERE kh.LoaiKhachHang = 'VIP';

SELECT * FROM v_HoaDonVIP;

CREATE VIEW v_DanhSachNhanVien AS
SELECT NhanVienID, TenNhanVien, ChucVu FROM NhanVien;

SELECT * FROM v_DanhSachNhanVien;

CREATE VIEW v_ThongKeDoanhThu AS
SELECT KhachHangID, SUM(TongTien) AS DoanhThu FROM HoaDon GROUP BY KhachHangID;

SELECT * FROM v_ThongKeDoanhThu;

CREATE VIEW v_SanPhamBanChay AS
SELECT TOP 5 SanPhamID, SUM(SoLuong) AS TongSoLuong FROM ChiTietHoaDon GROUP BY SanPhamID ORDER BY TongSoLuong DESC;

SELECT * FROM v_SanPhamBanChay;

CREATE VIEW v_HoaDonChiTiet AS
SELECT hd.HoaDonID, hd.NgayMua, kh.TenKhachHang, ct.SanPhamID, ct.SoLuong, ct.GiaBan 
FROM HoaDon hd JOIN ChiTietHoaDon ct ON hd.HoaDonID = ct.HoaDonID
JOIN KhachHang kh ON hd.KhachHangID = kh.KhachHangID;

SELECT * FROM v_HoaDonChiTiet;

--INDEX
CREATE INDEX idx_KhachHangID ON KhachHang(KhachHangID);

CREATE INDEX idx_SanPhamID ON SanPham(SanPhamID);

CREATE INDEX idx_NgayMua ON HoaDon(NgayMua);

CREATE INDEX idx_KhachHangID ON HoaDon(KhachHangID);

CREATE INDEX idx_GiaBan ON ChiTietHoaDon(GiaBan);

CREATE INDEX idx_TongTien ON HoaDon(TongTien);

CREATE INDEX idx_LoaiSanPham ON SanPham(LoaiSanPham);

EXEC sp_helpindex 'KhachHang';
EXEC sp_helpindex 'SanPham';
EXEC sp_helpindex 'HoaDon';
EXEC sp_helpindex 'ChiTietHoaDon';
--Stored Procedure
--Stored Procedure ??n gi?n (không tham s?) - L?y danh sách s?n ph?m:
CREATE PROCEDURE sp_LayDanhSachSanPham
AS
BEGIN
    SELECT * FROM SanPham;
END;

EXEC sp_LayDanhSachSanPham;
--Stored Procedure có tham s? - L?y thông tin khách hàng theo ID:
CREATE PROCEDURE sp_LayThongTinKhachHang @KhachHangID INT
AS
BEGIN
    SELECT * FROM KhachHang WHERE KhachHangID = @KhachHangID;
END;

EXEC sp_LayThongTinKhachHang @KhachHangID = 1;

--Stored Procedure có OUTPUT - Tính t?ng ti?n hóa ??n c?a khách hàng:
CREATE PROCEDURE sp_TinhTongTienHoaDon
    @KhachHangID INT,
    @TongTien FLOAT OUTPUT
AS
BEGIN
    SELECT @TongTien = SUM(TongTien) FROM HoaDon WHERE KhachHangID = @KhachHangID;
END;

DECLARE @TongTien FLOAT;
EXEC sp_TinhTongTienHoaDon @KhachHangID = 1, @TongTien = @TongTien OUTPUT;
SELECT @TongTien AS TongTien;

CREATE PROCEDURE sp_LayHoaDonTheoNgay @Ngay DATE
AS
BEGIN
    SELECT * FROM HoaDon WHERE NgayMua = @Ngay;
END;

EXEC sp_LayHoaDonTheoNgay @Ngay = '2024-03-17';

CREATE PROCEDURE sp_LaySanPhamTonKhoThap @SoLuong INT
AS
BEGIN
    SELECT * FROM SanPham WHERE SoLuongTon < @SoLuong;
END;

EXEC sp_LaySanPhamTonKhoThap @SoLuong = 10;

CREATE PROCEDURE sp_CapNhatGiaSanPham @SanPhamID INT, @GiaMoi FLOAT
AS
BEGIN
    UPDATE SanPham SET Gia = @GiaMoi WHERE SanPhamID = @SanPhamID;
END;

EXEC sp_CapNhatGiaSanPham @SanPhamID = 1, @GiaMoi = 500000;

CREATE PROCEDURE sp_XoaKhachHang @KhachHangID INT
AS
BEGIN
    DELETE FROM KhachHang WHERE KhachHangID = @KhachHangID;
END;

EXEC sp_XoaKhachHang @KhachHangID = 5;

CREATE PROCEDURE sp_LayDanhSachKhachHang
AS
BEGIN
    SELECT * FROM KhachHang;
END;


CREATE PROCEDURE sp_CapNhatSoLuongTon @SanPhamID INT, @SoLuong INT
AS
BEGIN
    UPDATE SanPham SET SoLuongTon = @SoLuong WHERE SanPhamID = @SanPhamID;
END;

EXEC sp_CapNhatSoLuongTon @SanPhamID = 2, @SoLuong = 100;

CREATE PROCEDURE sp_LayDanhSachHoaDon
AS
BEGIN
    SELECT * FROM HoaDon;
END;


CREATE PROCEDURE sp_TinhTongDoanhThu
AS
BEGIN
    SELECT SUM(TongTien) AS TongDoanhThu FROM HoaDon;
END;

EXEC sp_TinhTongDoanhThu;

--Function

--Function tr? v? ki?u vô h??ng - L?y t?ng s? ??n hàng c?a khách hàng:
CREATE FUNCTION fn_TongDonHang (@KhachHangID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Tong INT;
    SELECT @Tong = COUNT(*) FROM HoaDon WHERE KhachHangID = @KhachHangID;
    RETURN @Tong;
END;

SELECT dbo.fn_TongDonHang(1) AS TongDonHang;

--Function tr? v? b?ng - Danh sách hóa ??n theo khách hàng:
CREATE FUNCTION fn_HoaDonTheoKhachHang (@KhachHangID INT)
RETURNS TABLE
AS
RETURN (
    SELECT HoaDonID, NgayMua, TongTien
    FROM HoaDon
    WHERE KhachHangID = @KhachHangID
);

SELECT * FROM dbo.fn_HoaDonTheoKhachHang(1);

CREATE FUNCTION fn_TongHoaDonKhachHang (@KhachHangID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Tong FLOAT;
    SELECT @Tong = SUM(TongTien) FROM HoaDon WHERE KhachHangID = @KhachHangID;
    RETURN @Tong;
END;

SELECT dbo.fn_TongHoaDonKhachHang(1) AS TongTienKhachHang;

CREATE FUNCTION fn_TinhTrungBinhGiaSanPham ()
RETURNS FLOAT
AS
BEGIN
    DECLARE @TrungBinh FLOAT;
    SELECT @TrungBinh = AVG(Gia) FROM SanPham;
    RETURN @TrungBinh;
END;

SELECT dbo.fn_TinhTrungBinhGiaSanPham() AS TrungBinhGiaSanPham;

CREATE FUNCTION fn_DemSoHoaDonKhachHang (@KhachHangID INT)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT;
    SELECT @SoLuong = COUNT(*) FROM HoaDon WHERE KhachHangID = @KhachHangID;
    RETURN @SoLuong;
END;

SELECT dbo.fn_DemSoHoaDonKhachHang(1) AS SoHoaDon;

CREATE FUNCTION fn_SoLuongTonTheoLoai (@LoaiSanPham VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @TongSoLuong INT;
    SELECT @TongSoLuong = SUM(SoLuongTon) FROM SanPham WHERE LoaiSanPham = @LoaiSanPham;
    RETURN @TongSoLuong;
END;

SELECT dbo.fn_SoLuongTonTheoLoai('Dien thoai') AS TongSoLuongTon;

CREATE FUNCTION fn_LayTenSanPham (@SanPhamID INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @TenSanPham VARCHAR(100);
    SELECT @TenSanPham = TenSanPham FROM SanPham WHERE SanPhamID = @SanPhamID;
    RETURN @TenSanPham;
END;

SELECT dbo.fn_LayTenSanPham(3) AS TenSanPham;

CREATE FUNCTION fn_TinhTongTienHoaDon (@HoaDonID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TongTien FLOAT;
    SELECT @TongTien = SUM(GiaBan * SoLuong) FROM ChiTietHoaDon WHERE HoaDonID = @HoaDonID;
    RETURN @TongTien;
END;

SELECT dbo.fn_TinhTongTienHoaDon(2) AS TongTienHoaDon;

CREATE FUNCTION fn_TinhTongSoLuongSanPham ()
RETURNS INT
AS
BEGIN
    DECLARE @Tong INT;
    SELECT @Tong = SUM(SoLuongTon) FROM SanPham;
    RETURN @Tong;
END;

SELECT dbo.fn_TinhTongSoLuongSanPham() AS TongSanPhamTon;

CREATE FUNCTION fn_TongSoKhachHang ()
RETURNS INT
AS
BEGIN
    DECLARE @SoKhachHang INT;
    SELECT @SoKhachHang = COUNT(*) FROM KhachHang;
    RETURN @SoKhachHang;
END;

SELECT dbo.fn_TongSoKhachHang() AS TongKhachHang;

--Trigger
--Trigger ki?m tra khi thêm s?n ph?m, không cho phép s? l??ng t?n nh? h?n 0:
CREATE TRIGGER trg_KiemTraSoLuongTon
ON SanPham
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuongTon < 0)
    BEGIN
        RAISERROR ('So luong ton khong the nho hon 0', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

INSERT INTO SanPham (SanPhamID, TenSanPham, SoLuongTon) VALUES (10, 'Laptop', -5);

--Trigger t? ??ng c?p nh?t s? l?n s? d?ng th? VIP khi khách hàng thanh toán:
CREATE TRIGGER trg_CapNhatSoLanSuDungTheVIP
ON HoaDon
AFTER INSERT
AS
BEGIN
    UPDATE TheVIP
    SET SoLanSuDung = SoLanSuDung - 1
    FROM TheVIP t
    JOIN inserted i ON t.KhachHangID = i.KhachHangID
    WHERE SoLanSuDung > 0;
END;



CREATE TRIGGER trg_CapNhatTonKhoSauMua
ON ChiTietHoaDon
AFTER INSERT
AS
BEGIN
    UPDATE SanPham
    SET SoLuongTon = SoLuongTon - i.SoLuong
    FROM SanPham sp
    JOIN inserted i ON sp.SanPhamID = i.SanPhamID;
END;

CREATE TRIGGER trg_KiemTraGiaBan
ON SanPham
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Gia < 0)
    BEGIN
        RAISERROR ('Gia san pham khong duoc am!', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

UPDATE SanPham SET Gia = -1000 WHERE SanPhamID = 1;

CREATE TRIGGER trg_CapNhatNgayMuaHoaDon
ON HoaDon
AFTER INSERT
AS
BEGIN
    UPDATE HoaDon
    SET NgayMua = GETDATE()
    FROM HoaDon h
    JOIN inserted i ON h.HoaDonID = i.HoaDonID;
END;

INSERT INTO HoaDon (HoaDonID, KhachHangID, NgayMua, TongTien) VALUES (8, 7, NULL, 500000);

CREATE TRIGGER trg_CanhBaoSanPhamHetHang
ON SanPham
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuongTon = 0)
    BEGIN
        PRINT N'Cảnh báo: Một sản phẩm đã hết hàng!';
    END;
END;

UPDATE SanPham SET SoLuongTon = 0 WHERE SanPhamID = 2;

CREATE TRIGGER trg_CanhBaoTonKhoCao
ON SanPham
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuongTon > 1000)
    BEGIN
        PRINT N'Cảnh báo: Số lượng tồn kho vượt quá 1000!';
    END;
END;

UPDATE SanPham SET SoLuongTon = 1500 WHERE SanPhamID = 3;
