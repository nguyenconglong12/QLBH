IF OBJECT_ID('dbo.PSP_NhapHang_HienThiDanhSachNhapHang') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_NhapHang_HienThiDanhSachNhapHang;
    END;
GO
CREATE PROC dbo.PSP_NhapHang_HienThiDanhSachNhapHang
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
            f.TenLoaiSP ,
            g.TenNCC ,
            d.MaNCC
    FROM    dbo.PhieuNhap a
            JOIN dbo.ChiTietPhieuNhap b ON b.MaPhieuNhap = a.MaPhieuNhap
            JOIN dbo.NhanVien c ON c.MaNV = a.MaNV
            JOIN dbo.SanPham d ON d.MaSanPham = b.MaSanPham
            JOIN dbo.DonViTinh e ON e.MaDVT = d.MaDVT
            JOIN dbo.LoaiSanPham f ON f.MaLoaiSP = d.MaLoaiSP
            JOIN dbo.NhaCungCap g ON g.MaNCC = d.MaNCC
    WHERE   c.IsDelete = 0
            AND e.IsDelete = 0
            AND f.IsDelete = 0;
            
            GO
IF OBJECT_ID('dbo.PSP_NhapHang_LayMaPhieuNhapMax') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_NhapHang_LayMaPhieuNhapMax;
    END;
GO  
CREATE PROC PSP_NhapHang_LayMaPhieuNhapMax -- 4
    @MaNhanVien INT
AS
    SELECT  ISNULL(CONVERT(INT, MAX(SUBSTRING(MaPhieuNhap, 9, 12))), 0) AS IDMax
    FROM    dbo.PhieuNhap --PN2003010001
    WHERE   SUBSTRING(MaPhieuNhap, 3, 2) = SUBSTRING(CONVERT(CHAR(4), YEAR(GETDATE())),
                                                     3, 2)
            AND CONVERT(INT, SUBSTRING(MaPhieuNhap, 5, 2)) = MONTH(GETDATE())
            AND @MaNhanVien = CONVERT(INT, SUBSTRING(MaPhieuNhap, 7, 2));
            GO
            IF OBJECT_ID('dbo.PSP_NhapHang_LayMaPhieuNhapMaxTheoDatetime') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_NhapHang_LayMaPhieuNhapMaxTheoDatetime;
    END;
GO  
CREATE PROC PSP_NhapHang_LayMaPhieuNhapMaxTheoDatetime -- 4
    @MaNhanVien INT,
    @NgayTao date
AS
    SELECT  ISNULL(CONVERT(INT, MAX(SUBSTRING(MaPhieuNhap, 9, 12))), 0) AS IDMax
    FROM    dbo.PhieuNhap --PN2003010001
    WHERE   SUBSTRING(MaPhieuNhap, 3, 2) = SUBSTRING(CONVERT(CHAR(4), YEAR(@NgayTao)),
                                                     3, 2)
            AND CONVERT(INT, SUBSTRING(MaPhieuNhap, 5, 2)) = MONTH(@NgayTao)
            AND @MaNhanVien = CONVERT(INT, SUBSTRING(MaPhieuNhap, 7, 2));    
            
            GO
 IF OBJECT_ID('dbo.PSP_LoaiSanPham_LayDuLieuCbo') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_LoaiSanPham_LayDuLieuCbo;
    END;
GO  
CREATE PROC PSP_LoaiSanPham_LayDuLieuCbo
AS
SELECT     MaLoaiSP,    TenLoaiSP     
FROM dbo.LoaiSanPham
WHERE IsDelete=0
GO
 IF OBJECT_ID('dbo.PSP_DonViTinh_LayDuLieuCbo') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_DonViTinh_LayDuLieuCbo;
    END;
GO  
CREATE PROC PSP_DonViTinh_LayDuLieuCbo
AS
SELECT     MaDVT,    TenDVT     
FROM dbo.DonViTinh
WHERE IsDelete=0
GO
 IF OBJECT_ID('dbo.PSP_NhaCungCap_LayDuLieuCbo') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_NhaCungCap_LayDuLieuCbo;
    END;
GO  
CREATE PROC PSP_NhaCungCap_LayDuLieuCbo
AS
SELECT     MaNCC,    TenNCC     
FROM dbo.NhaCungCap
WHERE IsDelete=0

GO
IF OBJECT_ID('dbo.PSP_SanPham_LaySanPhamTheoLoai') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_SanPham_LaySanPhamTheoLoai;
    END;
GO  
CREATE PROC PSP_SanPham_LaySanPhamTheoLoai 3
@MaLoaiSanPham INT 
AS
SELECT MaSanPham, TenSanPham, MoTa, MaVach, MaLoaiSP, MaDVT, MaNCC, GiaBinhQuan, SoTon FROM dbo.SanPham
WHERE MaLoaiSP=@MaLoaiSanPham