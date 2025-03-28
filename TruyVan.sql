USE QLBANHANGTAISIEUTHI
--Truy van co ban
SELECT * FROM KhachHang;

INSERT INTO HoaDon (HoaDonID, KhachHangID, NgayMua, TongTien)
VALUES (8, 1, '2025-03-01', 500.000);

UPDATE SanPham SET Gia = 27000 WHERE SanPhamID = 1;

DELETE FROM HoaDon WHERE HoaDonID = 8;

--Truy van nang cao
-- 1. Danh sách hóa ??n kèm thông tin khách hàng
SELECT HoaDon.HoaDonID, KhachHang.TenKhachHang, HoaDon.NgayMua, HoaDon.TongTien
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.KhachHangID = KhachHang.KhachHangID;

-- 2. T?ng ti?n mua hàng c?a t?ng khách hàng
SELECT KhachHang.TenKhachHang, SUM(HoaDon.TongTien) AS TongTienMua
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.KhachHangID = KhachHang.KhachHangID
GROUP BY KhachHang.TenKhachHang;

-- 3. Khách hàng có t?ng ti?n mua hàng trên 500,000
SELECT KhachHang.TenKhachHang, SUM(HoaDon.TongTien) AS TongTienMua
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.KhachHangID = KhachHang.KhachHangID
GROUP BY KhachHang.TenKhachHang
HAVING SUM(HoaDon.TongTien) > 500.000;