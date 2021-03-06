USE [BanHang2020]
GO
/****** Object:  StoredProcedure [dbo].[PSP_NhapHang_HienThiDanhSachNhapHang]    Script Date: 04/27/2020 08:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[PSP_NhapHang_HienThiDanhSachNhapHang] 
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
            g.TenNCC,d.MaNCC,GiaBanHienHanh
    FROM    dbo.PhieuNhap a
            JOIN dbo.ChiTietPhieuNhap b ON b.MaPhieuNhap = a.MaPhieuNhap
            JOIN dbo.NhanVien c ON c.MaNV = a.MaNV
            JOIN dbo.SanPham d ON d.MaSanPham = b.MaSanPham
            JOIN dbo.DonViTinh e ON e.MaDVT = d.MaDVT
            JOIN dbo.LoaiSanPham f ON f.MaLoaiSP = d.MaLoaiSP JOIN dbo.NhaCungCap g ON g.MaNCC = d.MaNCC 
            JOIN GiaBan h ON h.MaSanPham=d.MaSanPham
    WHERE   c.IsDelete = 0
            AND e.IsDelete = 0
            AND f.IsDelete = 0
            and @MaPhieuNhap =case @MaPhieuNhap when  '0' then '0' else a.MaPhieuNhap end;