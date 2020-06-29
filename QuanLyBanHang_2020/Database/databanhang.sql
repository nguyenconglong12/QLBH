USE	BanHang2020
GO
IF OBJECT_ID('TaiKhoan') IS NOT NULL
BEGIN
    DROP TABLE TaiKhoan;
END
GO
CREATE TABLE TaiKhoan(MaTaiKhoan INT IDENTITY(1,1) PRIMARY KEY,
TenTaiKhoan NVARCHAR(30),
IsDelete BIT NOT NULL DEFAULT(0))
go
IF OBJECT_ID('NhanVien') IS NOT NULL
BEGIN
    DROP TABLE NhanVien;
END
GO
CREATE TABLE NhanVien(MaNV INT IDENTITY(1,1) PRIMARY KEY,
TenNhanVien NVARCHAR(50) NOT NULL,
NgaySinh DATE NULL,
DienThoai VARCHAR(15) NULL,
MaTaiKhoan int NOT NULL,
CONSTRAINT Fk_KhoaTaiKHoan FOREIGN KEY(MaTaiKhoan) REFERENCES dbo.TaiKhoan(MaTaiKhoan))
GO
IF OBJECT_ID('ChucNang') IS NOT NULL
BEGIN
    DROP TABLE ChucNang;
END
GO
CREATE TABLE ChucNang(MaChucNang INT IDENTITY(1,1) PRIMARY KEY,
TenChucNang NVARCHAR(100) NOT NULL,
TenVietTat VARCHAR(100) NOT NULL,
NhomChucNang INT NOT NULL DEFAULT(1), ChucNangCha INT,IsDelete BIT NOT NULL DEFAULT(0))-- có 3 nhóm 1: menu, 2: chức năng trong form,3: những chức năng đặc biệt
GO
IF OBJECT_ID('PhanQuyen') IS NOT NULL
BEGIN
    DROP TABLE PhanQuyen;
END
GO
-- 1: xem; 2: Them; 4: sưa: 8: xóa;
-- total:11; if(total&2=2
CREATE TABLE PhanQuyen(MaChucNang INT ,MaTaiKhoan INT , TongQuyen INT NOT NULL DEFAULT(0) ,IsDelete BIT NOT NULL DEFAULT(0),
CONSTRAINT pk_KhoaChinhPhanQUyen PRIMARY KEY(MaChucNang,MaTaiKhoan))

GO
ALTER TABLE dbo.NhanVien
ADD TenDanNhap VARCHAR(30) NOT NULL
ALTER TABLE dbo.NhanVien
ADD MatKhau varbinary(MAX)
GO
CREATE PROC PSP_NhanVien_KiemTraDangNhap
@TenDangNhap VARCHAR(30),
@MatKhau VARCHAR(30)
AS
IF EXISTS (SELECT 1 FROM dbo.NhanVien WHERE TenDangNhap=@TenDangNhap AND pwdcompare(@MatKhau,MatKhau)=1)
BEGIN
    SELECT 1 AS code,TenNhanVien,MaTaiKhoan FROM dbo.NhanVien
END
ELSE
BEGIN
    SELECT 0 AS code,N''AS TenNhanVien,0 AS MaTaiKhoan
END
GO
INSERT INTO dbo.TaiKhoan
        ( TenTaiKhoan, IsDelete )
VALUES  ( N'admin', -- TenTaiKhoan - nvarchar(30)
          0  -- IsDelete - bit
          )
INSERT INTO dbo.NhanVien
        ( TenNhanVien ,
          NgaySinh ,
          DienThoai ,
          MaTaiKhoan,
          TenDangNhap,
          MatKhau
        )
VALUES  ( N'Admin' , -- TenNhanVien - nvarchar(50)
          GETDATE() , -- NgaySinh - date
          '090987654' , -- DienThoai - varchar(15)
          1,  -- MaTaiKhoan - int
          'admin',
          pwdencrypt('admin')
        )
        
 go
 alter PROC PSP_NhanVien_HienThiDanhSachNhanVien
 AS
 SELECT ROW_NUMBER() over (order by (select 1)) as STT, MaNV, TenNhanVien, NgaySinh, DienThoai, MaTaiKhoan, TenDangNhap, MatKhau
 FROM dbo.NhanVien
 WHERE IsDelete=0
 GO
 CREATE PROC PSP_TaiKhoan_Loadcombo
 AS
 SELECT MaTaiKhoan, TenTaiKhoan
 FROM dbo.TaiKhoan
 WHERE IsDelete=0
 
 GO
 alter PROC PSP_NhanVien_InsertAndUpdate
 @MaNV INT , 
 @TenNhanVien NVARCHAR(50), 
 @NgaySinh DATE, 
 @DienThoai VARCHAR(15), 
 @MaTaiKhoan int, 
 @TenDangNhap VARCHAR(30), 
 @MatKhau VARCHAR(30)
 AS
 IF EXISTS (SELECT 1 FROM dbo.NhanVien WHERE MaNV=@MaNV)
 BEGIN
     UPDATE dbo.NhanVien
     SET TenNhanVien=@TenNhanVien,
		NgaySinh=@NgaySinh,
		DienThoai=@DienThoai,
		MaTaiKhoan=@MaTaiKhoan,
		TenDangNhap=@TenDangNhap
		
	WHERE MaNV=@MaNV
 END
 ELSE
 BEGIN
     INSERT INTO dbo.NhanVien
             ( TenNhanVien ,
               NgaySinh ,
               DienThoai ,
               MaTaiKhoan,
               TenDangNhap,
               MatKhau
             )
     VALUES  ( @TenNhanVien , -- TenNhanVien - nvarchar(50)
               @NgaySinh , -- NgaySinh - date
               @DienThoai , -- DienThoai - varchar(15)
               @MaTaiKhoan , -- MaTaiKhoan - int
               @TenDangNhap,
               PWDENCRYPT(@MatKhau)
             )
 END