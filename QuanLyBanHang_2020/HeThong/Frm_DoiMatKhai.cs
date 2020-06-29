using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyBanHang_2020.HeThong
{
    public partial class Frm_DoiMatKhai : Form
    {
        public Frm_DoiMatKhai()
        {
            InitializeComponent();
        }
        BLL_HeThong bd;
        string err = string.Empty;
        int count = 0;

        private void Frm_DoiMatKhai_Load(object sender, EventArgs e)
        {
            bd = new BLL_HeThong();
           
            if(ClsMain.MaTaiKhoan==1)
            {
                gbResetMatKhau.Enabled = true; 
                HienThiDuLieuCboNhanVien();
            }
            else
            {
                gbResetMatKhau.Enabled = false;
            }
        }

        private void HienThiDuLieuCboNhanVien()
        {
            DataTable dt = new DataTable();
            dt = bd.LayNhanVienVaoCbo(ref err);
            cboTenDangNhap.DataSource = dt;
            cboTenDangNhap.DisplayMember = "TenNhanVien";
            cboTenDangNhap.ValueMember = "MaNV";
            cboTenDangNhap.SelectedIndex = -1;
            cboTenDangNhap.Text = "Chọn nhân viên";
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            if(bd.ResetMatKhau(ref err,ref count,cboTenDangNhap.SelectedValue.ToString()))
            {
                MessageBox.Show(string.Format("Nhân viên {0} đã được reset mật khẩu thành công",cboTenDangNhap.Text));
            }
            else
            {
                MessageBox.Show(string.Format("Nhân viên {0} đã được reset mật khẩu không thành công", cboTenDangNhap.Text));
            }
        }

        private void btnDoiMatKhau_Click(object sender, EventArgs e)
        {
            if(bd.DoiMatKhau(ref err,ref count,ClsMain.MaNhanVien,txtMatKhauMoi.Text))
            {
                MessageBox.Show(string.Format("Nhân viên {0} đã được đổi mật khẩu thành công", ClsMain.TenNhanVien));
            }
            else
            {
                MessageBox.Show(string.Format("Nhân viên {0} đã được đổi mật khẩu không thành công\n "+err, ClsMain.TenNhanVien));
            }
        }
    }
}
