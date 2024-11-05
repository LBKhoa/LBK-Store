using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class CHITIETHOADONs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: CHITIETHOADONs_63134331
        public ActionResult Index()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            var cHITIETHOADON = db.CHITIETHOADON.Include(c => c.HOADON).Include(c => c.SANPHAM);
            return View(cHITIETHOADON.ToList());
        }

        // GET: CHITIETHOADONs_63134331/Details/5
        public ActionResult Details(int? id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETHOADON cHITIETHOADON = db.CHITIETHOADON.Find(id);
            if (cHITIETHOADON == null)
            {
                return HttpNotFound();
            }
            return View(cHITIETHOADON);
        }

        // GET: CHITIETHOADONs_63134331/Create
        public ActionResult Create()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            ViewBag.IDHD = new SelectList(db.HOADON, "IDHD", "TINHTRANG");
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP");
            return View();
        }

        // POST: CHITIETHOADONs_63134331/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "IDHD,IDSP,SL")] CHITIETHOADON cHITIETHOADON)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (ModelState.IsValid)
            {
                db.CHITIETHOADON.Add(cHITIETHOADON);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.IDHD = new SelectList(db.HOADON, "IDHD", "TINHTRANG", cHITIETHOADON.IDHD);
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP", cHITIETHOADON.IDSP);
            return View(cHITIETHOADON);
        }

        // GET: CHITIETHOADONs_63134331/Edit/5
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
            CHITIETHOADON cHITIETHOADON = db.CHITIETHOADON.Find(id);
            if (cHITIETHOADON == null)
            {
                return HttpNotFound();
            }
            ViewBag.IDHD = new SelectList(db.HOADON, "IDHD", "TINHTRANG", cHITIETHOADON.IDHD);
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP", cHITIETHOADON.IDSP);
            return View(cHITIETHOADON);
        }

        // POST: CHITIETHOADONs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "IDHD,IDSP,SL")] CHITIETHOADON cHITIETHOADON)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (ModelState.IsValid)
            {
                db.Entry(cHITIETHOADON).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.IDHD = new SelectList(db.HOADON, "IDHD", "TINHTRANG", cHITIETHOADON.IDHD);
            ViewBag.IDSP = new SelectList(db.SANPHAM, "IDSP", "TENSP", cHITIETHOADON.IDSP);
            return View(cHITIETHOADON);
        }

        // GET: CHITIETHOADONs_63134331/Delete/5
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
            CHITIETHOADON cHITIETHOADON = db.CHITIETHOADON.Find(id);
            if (cHITIETHOADON == null)
            {
                return HttpNotFound();
            }
            return View(cHITIETHOADON);
        }

        // POST: CHITIETHOADONs_63134331/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            CHITIETHOADON cHITIETHOADON = db.CHITIETHOADON.Find(id);
            db.CHITIETHOADON.Remove(cHITIETHOADON);
            db.SaveChanges();
            return RedirectToAction("Index");
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
