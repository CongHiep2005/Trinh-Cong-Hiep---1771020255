USE QLBANHANGTAISIEUTHI
--Truy van co ban
SELECT * FROM KhachHang;

INSERT INTO HoaDon (HoaDonID, KhachHangID, NgayMua, TongTien)
VALUES (8, 1, '2025-03-01', 500.000);

UPDATE SanPham SET Gia = 27000 WHERE SanPhamID = 1;

DELETE FROM HoaDon WHERE HoaDonID = 8;

--Truy van nang cao
-- 1. Danh s�ch h�a ??n k�m th�ng tin kh�ch h�ng
SELECT HoaDon.HoaDonID, KhachHang.TenKhachHang, HoaDon.NgayMua, HoaDon.TongTien
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.KhachHangID = KhachHang.KhachHangID;

-- 2. T?ng ti?n mua h�ng c?a t?ng kh�ch h�ng
SELECT KhachHang.TenKhachHang, SUM(HoaDon.TongTien) AS TongTienMua
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.KhachHangID = KhachHang.KhachHangID
GROUP BY KhachHang.TenKhachHang;

-- 3. Kh�ch h�ng c� t?ng ti?n mua h�ng tr�n 500,000
SELECT KhachHang.TenKhachHang, SUM(HoaDon.TongTien) AS TongTienMua
FROM HoaDon
INNER JOIN KhachHang ON HoaDon.KhachHangID = KhachHang.KhachHangID
GROUP BY KhachHang.TenKhachHang
HAVING SUM(HoaDon.TongTien) > 500.000;