IF OBJECT_ID('dbo.PSP_LayTenColumnChiTietNhapHang')IS NOT NULL
BEGIN
    DROP PROC dbo.PSP_LayTenColumnChiTietNhapHang
END
GO 
CREATE PROC PSP_LayTenColumnChiTietNhapHang
as
SELECT DISTINCT a.name
FROM sys.all_columns a JOIN sys.tables b ON a.object_id = b.object_id
WHERE b.name='phieuNhap' OR b.name='ChiTietPhieuNhap' OR b.name='sanpham'