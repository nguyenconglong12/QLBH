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
    public partial class Frm_NhanVien_Modified : Form
    {
        public Frm_NhanVien_Modified()
        {
            InitializeComponent();
        }

            public bool Them = false;
            BLL_HeThong bd;
            string err = string.Empty;
            int count = 0;
            public NhanVien _NhanVien = new NhanVien();
            
        private void Frm_NhanVien_Modified_Load(object sender, EventArgs e)
        {
            bd = new BLL_HeThong(); 
            LoadComboLoaiTaiKHoan();
            if(Them==true)
            {
                txtMaNhanVien.Text = "0";
                txtTenDangNhap.Focus();
            }
            else//Sửa
            {
                GanNhanVienVaoControl( _NhanVien);
            }
        }

        private void GanNhanVienVaoControl(NhanVien _NhanVien)
        {
            txtMaNhanVien.Text = _NhanVien.MaNV;
            txtTenNhanVien.Text = _NhanVien.TenNhanVien;
            dtpNgaySinh.Value = _NhanVien.NgaySinh;
            txtDienThoai.Text = _NhanVien.DienThoai;
            cboTaiKhoan.SelectedValue = _NhanVien.MaTaiKhoan;
            txtTenDangNhap.Text = _NhanVien.TenDangNhap;
            txtMatKhau.Text = _NhanVien.MatKhau;
        }

        private void LoadComboLoaiTaiKHoan()
        {
            DataTable dt = new DataTable();
            dt = bd.LayDuLieuComboLoaiTaiKhoan(ref err);
            cboTaiKhoan.DataSource = dt;
            cboTaiKhoan.DisplayMember = "TenTaiKhoan";
            cboTaiKhoan.ValueMember = "MaTaiKhoan";
            cboTaiKhoan.SelectedIndex = -1;
            cboTaiKhoan.Text = "---Chọn loại tài khoản";
        }

        private void btnCapNhap_Click(object sender, EventArgs e)
        {
            if(!string.IsNullOrEmpty(txtTenNhanVien.Text))
            {
                LayDuLieuTuControl();
                if(bd.ThemVaCapNhatNhanVien(ref err, ref count,_NhanVien))
                {
                    MessageBox.Show("Thêm thành công");
                    this.Close();
                }
            }
            else
            {
                MessageBox.Show("Chưa nhập tên");
            }
        }

        private void LayDuLieuTuControl()
        {
            _NhanVien = new NhanVien();
            _NhanVien.MaNV = txtMaNhanVien.Text;
            _NhanVien.TenNhanVien = txtTenNhanVien.Text;
            _NhanVien.NgaySinh = dtpNgaySinh.Value;
            _NhanVien.DienThoai = txtDienThoai.Text;
            _NhanVien.MaTaiKhoan = cboTaiKhoan.SelectedValue.ToString();
            _NhanVien.TenDangNhap = txtTenDangNhap.Text;
            _NhanVien.MatKhau = txtMatKhau.Text;
        }

       
    }
}
