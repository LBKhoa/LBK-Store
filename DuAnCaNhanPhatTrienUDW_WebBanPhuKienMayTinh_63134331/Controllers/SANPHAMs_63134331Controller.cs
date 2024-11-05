using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class SANPHAMs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: SANPHAMs_63134331
        public ActionResult Index(string loaiSanPham)
        {
            var sANPHAM = db.SANPHAM
                .Include(s => s.LOAISANPHAM)
                .Include(s => s.NHACUNGCAP);

            if (!string.IsNullOrEmpty(loaiSanPham))
            {
                sANPHAM = sANPHAM.Where(s => s.IDLSP == loaiSanPham);
                ViewBag.LoaiSanPham = db.LOAISANPHAM.FirstOrDefault(l => l.IDLSP == loaiSanPham)?.TENLSP;
            }

            return View(sANPHAM.ToList());
        }
        public ActionResult Index1(string IDSP = "", string TENSP = "", string GIASPMIN = "", string GIASPMAX = "", string SOLUONG = "", string BH = "", string IMGSP = "")
        {
            if (Session["ID"] == null || !Session["ID"].ToString().Contains("NV"))
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            string min = GIASPMIN, max = GIASPMAX;
            ViewBag.IDSP = IDSP;
            ViewBag.TENSP = TENSP;

            if (GIASPMIN == "")
            {
                ViewBag.GIASPMIN = "";
                min = "0";
            }
            else
            {
                ViewBag.GIASPMIN = GIASPMIN;
                min = GIASPMIN;
            }
            if (max == "")
            {
                max = Int32.MaxValue.ToString();
                ViewBag.GIASPMAX = "";
            }
            else
            {
                ViewBag.GIASPMAX = GIASPMAX;
                max = GIASPMAX;
            }
            ViewBag.SOLUONG = SOLUONG;
            ViewBag.BH = BH;
            ViewBag.IMGSP = IMGSP;
            int giaMin;
            int giaMax;
            if (GIASPMIN == "")
            {
                giaMin = 0;
            }
            else
            {
                giaMin = Int32.Parse(GIASPMIN);
            }
            if (GIASPMAX == "")
            {
                giaMax = Int32.MaxValue;
            }
            else
            {
                giaMax = Int32.Parse(GIASPMAX);
            }
            var sanPhams = db.SANPHAM.ToList();
            if (IDSP != "" || TENSP != "" || GIASPMIN != "" || GIASPMAX != "")
            {
                sanPhams = db.SANPHAM.Where(sp => sp.IDSP.Contains(IDSP) && sp.TENSP.Contains(TENSP) && giaMin <= sp.GIASP && sp.GIASP <= giaMax).ToList();
            }
            //var sanPhams = db.SANPHAM.SqlQuery("SanPham_TimKiem'" + IDSP + "',N'" + TENSP + "','" + min + "','" + max + "','" + SOLUONG + "','" + BH + "','" + IMGSP + "'");
            if (sanPhams.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(sanPhams);
        }


        // GET: SANPHAMs_63134331/Details/5
        public ActionResult Details(string id)
        {

            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SANPHAM sANPHAM = db.SANPHAM.Find(id);
            if (sANPHAM == null)
            {
                return HttpNotFound();
            }
            return View(sANPHAM);
        }
        private string taoMaSP()
        {

            string maSanPhamLonNhat = db.SANPHAM
                .OrderByDescending(sp => sp.IDSP)
                .Select(sp => sp.IDSP)
                .FirstOrDefault();

            int soThuTu = 1;
            if (!string.IsNullOrEmpty(maSanPhamLonNhat))
            {
                string soThuTuStr = maSanPhamLonNhat.Substring(2);
                int.TryParse(soThuTuStr, out soThuTu);
                soThuTu++;
            }

            return string.Format("SP{0:D4}", soThuTu);

        }

        // GET: SANPHAMs_63134331/Create
        public ActionResult Create()
        {
            ViewBag.IDLSP = new SelectList(db.LOAISANPHAM, "IDLSP", "TENLSP");
            ViewBag.IDNCC = new SelectList(db.NHACUNGCAP, "IDNCC", "TENNCC");
            return View();
        }

        // POST: SANPHAMs_63134331/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(HttpPostedFileBase IMG, HttpPostedFileBase HTML, [Bind(Include = "IDSP,TENSP,IMGSP,GIASP,SOLUONG,BH,TSKT,IDNCC,IDLSP")] SANPHAM sANPHAM)
        {
            sANPHAM.IDSP = taoMaSP();

            string nameIMG = System.IO.Path.GetFileName(IMG.FileName);
            // Lưu hình đại diện về Server
            string extension = Path.GetExtension(nameIMG);
            string newNameImg = sANPHAM.IDSP + extension;
            var path = Server.MapPath("~/assets/images/" + newNameImg);
            sANPHAM.IMGSP = Url.Content("~/assets/images/" + newNameImg); // Tạo đường dẫn tương đối
            IMG.SaveAs(path);

            string nameHTML = System.IO.Path.GetFileName(HTML.FileName);
            // Lưu hình đại diện về Server
            extension = Path.GetExtension(nameHTML);
            string newNameHTML = sANPHAM.IDSP + extension;
            path = Server.MapPath("~/assets/html/TSKT/" + newNameHTML);
            sANPHAM.TSKT = Url.Content("~/assets/html/TSKT/" + newNameHTML); // Tạo đường dẫn tương đối
            HTML.SaveAs(path);

            Debug.Print(sANPHAM.IMGSP);

            if (ModelState.IsValid)
            {
                db.SANPHAM.Add(sANPHAM);
                db.SaveChanges();
                return RedirectToAction("Index1");
            }

            ViewBag.IDLSP = new SelectList(db.LOAISANPHAM, "IDLSP", "TENLSP", sANPHAM.IDLSP);
            ViewBag.IDNCC = new SelectList(db.NHACUNGCAP, "IDNCC", "TENNCC", sANPHAM.IDNCC);
            return View(sANPHAM);
        }


        // GET: SANPHAMs_63134331/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SANPHAM sANPHAM = db.SANPHAM.Find(id);
            if (sANPHAM == null)
            {
                return HttpNotFound();
            }
            ViewBag.IDLSP = new SelectList(db.LOAISANPHAM, "IDLSP", "TENLSP", sANPHAM.IDLSP);
            ViewBag.IDNCC = new SelectList(db.NHACUNGCAP, "IDNCC", "TENNCC", sANPHAM.IDNCC);
            return View(sANPHAM);
        }

        // POST: SANPHAMs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(HttpPostedFileBase IMG, HttpPostedFileBase HTML, [Bind(Include = "IDSP,TENSP,IMGSP,GIASP,SOLUONG,BH,TSKT,IDNCC,IDLSP")] SANPHAM sANPHAM)
        {
            string nameIMG = System.IO.Path.GetFileName(IMG.FileName);
            // Lưu hình đại diện về Server
            string extension = Path.GetExtension(nameIMG);
            string newNameImg = sANPHAM.IDSP + extension; // Tên tệp tin mới
            var path = Server.MapPath("~/assets/images/" + newNameImg);
            sANPHAM.IMGSP = Url.Content("~/assets/images/" + newNameImg); // Tạo đường dẫn tương đối
            IMG.SaveAs(path);

            string nameHTML = System.IO.Path.GetFileName(HTML.FileName);
            // Lưu hình đại diện về Server
            extension = Path.GetExtension(nameHTML);
            string newNameHTML = sANPHAM.IDSP + extension; // Tên tệp tin mới
            path = Server.MapPath("~/assets/html/TSKT/" + newNameHTML);
            sANPHAM.TSKT = Url.Content("~/assets/html/TSKT/" + newNameHTML); // Tạo đường dẫn tương đối
            HTML.SaveAs(path);
            Debug.Print(sANPHAM.IMGSP);

            if (ModelState.IsValid)
            {
                db.Entry(sANPHAM).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index1");
            }
            ViewBag.IDLSP = new SelectList(db.LOAISANPHAM, "IDLSP", "TENLSP", sANPHAM.IDLSP);
            ViewBag.IDNCC = new SelectList(db.NHACUNGCAP, "IDNCC", "TENNCC", sANPHAM.IDNCC);
            return View(sANPHAM);
        }

        // GET: SANPHAMs_63134331/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SANPHAM sANPHAM = db.SANPHAM.Find(id);
            if (sANPHAM == null)
            {
                return HttpNotFound();
            }
            return View(sANPHAM);
        }

        // POST: SANPHAMs_63134331/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            SANPHAM sANPHAM = db.SANPHAM.Find(id);
            db.SANPHAM.Remove(sANPHAM);
            db.SaveChanges();
            return RedirectToAction("Index1");
        }

        public ActionResult Search(string productName)
        {
            var result = db.SANPHAM.Where(s => s.TENSP.Contains(productName)).OrderBy(s => s.GIASP).ToList();
            ViewBag.TuKhoa = productName;
            return View(result);
        }
        public ActionResult SearchNC(string productName, int minPrice = 0, int maxPrice = int.MaxValue, string manufacturer = "", string productType = "")
        {
            var query = db.SANPHAM.Where(s => s.TENSP.Contains(productName));

            query = query.Where(s => s.GIASP >= minPrice && s.GIASP <= maxPrice);

            if (!string.IsNullOrEmpty(manufacturer))
            {
                query = query.Where(s => s.NHACUNGCAP.TENNCC.Contains(manufacturer));
            }

            if (!string.IsNullOrEmpty(productType))
            {
                query = query.Where(s => s.LOAISANPHAM.TENLSP.Contains(productType));
            }

            var result = query.OrderBy(s => s.GIASP).ToList();

            ViewBag.TuKhoa = productName;
            ViewBag.MinPrice = minPrice;
            ViewBag.MaxPrice = maxPrice;
            ViewBag.Manufacturer = manufacturer;
            ViewBag.ProductType = productType;

            return View(result);
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
