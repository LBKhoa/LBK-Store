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
    
    public partial class CHITIETHOADON
    {
        public int IDHD { get; set; }
        public string IDSP { get; set; }
        public byte SL { get; set; }
    
        public virtual HOADON HOADON { get; set; }
        public virtual SANPHAM SANPHAM { get; set; }
    }
}
