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
    public partial class LogIn : Form
    {
        public LogIn()
        {
            InitializeComponent();
        }
        BLL_HeThong bd;
        DataTable dt;
        string err = string.Empty;
        private void btnDanhNhap_Click(object sender, EventArgs e)
        {
            if(DangNhap(txtTenDangNhap.Text,txtMatKhau.Text)==true)
            {
                this.Close();
            }
            else
            {
                MessageBox.Show("Tên đăng nhập hoặc mật khẩu sai");
            }
        }

        private bool DangNhap(string tenDangNhap, string matKhau)
        {
            bool result = false;
            dt = new DataTable();
            dt = bd.KiemTraDangNhap(ref err, tenDangNhap, matKhau);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0]["code"].ToString().Equals("1"))
                    {
                        ClsMain.TenNhanVien = dt.Rows[0]["TenNhanVien"].ToString();
                        ClsMain.MaTaiKhoan = Convert.ToInt32(dt.Rows[0]["MaTaiKhoan"].ToString());
                        ClsMain.MaNhanVien = dt.Rows[0]["MaNV"].ToString();
                        result = true;
                    }
                }
                else
                {
                    MessageBox.Show("User name hay password không đúng");
                }
            }
            else
            {
                MessageBox.Show(err);
            }
            return result;
        }

        private void LogIn_Load(object sender, EventArgs e)
        {
            bd = new BLL_HeThong();
            if(!bd.KiemTraKetNoi(ref err))
            {
                FrmKetNoi frm_KetNoi=new FrmKetNoi();
                frm_KetNoi.ShowDialog();
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
