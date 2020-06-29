using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyBanHang_2020.BanHang
{
    public partial class Frm_BanHang : Form
    {
        public Frm_BanHang()
        {
            InitializeComponent();
        }

        private void txtMaVach01_Enter(object sender, EventArgs e)
        {
            txtMaVach01.BackColor = Color.PaleTurquoise;
        }

        private void txtMaVach01_Leave(object sender, EventArgs e)
        {
            txtMaVach01.BackColor = Color.White;
        }

        private void txtMaVach02_Enter(object sender, EventArgs e)
        {
             txtMaVach02.BackColor = Color.Plum;
        }
        
    
        private void txtMaVach02_Leave(object sender, EventArgs e)
        {
      txtMaVach02.BackColor = Color.White;
        }

        private void txtKhachDua_Enter(object sender, EventArgs e)
        {
            txtKhachDua.BackColor = Color.FromArgb(0xDC, 0xA0, 0xDC);
        }

        private void txtKhachDua_Leave(object sender, EventArgs e)
        {
            txtKhachDua.BackColor = Color.White;
        }

        private void Frm_BanHang_Load(object sender, EventArgs e)
        {

            this.reportViewer1.RefreshReport();
        }
    }
}
