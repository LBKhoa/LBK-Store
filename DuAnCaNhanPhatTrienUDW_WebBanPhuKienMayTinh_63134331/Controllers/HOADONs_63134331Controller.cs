using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;
using Newtonsoft.Json;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class HOADONs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: HOADONs_63134331
        public ActionResult Index()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            var hOADON = db.HOADON.Include(h => h.KHACHHANG).Include(h => h.NHANVIEN);
            return View(hOADON.ToList());
        }

        // GET: HOADONs_63134331/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HOADON hOADON = db.HOADON.Find(id);
            if (hOADON == null)
            {
                return HttpNotFound();
            }
            return View(hOADON);
        }

        // GET: HOADONs_63134331/Create
        public ActionResult Create()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH");
            ViewBag.IDNV = new SelectList(db.NHANVIEN, "IDNV", "HOTENNV");
            return View();
        }
        public ActionResult DatThanhCong()
        {
            return View();
        }

        // POST: HOADONs_63134331/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "HOTENNN,SDTNN,DIACHINN")] HOADON hOADON)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            Session["newIDHD"] = (int)(db.HOADON.OrderByDescending(t => t.IDHD).Select(t => t.IDHD).FirstOrDefault() + 1);
            hOADON.IDHD = int.Parse(Session["newIDHD"].ToString()); //  IDHD mới
            string ngayDat = DateTime.Now.ToString("yyyy-MM-dd");
            hOADON.NDAT = DateTime.ParseExact(ngayDat, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            string ngayGiaoDuKien = DateTime.Now.AddDays(2).ToString("yyyy-MM-dd");
            hOADON.NGIAO = DateTime.ParseExact(ngayGiaoDuKien, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            hOADON.TINHTRANG = "Chờ xử lý";
            hOADON.SDTKH = Session["ID"].ToString();
            hOADON.IDNV = "NV0041";

            if (ModelState.IsValid)
            {
                db.HOADON.Add(hOADON);
                db.SaveChanges();
                Session["newIDHD"] = (int)Session["newIDHD"] + 1;

                List<CHITIETHOADON> selectedProducts = (List<CHITIETHOADON>)Session["SelectedProducts"];
                foreach (CHITIETHOADON sp in selectedProducts)
                {
                    db.CHITIETHOADON.Add(sp); var sessionId = Session["ID"].ToString();
                    var ctghToRemove = db.CHITIETGIOHANG.FirstOrDefault(ctgh => ctgh.SDTKH == sessionId && ctgh.IDSP == sp.IDSP);

                    if (ctghToRemove != null)
                    {
                        db.CHITIETGIOHANG.Remove(ctghToRemove);
                        db.SaveChanges();
                    }
                }
                db.SaveChanges();
                Session["SLSP"] = db.Database.SqlQuery<int>("EXEC SLSPTrongGH @username", new SqlParameter("username", Session["ID"].ToString())).SingleOrDefault();
                return RedirectToAction("Edit1", "KHACHHANGs_63134331", new { id = Session["ID"] });
            }
            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH", hOADON.SDTKH);
            ViewBag.IDNV = new SelectList(db.NHANVIEN, "IDNV", "HOTENNV", hOADON.IDNV);
            return View(hOADON);
        }

        public ActionResult GetHOADONList(string sdt)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            try
            {
                // Lấy danh sách HOADON từ cơ sở dữ liệu dựa trên số điện thoại
                var hoadonList = db.HOADON.Where(c => c.SDTKH == sdt).OrderByDescending(c => c.IDHD).ToList();

                // Chuyển đổi danh sách CHITIETHOADON sang danh sách CHITIETHOADONDTO
                var responseData = hoadonList.Select(h => new
                {
                    IDHD = h.IDHD,
                    HOTENNN = h.HOTENNN,
                    NDAT = h.NDAT.ToString("dd/MM/yyyy"),
                    SDTNN = h.SDTNN,
                    CHITIET = db.CHITIETHOADON.Where(ct => ct.IDHD == h.IDHD)
                                             .Select(ct => new CHITIETHOADONDTO
                                             {
                                                 IDSP = ct.IDSP,
                                                 TENSP = db.SANPHAM.Where(sp => sp.IDSP == ct.IDSP).Select(sp => sp.TENSP).FirstOrDefault(),
                                                 SL = ct.SL,
                                                 TSKT = db.SANPHAM.Where(sp => sp.IDSP == ct.IDSP).Select(sp => sp.TSKT).FirstOrDefault(),
                                             })
                                             .ToList(),
                    TongTien = GetTongTienHoaDon(h.IDHD).ToString("#,##0 đ")
                });

                // Trả về danh sách HOADON dưới dạng JSON
                return Json(new { success = true, data = responseData }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                // Xử lý nếu có lỗi xảy ra
                return Json(new { success = false, error = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public int GetTongTienHoaDon(int maDH)
        {
            // Lấy danh sách HOADON từ cơ sở dữ liệu dựa trên số điện thoại
            int tong = 0;
            // Lấy danh sách chi tiết hóa đơn cho hóa đơn có IDHD tương ứng
            var chitietList = db.CHITIETHOADON.Where(ct => ct.IDHD == maDH).ToList();
            // Tính tổng tiền cho từng chi tiết hóa đơn
            foreach (var chitiet in chitietList)
            {
                // Lấy giá tiền của sản phẩm từ bảng SANPHAM
                var giaTien = db.SANPHAM.Where(sp => sp.IDSP == chitiet.IDSP).Select(sp => sp.GIASP).FirstOrDefault();
                // Tính tổng tiền của sản phẩm (số lượng nhân với giá tiền)
                var subtotal = chitiet.SL * giaTien;
                // Cộng tổng tiền của sản phẩm vào tổng tiền của hóa đơn
                tong += subtotal;
            }

            return tong;
        }
        public ActionResult SaveSelectedProducts(List<CHITIETHOADON> selectedProducts)
        {
            // Lưu danh sách sản phẩm vào session
            Session["SelectedProducts"] = selectedProducts;

            return Json(new { success = true });
        }
        public ActionResult GetSelectedProducts()
        {
            try
            {
                // Lấy danh sách sản phẩm từ Session
                var selectedProducts = Session["SelectedProducts"] as List<CHITIETHOADON>;

                // Lấy thông tin sản phẩm từ bảng SANPHAM
                var productList = new List<object>();
                foreach (var product in selectedProducts)
                {
                    var sanpham = db.SANPHAM.Find(product.IDSP);
                    if (sanpham != null)
                    {
                        productList.Add(new
                        {
                            IDHD = product.IDHD,
                            IDSP = sanpham.IDSP,
                            IMGSP = sanpham.IMGSP,
                            TENSP = sanpham.TENSP,
                            SL = product.SL,
                            GIASP = sanpham.GIASP,
                        });
                    }
                }
                // Trả về danh sách sản phẩm dưới dạng JSON
                return Json(new { success = true, data = productList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                // Xử lý nếu có lỗi xảy ra
                return Json(new { success = false, error = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        // GET: HOADONs_63134331/Edit/5
        public ActionResult Edit(int? id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HOADON hOADON = db.HOADON.Find(id);
            if (hOADON == null)
            {
                return HttpNotFound();
            }
            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH", hOADON.SDTKH);
            ViewBag.IDNV = new SelectList(db.NHANVIEN, "IDNV", "HOTENNV", hOADON.IDNV);
            return View(hOADON);
        }

        // POST: HOADONs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "IDHD,NDAT,NGIAO,TINHTRANG,SDTKH,IDNV,HOTENNN,SDTNN,DIACHINN")] HOADON hOADON)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (ModelState.IsValid)
            {
                db.Entry(hOADON).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH", hOADON.SDTKH);
            ViewBag.IDNV = new SelectList(db.NHANVIEN, "IDNV", "HOTENNV", hOADON.IDNV);
            return View(hOADON);
        }

        private void sendEmail(string emailKH, List<CHITIETHOADON> listSP, HOADON hOADON)
        {
            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
            mail.From = new System.Net.Mail.MailAddress("khoa.lb.63cntt@ntu.edu.vn");
            mail.To.Add(emailKH);
            mail.Subject = "Đơn hàng #" + hOADON.IDHD + " đã được xác nhận";
            String bodyEmail = "Thông tin đơn hàng của bạn:\n" +
                "Ngày đặt: " + hOADON.NDAT.ToString("dd/MM/yyyy") + "\nNgày dự kiến giao: " + hOADON.NGIAO?.ToString("dd/MM/yyyy") + "\nĐịa chỉ nhận: " + hOADON.HOTENNN + ", " + hOADON.SDTNN +
                ", " + hOADON.DIACHINN + "\nChi tiết đơn hàng:\n";
            for (int i = 0; i < listSP.Count; i++)
            {
                var sp = db.SANPHAM.Find(listSP.ElementAt(i).IDSP);
                var tenSP = sp.TENSP;
                var giaSP = sp.GIASP;
                var sl = listSP.ElementAt(i).SL;
                var tongTien = giaSP * sl;
                bodyEmail += "\tTên sản phẩm: " + tenSP + "\n\t\tGiá sản phẩm: " + giaSP.ToString("N0")
                    + "đ\tSố lượng: " + sl + "\t Tiền cần thanh toán: " + tongTien.ToString("N0") + "đ\n";
            }
            bodyEmail += "Tổng tiền hóa đơn " + GetTongTienHoaDon(hOADON.IDHD).ToString("N0") + "đ";

            // Thêm các ký tự đặc biệt để tạo tab và xuống dòng
            bodyEmail = bodyEmail.Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;"); // Thay thế tab bằng ký tự đặc biệt "&nbsp;&nbsp;&nbsp;&nbsp;"
            bodyEmail = bodyEmail.Replace("\n", "<br>"); // Thay thế xuống dòng bằng ký tự đặc biệt "<br>"


            mail.Body = bodyEmail;
            mail.IsBodyHtml = true;
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new System.Net.NetworkCredential("emailntu@ntu.edu.vn", "passemail");
            smtp.EnableSsl = true;
            smtp.Send(mail);
        }


        public ActionResult UpdateHoaDon(int idhd, string idnv, string tinhtrang)
        {
            var hoaDon = db.HOADON.Find(idhd);
            var khachHang = db.KHACHHANG.Find(hoaDon.SDTKH);
            var chiTietHoaDon = db.CHITIETHOADON.Where(cthd => cthd.IDHD == idhd).ToList();
            var emailKH = khachHang.EMAILKH;
            sendEmail(emailKH, chiTietHoaDon, hoaDon);
            if (hoaDon != null)
            {
                hoaDon.IDNV = idnv;
                hoaDon.TINHTRANG = tinhtrang;

                db.Entry(hoaDon).State = EntityState.Modified;
                db.SaveChanges();
            }

            return RedirectToAction("Index");
        }


        // GET: HOADONs_63134331/Delete/5
        public ActionResult Delete(int? id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HOADON hOADON = db.HOADON.Find(id);
            if (hOADON == null)
            {
                return HttpNotFound();
            }
            return View(hOADON);
        }

        // POST: HOADONs_63134331/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            List<CHITIETHOADON> cHITIETHOADONs = db.CHITIETHOADON.Where(ch => ch.IDHD == id).ToList();
            foreach (CHITIETHOADON c in cHITIETHOADONs)
            {
                db.CHITIETHOADON.Remove(c);
            }
            HOADON hOADON = db.HOADON.Find(id);
            db.HOADON.Remove(hOADON);

            db.SaveChanges();
            return RedirectToAction("Index");
        }


        [HttpPost]
        public ActionResult ThanhToan()
        {
            // Lấy thông tin người dùng đang thực hiện thanh toán (từ session hoặc thông qua đăng nhập)
            string sdtKhachHang = Session["ID"] as string;
            string idNhanVien = "NV0041";// mặc định NV41 là Khách đặt online



            // Tạo bản ghi trong bảng HOADON
            HOADON hoadon = new HOADON();
            hoadon.NDAT = DateTime.Now; // Ngày đặt là ngày hiện tại
            hoadon.TINHTRANG = "Chờ xử lý"; // Thiết lập tình trạng thanh toán
            hoadon.SDTKH = sdtKhachHang;
            hoadon.IDNV = idNhanVien;
            hoadon.HOTENNN = "Họ và tên người nhận"; // Thay bằng dữ liệu từ form đăng nhập/người dùng nhập
            hoadon.SDTNN = "Số điện thoại người nhận"; // Thay bằng dữ liệu từ form đăng nhập/người dùng nhập
            hoadon.DIACHINN = "Địa chỉ người nhận"; // Thay bằng dữ liệu từ form đăng nhập/người dùng nhập

            db.HOADON.Add(hoadon);
            db.SaveChanges();

            // Lấy danh sách sản phẩm trong giỏ hàng của khách hàng
            List<CHITIETGIOHANG> gioHang = db.CHITIETGIOHANG.Where(c => c.SDTKH == sdtKhachHang).ToList();

            // Tạo các bản ghi trong bảng CHITIETHOADON từ danh sách sản phẩm trong giỏ hàng
            foreach (var item in gioHang)
            {
                CHITIETHOADON chiTietHoaDon = new CHITIETHOADON();
                chiTietHoaDon.IDHD = hoadon.IDHD;
                chiTietHoaDon.IDSP = item.IDSP;
                chiTietHoaDon.SL = item.SL;

                db.CHITIETHOADON.Add(chiTietHoaDon);
            }
            db.SaveChanges();

            // Xóa các sản phẩm trong giỏ hàng của khách hàng
            db.CHITIETGIOHANG.RemoveRange(gioHang);
            db.SaveChanges();

            return RedirectToAction("Index", "Home_63134331"); // Chuyển hướng về trang chủ sau khi thanh toán thành công
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
