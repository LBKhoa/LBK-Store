using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;
using Microsoft.Ajax.Utilities;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class KHACHHANGs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: KHACHHANGs_63134331

        public ActionResult Index(string HOTENKH = "", string DIACHIKH = "", string EMAILKH = "", string SDTKH = "")
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            ViewBag.HOTENKH = HOTENKH;
            ViewBag.DIACHIKH = DIACHIKH;
            ViewBag.EMAILKH = EMAILKH;
            ViewBag.SDTKH = SDTKH;
            var khachHangs = db.KHACHHANG.ToList();
            if (HOTENKH != "" || DIACHIKH != "" || EMAILKH != "" || SDTKH != "")
            {
                khachHangs = db.KHACHHANG.Where(kh => kh.HOTENKH.Contains(HOTENKH) && kh.DIACHIKH.Contains(DIACHIKH) && kh.EMAILKH.Contains(EMAILKH) && kh.SDTKH.Contains(SDTKH)).ToList();
            }

            //var khachHangs = db.KHACHHANG.SqlQuery("KhachHang_TimKiem 'N" + HOTENKH + "',N'" + DIACHIKH + "','" + EMAILKH + "','" + SDTKH + "'");
            if (khachHangs.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(khachHangs);
        }


        // GET: KHACHHANGs_63134331/Details/5
        public ActionResult Details(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANG.Find(id);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

        // GET: KHACHHANGs_63134331/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: KhachHang/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "HOTENKH,DIACHIKH,EMAILKH,SDTKH,PASSKH")] KHACHHANG KhachHang)
        {
            ViewBag.Error = null;
            KhachHang.DIACHIKH = "";
            string hashedPassword = "";
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
                try
                {
                    db.KHACHHANG.Add(KhachHang);
                    db.SaveChanges();
                    if (Session["Quyen"] != null)
                        return RedirectToAction("Index", "Admin");

                    return RedirectToAction("DangNhap", "XACTHUCs_63134331");
                }
                catch (Exception )
                {
                    ViewBag.Error = "Số điện thoại này đã đăng ký cho tài khoản khác.";
                }
            }
            var routeValues = new RouteValueDictionary { { "id", 406 } };
            return RedirectToAction("DangKy", "XACTHUCs_63134331", routeValues);
        }

        // GET: KHACHHANGs_63134331/Edit/5
        public ActionResult Edit(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANG.Find(id);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

        // POST: KHACHHANGs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "HOTENKH,DIACHIKH,EMAILKH,SDTKH,PASSKH")] KHACHHANG kHACHHANG, string newSDTKH)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            string hashedPassword = "";
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(kHACHHANG.PASSKH));
                foreach (byte b in bytes)
                {
                    hashedPassword += b.ToString("x2");
                }
            }
            kHACHHANG.PASSKH = hashedPassword;

            // Nếu newSDTKH được cung cấp, cập nhật SDTKH mới
            if (!string.IsNullOrEmpty(newSDTKH))
            {
                kHACHHANG.SDTKH = newSDTKH;
            }

            if (ModelState.IsValid)
            {
                db.Entry(kHACHHANG).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(kHACHHANG);
        }

        public ActionResult Edit1(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANG.Find(id);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

        // POST: KHACHHANGs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit1([Bind(Include = "HOTENKH,DIACHIKH,EMAILKH,SDTKH,PASSKH")] KHACHHANG kHACHHANG)
        {
            string hashedPassword = "";
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(kHACHHANG.PASSKH));
                foreach (byte b in bytes)
                {
                    hashedPassword += b.ToString("x2");
                }
            }
            kHACHHANG.PASSKH = hashedPassword;

            if (ModelState.IsValid)
            {
                db.Entry(kHACHHANG).State = EntityState.Modified;
                db.SaveChanges();
                Session["Username"] = kHACHHANG.HOTENKH;
                Session["Address"] = kHACHHANG.DIACHIKH;
                return RedirectToAction("Edit1");
            }
            return View(kHACHHANG);
        }

        // GET: KHACHHANGs_63134331/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANG.Find(id);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

        // POST: KHACHHANGs_63134331/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            if (string.IsNullOrEmpty(id))
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

            KHACHHANG kHACHHANG = db.KHACHHANG.Find(id);

            if (kHACHHANG == null)
                return HttpNotFound();

            db.KHACHHANG.Remove(kHACHHANG);
            db.SaveChanges();

            return RedirectToAction("Index");
        }


        public ActionResult GioHang()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() != "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            var gioHangList = db.Database.SqlQuery<GioHangKH_Result>("EXEC GioHangKH @username", new SqlParameter("@username", Session["ID"])).ToList();
            return View(gioHangList);
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
