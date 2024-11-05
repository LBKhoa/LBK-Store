using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;
using System.Security.Cryptography;
using System.Text;


namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class NHANVIENs_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: NHANVIENs_63134331
        public ActionResult Index(string IDNV = "", string HOTENNV = "", string SDTNV = "", string EMAILNV = "", string DIACHINV = "")
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            ViewBag.IDNV = IDNV;
            ViewBag.HOTENNV = HOTENNV;
            ViewBag.SDTNV = SDTNV;
            ViewBag.EMAILNV = EMAILNV;
            ViewBag.DIACHINV = DIACHINV;
            var nhanViens = db.NHANVIEN.ToList();
            if (IDNV != "" || HOTENNV != "" || SDTNV != "" || EMAILNV != "" || DIACHINV != "")
            {
                nhanViens = db.NHANVIEN.Where(nv => nv.IDNV.Contains(IDNV) && nv.HOTENNV.Contains(HOTENNV) && nv.SDTNV.Contains(SDTNV) && nv.EMAILNV.Contains(EMAILNV) && nv.DIACHINV.Contains(DIACHINV)).ToList();
            }
            //var nhanViens = db.NHANVIEN.SqlQuery("NhanVien_TimKiem'" + IDNV + "','" + HOTENNV + "','" + SDTNV + "','" + EMAILNV + "', N'" + DIACHINV + "'");
            if (nhanViens.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(nhanViens);
        }

        // GET: NHANVIENs_63134331/Details/5
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
            NHANVIEN nHANVIEN = db.NHANVIEN.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // GET: NHANVIENs_63134331/Create
        public ActionResult Create()
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null" || Convert.ToBoolean(Session["Quyen"]) == false)
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            return View();
        }

        // POST: NHANVIENs_63134331/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "IDNV,HOTENNV,SDTNV,DIACHINV,EMAILNV,PASSNV,QUYEN")] NHANVIEN nHANVIEN)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (ModelState.IsValid)
            {
                // Chuyển đổi mật khẩu sang MD5
                string md5Password = GetMd5Hash(nHANVIEN.PASSNV);
                nHANVIEN.PASSNV = md5Password;

                // Lấy danh sách tất cả mã nhân viên từ cơ sở dữ liệu
                List<string> employeeCodes = db.NHANVIEN.Select(e => e.IDNV).ToList();

                // Sắp xếp danh sách theo thứ tự giảm dần
                employeeCodes.Sort((x, y) => string.Compare(y, x));

                // Lấy mã nhân viên lớn nhất
                string maxEmployeeCode = employeeCodes.FirstOrDefault();

                // Tạo mã nhân viên mới
                string newEmployeeCode = GenerateNextEmployeeCode(maxEmployeeCode);

                // Gán mã nhân viên mới cho đối tượng NHANVIEN
                nHANVIEN.IDNV = newEmployeeCode;

                db.NHANVIEN.Add(nHANVIEN);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(nHANVIEN);
        }

        private string GenerateNextEmployeeCode(string maxEmployeeCode)
        {
            // Xác định số thứ tự từ mã nhân viên lớn nhất
            int sequence = int.Parse(maxEmployeeCode.Substring(2)) + 1;

            // Tạo mã nhân viên mới
            string newEmployeeCode = "NV" + sequence.ToString("D4");

            return newEmployeeCode;
        }


        private string GetMd5Hash(string input)
        {
            using (MD5 md5 = MD5.Create())
            {
                byte[] inputBytes = Encoding.UTF8.GetBytes(input);
                byte[] hashBytes = md5.ComputeHash(inputBytes);

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < hashBytes.Length; i++)
                {
                    sb.Append(hashBytes[i].ToString("x2"));
                }

                return sb.ToString();
            }
        }


        // GET: NHANVIENs_63134331/Edit/5
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
            NHANVIEN nHANVIEN = db.NHANVIEN.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // POST: NHANVIENs_63134331/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "IDNV,HOTENNV,SDTNV,DIACHINV,EMAILNV,PASSNV,QUYEN")] NHANVIEN nHANVIEN)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");

            string hashedPassword = "";
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(nHANVIEN.PASSNV));
                foreach (byte b in bytes)
                {
                    hashedPassword += b.ToString("x2");
                }
            }
            nHANVIEN.PASSNV = hashedPassword;

            if (ModelState.IsValid)
            {
                db.Entry(nHANVIEN).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(nHANVIEN);
        }

        // GET: NHANVIENs_63134331/Delete/5
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
            NHANVIEN nHANVIEN = db.NHANVIEN.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // POST: NHANVIENs_63134331/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            if (Session["ID"] == null)
                return RedirectToAction("DangNhap", "XACTHUCs_63134331");
            if (Session["Quyen"].ToString() == "null")
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            NHANVIEN nHANVIEN = db.NHANVIEN.Find(id);
            db.NHANVIEN.Remove(nHANVIEN);
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
