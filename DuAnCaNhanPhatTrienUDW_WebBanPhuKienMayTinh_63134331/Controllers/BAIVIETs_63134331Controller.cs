using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.HtmlControls;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class BAIVIETs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: BAIVIETs_63134331Controller
        public ActionResult Index()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            return View(db.BAIVIET.ToList());
        }
        public ActionResult Index1()
        {
            var danhSachBaiVietNgoc = db.BAIVIET.OrderByDescending(b => b.IDBV).ToList();
            return View(danhSachBaiVietNgoc);
        }

        // GET: BAIVIETs_63134331Controller/Details/5
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
            BAIVIET bAIVIET = db.BAIVIET.Find(id);
            if (bAIVIET == null)
            {
                return HttpNotFound();
            }
            return View(bAIVIET);
        }

        private string taoMaBV()
        {
            string maBVmax = db.BAIVIET
                .OrderByDescending(sp => sp.IDBV)
                .Select(sp => sp.IDBV)
                .FirstOrDefault();
            int soThuTu = 1;
            if (!string.IsNullOrEmpty(maBVmax))
            {
                string soThuTuStr = maBVmax.Substring(2);
                int.TryParse(soThuTuStr, out soThuTu);
                soThuTu++;
            }
            return string.Format("BV{0:D4}", soThuTu);
        }

        // GET: BAIVIETs_63134331Controller/Create
        public ActionResult Create()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            return View();
        }

        // POST: BAIVIETs_63134331Controllers/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "IDBV,TENBV,IMGBV,CHITIET")] BAIVIET bAIVIET, HttpPostedFileBase IMG, HttpPostedFileBase HTML)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            bAIVIET.IDBV = taoMaBV();

            if (ModelState.IsValid)
            {
                string nameIMG = System.IO.Path.GetFileName(IMG.FileName);
                // Lưu hình đại diện về Server
                string extension = Path.GetExtension(nameIMG);
                string newNameImg = bAIVIET.IDBV + extension;
                var path = Server.MapPath("~/assets/images/" + newNameImg);
                bAIVIET.IMGBV = Url.Content("~/assets/images/" + newNameImg); // Tạo đường dẫn tương đối
                IMG.SaveAs(path);

                string nameHTML = System.IO.Path.GetFileName(HTML.FileName);
                // Lưu hình đại diện về Server
                extension = Path.GetExtension(nameHTML);
                string newNameHTML = bAIVIET.IDBV + extension;
                path = Server.MapPath("~/assets/html/BV/" + newNameHTML);
                bAIVIET.CHITIET = Url.Content("~/assets/html/BV/" + newNameHTML); // Tạo đường dẫn tương đối
                HTML.SaveAs(path);

                db.BAIVIET.Add(bAIVIET);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(bAIVIET);
        }


        // GET: BAIVIETs_63134331Controller/Edit/5
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
            BAIVIET bAIVIET = db.BAIVIET.Find(id);
            if (bAIVIET == null)
            {
                return HttpNotFound();
            }
            return View(bAIVIET);
        }

        // POST: BAIVIETs_63134331Controller/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "IDBV,TENBV,IMGBV,CHITIET")] BAIVIET bAIVIET, HttpPostedFileBase IMG, HttpPostedFileBase HTML)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            if (ModelState.IsValid)
            {
                string nameIMG = System.IO.Path.GetFileName(IMG.FileName);
                // Lưu hình đại diện về Server
                string extension = Path.GetExtension(nameIMG);
                string newNameImg = bAIVIET.IDBV + extension;
                var path = Server.MapPath("~/assets/images/" + newNameImg);
                bAIVIET.IMGBV = Url.Content("~/assets/images/" + newNameImg); // Tạo đường dẫn tương đối
                IMG.SaveAs(path);

                string nameHTML = System.IO.Path.GetFileName(HTML.FileName);
                // Lưu hình đại diện về Server
                extension = Path.GetExtension(nameHTML);
                string newNameHTML = bAIVIET.IDBV + extension;
                path = Server.MapPath("~/assets/html/BV/" + newNameHTML);
                bAIVIET.CHITIET = Url.Content("~/assets/html/BV/" + newNameHTML); // Tạo đường dẫn tương đối
                HTML.SaveAs(path);


                db.Entry(bAIVIET).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(bAIVIET);
        }

        // GET: BAIVIETs_63134331Controller/Delete/5
        public ActionResult Delete(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            BAIVIET bAIVIET = db.BAIVIET.Find(id);
            if (bAIVIET == null)
            {
                return HttpNotFound();
            }
            return View(bAIVIET);
        }

        // POST: BAIVIETs_63134331Controller/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            BAIVIET bAIVIET = db.BAIVIET.Find(id);
            db.BAIVIET.Remove(bAIVIET);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public ActionResult XemBV(string idbv)
        {
            if (idbv == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            BAIVIET bv = db.BAIVIET.Find(idbv);
            if (bv == null)
            {
                return HttpNotFound();
            }
            return View(bv);
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
