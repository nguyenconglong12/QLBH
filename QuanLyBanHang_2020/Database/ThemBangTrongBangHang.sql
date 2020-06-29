--Tổ chức database cho chức năng nhập,bán hàng
IF OBJECT_ID('DonViTinh')IS NOT NULL
BEGIN
    DROP TABLE DonViTinh
END
GO
CREATE TABLE DonViTinh
(
	MaDVT INT IDENTITY(1,1) PRIMARY KEY,
	TenDVT NVARCHAR(20) NOT NULL,
	MoTa NVARCHAR(200),
	IsDelete BIT NOT NULL DEFAULT(0)
)
GO
IF OBJECT_ID('NhaCungCap')IS NOT NULL
BEGIN
    DROP TABLE NhaCungCap
END
GO
CREATE TABLE NhaCungCap
(
	MaNCC INT IDENTITY(1,1) PRIMARY KEY ,
	TenNCC NVARCHAR(50)NOT NULL,
	DiaChi NVARCHAR(100),
	DienThoai VARCHAR(13),
	IsDelete BIT NOT NULL DEFAULT(0)
)
GO
IF OBJECT_ID('LoaiSanPham')IS NOT NULL
BEGIN
    DROP TABLE LoaiSanPham
END
GO
CREATE TABLE LoaiSanPham
(
	MaLoaiSP INT IDENTITY(1,1) PRIMARY KEY,
	TenLoaiSP NVARCHAR(50)NOT NULL,
	IsDelete BIT NOT NULL DEFAULT(0)
)
GO
IF OBJECT_ID('SanPham')IS NOT NULL
BEGIN
    DROP TABLE SanPham
END
GO
CREATE TABLE SanPham
(
	MaSanPham INT IDENTITY(1,1) PRIMARY KEY,
	TenSanPham NVARCHAR(50) NOT NULL,
	MoTa NVARCHAR(200),
	MaVach VARCHAR(20),
	MaLoaiSP INT NOT NULL,
	MaDVT INT NOT NULL,
	MaNCC INT NOT NULL,
	GiaBinhQuan BIGINT,
	SoTon BIGINT,
	CONSTRAINT fk_DVT FOREIGN KEY(MaDVT) REFERENCES dbo.DonViTinh(MaDVT),
CONSTRAINT fk_NCC FOREIGN KEY(MaNCC)REFERENCES dbo.NhaCungCap(MaNCC),
CONSTRAINT fk_LoaiSP FOREIGN KEY(MaLoaiSP)REFERENCES dbo.LoaiSanPham(MaLoaiSP)	
)
GO
IF OBJECT_ID('PhieuNhap')IS NOT NULL
BEGIN
    DROP TABLE PhieuNhap
END
GO
CREATE TABLE PhieuNhap
(
	MaPhieuNhap CHAR(12) PRIMARY KEY,--PN2003010001'
	NgayNhap DATETIME,
	MaNV INT NOT NULL,
	CONSTRAINT fk_NhanVien FOREIGN KEY(MaNV) REFERENCES dbo.NhanVien(MaNV)		 
)
GO
IF OBJECT_ID('ChiTietPhieuNhap')IS NOT NULL
BEGIN
    DROP TABLE ChiTietPhieuNhap
END
GO
CREATE TABLE ChiTietPhieuNhap
    (
      MaPhieuNhap CHAR(12) ,
      MaSanPham INT ,
      SoLuongNhap BIGINT NOT NULL
                         DEFAULT ( 0 ) ,
      DonGiaNhap BIGINT NOT NULL
                        DEFAULT ( 0 ) ,
      SoLuonNhapTon BIGINT NOT NULL
                           DEFAULT ( 0 ) ,
      CONSTRAINT pk_ChiTietNhap PRIMARY KEY ( MaPhieuNhap, MaSanPham ) ,
      CONSTRAINT fk_PhieuNhap FOREIGN KEY ( MaPhieuNhap ) REFERENCES dbo.PhieuNhap ( MaPhieuNhap ) ,
      CONSTRAINT fk_SanPham1 FOREIGN KEY ( MaSanPham ) REFERENCES dbo.SanPham ( MaSanPham )
    );
    
    GO
  GO
IF OBJECT_ID('HoaDon')IS NOT NULL
BEGIN
    DROP TABLE HoaDon
END
GO  
CREATE TABLE HoaDon
(
	MaHoaDon CHAR(12) PRIMARY KEY ,
	MaNV INT NOT NULL	,
	NgayNhap DATETIME,
	GiamGia BIGINT,
	TongThanhTien BIGINT,
	CONSTRAINT fk_NhanVien FOREIGN KEY(MaNV) REFERENCES dbo.NhanVien(MaNV)
)
GO
IF OBJECT_ID('ChiTietHoaDon')IS NOT NULL
BEGIN
    DROP TABLE ChiTietHoaDon
END
GO 
CREATE TABLE ChiTietHoaDon
(
	MaHoaDon CHAR(12),
	MaSanPham INT ,
	SoLuongBan BIGINT  NOT NULL DEFAULT(0),
	DonGiaBan BIGINT  NOT NULL DEFAULT(0),
	GiamGia BIGINT  NOT NULL DEFAULT(0),
	ThanhTienBan BIGINT NOT NULL DEFAULT(0),
 CONSTRAINT pk_ChiTietHoaDon PRIMARY KEY ( MaHoaDon, MaSanPham ) ,
      CONSTRAINT fk_HoaDon FOREIGN KEY ( MaHoaDon ) REFERENCES dbo.HoaDon ( MaHoaDon ) ,
      CONSTRAINT fk_SanPham FOREIGN KEY ( MaSanPham ) REFERENCES dbo.SanPham ( MaSanPham )
    );