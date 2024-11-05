using System.Web;
using System.Web.Mvc;

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
