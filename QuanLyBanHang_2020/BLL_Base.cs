using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyBanHang_2020
{
    public class BLL_Base : IDisposable
    {
        public Database data;
        public void Dispose()
        {
            if (data != null)
            {
                data.Dispose();
                data = null;
            }
        }
        public BLL_Base()
        {
            data = new Database();
        }
    }
}
