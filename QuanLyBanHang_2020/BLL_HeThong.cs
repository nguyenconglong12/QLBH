using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyBanHang_2020
{
    public partial class BLL_HeThong : IDisposable
    {
        Database data;
        public void Dispose()
        {
            if (data != null)
            {
                data.Dispose();
                data = null;
            }
        }
        public BLL_HeThong()
        {
            data = new Database();
        }
        public bool KiemTraKetNoi(ref string err)
        {
            if (data == null)
                return false;
            if (!data.KiemTraKetNoi(ref err))
                return false;
            return true;
        }
        public DataTable KiemTraDangNhap(ref string err,string tenDangNhap,string matKhau)
        {
            return data.GetDataTable(ref err, "PSP_NhanVien_KiemTraDangNhap", CommandType.StoredProcedure,
                new SqlParameter("@TenDangNhap", tenDangNhap),
                new SqlParameter("@MatKhau", matKhau));
        }
        public bool ThucThiSaoLuuDulieu(ref string err,ref int count,string path)
        {
           return data.MyExcuteNonQuery(ref err, ref count, "PSP_SaoLuuDuLieu", CommandType.StoredProcedure,
                new SqlParameter("@duongdan", path));
        }
        public bool ThucThiPhucHoiDulieu(ref string err, ref int count,string sql)
        {
            return data.MyExcuteNonQuery(ref err, ref count, sql, CommandType.Text,
                 null);
        }

        public bool DoiMatKhau(ref string err,ref int count,string maNhanVien,string MatKhau)
        {
            return data.MyExcuteNonQuery(ref err, ref count, "PSP_NhanVien_DoiMatKhau", CommandType.StoredProcedure,
                new SqlParameter("@MaNhanVien", maNhanVien),
                new SqlParameter("@MatKhau", MatKhau));
        }
        public bool ResetMatKhau(ref string err, ref int count, string maNhanVien)
        {
            return data.MyExcuteNonQuery(ref err, ref count, "PSP_NhanVien_ResetMatKhau", CommandType.StoredProcedure,
                new SqlParameter("@MaNhanVien", maNhanVien));
        }
        public DataTable LayNhanVienVaoCbo(ref string err)
        {
            return data.GetDataTable(ref err, "PSP_NhanVien_LayDuLieuCombo", CommandType.StoredProcedure, null);
        }
    }
}
