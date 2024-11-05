using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class XACTHUCs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();
        // GET: XACTHUCs_63134331

        public static short xacDinhQuyen(String id)
        {

            if (id == "null")
            {
                Debug.Print("2");
                return 2;
            }
            else if (id == "0")
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DangNhap()
        {
            ViewBag.Error = "";
            return View();
        }

        [HttpPost]
        public ActionResult DangNhap(string username, string password)
        {
            string hashedPassword = "";
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                foreach (byte b in bytes)
                {
                    hashedPassword += b.ToString("x2");
                }
            }

            Session["newIDHD"] = (int)(db.HOADON.OrderByDescending(t => t.IDHD).Select(t => t.IDHD).FirstOrDefault() + 1);

            if (username.Contains("NV"))
            {
                Debug.Print("EXEC KHDangNhap " + username + ", " + password);
                var result = db.Database.SqlQuery<NVDangNhap_Result>("EXEC NVDangNhap @username, @password",
                new SqlParameter("username", username),
                new SqlParameter("password", hashedPassword)
                ).SingleOrDefault();
                if (result != null && result.KQ > 0)
                {
                    // Xác thực thành công
                    // Lưu thông tin người dùng vào Session hoặc Cookie và chuyển hướng đến trang chính
                    var nv = db.NHANVIEN.FirstOrDefault(n => n.IDNV == username);
                    if (nv != null)
                    {
                        Session["UserName"] = nv.HOTENNV;
                        Session["ID"] = nv.IDNV;
                        Session["Quyen"] = nv.QUYEN;
                        // Lưu thông tin vào Session
                        // hoặc lưu vào Cookie:
                        // HttpCookie cookie = new HttpCookie("HOTENNV");
                        // cookie.Value = nv.HOTENNV;
                        // cookie.Expires = DateTime.Now.AddDays(7);
                        // Response.Cookies.Add(cookie);
                    }
                    return RedirectToAction("Admin", "Home_63134331");
                }

            }
            else
            {

                var result = db.Database.SqlQuery<int>("EXEC KHDangNhap @username, @password",
                new SqlParameter("username", username),
                new SqlParameter("password", hashedPassword)
                ).SingleOrDefault();
                if (result > 0)
                {
                    // Xác thực thành công
                    // Lưu thông tin người dùng vào Session hoặc Cookie và chuyển hướng đến trang chính
                    var kh = db.KHACHHANG.FirstOrDefault(n => n.SDTKH == username);
                    var slsp = db.Database.SqlQuery<int>("EXEC SLSPTrongGH @username", new SqlParameter("username", username)).SingleOrDefault();
                    if (kh != null)
                    {
                        Session["UserName"] = kh.HOTENKH;
                        Session["ID"] = kh.SDTKH;
                        Session["Address"] = (kh.DIACHIKH == null) ? "Chưa có địa chỉ" : kh.DIACHIKH;
                        Session["Quyen"] = "null";
                        Session["SLSP"] = slsp;
                        Session["SelectedProducts"] = new List<CHITIETHOADON>();
                        // Lưu thông tin vào Session
                        // hoặc lưu vào Cookie:
                        // HttpCookie cookie = new HttpCookie("HOTENNV");
                        // cookie.Value = nv.HOTENNV;
                        // cookie.Expires = DateTime.Now.AddDays(7);
                        // Response.Cookies.Add(cookie);
                    }
                    return RedirectToAction("Index", "Home_63134331");
                }
                Debug.Print(result.ToString());
            }

            // Xác thực thất bại
            ViewBag.Error = "Sai tên đăng nhập hoặc mật khẩu!";
            return View();
        }
        public ActionResult DangKy()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DangKy([Bind(Include = "HOTENKH,DIACHIKH,EMAILKH,SDTKH,PASSKH")] KHACHHANG KhachHang)
        {
            ViewBag.Error = null;
            string hashedPassword = "";
            KhachHang.HOTENKH = KhachHang.HOTENKH.Trim();
            KhachHang.DIACHIKH = KhachHang.DIACHIKH.Trim();
            KhachHang.EMAILKH = KhachHang.EMAILKH.Trim();
            KhachHang.SDTKH = KhachHang.SDTKH.Trim();
            KhachHang.PASSKH = KhachHang.PASSKH.Trim();
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(KhachHang.PASSKH));
                foreach (byte b in bytes)
                {
                    hashedPassword += b.ToString("x2");
                }
            }
            KhachHang.PASSKH = hashedPassword;
            if (ModelState.IsValid)
            {
                if (KhachHang.SDTKH.Length != 10)
                {
                    ModelState.AddModelError("SDTKH", "Số điện thoại phải có đúng 10 ký tự.");
                    return View(KhachHang);
                }
                try
                {
                    db.KHACHHANG.Add(KhachHang);
                    db.SaveChanges();
                    return RedirectToAction("DangNhap", "XACTHUCs_63134331");
                }
                catch (Exception)
                {
                    ViewBag.Error = "Số điện thoại này đã đăng ký cho tài khoản khác.";
                }
            }
            return View();
        }

        public ActionResult DangXuat()
        {
            Session.Clear(); // xóa tất cả các session
            return RedirectToAction("Index", "Home_63134331"); // chuyển hướng về trang chủ
        }

        public ActionResult Loi404()
        {
            return View();
        }
    }
}