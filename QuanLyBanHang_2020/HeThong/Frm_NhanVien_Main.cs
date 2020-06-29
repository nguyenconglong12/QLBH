using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyBanHang_2020
{
    public partial class Frm_NhanVien_Main : Form
    {
        public Frm_NhanVien_Main()
        {
            InitializeComponent();
        }
        BLL_HeThong bd;
        string err = string.Empty;
        int count = 0;
        DataTable dt;
        NhanVien _NhanVien;
        private void Frm_NhanVien_Main_Load(object sender, EventArgs e)
        {
            bd = new BLL_HeThong();
            HienThiDanhSachNhanVien();
        }

        private void HienThiDanhSachNhanVien()
        {
            dt = new DataTable();
            dt = bd.LayDanhSachNhanVienFull(ref err);
            dgvDanhSachNhanVien.DataSource = dt;
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            Frm_NhanVien_Modified _FrmNhanVienModified = new Frm_NhanVien_Modified();
            _FrmNhanVienModified.Them = true;
            _FrmNhanVienModified.ShowDialog();
            HienThiDanhSachNhanVien();
        }

        private void dgvDanhSachNhanVien_Click(object sender, EventArgs e)
        {
            if(dgvDanhSachNhanVien.Rows.Count>0)
            {
                _NhanVien = new NhanVien();
                _NhanVien.MaNV = dgvDanhSachNhanVien.CurrentRow.Cells["colMaNhanVien"].Value.ToString();
                _NhanVien.TenNhanVien = dgvDanhSachNhanVien.CurrentRow.Cells["colTenNhanVien"].Value.ToString();
                _NhanVien.NgaySinh = Convert.ToDateTime(dgvDanhSachNhanVien.CurrentRow.Cells["colNgaySinh"].Value.ToString());
                _NhanVien.DienThoai = dgvDanhSachNhanVien.CurrentRow.Cells["colDienThoai"].Value.ToString();
                _NhanVien.MaTaiKhoan = dgvDanhSachNhanVien.CurrentRow.Cells["colMaTaiKhoan"].Value.ToString();
                _NhanVien.TenDangNhap = dgvDanhSachNhanVien.CurrentRow.Cells["colTenDangNhap"].Value.ToString();
                _NhanVien.MatKhau = dgvDanhSachNhanVien.CurrentRow.Cells["colMatKhau"].Value.ToString();

            }
        }

        private void toolStripButton2_Click(object sender, EventArgs e)
        {
            if (_NhanVien != null)
            {
                Frm_NhanVien_Modified _FrmNhanVienModified = new Frm_NhanVien_Modified();
                _FrmNhanVienModified.Them = false;
                _FrmNhanVienModified._NhanVien = _NhanVien;
                _FrmNhanVienModified.ShowDialog();
                HienThiDanhSachNhanVien();
            }
            else
            {
                MessageBox.Show("chua chọn nv can xoa");
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (_NhanVien !=null)
            {
                if (bd.XoaNhanVienUpdateIsDelete(ref err, ref count, _NhanVien))
                {
                    if(count>0)
                    {
                        MessageBox.Show("Xóa thành công","Thông báo",MessageBoxButtons.OK,MessageBoxIcon.Information);
                        HienThiDanhSachNhanVien();
                    }
                    else
                    {
                        MessageBox.Show("Xóa không thành công\n"+err, "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                }
            }else
            {
                MessageBox.Show("chua chọn nv can xoa");
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void btnNapLai_Click(object sender, EventArgs e)
        {
            HienThiDanhSachNhanVien();
        }
    }
}
