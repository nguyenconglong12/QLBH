IF OBJECT_ID('dbo.PSP_NhanVien_Delete')IS NOT NULL
BEGIN
	DROP PROC dbo.PSP_NhanVien_Delete
END
GO
CREATE PROC PSP_NhanVien_Delete
@MaNV INT 
AS
DELETE dbo.NhanVien
WHERE MaNV=@MaNV
GO
--Thu tuc xóa theo các cập nhật dữ liệu cho thuộc tính IsDelete
IF OBJECT_ID('dbo.PSP_NhanVien_DeleteUpdateIsDelete')IS NOT NULL
BEGIN
	DROP PROC dbo.PSP_NhanVien_DeleteUpdateIsDelete
END
GO
CREATE PROC PSP_NhanVien_DeleteUpdateIsDelete
@MaNV INT 
AS
UPDATE dbo.NhanVien
SET IsDelete=1
WHERE MaNV=@MaNV
GO

IF OBJECT_ID('dbo.PSP_SaoLuuDuLieu')IS NOT NULL
BEGIN
	DROP PROC dbo.PSP_SaoLuuDuLieu
END
GO
CREATE proc [dbo].[PSP_SaoLuuDuLieu]
	@duongdan nvarchar(max)
as
begin
	declare @dbname nvarchar(50)
	set @dbname =  DB_NAME()
	BACKUP DATABASE @dbname
	TO  DISK = @duongdan
	WITH NOFORMAT, NOINIT,  
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	select ErrorCode = 1
END

GO
IF OBJECT_ID('dbo.PSP_NhanVien_DoiMatKhau')IS NOT NULL
BEGIN
	DROP PROC dbo.PSP_NhanVien_DoiMatKhau
END
GO
CREATE PROC PSP_NhanVien_DoiMatKhau
@MaNhanVien INT,
@MatKhau VARCHAR(30)
AS
UPDATE dbo.NhanVien
SET MatKhau=pwdEncrypt(@MatKhau)
WHERE MaNV=@MaNhanVien
GO
IF OBJECT_ID('dbo.PSP_NhanVien_ResetMatKhau')IS NOT NULL
BEGIN
	DROP PROC dbo.PSP_NhanVien_ResetMatKhau
END
GO
CREATE PROC PSP_NhanVien_ResetMatKhau
@MaNhanVien INT
AS
UPDATE dbo.NhanVien
SET MatKhau=pwdEncrypt(TenDangNhap)
WHERE MaNV=@MaNhanVien
go
IF OBJECT_ID('dbo.PSP_NhanVien_LayDuLieuCombo')IS NOT NULL
BEGIN
	DROP PROC dbo.PSP_NhanVien_LayDuLieuCombo
END
GO
CREATE PROC PSP_NhanVien_LayDuLieuCombo
AS
SELECT MaNV,TenNhanVien
FROM dbo.NhanVien
WHERE IsDelete=0