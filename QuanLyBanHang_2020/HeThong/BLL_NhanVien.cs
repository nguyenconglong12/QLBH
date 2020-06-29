using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace QuanLyBanHang_2020
{
    public partial class BLL_HeThong
    {
        public DataTable LayDanhSachNhanVienFull(ref string err)
        {
            return data.GetDataTable(ref err, "PSP_NhanVien_HienThiDanhSachNhanVien", CommandType.StoredProcedure, null);
        }
        public DataTable LayDuLieuComboLoaiTaiKhoan(ref string err)
        {
            return data.GetDataTable(ref err, "PSP_TaiKhoan_Loadcombo", CommandType.StoredProcedure, null);
        }
        public bool ThemVaCapNhatNhanVien(ref string err,ref int count,NhanVien _nhanVien)
        {
            return data.MyExcuteNonQuery(ref err, ref count, "PSP_NhanVien_InsertAndUpdate", CommandType.StoredProcedure,
                new SqlParameter("@MaNV", _nhanVien.MaNV),
                  new SqlParameter("@TenNhanVien", _nhanVien.TenNhanVien),
                    new SqlParameter("@NgaySinh", _nhanVien.NgaySinh),
                      new SqlParameter("@DienThoai", _nhanVien.DienThoai),
                        new SqlParameter("@MaTaiKhoan", _nhanVien.MaTaiKhoan),
                          new SqlParameter("@TenDangNhap", _nhanVien.TenDangNhap),
                            new SqlParameter("@MatKhau", _nhanVien.MatKhau));

        }
        public bool XoaNhanVienVinhVien(ref string err,ref int count,NhanVien _nhanVien)
        {
            return data.MyExcuteNonQuery(ref err, ref count, "PSP_NhanVien_Delete", CommandType.StoredProcedure,
                new SqlParameter("@MaNV", _nhanVien.MaNV));
        }
        public bool XoaNhanVienUpdateIsDelete(ref string err, ref int count, NhanVien _nhanVien)
        {
            return data.MyExcuteNonQuery(ref err, ref count, "PSP_NhanVien_DeleteUpdateIsDelete", CommandType.StoredProcedure,
                new SqlParameter("@MaNV", _nhanVien.MaNV));
        }
    }
}
