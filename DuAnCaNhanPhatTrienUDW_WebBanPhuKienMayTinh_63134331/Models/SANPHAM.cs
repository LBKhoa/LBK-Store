//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DuAnCaNhanPhatTrienUDW_WebBanPhuKienMayTinh_63134331.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class SANPHAM
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SANPHAM()
        {
            this.CHITIETGIOHANG = new HashSet<CHITIETGIOHANG>();
            this.CHITIETHOADON = new HashSet<CHITIETHOADON>();
        }
    
        public string IDSP { get; set; }
        public string TENSP { get; set; }
        public string IMGSP { get; set; }
        public int GIASP { get; set; }
        public int SOLUONG { get; set; }
        public string BH { get; set; }
        public string TSKT { get; set; }
        public string IDNCC { get; set; }
        public string IDLSP { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CHITIETGIOHANG> CHITIETGIOHANG { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CHITIETHOADON> CHITIETHOADON { get; set; }
        public virtual LOAISANPHAM LOAISANPHAM { get; set; }
        public virtual NHACUNGCAP NHACUNGCAP { get; set; }
    }
}
