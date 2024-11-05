using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class CHITIETGIOHANGs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: CHITIETGIOHANGs_63134331
        public ActionResult Index()
        {
            var cHITIETGIOHANG = db.CHITIETGIOHANG.Include(c => c.KHACHHANG).Include(c => c.SANPHAM);
            return View(cHITIETGIOHANG.ToList());
        }

        // GET: CHITIETGIOHANGs_63134331/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETGIOHANG cHITIETGIOHANG = db.CHITIETGIOHANG.Find(id);
            if (cHITIETGIOHANG == null)
            {
                return HttpNotFound();
            }
            return View(cHITIETGIOHANG);
        }

        // GET: CHITIETGIOHANGs_63134331/Create
        public ActionResult Create()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH");
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP");
            return View();
        }

        // POST: CHITIETGIOHANGs_63134331/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "SDTKH,IDSP,SL")] CHITIETGIOHANG cHITIETGIOHANG)
        {
            if (Session["ID"] == null || cHITIETGIOHANG.SDTKH == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            if (ModelState.IsValid)
            {
                CHITIETGIOHANG check_CTGH = db.CHITIETGIOHANG.Find(cHITIETGIOHANG.SDTKH, cHITIETGIOHANG.IDSP);
                if (check_CTGH != null)
                {
                    // Nếu chi tiết giỏ hàng đã tồn tại, tăng số lượng sản phẩm lên 1
                    check_CTGH.SL++;
                    db.Entry(check_CTGH).State = EntityState.Modified;
                    db.SaveChanges();
                }
                else
                {
                    // Nếu chi tiết giỏ hàng không tồn tại, tạo mới
                    db.CHITIETGIOHANG.Add(cHITIETGIOHANG);
                    db.SaveChanges();
                    // Cập nhật lại số lượng sản phẩm trong giỏ hàng
                    Session["SLSP"] = int.Parse(Session["SLSP"].ToString()) + 1;
                }
                return RedirectToAction("GioHang", "KHACHHANGs_63134331");
            }
            ModelState.AddModelError("", "Có lỗi xảy ra khi thêm vào giỏ hàng.");

            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH", cHITIETGIOHANG.SDTKH);
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP", cHITIETGIOHANG.IDSP);
            return View(cHITIETGIOHANG);
        }

        // GET: CHITIETGIOHANGs_63134331/Edit/5
        public ActionResult Edit(string sdt, string idsp)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (sdt == null || idsp == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETGIOHANG cHITIETGIOHANG = db.CHITIETGIOHANG.Find(sdt, idsp);
            if (cHITIETGIOHANG == null)
            {
                return HttpNotFound();
            }
            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH", cHITIETGIOHANG.SDTKH);
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP", cHITIETGIOHANG.IDSP);
            return View(cHITIETGIOHANG);
        }

        // POST: CHITIETGIOHANGs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "SDTKH,IDSP,SL")] CHITIETGIOHANG cHITIETGIOHANG)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (ModelState.IsValid)
            {
                db.Entry(cHITIETGIOHANG).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.SDTKH = new SelectList(db.KHACHHANG, "SDTKH", "HOTENKH", cHITIETGIOHANG.SDTKH);
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP", cHITIETGIOHANG.IDSP);
            return View(cHITIETGIOHANG);
        }

        // GET: CHITIETGIOHANGs_63134331/Delete/5
        public ActionResult Delete(string sdtkh, string idsp)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            if (sdtkh == null || idsp == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            CHITIETGIOHANG cHITIETGIOHANG = db.CHITIETGIOHANG.FirstOrDefault(c => c.SDTKH == sdtkh && c.IDSP == idsp);
            if (cHITIETGIOHANG == null)
            {
                return HttpNotFound();
            }

            return View(cHITIETGIOHANG);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string sdtkh, string idsp)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");

            try
            {
                CHITIETGIOHANG cHITIETGIOHANG = db.CHITIETGIOHANG.FirstOrDefault(c => c.SDTKH == sdtkh && c.IDSP == idsp);
                if (cHITIETGIOHANG == null)
                {
                    return HttpNotFound();
                }

                db.CHITIETGIOHANG.Remove(cHITIETGIOHANG);
                Session["SLSP"] = int.Parse(Session["SLSP"].ToString()) - 1;
                db.SaveChanges();

                return RedirectToAction("GioHang", "KHACHHANGs_63134331");
            }
            catch (Exception)
            {
                // Handle the exception or log the error
                return RedirectToAction("GioHang", "KHACHHANGs_63134331"); // Redirect to an error page or display an error message
            }
        }


        [HttpPost]
        public ActionResult UpdateCart(string sdtkh, string idsp, byte soluong)
        {
            // Tìm sản phẩm trong CHITIETGIOHANG dựa trên sdtkh và idsp
            CHITIETGIOHANG item = db.CHITIETGIOHANG.FirstOrDefault(i => i.SDTKH == sdtkh && i.IDSP == idsp);

            SANPHAM product = db.SANPHAM.FirstOrDefault(p => p.IDSP == idsp);

            if (item != null && product != null && soluong <= product.SOLUONG)
            {
                // Cập nhật số lượng sản phẩm
                item.SL = soluong;

                // Lưu thông tin cập nhật vào cơ sở dữ liệu
                db.SaveChanges();

                return Json(new { Success = true });
            }
            return Json(new { Success = false, ErrorMessage = "Số lượng chọn vượt quá số lượng hiện có." });
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
