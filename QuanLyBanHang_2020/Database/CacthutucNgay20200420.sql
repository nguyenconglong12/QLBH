IF OBJECT_ID('dbo.PSP_NhapHang_XoaPhieuNhap') IS NOT NULL
BEGIN
    DROP PROC dbo.PSP_NhapHang_XoaPhieuNhap;
END
GO 
CREATE PROC PSP_NhapHang_XoaPhieuNhap
@MaPhieuNhap CHAR(12)
AS
SET XACT_ABORT ON
BEGIN TRAN
	DECLARE @MaSanPham INT 
	DECLARE cursor_ChiTietPhieuNhap CURSOR
	FAST_FORWARD
	FOR
		SELECT MaSanPham
		FROM dbo.ChiTietPhieuNhap
		WHERE MaPhieuNhap=@MaPhieuNhap
	OPEN cursor_ChiTietPhieuNhap 
	FETCH NEXT FROM cursor_ChiTietPhieuNhap INTO @MaSanPham
	WHILE @@FETCH_STATUS=0	
	BEGIN
		--Xóa chi tiết phiếu nhập
		DELETE dbo.ChiTietPhieuNhap
		WHERE MaPhieuNhap=@MaPhieuNhap AND MaSanPham=@MaSanPham
	
			
		FETCH NEXT FROM cursor_ChiTietPhieuNhap INTO @MaSanPham
	END 
	CLOSE cursor_ChiTietPhieuNhap
	DEALLOCATE cursor_ChiTietPhieuNhap
	--xóa phiếu nhập
	DELETE dbo.PhieuNhap
	WHERE MaPhieuNhap=@MaPhieuNhap		
COMMIT