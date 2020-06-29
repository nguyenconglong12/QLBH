using QuanLyBanHang_2020.BanHang;

using QuanLyBanHang_2020.HeThong;
using QuanLyBanHang_2020.QuanLyNhapHang;
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
    public partial class FrmMain : Form
    {
        public FrmMain()
        {
            InitializeComponent();
        }
        public string tenNhanVien = string.Empty;
        private void FrmMain_Load(object sender, EventArgs e)
        {
            LogIn frm_Login = new LogIn();
            frm_Login.ShowDialog();
            //các việc thực hiện trên form main sau khi thực hiện login thành công
            txtTenNhanVien.Text = ClsMain.TenNhanVien;
        }

        private void mnuDangXuat_Click(object sender, EventArgs e)
        {
            LogIn frm_Login = new LogIn();
            frm_Login.ShowDialog();
            //các việc thực hiện trên form main sau khi thực hiện login thành công
            txtTenNhanVien.Text = ClsMain.TenNhanVien;
        }

        private void mnuQuanLyNhanVien_Click(object sender, EventArgs e)
        {
            Frm_NhanVien_Main frmNhanVien = new Frm_NhanVien_Main();
            frmNhanVien.ShowDialog();
        }

        private void mnuSaoLuu_Click(object sender, EventArgs e)
        {
           
        }

        private void mnuPhucHoi_Click(object sender, EventArgs e)
        {
            
        }

        private void mnuDoiMatKhau_Click(object sender, EventArgs e)
        {
            Frm_DoiMatKhai frmDoiMatKhau = new Frm_DoiMatKhai();
            frmDoiMatKhau.ShowDialog();
        }

        private void btnChiTietNhapHang_Click(object sender, EventArgs e)
        {
            Frm_ChiTietNhapHang_Main frmNhapHang = new Frm_ChiTietNhapHang_Main();
            frmNhapHang.ShowDialog();
        }

        private void mnuDoiGiaBan_Click(object sender, EventArgs e)
        {
                    }

        private void mnuBanHang_Click(object sender, EventArgs e)
        {
            Frm_BanHang frmBanHang = new Frm_BanHang();
            frmBanHang.ShowDialog();
        }

        private void mnuDonViTinh_Click(object sender, EventArgs e)
        {
           
        }

        private void phânQuyềnToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }
    }
}
