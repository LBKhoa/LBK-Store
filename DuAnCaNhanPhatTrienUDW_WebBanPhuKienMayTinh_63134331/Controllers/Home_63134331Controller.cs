using DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Data.Entity;
using System.Net;



namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Controllers
{
    public class Home_63134331Controller : Controller
    {
        private Project_63134331Entities db = new Project_63134331Entities();

        // GET: SANPHAMs_63134331
        public ActionResult Index(string loaiSanPham)
        {
            if (Convert.ToString(Session["ID"]).Contains("NV"))
                return RedirectToAction("Admin", "Home_63134331");


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

        public ActionResult Admin()
        {

            if (Session["Quyen"] != null && XACTHUCs_63134331Controller.xacDinhQuyen(Session["Quyen"].ToString()) != 2)
            {
                if (Session["ID"] == null)
                    return RedirectToAction("DangNhap", "XACTHUCs_63134331");

                return View();
            }
            else
            {
                return RedirectToAction("Loi404", "XACTHUCs_63134331");
            }
        }
    }
}