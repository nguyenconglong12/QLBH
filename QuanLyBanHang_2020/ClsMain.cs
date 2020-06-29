using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace QuanLyBanHang_2020
{
    public class ClsMain
    {
        public static string TenNhanVien;
        public static string MaNhanVien;
        public static int MaTaiKhoan;

        public static string DatabaseName = "BanHang2020";//Tên database được dùng trong hệ thống

        //method
        public static void ExportExcel(DataGridView dgv,string title,string footer,string path)
        {
            string outPut = string.Empty;
            outPut = title + "\r\n";
            for (int i = 0; i < dgv.ColumnCount; i++)
            {
                outPut += dgv.Columns[i].HeaderText+"\t";
            }
            outPut += "\r\n";
            for (int i = 0; i < dgv.Rows.Count; i++)
            {
                for (int j = 0; j < dgv.ColumnCount; j++)
                {
                    outPut += dgv.Rows[i].Cells[j].Value.ToString() + "\t";
                }
                outPut += "\r\n";
            }
            outPut += footer+"\r\n";

            using(FileStream fs=new FileStream(path,FileMode.CreateNew,FileAccess.Write,FileShare.Write))
            {
                using (StreamWriter sW = new StreamWriter(fs, Encoding.Unicode))
                {
                    sW.WriteLine(outPut);
                }
            }
        }
        private static int MaxValue(int a,int b)
        { 
            return a > b ? a : b;
        }
        /// <summary>
        /// Xuất nội dung DataGridView ra file Excel.
        /// </summary>
        /// <param name="dgv">Đối tượng DataGridView</param>
        /// <param name="title">Nội dung tiêu đề cho file Excel</param>
        /// <param name="path">Đường dẫn lưu file</param>
        /// <param name="colBegin">Giá trị Ascii của cột đầu tiên (A="65")</param>
        /// <param name="cellBegin">Ô đầu tiên của vùng table (A2)</param>
        public static void ExportExcelByMicrosoft(DataGridView dgv, string title, string path, int colBegin, string cellBegin)
        {
            Excel.Application xlApp = new Excel.Application();
            if (xlApp == null)
            {
                MessageBox.Show("Lỗi không thể sử dụng được thư viện EXCEL");
                return;
            }
            xlApp.Visible = false;
            object misValue = System.Reflection.Missing.Value;
            Excel.Workbook wb = xlApp.Workbooks.Add(misValue);
            Excel.Worksheet ws = (Excel.Worksheet)wb.Worksheets[1];

            if (ws == null)
            {
                MessageBox.Show("Không thể tạo được WorkSheet");
                return;
            }
            const string fontName = "Times New Roman";
            const int fontSizeTieuDe = 18;
            const int fontSizeTenTruong = 14;
            const int fontSizeNoiDung = 12;
            //Vùng tiêu đề của table
            Excel.Range titleTable;
            int col = colBegin;
            int colNumber = 0;//xác định số column trong nguồn dữ liệu
            for (int i = 0; i < dgv.Columns.Count; i++)
            {
                // char Cot = char.Parse((KyTu++).ToString());
                if (dgv.Columns[i].Visible == true)
                {
                    KeysConverter key = new KeysConverter();
                    String s = key.ConvertFromString((col++).ToString()).ToString();
                    //  MessageBox.Show(s);
                    colNumber++;
                    titleTable = ws.get_Range(s + "2", s + "2");
                    titleTable.Font.Size = fontSizeTenTruong;
                    titleTable.Font.Name = fontName;
                    titleTable.Cells.HorizontalAlignment = Excel.XlHAlign.xlHAlignCenter;
                    titleTable.Value2 = dgv.Columns[i].HeaderText;
                    titleTable.ColumnWidth = dgv.Columns[i].HeaderText.Length + 5;
                }
            }

            //Để ghi nội dung
            int soDongCanGhi = dgv.RowCount + 3;
            Excel.Range contentTable;
            for (int i = 3; i < soDongCanGhi; i++)
            {
                col = colBegin;
                for (int j = 0; j < dgv.Columns.Count; j++)
                {
                    if (dgv.Columns[j].Visible == true)
                    {
                        KeysConverter key = new KeysConverter();
                        String s = key.ConvertFromString((col++).ToString()).ToString();
                        contentTable = ws.get_Range(s + i, s + i);
                        contentTable.Font.Size = fontSizeNoiDung;
                        contentTable.Font.Name = fontName;
                        contentTable.Value2 = dgv.Rows[i - 3].Cells[j].Value.ToString();
                    }
                }
            }
            #region Thiết kế phần tiêu đề
            KeysConverter keys = new KeysConverter();
            String col1 = keys.ConvertFromString((colBegin).ToString()).ToString();
            String col2 = keys.ConvertFromString((colBegin + colNumber - 1).ToString()).ToString();
            Excel.Range rangetitle = ws.get_Range("A1", col2 + "1");
            rangetitle.Merge();
            rangetitle.Font.Bold = true;
            rangetitle.Font.Size = fontSizeTieuDe;
            rangetitle.Font.Name = fontName;
            rangetitle.Cells.HorizontalAlignment = Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;
            rangetitle.Value2 = title;

            titleTable = ws.get_Range(cellBegin, col2 + "2");
            titleTable.Interior.Color = ConsoleColor.Blue;

            #endregion
            Excel.Range boderTable = ws.get_Range(cellBegin).CurrentRegion;// khai báo vùng để đóng khung.
            BorderAround(boderTable);
            //Lưu file
            wb.SaveAs(path);
            //đóng file để hoàn tất quá trình lưu trữ
            wb.Close(true, misValue, misValue);
            //thoát và thu hồi bộ nhớ cho COM
            xlApp.Quit();
            releaseObject(ws);
            releaseObject(wb);
            releaseObject(xlApp);

            //Mở File excel sau khi Xuất thành công
            System.Diagnostics.Process.Start(path);
        }
        private static void BorderAround(Excel.Range range)
        {
            Excel.Borders borders = range.Borders;
            borders[Excel.XlBordersIndex.xlEdgeLeft].LineStyle = Excel.XlLineStyle.xlContinuous;
            borders[Excel.XlBordersIndex.xlEdgeTop].LineStyle = Excel.XlLineStyle.xlContinuous;
            borders[Excel.XlBordersIndex.xlEdgeBottom].LineStyle = Excel.XlLineStyle.xlContinuous;
            borders[Excel.XlBordersIndex.xlEdgeRight].LineStyle = Excel.XlLineStyle.xlContinuous;
            borders.Color = Color.Red;
            borders[Excel.XlBordersIndex.xlInsideVertical].LineStyle = Excel.XlLineStyle.xlContinuous;
            borders[Excel.XlBordersIndex.xlInsideHorizontal].LineStyle = Excel.XlLineStyle.xlContinuous;
            borders[Excel.XlBordersIndex.xlDiagonalUp].LineStyle = Excel.XlLineStyle.xlLineStyleNone;
            borders[Excel.XlBordersIndex.xlDiagonalDown].LineStyle = Excel.XlLineStyle.xlLineStyleNone;
        }
        private static void releaseObject(object obj)
        {
            try
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                obj = null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                obj = null;
            }
            finally
            { GC.Collect(); }
        }
    }
}
