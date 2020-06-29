using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyBanHang_2020
{
    public class Database : IDisposable
    {
        //private string connectionString = "Server=MINHPHUC;database=BanHang2020;uid=sa;pwd=123";
        private string connectionString01 = "Server=MAYTINH-7LVLLGF;database=BanHang2020;integrated Security=true";
        private SqlConnection cnn;
        private SqlCommand cmd;
        private SqlDataAdapter da;
        public void Dispose()
        {
            if (cnn != null)
            {
                cnn.Dispose();
                cnn = null;
            }
            if (cmd != null)
            {
                cmd.Dispose();
                cmd = null;
            }
            if (da != null)
            {
                da.Dispose();
                da = null;
            }
        }
        public Database()
        {
            cnn = new SqlConnection(connectionString01);
        }
        public bool KiemTraKetNoi(ref string err)
        {
            try
            {
                cnn.Open();
                return true;
            }
            catch (Exception ex)
            {
                err = ex.Message;
                return false;
            }
            finally
            {
                cnn.Close();
            }
        }
        /// <summary>
        /// Phương thức để lấy dữ liệu từ database trả về đối tượng datatable
        /// </summary>
        /// <param name="err">Biến tham chiếu ghi lỗi</param>
        /// <param name="Sql">Tên thủ tục Sql Hay Command text</param>
        /// <param name="ct">Loại CommandType. thưởng sử dụng CommandType.StoredProcedure</param>
        /// <param name="param">Danh sách tham số cho thủ tục. nếu không có sử dụng giá null</param>
        /// <returns></returns>
        public DataTable GetDataTable(ref string err, string Sql,CommandType ct,params SqlParameter[] param)
        {
            DataTable dt=null;
            try
            {
                if(cnn.State==ConnectionState.Open)
                {
                    cnn.Close();
                }
                cnn.Open();
                cmd = new SqlCommand(Sql, cnn);
                cmd.CommandType = ct;
                cmd.CommandTimeout = 6000;
                if(param!=null)
                {

                    foreach (SqlParameter item in param)
                    {
                        cmd.Parameters.Add(item);
                    }
                }
                da = new SqlDataAdapter(cmd);
                dt = new DataTable();
                da.Fill(dt);
               // return dt;
            }
            catch (Exception ex)
            {
                err = ex.Message;
            }
            finally
            {
                cnn.Close();
            }
            return dt;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="err"></param>
        /// <param name="count"></param>
        /// <param name="Sql"></param>
        /// <param name="ct"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public bool MyExcuteNonQuery(ref string err,ref int count, string Sql, CommandType ct, params SqlParameter[] param)
        {
           
            try
            {
                if (cnn.State == ConnectionState.Open)
                {
                    cnn.Close();
                }
                cnn.Open();
                cmd = new SqlCommand(Sql, cnn);
                cmd.CommandType = ct;
                cmd.CommandTimeout = 6000;
                if (param != null)
                {

                    foreach (SqlParameter item in param)
                    {
                        cmd.Parameters.Add(item);
                    }
                }
                count = cmd.ExecuteNonQuery();
                 return true;
            }
            catch (Exception ex)
            {
                err = ex.Message;
                return false;
            }
            finally
            {
                cnn.Close();
            }
        }

        public object MyExecuteScalar(ref string err,  string Sql, CommandType ct, params SqlParameter[] param)
        {

            try
            {
                if (cnn.State == ConnectionState.Open)
                {
                    cnn.Close();
                }
                cnn.Open();
                cmd = new SqlCommand(Sql, cnn);
                cmd.CommandType = ct;
                cmd.CommandTimeout = 6000;
                if (param != null)
                {

                    foreach (SqlParameter item in param)
                    {
                        cmd.Parameters.Add(item);
                    }
                }
              return  cmd.ExecuteScalar();
                 
            }
            catch (Exception ex)
            {
                err = ex.Message;
                return null;
            }
            finally
            {
                cnn.Close();
            }
        }
    }
}
