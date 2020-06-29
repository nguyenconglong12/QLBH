use BanHang2020
go
--Các thủ tục trong buổi học ngày 6-4-2020
if OBJECT_ID('dbo.PSP_NhapHang_NhapChiTietPhieuNhap')is not null
begin
	drop proc dbo.PSP_NhapHang_NhapChiTietPhieuNhap;
end
go
create proc dbo.PSP_NhapHang_NhapChiTietPhieuNhap
@MaSanPham int, 
@TenSanPham nvarchar(50), 
@MoTa nvarchar(200), 
@MaVach varchar(20), 
@MaLoaiSP int, 
@MaDVT int, 
@MaNCC int,
@MaPhieuNhap char(12), 
@SoLuongNhap bigint, 
@DonGiaNhap bigint,
@NgayNhap datetime,
@MaNV int 
as
set xact_abort on
begin tran
declare @MaSanPhamNew int
if exists (select 1 from PhieuNhap where MaPhieuNhap=@MaPhieuNhap)
begin
	if exists ( select 1 from SanPham where MaSanPham=@MaSanPham)
	begin --sản phẩm đã có

	--thêm vào chi tiết phiếu nhập
	insert into ChiTietPhieuNhap(MaPhieuNhap, MaSanPham, SoLuongNhap, DonGiaNhap, SoLuonNhapTon)
	values(@MaPhieuNhap, @MaSanPham, @SoLuongNhap, @DonGiaNhap, @SoLuongNhap)
	
	end
	else --Sản phẩm mới
	begin
	--thêm sản phẩm mới
	insert into SanPham( TenSanPham, MoTa, MaVach, MaLoaiSP, MaDVT, MaNCC, GiaBinhQuan, SoTon)
	values(@TenSanPham, @MoTa, @MaVach, @MaLoaiSP, @MaDVT, @MaNCC,0, 0)
	--Lấy mã sản phẩm lớn nhất
	set @MaSanPhamNew=(select MAX(MaSanPham)from SanPham)	
	--Thêm ChiTietPhieuNhap
	insert into ChiTietPhieuNhap(MaPhieuNhap, MaSanPham, SoLuongNhap, DonGiaNhap, SoLuonNhapTon)
	values(@MaPhieuNhap, @MaSanPhamNew, @SoLuongNhap, @DonGiaNhap, @SoLuongNhap)

-- việc cập dongiabq và slton của sản phẩm sẽ được thực hiện bằng trigger
	
	end
end
else
begin
	--insert phiếu nhập
	insert into PhieuNhap(MaPhieuNhap, NgayNhap, MaNV)
	values(@MaPhieuNhap, @NgayNhap, @MaNV)
	
	if exists ( select 1 from SanPham where MaSanPham=@MaSanPham)
	begin --sản phẩm đã có

	--thêm vào chi tiết phiếu nhập
	insert into ChiTietPhieuNhap(MaPhieuNhap, MaSanPham, SoLuongNhap, DonGiaNhap, SoLuonNhapTon)
	values(@MaPhieuNhap, @MaSanPham, @SoLuongNhap, @DonGiaNhap, @SoLuongNhap)
	
	end
	else --Sản phẩm mới
	begin
	--thêm sản phẩm mới
	insert into SanPham( TenSanPham, MoTa, MaVach, MaLoaiSP, MaDVT, MaNCC, GiaBinhQuan, SoTon)
	values(@TenSanPham, @MoTa, @MaVach, @MaLoaiSP, @MaDVT, @MaNCC,0, 0)
	--Lấy mã sản phẩm lớn nhất
	set @MaSanPhamNew=(select MAX(MaSanPham)from SanPham)	
	--Thêm ChiTietPhieuNhap
	insert into ChiTietPhieuNhap(MaPhieuNhap, MaSanPham, SoLuongNhap, DonGiaNhap, SoLuonNhapTon)
	values(@MaPhieuNhap, @MaSanPhamNew, @SoLuongNhap, @DonGiaNhap, @SoLuongNhap)

-- việc cập dongiabq và slton của sản phẩm sẽ được thực hiện bằng trigger
	
	end
	
end
commit

go
ALTER PROC [dbo].[PSP_NhapHang_HienThiDanhSachNhapHang] --'PN2004040002'
@MaPhieuNhap varchar(12)='0'
AS
    SELECT  ROW_NUMBER() OVER ( ORDER BY ( SELECT   1
                                         ) ) AS STT ,
            a.MaPhieuNhap ,
            NgayNhap ,
            a.MaNV ,
            c.TenNhanVien ,
            b.MaSanPham ,
            d.TenSanPham ,
            d.MaDVT ,
            e.TenDVT ,
            b.SoLuongNhap ,
            b.SoLuonNhapTon AS SoLuongNhapTon ,
            b.DonGiaNhap ,
            b.SoLuongNhap * b.DonGiaNhap AS ThanhTienNhap ,
            d.MaLoaiSP ,
            f.TenLoaiSP,
            g.TenNCC,d.MaNCC
    FROM    dbo.PhieuNhap a
            JOIN dbo.ChiTietPhieuNhap b ON b.MaPhieuNhap = a.MaPhieuNhap
            JOIN dbo.NhanVien c ON c.MaNV = a.MaNV
            JOIN dbo.SanPham d ON d.MaSanPham = b.MaSanPham
            JOIN dbo.DonViTinh e ON e.MaDVT = d.MaDVT
            JOIN dbo.LoaiSanPham f ON f.MaLoaiSP = d.MaLoaiSP JOIN dbo.NhaCungCap g ON g.MaNCC = d.MaNCC
    WHERE   c.IsDelete = 0
            AND e.IsDelete = 0
            AND f.IsDelete = 0
            and @MaPhieuNhap =case @MaPhieuNhap when  '0' then '0' else a.MaPhieuNhap end;
            
go		
create TRIGGER [InsertChiTietPhieuNhap]
   ON   [ChiTietPhieuNhap]
   AFTER INSERT
AS 
BEGIN
	DECLARE @DonGiaNhapBinhQuan bigint
	SET @DonGiaNhapBinhQuan=(SELECT AVG(DonGiaNhap) FROM ChiTietPhieuNhap WHERE MaSanPham =(SELECT MaSanPham FROM Inserted))
	
	UPDATE SanPham
	SET SoTon+=(SELECT SoLuongNhap FROM Inserted),
	GiaBinhQuan=@DonGiaNhapBinhQuan
	WHERE MaSanPham=(SELECT MaSanPham FROM Inserted)
END
go
create TRIGGER [UpdateChiTietPhieuNhap]
   ON   [ChiTietPhieuNhap]
   AFTER UPDATE
AS 
BEGIN
DECLARE @DonGiaNhapBinhQuan FLOAT
	SET @DonGiaNhapBinhQuan=(SELECT AVG(DonGiaNhap) FROM ChiTietPhieuNhap WHERE MaSanPham =(SELECT MaSanPham FROM Inserted))

	DECLARE @SoLuongMoi FLOAT
	SET @SoLuongMoi=(SELECT SoLuongNhap FROM Inserted)
	
	DECLARE @SoLuongCu FLOAT
	SET @SoLuongCu=(SELECT SoLuongNhap FROM Deleted)
	
	UPDATE SanPham
	SET SoTon+=@SoLuongMoi-@SoLuongCu,
	GiaBinhQuan=@DonGiaNhapBinhQuan
	WHERE MaSanPham=(SELECT MaSanPham FROM Inserted)
END

go
create TRIGGER [DeleteChiTietPhieuNhap]
   ON   [ChiTietPhieuNhap]
   AFTER DELETE
AS 
BEGIN
DECLARE @DonGiaNhapBinhQuan FLOAT
	SET @DonGiaNhapBinhQuan=(SELECT ISNULL(AVG(DonGiaNhap),0) FROM ChiTietPhieuNhap WHERE MaSanPham =(SELECT MaSanPham FROM Deleted))
	UPDATE SanPham
	SET SoTon-=(SELECT SoLuongNhap FROM Deleted),
	GiaBinhQuan=@DonGiaNhapBinhQuan
	WHERE MaSanPham=(SELECT MaSanPham FROM Deleted)
END
go
if OBJECT_ID('dbo.PSP_NhapHang_SuaChiTietNhap')is not null
begin 
	drop proc dbo.PSP_NhapHang_SuaChiTietNhap;
end
go
create proc dbo.PSP_NhapHang_SuaChiTietNhap
@MaPhieuNhap char(12),
@MaSanPham int,
@SoLuongNhap bigint,
@DonGiaNhap bigint,
@TenSanPham nvarchar(50), 
@MoTa nvarchar(200), 
@MaVach varchar(20), 
@MaLoaiSP int, 
@MaDVT int, 
@MaNCC int
as
set xact_abort on
begin tran
	update SanPham
	set TenSanPham=@TenSanPham,
		MoTa=@MoTa,
		MaVach=@MaVach,
		MaLoaiSP=@MaLoaiSP,
		MaDVT=@MaDVT,
		MaNCC=@MaNCC
	where MaSanPham=@MaSanPham
	
	update ChiTietPhieuNhap
	set  SoLuongNhap=@SoLuongNhap,
		SoLuonNhapTon=@SoLuongNhap,
		DonGiaNhap=@DonGiaNhap
	where MaPhieuNhap=@MaPhieuNhap 
	and MaSanPham=@MaSanPham
commit

go
if OBJECT_ID('dbo.PSP_NhapHang_XoaChiTietNhap')is not null
begin 
	drop proc dbo.PSP_NhapHang_XoaChiTietNhap;
end
go
create proc PSP_NhapHang_XoaChiTietNhap
@MaPhieuNhap char(12),
@MaSanPham int
as
if exists (select 1 from ChiTietPhieuNhap where MaPhieuNhap=@MaPhieuNhap and MaSanPham=@MaSanPham )
begin
	delete ChiTietPhieuNhap
	where MaPhieuNhap=@MaPhieuNhap and MaSanPham=@MaSanPham
		if not exists (select 1 from ChiTietPhieuNhap where MaPhieuNhap=@MaPhieuNhap)
		begin 
			delete PhieuNhap
			where MaPhieuNhap=@MaPhieuNhap
		end
end