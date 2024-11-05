use master 
drop database QLCHTBPKMT;
go

CREATE DATABASE Project_63134331;
--Cửa hàng kinh doanh thiết bị và phụ kiện máy tính
GO 
USE Project_63134331;
GO
CREATE TABLE NHANVIEN (
	IDNV CHAR(6) PRIMARY KEY NOT NULL	,
	HOTENNV NVARCHAR(50) NOT NULL,
	SDTNV CHAR(10) NOT NULL,
	DIACHINV NVARCHAR(100) NOT NULL,
	EMAILNV VARCHAR(50) NOT NULL, 
	PASSNV TEXT NOT NULL,
	QUYEN BIT DEFAULT 0, -- mặc định là nhân viên xử lý
);
CREATE TABLE KHACHHANG (
	HOTENKH NVARCHAR(50) NOT NULL,
	DIACHIKH NVARCHAR(100),
	EMAILKH VARCHAR(50) NOT NULL,
	SDTKH CHAR(10) PRIMARY KEY NOT NULL,
	PASSKH TEXT NOT NULL,
);

CREATE TABLE LOAISANPHAM (
	IDLSP CHAR(6) PRIMARY KEY NOT NULL,
	TENLSP NVARCHAR(50) NOT NULL,
);
CREATE TABLE NHACUNGCAP (
	IDNCC CHAR(6) PRIMARY KEY NOT NULL,
	TENNCC NVARCHAR(50) NOT NULL,
	EMAILNCC VARCHAR(50),
	DIACHINCC NVARCHAR(100),
	SDTNCC CHAR(11),
);
CREATE TABLE SANPHAM (
	IDSP CHAR(6) PRIMARY KEY NOT NULL,
	TENSP NVARCHAR(150) NOT NULL,
	IMGSP TEXT NOT NULL,
	GIASP INT NOT NULL,
	SOLUONG INT NOT NULL,
	BH NVARCHAR(8) NOT NULL, --thời gian bảo hành của sản phẩm
	TSKT TEXT NOT NULL, --đường dẫn file html
	IDNCC CHAR(6) NOT NULL,
	IDLSP CHAR(6) NOT NULL,
	CONSTRAINT FK_SP_NCC FOREIGN KEY (IDNCC) REFERENCES NHACUNGCAP (IDNCC),
	CONSTRAINT FK_SP_LSP FOREIGN KEY (IDLSP) REFERENCES LOAISANPHAM (IDLSP),
);

CREATE TABLE HOADON (
	IDHD INT PRIMARY KEY NOT NULL,
	NDAT DATE NOT NULL, -- ngày đặt
	NGIAO DATE NULL, --ngày giao
	TINHTRANG NVARCHAR(20) NOT NULL,
	SDTKH CHAR(10) NOT NULL,
	IDNV CHAR(6) NOT NULL,
	HOTENNN NVARCHAR(50) NOT NULL,		--THÔNG TIN NGƯỜI NHẬN
	SDTNN CHAR(10) NOT NULL,
	DIACHINN NVARCHAR(100) NOT NULL,
	CONSTRAINT FK_HD_KH FOREIGN KEY (SDTKH) REFERENCES KHACHHANG (SDTKH),
	CONSTRAINT FK_HD_NV FOREIGN KEY (IDNV) REFERENCES NHANVIEN(IDNV),
);
CREATE TABLE CHITIETHOADON (
	IDHD INT NOT NULL,
	IDSP CHAR(6) NOT NULL,
	SL TINYINT NOT NULL,
	PRIMARY KEY(IDHD, IDSP),
	CONSTRAINT FK_CTHD_HD FOREIGN KEY (IDHD) REFERENCES HOADON (IDHD),
	CONSTRAINT FK_CTHD_SP FOREIGN KEY (IDSP) REFERENCES SANPHAM (IDSP),
);
CREATE TABLE CHITIETGIOHANG (
	SDTKH CHAR(10) NOT NULL,
	IDSP CHAR(6) NOT NULL,
	SL TINYINT NOT NULL,
	PRIMARY KEY(SDTKH, IDSP),
	CONSTRAINT FK_CTGH_KH FOREIGN KEY (SDTKH) REFERENCES KHACHHANG (SDTKH),
	CONSTRAINT FK_CTGH_SP FOREIGN KEY (IDSP) REFERENCES SANPHAM (IDSP),
);
CREATE TABLE BAIVIET (
	IDBV CHAR(6) PRIMARY KEY NOT NULL,
	TENBV NVARCHAR(100),
	IMGBV VARCHAR(100),
	CHITIET VARCHAR(100)
);


INSERT INTO NHANVIEN (IDNV, HOTENNV, SDTNV, DIACHINV, EMAILNV, PASSNV, QUYEN) VALUES
(N'NV0001', N'Trang Thành Châu Ngân', '0924494136', N'Xã Trà Vân, Huyện Nam Trà My, Quảng Nam', 'trangthanhchau172@hotmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0002', N'Nguyễn Thị Thúy Vy', '0585884851', N'Xã Hòa Lễ, Huyện Krông Bông, Đắk Lắk', 'xathuyvy384@microsoft.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0003', N'Lò Xuân Cao Văn', '0354850724', N'Xã Minh Ngọc, Huyện Bắc Mê, Hà Giang', 'loxuancao848@yahoo.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0004', N'Dư Quốc Trung Dân', '0832965927', N'Phường Long Hưng, Thị xã Tân Châu, An Giang', 'duquoctrung381@facebook.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0005', N'Thoa Tân Phước Vinh', '0377277862', N'Xã Đại Chánh, Huyện Đại Lộc, Quảng Nam', 'thoatanphuoc989@google.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0006', N'Duy Vy Lan', '0943363572', N'Xã An Đồng, Huyện Quỳnh Phụ, Thái Bình', 'duyvylan273@icloud.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0007', N'Bì Quang Sáng', '0973929405', N'Thị trấn Bảy Ngàn, Huyện Châu Thành A, Hậu Giang', 'biquangsang871@facebook.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0008', N'Hàng Quỳnh Ngân', '0349545964', N'Phường Hiệp Tân, Quận Tân Phú, Hồ Chí Minh', 'hangquynhngan376@gmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0009', N'Trang Ðại Ngọc', '0899381247', N'Xã Vĩnh Hòa, Huyện Vĩnh Thạnh, Bình Định', 'trangaingoc56@naver.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0010', N'Nghị Liên Phương', '0912406442', N'Xã Nậm Chua, Huyện Nậm Pồ, Điện Biên', 'nghilienphuong700@naver.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0012', N'Hoa Viết Sơn', '0359338213', N'Phường 4, Thành phố Tân An, Long An', 'hoavietson178@hotmail.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0011', N'Kim Hạ Vy', '0332190003', N'Xã Tân Phú, Huyện Tân Châu, Tây Ninh', 'kimhavy452@facebook.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0013', N'Liễu Quang Thịnh', '0924079483', N'Phường Quang Trung, Thành phố Hải Dương, Hải Dương', 'lieuquangthinh413@gmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0014', N'Lèng Yến Thanh', '0334001701', N'Xã Khang Ninh, Huyện Ba Bể, Bắc cạn', 'lengyenthanh861@icloud.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0015', N'Lyly Lệ Quân', '0339748502', N'Xã Thanh Vân, Huyện Tam Dương, Vĩnh Phúc', 'lylylequan949@microsoft.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0016', N'Tinh Thái Hồng', '0982819276', N'Xã Nậm Nèn, Huyện Mường Chà, Điện Biên', 'tthong@hotmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0017', N'Quán Phúc Cường', '0327029665', N'Xã Phước Quang, Huyện Tuy Phước, Bình Định', 'quanphuccuong309@microsoft.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0018', N'Lý Thanh Nguyên', '0915778419', N'Xã Thượng Nông, Huyện Nà Hang, Tuyên Quang', 'lythanhnguyen719@facebook.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0019', N'Hà Thu Duyên', '0869340947', N'Xã Giao Nhân, Huyện Giao Thủy, Nam Định', 'hathuduyen79@google.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0020', N'Hi Thư Lâm', '0346015510', N'Thị trấn Tằng Loỏng, Huyện Bảo Thắng, Lào Cai', 'hithulam304@naver.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0021', N'Hoa Ðại Thống', '0332792325', N'Xã Ia Pia, Huyện Chư Prông, Gia Lai', 'hoaaithong502@hotmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0022', N'Trà Bạch Kim', '0523569234', N'Xã Lạc Quới, Huyện Tri Tôn, An Giang', 'trabachkim109@hotmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0023', N'Lê Hương Trang', '0786016361', N'Xã Vinh An, Huyện Phú Vang, Thừa Thiên Huế', 'lehuongtrang63@google.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0024', N'Cao Xuân Khoa', '0522610921', N'Phường An Hòa, Thành phố Huế, Thừa Thiên Huế', 'caoxuankhoa49@google.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0025', N'Giàng Minh Tiến', '0348561767', N'Xã Tân Hưng, Huyện Bàu Bàng, Bình Dương', 'giangminhtien273@hotmail.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0026', N'Vương Trường Nhân', '0365925082', N'Xã Hợp Châu, Huyện Tam Đảo, Vĩnh Phúc', 'vuongtruongnhan804@hotmail.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0027', N'Mai Huyền Trang', '0339006414', N'Xã An Thành, Huyện Đăk Pơ, Gia Lai', 'maihuyentrang50@icloud.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0028', N'Hạ Tuệ Lâm', '0944406811', N'Xã Kỳ Hoa, Thị xã Kỳ Anh, Hà Tĩnh', 'hatuelam180@google.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0029', N'Ngân Quỳnh Tiên', '0948125854', N'Phường Đức Thuận, Thị xã Hồng Lĩnh, Hà Tĩnh', 'nganquynhtien20@microsoft.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0030', N'Phó Thanh Quang', '0358530630', N'Xã Bình Khê, Thị xã Đông Triều, Quảng Ninh', 'phothanhquang546@microsoft.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0031', N'Trần Hữu Nghĩa', '0927127468', N'Xã Nậm Tỵ, Huyện Hoàng Su Phì, Hà Giang', 'hmahuunghia526@gmail.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0032', N'Hà Thu Loan', '0797369422', N'Xã Minh Tân, Huyện Kiến Thuỵ, Hải Phòng', 'Xã Minh Tân, Huyện Kiến Thuỵ, Hải Phòng', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0033', N'Khoa Tường Minh', '0794613319', N'Xã A Vao, Huyện Đa Krông, Quảng Trị', 'khoatuongminh569@facebook.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0034', N'Hầu Gia Nghị', '0981957057', N'Xã Lai Hưng, Huyện Bàu Bàng, Bình Dương', 'haugianghi50@facebook.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0035', N'Trình Lan Khuê', '0377678282', N'Xã Lộc Tiến, Huyện Phú Lộc, Thừa Thiên Huế', 'trinhlankhue471@naver.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0036', N'Dương Ngọc Ðoàn', '0823704751', N'Xã Phước Thái, Huyện Ninh Phước, Ninh Thuận', 'duongngocoan582@google.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0037', N'Sơn Thanh Loan', '0968672690', N'Xã Hồng Định, Huyện Quảng Uyên, Cao Bằng', 'sonthanhloan885@facebook.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0038', N'Phương An Di', '0869147372', N'Phường Hòa Bình, Thành phố Biên Hòa, Đồng Nai', 'phuongandi850@yahoo.com', 'cfe85c77d0fa842d9d18a4492e0128c8c4f3c3dc0e20a746a9fcdd939b2b98d9', '0'),
(N'NV0039', N'Ông Duy Ngôn', '0963506325', N'Xã Đồng Tiến, Huyện Cô Tô, Quảng Ninh', 'ongduyngon685@facebook.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0040', N'Quang Tường Vinh', '0359868993', N'Xã An Thạnh 1, Huyện Cù Lao Dung, Sóc Trăng', 'quangtuongvinh890@icloud.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1'),
(N'NV0041', N'Online', '0123456789', N'Online', 'online@icloud.com', '5f9ece2a76bede5c60e0ecfe6cf3289f381afb4a6ad619e77f78c0646105a840', '1');


INSERT INTO KHACHHANG (HOTENKH, DIACHIKH, EMAILKH, SDTKH, PASSKH) VALUES
(N'Ngạc Quang Ninh', N' Huyện Phù Yên, Sơn La', 'ngacquangninh162@hotmail.com', '0384139028', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Điền Phương Nghi', N'Xã Ea Ning, Huyện Cư Kuin, Đắc Lắc', 'dienphuongnghi852@naver.com', '0373247968', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Thế Mỹ Thuận', N'Phường Hạ Lý, Quận Hồng Bàng, Hải Phòng', 'themythuan710@naver.com', '0884953270', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Bình Minh Hằng', N'Phường Nghi Hải, Thị xã Cửa Lò, Nghệ An', 'binhminhhang949@yahoo.com', '0332431670', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Khiếu Hoàn Vi', N'Xã Tường Phù, Huyện Phù Yên, Sơn La', 'khieuhoanvi323@naver.com', '0796217389', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Biện Bá Thành', N'Xã Vĩnh Trạch, Thành phố Bạc Liêu, Bạc Liêu', 'bienbathanh767@yahoo.com', '0354071965', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Cầm Duy Luận', N'Thị Trấn Ngã Sáu, Huyện Châu Thành, Hậu Giang', 'camduyluan301@google.com', '0394503281', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Huỳnh Lệ Nhi', N'Xã Việt Hưng, Huyện Kim Thành, Hải Dương', 'huynhlenhi452@naver.com', '0815128064', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Cao Bảo Chấn', N'Xã Tân Lộc, Huyện Thới Bình, Cà Mau', 'caobaochan992@facebook.com', '0555841112', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Vạn Kim Thư', N'Xã Nghĩa Đạo, Huyện Thuận Thành, Bắc Ninh', 'vankimthu966@microsoft.com', '0363576908', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Xa Ái Khanh', N'Xã Ba Cụm Bắc, Huyện Khánh Sơn, Khánh Hòa', 'xkhanh@yahoo.com', '0592037981', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Giang Bá Thành', N'Xã Nà Ơt, Huyện Mai Sơn, Sơn La', 'giangbathanh278@icloud.com', '0830384169', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Thập Minh Ngọc', N'Phường Minh Phương, Thành phố Việt Trì, Phú Thọ', 'thapminhngoc985@hotmail.com', '0770539614', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Đổng Kim Cương', N'Phường 3, Thành phố Đông Hà, Quảng Trị', 'dongkimcuong730@facebook.com', '0778195026', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Sùng Khánh Hoàng', N'Thị trấn Bần Yên Nhân, Huyện Mỹ Hào, Hưng Yên', 'sungkhanhhoang95@hotmail.com', '0856273094', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Lường Nhật Tiến', N'Xã Hoàng Quế, Thị xã Đông Triều, Quảng Ninh', 'luongnhattien505@google.com', '0593895674', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Điêu Quế Thu', N'Xã An Thạch, Huyện Tuy An, Phú Yên', 'dieuquethu920@naver.com', '0925271896', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Thân Duy Thanh', N'Xã Thạnh Tiến, Huyện Vĩnh Thạnh, Cần Thơ', 'thanduythanh633@google.com', '0327806291', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Đặng Kiều Trang', N'Xã Phước Tân, Huyện Bác Ái, Ninh Thuận', 'dangkieutrang738@microsoft.com', '0865864703', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Cự Anh Vũ', N'Thị trấn Chùa Hang, Huyện Đồng Hỷ, Thái Nguyên', 'cuanhvu613@yahoo.com', '0929045687', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Phong Thái Hà', N'Xã Song Lộc, Huyện Châu Thành, Trà Vinh', 'phongthaiha242@naver.com', '0373627098', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Bì Hữu Tâm', N'Xã Hòa Minh, Huyện Châu Thành, Trà Vinh', 'bihuutam53@hotmail.com', '0919640287', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Lý Huyền Ngọc', N'Xã Hồng Tiến, Thị xã Hương Trà, Thừa Thiên Huế', 'lyhuyenngoc315@naver.com', '0996075319', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Biện Thảo My', N'Xã Quất Lưu, Huyện Bình Xuyên, Vĩnh Phúc', 'bienthaomy700@yahoo.com', '0789465873', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Ngọc Cẩm Hường', N'Xã Trực Đại, Huyện Trực Ninh, Nam Định', 'ngoccamhuong84@microsoft.com', '0775639148', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Vưu Triều Nguyệt', N'Xã Long Tân, Huyện Đất Đỏ, Bà Rịa - Vũng Tàu', 'vuutrieunguyet190@google.com', '0993054612', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Cát Quốc Hiền', N'Xã Suối Kiết, Huyện Tánh Linh, Bình Thuận', 'catquochien956@facebook.com', '0850365279', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Kông Huy Anh', N'Thị trấn Chí Thạnh, Huyện Tuy An, Phú Yên', 'konghuyanh670@hotmail.com', '0881329867', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Ong Bình Minh', N'Xã Yên Sơn, Huyện Yên Châu, Sơn La', 'ongbinhminh593@microsoft.com', '0981635092', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Hà Thái Hòa', N'Xã Ia Lang, Huyện Đức Cơ, Gia Lai', 'hathaihoa808@yahoo.com', '0847938054', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Thái Như Mai', N'Xã Duy Minh, Huyện Duy Tiên, Hà Nam', 'thainhumai952@microsoft.com', '0768576014', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Phùng Gia Quỳnh', N'Xã An Mỹ, Huyện Tuy An, Phú Yên', 'phunggiaquynh144@microsoft.com', '0890467281', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Bạc Ðoan Thanh', N'Xã Tân Việt, Huyện Văn Lãng, Lạng Sơn', 'bacoanthanh944@facebook.com', '0706924137', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Danh Như Mai', N'Phường Ba Hàng, Thị xã Phổ Yên, Thái Nguyên', 'danhnhumai160@icloud.com', '0880683715', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Bồ Từ Ðông', N'Xã Nậm Sỏ, Huyện Tân Uyên, Lai Châu', 'botuong635@google.com', '0783678150', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Bùi Xuân Thu', N'Xã Phú Lũng, Huyện Yên Minh, Hà Giang', 'buixuanthu5@naver.com', '0377189352', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Tào Mạnh Trường', N'Xã Xà Bang, Huyện Châu Đức, Bà Rịa - Vũng Tàu', 'taomanhtruong69@icloud.com', '0761290647', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Hoàng Cao Kỳ', N'Xã Tiến Hưng, Thị xã Đồng Xoài, Bình Phước', 'hoangcaoky948@naver.com', '0897864139', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Thoa Gia Hân', N'Xã Đông Hòa, Huyện Châu Thành, Tiền Giang', 'thoagiahan279@gmail.com', '0368296471', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece'),
(N'Phí Ðức Bằng', N'Xã Phong Thạnh, Huyện Cầu Kè, Trà Vinh', 'phiucbang578@google.com', '0772469801', 'aa7eba2fa0f854bbd98c94305079975879caf3d8f7a7fcc58d83fd591ca9aece');

INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP001', N'VGA - Card màn hình');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP002', N'CPU - Bộ vi xử lý');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP003', N'Bo mạch chủ');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP004', N'Bộ nhớ trong RAM');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP005', N'Bộ nhớ ngoài SSD - HDD');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP006', N'Case Vỏ máy tính');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP007', N'PSU - Nguồn máy tính');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP008', N'FAN - Tản nhiệt ');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP009', N'Màn hình');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP010', N'Bàn phím');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP011', N'Chuột');
INSERT INTO LOAISANPHAM (IDLSP, TENLSP) VALUES ('LSP012', N'Laptop');

INSERT INTO NHACUNGCAP (IDNCC, TENNCC, EMAILNCC, DIACHINCC, SDTNCC) VALUES
	('NCC001', 'Acer', 'acercare.vn@acer.com', N'585-587 Điện Biên Phủ, Phường 1, Quận 3, Tp. HCM ', '1900969601'),
	('NCC002', 'Akko', 'akkovietnam@gmail.com', N'296 Trương Định, Tương Mai, Hoàng Mai, Hà Nội', '0934389001'),
	('NCC003', 'AMD', 'hotro@amdvietnam.com.vn', N'Tầng 9, Tòa nhà PAX SKY, 13-15-17 Trương Định, Phường 6, Quận 3, TP Hồ Chí Minh', '0902354338'),
	('NCC004', 'ASUS', 'Legalcompliance@asus.com', N'285 Cách Mạng Tháng 8 , Phường 12 , Quận 10 , Thành phố Hồ Chí Minh, Việt Nam', '18006588'),
	('NCC005', 'Cooler Master', 'son_nguyen@coolermaster.com', N'Số 54 Trần Quang Diệu, Q. Đống Đa, Tp. Hà Nội, Việt Nam', '0899798798'),
	('NCC006', 'Corsair', 'Contact@corsair.com', N'178-180 Hoàng Văn Thụ, Phường 9, Quận Phú Nhuận, Thành phố Hồ Chí Minh, Việt Nam', '18001080'),
	('NCC007', 'Dell', 'technical_support@help.dell.com', N'350-352 Võ Văn Kiệt, Phường Cô Giang, Quận 1, Thành phố Hồ Chí Minh, Việt Nam', '02871089666'),
	('NCC008', 'G.Skill', 'marketing@gskill.com', N'241 Phố Vọng, Hai Bà Trưng, Hà Nội', '0436285868'),
	('NCC009', 'GIGABYTE', 'mydata@gigabyte.com', N'175 Nguyễn Thị Minh khai, P. Phạm Ngũ Lão, Quận 1, TP Hồ Chí Minh', '02839256714'),
	('NCC010', 'HKC', 'admin@hkc.vn', N'51 Đường B4, P. Tây Thạnh, quận Tân Phú, TP Hồ Chí MMinh', '0343884466'),
	('NCC011', 'HP', 'cskh@hp.com', N'29 Lê Duẩn, Tòa Nhà Sài Gòn, Quận 1, TP Hồ Chí Minh', '1800588868'),
	('NCC012', 'Intel', 'Support@intel.com', N'178-180 Hoàng Văn Thụ, Phường 9, Quận Phú Nhuận, Thành phố Hồ Chí Minh, Việt Nam', '02838446442'),
	('NCC013', 'Kingston', 'Support@kingston.com', N'265 Xô Viết Nghệ Tĩnh, Phường 15, Quận Bình Thạnh, Thành phố Hồ Chí Minh, Việt Nam', '02838447728'),
	('NCC014', 'Lenovo', 'vn_premier@lenovo.com', N'138-142 Hai Bà Trưng, Phường Đa Kao, Quận 1, Hồ Chí Minh, Việt Nam', '18006178'),
	('NCC016', 'LG', 'lgcarecenter@lge.com', N'KCN Tràng Duệ, xã Lê Lợi, Huyện An Dương, TP Hải Phòng', '02439345151'),
	('NCC017', 'Logitech', 'Help@logitech.com', N'Phòng 21, Lầu 4, 72 - 74 Nguyễn Thị Minh Khai, Phường 6, Quận 3, TP.HCM, Việt Nam', '02444582158'),
	('NCC019', 'MSI', 'vnservice@msi.com', N'133/16 Huỳnh Mẫn Đạt, Phường 7, Quận 5, TP Hồ Chí Minh', '02866732331'),
	('NCC021', 'Razer', 'rzrsupport@razer.com', N'194/3 Nguyễn Trọng Tuyển, Phường 8, Quận Phú Nhuận, Tp. Hồ Chí Minh', '02873000911'),
	('NCC022', 'Samsung', 'Support@samsung.com', N'308-310-312 Hồng Bàng, Phường 15, Quận 5, Thành phố Hồ Chí Minh, Việt Nam', '19006047'),
	('NCC023', 'Viewsonic', 'hotro@viewsonic.com', N'185 Nguyễn Oanh, phường 10, quận Gò Vấp, HCM.', '0916192729');

INSERT INTO SANPHAM (IDSP, TENSP, IMGSP, GIASP, SOLUONG, BH, TSKT, IDNCC, IDLSP) VALUES	
	('SP0001', N'Bàn phím cơ AKKO PC98B Plus AIR', '/assets/images/SP0001.jpg', '3090000', 14, N'12 Tháng', '/assets/html/TSKT/SP0001.html', 'NCC002', 'LSP010'),
	('SP0002', N'Bàn phím cơ AKKO 3068B Black Gold', '/assets/images/SP0002.jpg', '2190000', 11, N'12 Tháng', '/assets/html/TSKT/SP0002.html', 'NCC002', 'LSP010'),
	('SP0003', N'Bàn phím cơ AKKO 5075B Plus Black&Cyan', '/assets/images/SP0003.jpg', '2390000', 23, N'12 Tháng', '/assets/html/TSKT/SP0003.html', 'NCC002', 'LSP010'),
	('SP0004', N'Bàn phím cơ AKKO 3087 RF Ocean Star', '/assets/images/SP0004.jpg', '1499000', 30, N'12 Tháng', '/assets/html/TSKT/SP0004.html', 'NCC002', 'LSP010'),
	('SP0005', N'AMD Ryzen 9 7950X3D / 4.2GHz Boost 5.7GHz / 16 nhân 32 luồng / 144MB / AM5', '/assets/images/SP0005.jpg', '18590000', 20, N'36 Tháng', '/assets/html/TSKT/SP0005.html', 'NCC003', 'LSP002'),
	('SP0006', N'AMD Ryzen 9 7900X3D / 4.4GHz Boost 5.6GHz / 12 nhân 24 luồng / 140MB / AM5', '/assets/images/SP0006.jpg', '15890000', 30, N'36 Tháng', '/assets/html/TSKT/SP0006.html', 'NCC003', 'LSP002'),
	('SP0007', N'AMD Ryzen 9 7900 / 3.7GHz Boost 5.4GHz / 12 nhân 24 luồng / 76MB / AM5', '/assets/images/SP0007.jpg', '11690000', 1, N'36 Tháng', '/assets/html/TSKT/SP0007.html', 'NCC003', 'LSP002'),
	('SP0008', N'AMD Ryzen 5 7600X / 4.7GHz Boost 5.3GHz / 6 nhân 12 luồng / 38MB / AM5', '/assets/images/SP0008.jpg', '6690000', 3, N'36 Tháng', '/assets/html/TSKT/SP0008.html', 'NCC003', 'LSP002'),
	('SP0009', N'AMD Ryzen 7 7700X / 4.5GHz Boost 5.4GHz / 8 nhân 16 luồng / 40MB / AM5', '/assets/images/SP0009.jpg', '11290000', 23, N'36 Tháng', '/assets/html/TSKT/SP0009.html', 'NCC003', 'LSP002'),
	('SP0010', N'AMD Ryzen 7 5800X / 3.8GHz Boost 4.7GHz / 8 nhân 16 luồng / 32MB / AM4', '/assets/images/SP0010.jpg', '11990000', 27, N'36 Tháng', '/assets/html/TSKT/SP0010.html', 'NCC003', 'LSP002'),
	('SP0011', N'Chuột Cooler Master MM730 White', '/assets/images/SP0011.jpg', '1000000', 22, N'24 Tháng', '/assets/html/TSKT/SP0011.html', 'NCC005', 'LSP011'),
	('SP0012', N'Chuột Cooler Master MM730 RGB', '/assets/images/SP0012.jpg', '1000000', 28, N'24 Tháng', '/assets/html/TSKT/SP0012.html', 'NCC005', 'LSP011'),
	('SP0013', N'Chuột Cooler Master MM731 RGB Matte Black', '/assets/images/SP0013.jpg', '1490000', 16, N'24 Tháng', '/assets/html/TSKT/SP0013.html', 'NCC005', 'LSP011'),
	('SP0014', N'Case Cooler Master Cosmos C700P Black Edition', '/assets/images/SP0014.jpg', '9390000', 30, N'12 Tháng', '/assets/html/TSKT/SP0014.html', 'NCC005', 'LSP006'),
	('SP0015', N'Case Cooler Master MASTERBOX MB520 ARGB (3 fan ARGB)', '/assets/images/SP0015.jpg', '2590000', 13, N'12 Tháng', '/assets/html/TSKT/SP0015.html', 'NCC005', 'LSP006'),
	('SP0016', N'Case Cooler Master MASTERCASE H500P MESH ARGB', '/assets/images/SP0016.jpg', '4390000', 29, N'12 Tháng', '/assets/html/TSKT/SP0016.html', 'NCC005', 'LSP006'),
	('SP0017', N'Case Cooler Master Mastercase H500P Mesh White ARGB (2 fan ARGB)', '/assets/images/SP0017.jpg', '4190000', 4, N'12 Tháng', '/assets/html/TSKT/SP0017.html', 'NCC005', 'LSP006'),
	('SP0018', N'Case Cooler Master MASTERCASE HAF 500 (3 fan ARGB)', '/assets/images/SP0018.jpg', '3990000', 10, N'12 Tháng', '/assets/html/TSKT/SP0018.html', 'NCC005', 'LSP006'),
	('SP0019', N'Fan Cooler Master MasterFan MF120 Halo White Kit 3 Fan', '/assets/images/SP0019.jpg', '1190000', 13, N'12 Tháng', '/assets/html/TSKT/SP0019.html', 'NCC005', 'LSP008'),
	('SP0020', N'Tản nhiệt Cooler Master MASTERLIQUID PL240 FLUX', '/assets/images/SP0020.jpg', '4290000', 26, N'12 Tháng', '/assets/html/TSKT/SP0020.html', 'NCC005', 'LSP008'),
	('SP0021', N'Tản nhiệt Cooler Master Hyper 212 ARGB TURBO', '/assets/images/SP0021.jpg', '1190000', 14, N'12 Tháng', '/assets/html/TSKT/SP0021.html', 'NCC005', 'LSP008'),
	('SP0022', N'Tản nhiệt Cooler Master Hyper 212 ARGB', '/assets/images/SP0022.jpg', '950000', 14, N'12 Tháng', '/assets/html/TSKT/SP0022.html', 'NCC005', 'LSP008'),
	('SP0023', N'Tản nhiệt Cooler Master MASTERAIR MA624 STEALTH', '/assets/images/SP0023.jpg', '2990000', 4, N'24 Tháng', '/assets/html/TSKT/SP0023.html', 'NCC005', 'LSP008'),
	('SP0024', N'Fan Cooler Master MasterFan SF120M', '/assets/images/SP0024.jpg', '790000', 6, N'36 Tháng', '/assets/html/TSKT/SP0024.html', 'NCC005', 'LSP008'),
	('SP0025', N'RAM Corsair Dominator Platinum 64GB (2x32GB) RGB 6000 DDR5 (CMT64GX5M2B6000C40)', '/assets/images/SP0025.jpg', '12990000', 4, N'36 Tháng', '/assets/html/TSKT/SP0025.html', 'NCC006', 'LSP004'),
	('SP0026', N'RAM Corsair Dominator Platinum 64GB (2x32GB) RGB 5600 DDR5 (CMT64GX5M2B5600C40)', '/assets/images/SP0026.jpg', '11990000', 6, N'36 Tháng', '/assets/html/TSKT/SP0026.html', 'NCC006', 'LSP004'),
	('SP0027', N'Ram Corsair Vengeance RS RGB 1x8GB 3600 (CMG8GX4M1D3600C18)', '/assets/images/SP0027.jpg', '1490000', 8, N'36 Tháng', '/assets/html/TSKT/SP0027.html', 'NCC006', 'LSP004'),
	('SP0028', N'Ram Corsair Vengeance RGB 32GB (2x16GB) 5600 DDR5 White (CMH32GX5M2B5600C36W)', '/assets/images/SP0028.jpg', '6900000', 24, N'36 Tháng', '/assets/html/TSKT/SP0028.html', 'NCC006', 'LSP004'),
	('SP0029', N'RAM Corsair Dominator Platinum 32GB (2x16GB) RGB 5600 DDR5 (CMT32GX5M2B5600c36)', '/assets/images/SP0029.jpg', '7990000', 4, N'36 Tháng', '/assets/html/TSKT/SP0029.html', 'NCC006', 'LSP004'),
	('SP0030', N'Ram Corsair Vengeance LPX 32GB (2x16GB) 5200 DDR5 C40 (CMK32GX5M2B5200C40)', '/assets/images/SP0030.jpg', '8990000', 9, N'36 Tháng', '/assets/html/TSKT/SP0030.html', 'NCC006', 'LSP004'),
	('SP0031', N'Ram Corsair Vengeance RS RGB 32gb (2x16GB) bus 3600 (CMG32GX4M2D3600C18)', '/assets/images/SP0031.jpg', '4490000', 2, N'36 Tháng', '/assets/html/TSKT/SP0031.html', 'NCC006', 'LSP004'),
	('SP0032', N'Ram Corsair Dominator 32GB (2x16GB) RGB 3200 White (CMT32GX4M2E3200C16W)', '/assets/images/SP0032.jpg', '7190000', 16, N'36 Tháng', '/assets/html/TSKT/SP0032.html', 'NCC006', 'LSP004'),
	('SP0033', N'RAM Corsair Vengeance LPX 8GB bus 3200 (CMK8GX4M1E3200C16)', '/assets/images/SP0033.jpg', '1090000', 26, N'36 Tháng', '/assets/html/TSKT/SP0033.html', 'NCC006', 'LSP004'),
	('SP0034', N'Tản nhiệt nước Corsair H150i ELITE CAPELLIX XT Black', '/assets/images/SP0034.jpg', '5290000', 17, N'60 Tháng', '/assets/html/TSKT/SP0034.html', 'NCC006', 'LSP008'),
	('SP0035', N'Tản nhiệt nước Corsair H100i ELITE CAPELLIX XT WHITE', '/assets/images/SP0035.jpg', '4150000', 18, N'60 Tháng', '/assets/html/TSKT/SP0035.html', 'NCC006', 'LSP008'),
	('SP0036', N'Tản nhiệt nước Corsair H100i ELITE CAPELLIX XT BLACK', '/assets/images/SP0036.jpg', '4490000', 2, N'60 Tháng', '/assets/html/TSKT/SP0036.html', 'NCC006', 'LSP008'),
	('SP0037', N'Tản nhiệt nước Corsair H55 RGB', '/assets/images/SP0037.jpg', '2290000', 19, N'36 Tháng', '/assets/html/TSKT/SP0037.html', 'NCC006', 'LSP008'),
	('SP0038', N'Tản nhiệt nước Corsair H150i ELITE CAPELLIX LCD', '/assets/images/SP0038.jpg', '8290000', 1, N'60 Tháng', '/assets/html/TSKT/SP0038.html', 'NCC006', 'LSP008'),
	('SP0039', N'Fan Corsair iCUE SP140 RGB ELITE 140mm — Dual Fan Kit with Lighting Node CORE', '/assets/images/SP0039.jpg', '1790000', 19, N'24 Tháng', '/assets/html/TSKT/SP0039.html', 'NCC006', 'LSP008'),
	('SP0040', N'Fan Corsair iCUE SP120 RGB ELITE 120mm — Triple Pack with Lighting Node CORE', '/assets/images/SP0040.jpg', '1900000', 10, N'24 Tháng', '/assets/html/TSKT/SP0040.html', 'NCC006', 'LSP008'),
	('SP0041', N'Fan Corsair iCUE QL140 RGB 140mm White — Dual Fan Kit with Lighting Node CORE', '/assets/images/SP0041.jpg', '2990000', 14, N'24 Tháng', '/assets/html/TSKT/SP0041.html', 'NCC006', 'LSP008'),
	('SP0042', N'(1000W) Nguồn Corsair RM1000e - 80 Plus Gold - Full Modular', '/assets/images/SP0042.jpg', '5990000', 9, N'84 Tháng', '/assets/html/TSKT/SP0042.html', 'NCC006', 'LSP007'),
	('SP0043', N'(750W) Nguồn Corsair RM750e - 80 Plus Gold - Full Modular', '/assets/images/SP0043.jpg', '3290000', 4, N'84 Tháng', '/assets/html/TSKT/SP0043.html', 'NCC006', 'LSP007'),
	('SP0044', N'(850W) Nguồn Corsair RM850e - 80 Plus Gold - Full Modular', '/assets/images/SP0044.jpg', '3690000', 17, N'84 Tháng', '/assets/html/TSKT/SP0044.html', 'NCC006', 'LSP007'),
	('SP0045', N'(850W) Nguồn Corsair RM850 White - 80 Plus Gold - Full Modular', '/assets/images/SP0045.jpg', '3990000', 22, N'12 Tháng', '/assets/html/TSKT/SP0045.html', 'NCC006', 'LSP007'),
	('SP0046', N'(750W) Nguồn Corsair RM750 White - 80 Plus Gold - Full Modular', '/assets/images/SP0046.jpg', '3390000', 21, N'12 Tháng', '/assets/html/TSKT/SP0046.html', 'NCC006', 'LSP007'),
	('SP0047', N'(750W) Nguồn Corsair CV750 - 80 Plus Bronze', '/assets/images/SP0047.jpg', '1890000', 16, N'36 Tháng', '/assets/html/TSKT/SP0047.html', 'NCC006', 'LSP007'),
	('SP0048', N'(1200W) Nguồn Corsair HX1200 - 80 Plus Platinum - Full Modular', '/assets/images/SP0048.jpg', '7490000', 22, N'12 Tháng', '/assets/html/TSKT/SP0048.html', 'NCC006', 'LSP007'),
	('SP0049', N'(850W) Nguồn Corsair RM850X - 80 Plus Gold - Full Modular', '/assets/images/SP0049.jpg', '4490000', 24, N'12 Tháng', '/assets/html/TSKT/SP0049.html', 'NCC006', 'LSP007'),
	('SP0050', N'(650W) Nguồn Corsair CV650 - 80 Plus Bronze', '/assets/images/SP0050.jpg', '1650000', 17, N'36 Tháng', '/assets/html/TSKT/SP0050.html', 'NCC006', 'LSP007'),
	('SP0051', N'(550W) Nguồn Corsair CV550 - 80 Plus Bronze', '/assets/images/SP0051.jpg', '1390000', 2, N'36 Tháng', '/assets/html/TSKT/SP0051.html', 'NCC006', 'LSP007'),
	('SP0052', N'(650W) Nguồn Corsair RM650 - 80 Plus Gold - Full Modular', '/assets/images/SP0052.jpg', '2990000', 4, N'12 Tháng', '/assets/html/TSKT/SP0052.html', 'NCC006', 'LSP007'),
	('SP0053', N'(750W) Nguồn Corsair SF750 - 80 Plus Platinum - Full Modular', '/assets/images/SP0053.jpg', '4100000', 5, N'84 Tháng', '/assets/html/TSKT/SP0053.html', 'NCC006', 'LSP007'),
	('SP0054', N'(1600W) Nguồn Corsair AX1600i - 1600 Watt - 80 Plus Titanium - Full Modular', '/assets/images/SP0054.jpg', '12990000', 28, N'12 Tháng', '/assets/html/TSKT/SP0054.html', 'NCC006', 'LSP007'),
	('SP0055', N'(850W) Nguồn Corsair HX850 - 80 Plus Platinum - Full Modular', '/assets/images/SP0055.jpg', '4990000', 2, N'12 Tháng', '/assets/html/TSKT/SP0055.html', 'NCC006', 'LSP007'),
	('SP0056', N'Case Corsair 5000X RGB Tempered Glass White (sẵn 3 fan Argb)', '/assets/images/SP0056.jpg', '6800000', 1, N'24 Tháng', '/assets/html/TSKT/SP0056.html', 'NCC006', 'LSP006'),
	('SP0057', N'Case Corsair iCUE 7000X RGB TG White (sẵn 4 fan RGB)', '/assets/images/SP0057.jpg', '6990000', 3, N'24 Tháng', '/assets/html/TSKT/SP0057.html', 'NCC006', 'LSP006'),
	('SP0058', N'Case Corsair iCUE 7000X RGB TG Black (sẵn 4 fan RGB)', '/assets/images/SP0058.jpg', '6990000', 21, N'24 Tháng', '/assets/html/TSKT/SP0058.html', 'NCC006', 'LSP006'),
	('SP0059', N'Case Corsair 7000D Airflow TG Black', '/assets/images/SP0059.jpg', '5400000', 3, N'24 Tháng', '/assets/html/TSKT/SP0059.html', 'NCC006', 'LSP006'),
	('SP0060', N'Case Corsair 5000X RGB Tempered Glass White (sẵn 3 fan rgb)', '/assets/images/SP0060.jpg', '4490000', 13, N'24 Tháng', '/assets/html/TSKT/SP0060.html', 'NCC006', 'LSP006'),
	('SP0061', N'Case Corsair 5000D AIRFLOW Tempered Glass Black', '/assets/images/SP0061.jpg', '3890000', 21, N'24 Tháng', '/assets/html/TSKT/SP0061.html', 'NCC006', 'LSP006'),
	('SP0062', N'Case Corsair 4000X Black', '/assets/images/SP0062.jpg', '3490000', 8, N'24 Tháng', '/assets/html/TSKT/SP0062.html', 'NCC006', 'LSP006'),
	('SP0063', N'Case Corsair 4000D AIRFLOW Black', '/assets/images/SP0063.jpg', '2290000', 5, N'24 Tháng', '/assets/html/TSKT/SP0063.html', 'NCC006', 'LSP006'),
	('SP0064', N'Chuột không dây Corsair DarkCore RGB Pro Wireless', '/assets/images/SP0064.jpg', '2390000', 23, N'24 Tháng', '/assets/html/TSKT/SP0064.html', 'NCC006', 'LSP011'),
	('SP0065', N'Chuột Corsair Katar Pro Wireless', '/assets/images/SP0065.jpg', '890000', 5, N'24 Tháng', '/assets/html/TSKT/SP0065.html', 'NCC006', 'LSP011'),
	('SP0066', N'Chuột Corsair Katar Pro Ultra Light', '/assets/images/SP0066.jpg', '450000', 14, N'24 Tháng', '/assets/html/TSKT/SP0066.html', 'NCC006', 'LSP011'),
	('SP0067', N'Chuột Corsair Sabre RGB Pro Wireless', '/assets/images/SP0067.jpg', '2690000', 27, N'24 Tháng', '/assets/html/TSKT/SP0067.html', 'NCC006', 'LSP011'),
	('SP0068', N'Corsair M95', '/assets/images/SP0068.jpg', '1640000', 5, N'24 Tháng', '/assets/html/TSKT/SP0068.html', 'NCC006', 'LSP011'),
	('SP0069', N'Corsair Raptor M40', '/assets/images/SP0069.jpg', '1190000', 13, N'24 Tháng', '/assets/html/TSKT/SP0069.html', 'NCC006', 'LSP011'),
	('SP0070', N'RAM G.Skill Trident Z5 RGB 32GB (2x16GB) 5600 DDR5 Silver (F5-5600J4040C16GX2-TZ5RS)', '/assets/images/SP0070.jpg', '6990000', 27, N'36 Tháng', '/assets/html/TSKT/SP0070.html', 'NCC008', 'LSP004'),
	('SP0071', N'Ram G.Skill Trident Z 1x8GB RGB 3200 (F4-3200C16S-8GTZR)', '/assets/images/SP0071.jpg', '1390000', 23, N'36 Tháng', '/assets/html/TSKT/SP0071.html', 'NCC008', 'LSP004'),
	('SP0072', N'RAM G.Skill Trident Z5 RGB 64GB (2x32GB) 6000 DDR5 Silver (F5-6000J3040G32GX2-TZ5RS)', '/assets/images/SP0072.jpg', '13990000', 22, N'36 Tháng', '/assets/html/TSKT/SP0072.html', 'NCC008', 'LSP004'),
	('SP0073', N'RAM G.Skill Trident Z5 RGB 32GB (2x16GB) 5600 DDR5 Black (F5-5600J3636C16GX2-TZ5RK)', '/assets/images/SP0073.jpg', '7990000', 13, N'36 Tháng', '/assets/html/TSKT/SP0073.html', 'NCC008', 'LSP004'),
	('SP0074', N'RAM G.Skill Trident Z5 RGB 32GB (2x16GB) 5600 DDR5 Black (F5-5600J3636C16GX2-TZ5RK)', '/assets/images/SP0074.jpg', '11990000', 2, N'36 Tháng', '/assets/html/TSKT/SP0074.html', 'NCC008', 'LSP004'),
	('SP0075', N'RAM G.Skill Ripjaws S5 32GB (2x16GB) 5600 DDR5 White (F5-5600U3636C16GX2-RS5W)', '/assets/images/SP0075.jpg', '11990000', 6, N'36 Tháng', '/assets/html/TSKT/SP0075.html', 'NCC008', 'LSP004'),
	('SP0076', N'RAM G.Skill Ripjaws S5 32GB (2x16GB) 5600 DDR5 Black (F5-5600U3636C16GX2-RS5K)', '/assets/images/SP0076.jpg', '11990000', 15, N'36 Tháng', '/assets/html/TSKT/SP0076.html', 'NCC008', 'LSP004'),
	('SP0077', N'Ram G.Skill Trident Z 1x16GB RGB 3200 (F4-3200C16D-32GTZR)', '/assets/images/SP0077.jpg', '2890000', 22, N'36 Tháng', '/assets/html/TSKT/SP0077.html', 'NCC008', 'LSP004'),
	('SP0078', N'RAM DDR5 G.Skill Trident Z5 RGB 16GB (2x16GB ) 6000mhz Silver (F5-6000U4040E16GX2-TZ5RS)', '/assets/images/SP0078.jpg', '11990000', 7, N'36 Tháng', '/assets/html/TSKT/SP0078.html', 'NCC008', 'LSP004'),
	('SP0079', N'Ram G.Skill Trident Z RGB 2x8GB 5066mhz (F4-5066C20D-16GTZR)', '/assets/images/SP0079.jpg', '5490000', 28, N'36 Tháng', '/assets/html/TSKT/SP0079.html', 'NCC008', 'LSP004'),
	('SP0080', N'Màn hình GIGABYTE G27F 2 27" IPS 170Hz chuyên game', '/assets/images/SP0080.jpg', '6850000', 28, N'36 Tháng', '/assets/html/TSKT/SP0080.html', 'NCC009', 'LSP009'),
	('SP0081', N'Màn hình GIGABYTE G24F 2 24" IPS 180Hz chuyên game', '/assets/images/SP0081.jpg', '5990000', 20, N'36 Tháng', '/assets/html/TSKT/SP0081.html', 'NCC009', 'LSP009'),
	('SP0082', N'Màn hình cong GIGABYTE G27FC A 27" VA 170Hz chuyên game', '/assets/images/SP0082.jpg', '6490000', 24, N'36 Tháng', '/assets/html/TSKT/SP0082.html', 'NCC009', 'LSP009'),
	('SP0083', N'Màn hình GIGABYTE G27F 27" IPS 144Hz chuyên game', '/assets/images/SP0083.jpg', '6850000', 26, N'36 Tháng', '/assets/html/TSKT/SP0083.html', 'NCC009', 'LSP009'),
	('SP0084', N'Màn hình GIGABYTE G24F 2 24" IPS 180Hz chuyên game', '/assets/images/SP0084.jpg', '5990000', 25, N'36 Tháng', '/assets/html/TSKT/SP0084.html', 'NCC009', 'LSP009'),
	('SP0085', N'SSD GIGABYTE NVMe 256Gb', '/assets/images/SP0085.jpg', '1290000', 10, N'36 Tháng', '/assets/html/TSKT/SP0085.html', 'NCC009', 'LSP005'),
	('SP0086', N'SSD GIGABYTE NVMe 512Gb', '/assets/images/SP0086.jpg', '1990000', 2, N'36 Tháng', '/assets/html/TSKT/SP0086.html', 'NCC009', 'LSP005'),
	('SP0087', N'SSD GIGABYTE AORUS Gen5 10000 2TB', '/assets/images/SP0087.jpg', '11990000', 2, N'36 Tháng', '/assets/html/TSKT/SP0087.html', 'NCC009', 'LSP005'),
	('SP0088', N'Intel Xeon E-2236 12MB 3.4GHz 6 Nhân 12 Luồng LGA 1151', '/assets/images/SP0088.jpg', '7690000', 10, N'36 Tháng', '/assets/html/TSKT/SP0088.html', 'NCC012', 'LSP002'),
	('SP0089', N'Intel Pentium Gold G7400 / 3.7GHz / 2 Nhân 4 Luồng / 6MB / LGA 1700', '/assets/images/SP0089.jpg', '2390000', 14, N'36 Tháng', '/assets/html/TSKT/SP0089.html', 'NCC012', 'LSP002'),
	('SP0090', N'Intel Core i7 13700KF / 3.4GHz Turbo 5.4GHz / 16 Nhân 24 Luồng / 30MB / LGA 1700', '/assets/images/SP0090.jpg', '10990000', 24, N'36 Tháng', '/assets/html/TSKT/SP0090.html', 'NCC012', 'LSP002'),
	('SP0091', N'Intel Core i9 13900F / 2.0GHz Turbo 5.6GHz / 24 Nhân 32 Luồng / 36MB / LGA 1700', '/assets/images/SP0091.jpg', '14990000', 10, N'36 Tháng', '/assets/html/TSKT/SP0091.html', 'NCC012', 'LSP002'),
	('SP0092', N'Intel Core i9 10980XE / 24.75MB / 4.6GHz / 18 nhân 36 luồng / LGA 2066', '/assets/images/SP0092.jpg', '19990000', 8, N'36 Tháng', '/assets/html/TSKT/SP0092.html', 'NCC012', 'LSP002'),
	('SP0093', N'Intel Core i5 13600KF / 3.5GHz Turbo 5.1GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700', '/assets/images/SP0093.jpg', '7990000', 16, N'36 Tháng', '/assets/html/TSKT/SP0093.html', 'NCC012', 'LSP002'),
	('SP0094', N'Intel Core i5 13400F / 2.5GHz Turbo 4.6GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700', '/assets/images/SP0094.jpg', '5590000', 1, N'36 Tháng', '/assets/html/TSKT/SP0094.html', 'NCC012', 'LSP002'),
	('SP0095', N'Intel Core i5 12600KF / 3.7GHz Turbo 4.9GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700', '/assets/images/SP0095.jpg', '6990000', 6, N'36 Tháng', '/assets/html/TSKT/SP0095.html', 'NCC012', 'LSP002'),
	('SP0096', N'Intel Core i3 12100F / 3.3GHz Turbo 4.3GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700', '/assets/images/SP0096.jpg', '2490000', 2, N'36 Tháng', '/assets/html/TSKT/SP0096.html', 'NCC012', 'LSP002'),
	('SP0097', N'Intel Core i3 10105F / 6MB / 4.4GHZ / 4 nhân 8 luồng / LGA 1200', '/assets/images/SP0097.jpg', '1890000', 24, N'36 Tháng', '/assets/html/TSKT/SP0097.html', 'NCC012', 'LSP002'),
	('SP0098', N'RAM Kingston Fury Beast 1x8GB 3600 DDR4 RGB', '/assets/images/SP0098.jpg', '1090000', 25, N'36 Tháng', '/assets/html/TSKT/SP0098.html', 'NCC013', 'LSP004'),
	('SP0099', N'RAM Kingston Fury Beast RGB 64GB (2x32GB) bus 5600 DDR5 (KF556C40BBAK2-64)', '/assets/images/SP0099.jpg', '11990000', 24, N'36 Tháng', '/assets/html/TSKT/SP0099.html', 'NCC013', 'LSP004'),
	('SP0100', N'SSD Kingston NV2 250GB M.2 PCIe NVMe Gen4', '/assets/images/SP0100.jpg', '990000', 18, N'36 Tháng', '/assets/html/TSKT/SP0100.html', 'NCC013', 'LSP005'),
	('SP0101', N'RAM Kingston Fury Beast RGB 32GB (2x16GB) bus 5200 DDR5 (KF552C40BBAK2-32)', '/assets/images/SP0101.jpg', '5990000', 4, N'36 Tháng', '/assets/html/TSKT/SP0101.html', 'NCC013', 'LSP004'),
	('SP0102', N'SSD Kingston A400 480GB 2.5 SATA III', '/assets/images/SP0102.jpg', '1490000', 10, N'36 Tháng', '/assets/html/TSKT/SP0102.html', 'NCC013', 'LSP005'),
	('SP0103', N'RAM Kingston Fury Beast 8GB 3200 DDR4 RGB (KF432C16BBA/8)', '/assets/images/SP0103.jpg', '990000', 2, N'36 Tháng', '/assets/html/TSKT/SP0103.html', 'NCC013', 'LSP004'),
	('SP0104', N'ASUS CROSSHAIR VIII HERO X570 (AMD Socket AM4)', '/assets/images/SP0104.jpg', '9990000', 15, N'36 Tháng', '/assets/html/TSKT/SP0104.html', 'NCC004', 'LSP003'),
	('SP0105', N'ASUS ROG MAXIMUS Z790 HERO DDR5', '/assets/images/SP0105.jpg', '18990000', 27, N'36 Tháng', '/assets/html/TSKT/SP0105.html', 'NCC004', 'LSP003'),
	('SP0106', N'ASUS ROG STRIX B650-A GAMING WIFI (DDR5)', '/assets/images/SP0106.jpg', '8490000', 1, N'36 Tháng', '/assets/html/TSKT/SP0106.html', 'NCC004', 'LSP003'),
	('SP0107', N'MSI MPG B760I EDGE WIFI DDR4', '/assets/images/SP0107.jpg', '5990000', 16, N'36 Tháng', '/assets/html/TSKT/SP0107.html', 'NCC019', 'LSP003'),
	('SP0108', N'MSI PRO H610M-E DDR4', '/assets/images/SP0108.jpg', '2190000', 27, N'36 Tháng', '/assets/html/TSKT/SP0108.html', 'NCC019', 'LSP003'),
	('SP0109', N'MSI TRX40 PRO 10G', '/assets/images/SP0109.jpg', '13390000', 24, N'36 Tháng', '/assets/html/TSKT/SP0109.html', 'NCC019', 'LSP003'),
	('SP0110', N'GIGABYTE B650M AORUS ELITE AX (DDR5)', '/assets/images/SP0110.jpg', '6590000', 5, N'36 Tháng', '/assets/html/TSKT/SP0110.html', 'NCC009', 'LSP003'),
	('SP0111', N'GIGABYTE B660M AORUS PRO DDR4 (rev. 1.0)', '/assets/images/SP0111.jpg', '3890000', 10, N'36 Tháng', '/assets/html/TSKT/SP0111.html', 'NCC009', 'LSP003'),
	('SP0112', N'GIGABYTE B760M AORUS ELITE AX DDR4', '/assets/images/SP0112.jpg', '4790000', 7, N'36 Tháng', '/assets/html/TSKT/SP0112.html', 'NCC009', 'LSP003'),
	('SP0113', N'ASUS TUF Gaming GeForce RTX 3070 Ti V2 8GB GDDR6X', '/assets/images/SP0113.jpg', '17990000', 1, N'36 Tháng', '/assets/html/TSKT/SP0113.html', 'NCC004', 'LSP001'),
	('SP0114', N'MSI GeForce RTX 3070 GAMING Z TRIO 8GB (LHR)', '/assets/images/SP0114.jpg', '14990000', 27, N'36 Tháng', '/assets/html/TSKT/SP0114.html', 'NCC019', 'LSP001'),
	('SP0115', N'GIGABYTE AORUS GeForce RTX 3060 ELITE 12G (rev 2.0)', '/assets/images/SP0115.jpg', '10990000', 25, N'36 Tháng', '/assets/html/TSKT/SP0115.html', 'NCC009', 'LSP001'),
	('SP0116', N'Gigabyte AORUS GeForce RTX 3090 Ti XTREME WATERFORCE 24G', '/assets/images/SP0116.jpg', '47990000', 26, N'36 Tháng', '/assets/html/TSKT/SP0116.html', 'NCC009', 'LSP001'),
	('SP0117', N'ASUS TUF Gaming GeForce RTX 4090 OC Edition 24GB GDDR6X', '/assets/images/SP0117.jpg', '54990000', 26, N'36 Tháng', '/assets/html/TSKT/SP0117.html', 'NCC004', 'LSP001'),
	('SP0118', N'Laptop LG Gram 2022 16Z90Q GAH78A5', '/assets/images/SP0118.jpg', '35990000', 2, N'12 Tháng', '/assets/html/TSKT/SP0118.html', 'NCC016', 'LSP012'),
	('SP0119', N'Màn hình LG 27GN60R-B UltraGear 27" IPS 144Hz Gsync compatible', '/assets/images/SP0119.jpg', '5090000', 12, N'24 Tháng', '/assets/html/TSKT/SP0119.html', 'NCC016', 'LSP009'),
	('SP0120', N'Màn hình LG 48GQ900-B UltraGear 48" OLED 4K 138Hz HDR10 Gsync', '/assets/images/SP0120.jpg', '30990000', 23, N'24 Tháng', '/assets/html/TSKT/SP0120.html', 'NCC016', 'LSP009'),
	('SP0121', N'Màn hình LG 27GP95R-B UltraGear 27" Nano IPS 4K 160Hz Gsync chuyên game', '/assets/images/SP0121.jpg', '18990000', 12, N'24 Tháng', '/assets/html/TSKT/SP0121.html', 'NCC016', 'LSP009'),
	('SP0122', N'Chuột Logitech G502 X Plus LightSpeed Black', '/assets/images/SP0122.jpg', '3590000', 28, N'24 Tháng', '/assets/html/TSKT/SP0122.html', 'NCC017', 'LSP011'),
	('SP0123', N'Chuột Logitech G502 X Black', '/assets/images/SP0123.jpg', '1750000', 8, N'24 Tháng', '/assets/html/TSKT/SP0123.html', 'NCC017', 'LSP011'),
	('SP0124', N'Bàn phím cơ Logitech MX Mechanical Graphite Tactile Silent', '/assets/images/SP0124.jpg', '3990000', 29, N'24 Tháng', '/assets/html/TSKT/SP0124.html', 'NCC017', 'LSP010'),
	('SP0125', N'Chuột Logitech MX Master 3S Graphite', '/assets/images/SP0125.jpg', '2590000', 14, N'12 Tháng', '/assets/html/TSKT/SP0125.html', 'NCC017', 'LSP011'),
	('SP0126', N'Laptop Gaming HP Victus 15 FA0110TX 7C0R3PA', '/assets/images/SP0126.jpg', '28990000', 21, N'12 Tháng', '/assets/html/TSKT/SP0126.html', 'NCC011', 'LSP012'),
	('SP0127', N'Laptop Gaming HP VICTUS 16 E1106AX 7C0T1PA', '/assets/images/SP0127.jpg', '24990000', 14, N'12 Tháng', '/assets/html/TSKT/SP0127.html', 'NCC011', 'LSP012'),
	('SP0128', N'Laptop gaming HP VICTUS 15 fa0111TX 7C0R4PA', '/assets/images/SP0128.jpg', '26670000', 28, N'12 Tháng', '/assets/html/TSKT/SP0128.html', 'NCC011', 'LSP012'),
	('SP0129', N'Laptop HP Pavilion 15 EG2063TU 6K791PA', '/assets/images/SP0129.jpg', '13990000', 8, N'12 Tháng', '/assets/html/TSKT/SP0129.html', 'NCC011', 'LSP012'),
	('SP0130', N'Laptop HP Pavilion 14 dv2032TU 6K768PA', '/assets/images/SP0130.jpg', '21490000', 14, N'12 Tháng', '/assets/html/TSKT/SP0130.html', 'NCC011', 'LSP012'),
	('SP0131', N'Laptop gaming HP Omen 16 b0176TX 5Z9Q7PA', '/assets/images/SP0131.jpg', '45490000', 13, N'12 Tháng', '/assets/html/TSKT/SP0131.html', 'NCC011', 'LSP012'),
	('SP0132', N'Laptop Gaming HP Omen 16 b0127TX 4Y0W7PA', '/assets/images/SP0132.jpg', '45990000', 21, N'12 Tháng', '/assets/html/TSKT/SP0132.html', 'NCC011', 'LSP012'),
	('SP0133', N'Màn Hình Samsung LS24A336 24" VA 60Hz', '/assets/images/SP0133.jpg', '2930000', 13, N'24 Tháng', '/assets/html/TSKT/SP0133.html', 'NCC022', 'LSP009'),
	('SP0134', N'Màn hình cong Samsung Odyssey G8 LS34BG850 34" OLED 2K 175Hz', '/assets/images/SP0134.jpg', '39990000', 27, N'24 Tháng', '/assets/html/TSKT/SP0134.html', 'NCC022', 'LSP009'),
	('SP0135', N'Màn hình Samsung ViewFinity LS27B800 27" IPS 4K USBC chuyên đồ họa', '/assets/images/SP0135.jpg', '9690000', 11, N'24 Tháng', '/assets/html/TSKT/SP0135.html', 'NCC022', 'LSP009'),
	('SP0136', N'SSD SamSung 980 PRO 2TB M.2 Heatsink PCIe gen 4 NVMe', '/assets/images/SP0136.jpg', '9990000', 13, N'60 Tháng', '/assets/html/TSKT/SP0136.html', 'NCC022', 'LSP005'),
	('SP0137', N'Ram Laptop Samsung DDR5 8GB 4800MHz 1.1v M425R1GB4BB0-CQK0L', '/assets/images/SP0137.jpg', '1600000', 29, N'36 Tháng', '/assets/html/TSKT/SP0137.html', 'NCC022', 'LSP005'),
	('SP0138', N'SSD Samsung 870 QVO 8TB 2.5 Inch SATA III', '/assets/images/SP0138.jpg', '20490000', 23, N'36 Tháng', '/assets/html/TSKT/SP0138.html', 'NCC022', 'LSP005'),
	('SP0139', N'Chuột Razer Deathadder V3', '/assets/images/SP0139.jpg', '1890000', 23, N'24 Tháng', '/assets/html/TSKT/SP0139.html', 'NCC021', 'LSP011'),
	('SP0140', N'Chuột Razer Naga V2 Pro', '/assets/images/SP0140.jpg', '4790000', 12, N'24 Tháng', '/assets/html/TSKT/SP0140.html', 'NCC021', 'LSP011'),
	('SP0141', N'Bàn phím Razer DeathStalker V2', '/assets/images/SP0141.jpg', '3890000', 4, N'24 Tháng', '/assets/html/TSKT/SP0141.html', 'NCC021', 'LSP010'),
	('SP0142', N'Bàn phím Razer DeathStalker V2 Pro', '/assets/images/SP0142.jpg', '5690000', 4, N'24 Tháng', '/assets/html/TSKT/SP0142.html', 'NCC021', 'LSP010'),
	('SP0143', N'Bàn phím Razer Ornata V3 X', '/assets/images/SP0143.jpg', '1089000', 22, N'24 Tháng', '/assets/html/TSKT/SP0143.html', 'NCC021', 'LSP010'),
	('SP0144', N'Chuột Razer DeathAdder V3 Pro Wireless', '/assets/images/SP0144.jpg', '3390000', 15, N'24 Tháng', '/assets/html/TSKT/SP0144.html', 'NCC021', 'LSP011'),
	('SP0145', N'Màn hình ViewSonic VX2728J-2K 27" Fast IPS 2K 165Hz HDR10 chuyên game', '/assets/images/SP0145.jpg', '7590000', 1, N'36 Tháng', '/assets/html/TSKT/SP0145.html', 'NCC023', 'LSP009'),
	('SP0146', N'Màn hình ViewSonic VA2409-MHU 24" IPS 75Hz USBC viền mỏng', '/assets/images/SP0146.jpg', '3890000', 10, N'36 Tháng', '/assets/html/TSKT/SP0146.html', 'NCC023', 'LSP009'),
	('SP0147', N'Màn hình ViewSonic VP2756-2K 27" IPS 2K USBC chuyên đồ hoạ', '/assets/images/SP0147.jpg', '8790000', 18, N'36 Tháng', '/assets/html/TSKT/SP0147.html', 'NCC023', 'LSP009'),
	('SP0148', N'Màn hình ViewSonic VX2780-2K-SHDJ 27" IPS 2K 75Hz', '/assets/images/SP0148.jpg', '5990000', 6, N'36 Tháng', '/assets/html/TSKT/SP0148.html', 'NCC023', 'LSP009'),
	('SP0149', N'Màn hình cong ViewSonic VX2718-PC 27" VA 165Hz chuyên game', '/assets/images/SP0149.jpg', '4490000', 10, N'36 Tháng', '/assets/html/TSKT/SP0149.html', 'NCC023', 'LSP009'),
	('SP0150', N'Màn hình cong HKC M27G4F 27" VA 165Hz chuyên game', '/assets/images/SP0150.jpg', '4650000', 17, N'24 Tháng', '/assets/html/TSKT/SP0150.html', 'NCC010', 'LSP009'),
	('SP0151', N'Màn hình HKC MB27S9U 27" IPS 4K', '/assets/images/SP0151.jpg', '6390000', 22, N'24 Tháng', '/assets/html/TSKT/SP0151.html', 'NCC010', 'LSP009'),
	('SP0152', N'Màn hình cong HKC MG32K2Q 32" 2K 144Hz G-Sync chuyên game', '/assets/images/SP0152.jpg', '6290000', 27, N'24 Tháng', '/assets/html/TSKT/SP0152.html', 'NCC010', 'LSP009'),
	('SP0153', N'Màn hình HKC MB24V9 24" IPS 75Hz', '/assets/images/SP0153.jpg', '2550000', 1, N'24 Tháng', '/assets/html/TSKT/SP0153.html', 'NCC010', 'LSP009'),
	('SP0154', N'Màn hình cong HKC MB34A4Q 34" 2K 144Hz HDR10 chuyên game', '/assets/images/SP0154.jpg', '8190000', 2, N'24 Tháng', '/assets/html/TSKT/SP0154.html', 'NCC010', 'LSP009'),
	('SP0155', N'(LED 24'' 60Hz ) HKC M24A6 Monitor wide Led', '/assets/images/SP0155.jpg', '2799000', 16, N'24 Tháng', '/assets/html/TSKT/SP0155.html', 'NCC010', 'LSP009'),
	('SP0156', N'Màn hình HKC MB27V9 27" IPS 75Hz', '/assets/images/SP0156.jpg', '3090000', 9, N'24 Tháng', '/assets/html/TSKT/SP0156.html', 'NCC010', 'LSP009'),
	('SP0157', N'Laptop Lenovo ThinkPad E14 21E300E3VN', '/assets/images/SP0157.jpg', '25990000', 14, N'24 Tháng', '/assets/html/TSKT/SP0157.html', 'NCC014', 'LSP012'),
	('SP0158', N'Laptop Lenovo Ideapad 5 Pro 14ITL6 82L300MAVN', '/assets/images/SP0158.jpg', '21990000', 28, N'36 Tháng', '/assets/html/TSKT/SP0158.html', 'NCC014', 'LSP012'),
	('SP0159', N'Laptop Lenovo IdeaPad 1 15AMN7 82VG0022VN', '/assets/images/SP0159.jpg', '12490000', 26, N'24 Tháng', '/assets/html/TSKT/SP0159.html', 'NCC014', 'LSP012'),
	('SP0160', N'Laptop Lenovo IdeaPad Gaming 3 15IAH7 82S9006YVN', '/assets/images/SP0160.jpg', '21490000', 1, N'24 Tháng', '/assets/html/TSKT/SP0160.html', 'NCC014', 'LSP012'),
	('SP0161', N'Laptop gaming Lenovo Legion 5 Pro 16IAH7H 82RF0043VN', '/assets/images/SP0161.jpg', '43990000', 1, N'24 Tháng', '/assets/html/TSKT/SP0161.html', 'NCC014', 'LSP012'),
	('SP0162', N'Laptop gaming Lenovo Legion 5 Pro 16IAH7H 82RF0044VN', '/assets/images/SP0162.jpg', '53990000', 29, N'24 Tháng', '/assets/html/TSKT/SP0162.html', 'NCC014', 'LSP012'),
	('SP0163', N'Màn hình cảm ứng di động Lenovo ThinkVision M14t 14" IPS FHD USBC', '/assets/images/SP0163.jpg', '7990000', 14, N'36 Tháng', '/assets/html/TSKT/SP0163.html', 'NCC014', 'LSP009'),
	('SP0164', N'Laptop Lenovo IdeaPad 5 14ABA7 82SE007DVN', '/assets/images/SP0164.jpg', '17990000', 12, N'36 Tháng', '/assets/html/TSKT/SP0164.html', 'NCC014', 'LSP012'),
	('SP0165', N'Màn hình Lenovo L24i-30 24" IPS 75Hz Freesync', '/assets/images/SP0165.jpg', '3490000', 29, N'36 Tháng', '/assets/html/TSKT/SP0165.html', 'NCC014', 'LSP009'),
	('SP0166', N'Màn hình Lenovo Q24i-20 24" IPS 75Hz loa kép 3W', '/assets/images/SP0166.jpg', '3750000', 10, N'36 Tháng', '/assets/html/TSKT/SP0166.html', 'NCC014', 'LSP009'),
	('SP0167', N'Màn hình Lenovo Q27q-20 27" IPS 2K 75Hz chuyên đồ họa', '/assets/images/SP0167.jpg', '6590000', 20, N'36 Tháng', '/assets/html/TSKT/SP0167.html', 'NCC014', 'LSP009');

GO

INSERT INTO BAIVIET (IDBV, TENBV, IMGBV, CHITIET) VALUES	
	('BV0001', N'Photoshop có tính năng AI mới, và nó bá đạo khủng khiếp', '/assets/images/BV0001.jpg', '/assets/html/BV/BV0001.html'),
	('BV0002', N'RTX 4090 phô diễn sức mạnh dùng AI vẽ anime waifu chỉ trong vài giây', '/assets/images/BV0002.jpg', '/assets/html/BV/BV0002.html'),
	('BV0003', N'ASUS giới thiệu loạt laptop 2023 mang tinh thần “Tuyệt đỉnh tinh hoa, kiến tạo kỳ tích”', '/assets/images/BV0003.jpg', '/assets/html/BV/BV0003.html'),
	('BV0004', N'Top 10 tựa game chơi đùa với góc nhìn của bạn theo cách đầy sáng tạo', '/assets/images/BV0004.jpg', '/assets/html/BV/BV0004.html'),
	('BV0005', N'Mortal Kombat 1 yêu cầu cấu hình dễ thở, chỉ cần GTX 980 là đủ để bạn khiến đối phương tắt thở', '/assets/images/BV0005.jpg', '/assets/html/BV/BV0005.html'),
	('BV0006', N'Xuất hiện card đồ họa Trung Quốc Maxsun RTX 4070 Ti MGG gắn tới 5 quạt tản nhiệt', '/assets/images/BV0006.jpg', '/assets/html/BV/BV0006.html'),
	('BV0007', N'Đã là dân chơi hệ PC thì kiểu gì cũng phải dính 1 trong 11 lỗi này khi ráp máy', '/assets/images/BV0007.jpg', '/assets/html/BV/BV0007.html'),
	('BV0008', N'Chuyện lạ đó đây: ChatGPT giúp nhân viên làm việc tốt hơn, ít nghỉ việc hơn', '/assets/images/BV0008.jpg', '/assets/html/BV/BV0008.html'),
	('BV0009', N'AI có thể phá hơn 50% mật khẩu thông dụng trong vòng chưa đầy 1 phút', '/assets/images/BV0009.jpg', '/assets/html/BV/BV0009.html'),
	('BV0010', N'Tổng hợp meme hài hước cuối tuần: Cãi thắng sếp, ngủ đi crush không yêu bạn đâu …', '/assets/images/BV0010.jpg', '/assets/html/BV/BV0010.html'),
	('BV0011', N'Hướng dẫn chọn màn hình gaming tần số quét cao theo nhu cầu giá dưới 5 triệu đầu năm 2023', '/assets/images/BV0011.jpg', '/assets/html/BV/BV0011.html'),
	('BV0012', N'Vì ai cũng cần desktop ấn tượng, mời tải bộ hình nền xe mô tô Yamaha R15', '/assets/images/BV0012.jpg', '/assets/html/BV/BV0012.html'),
	('BV0013', N'Top 10 tựa game chỉ cần chơi 5 phút là đủ để vui vẻ cả ngày - GVN360', '/assets/images/BV0013.jpg', '/assets/html/BV/BV0013.html'),
	('BV0014', N'Ngon hơn người yêu cũ, Steam cho chơi thử 90 phút trước khi mua game, mở màn là Dead Space Remake', '/assets/images/BV0014.jpg', '/assets/html/BV/BV0014.html');


GO

CREATE PROC NVDangNhap
@username CHAR(6),
@password TEXT
AS
BEGIN
	SELECT COUNT(*) AS "KQ", QUYEN
	FROM NHANVIEN
	WHERE IDNV = @username AND CAST(PASSNV AS VARCHAR(MAX)) = CAST(@password AS VARCHAR(MAX))
	GROUP BY QUYEN
END

GO

CREATE PROC KHDangNhap
@username CHAR(10),
@password TEXT
AS
BEGIN
	SELECT COUNT(*) AS "KetQua"
	FROM KHACHHANG
	WHERE SDTKH = @username AND CAST(PASSKH AS VARCHAR(MAX)) = CAST(@password AS VARCHAR(MAX))
END

GO

CREATE PROC DSSPTheoLoaiSP
@LoaiSP NVARCHAR(50)
AS
BEGIN
	SELECT TENLSP, IMGSP, GIASP FROM SANPHAM
	INNER JOIN LOAISANPHAM
	ON SANPHAM.IDLSP = LOAISANPHAM.IDLSP
	WHERE TENLSP = @LoaiSP
	ORDER BY GIASP
END

GO

CREATE PROC SLSPTrongGH
@username char(10)
AS
BEGIN
	SELECT COUNT(IDSP) as 'SL'
	FROM CHITIETGIOHANG
	WHERE SDTKH = @username
	GROUP BY SDTKH
END

GO

CREATE PROC GioHangKH
@username char(10)
AS
BEGIN
	SELECT  SANPHAM.IDSP, IMGSP, TENSP, SL, GIASP, SL * GIASP AS N'Tổng'
	FROM CHITIETGIOHANG
	INNER JOIN SANPHAM ON SANPHAM.IDSP = CHITIETGIOHANG.IDSP
	WHERE SDTKH = @username;
END

GO
CREATE PROCEDURE KhachHang_TimKiem
    @HOTENKH nvarchar(50)=NULL,
	@DIACHIKH nvarchar(100)=NULL,
	@EMAILKH nvarchar(50)= NULL,
	@SDTKH varchar(10)=NULL
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM KHACHHANG
       WHERE  (1=1)
       '
IF @HOTENKH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (HOTENKH LIKE ''%'+@HOTENKH+'%'')
              '
IF @DIACHIKH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (DIACHIKH LIKE ''%'+@DIACHIKH+'%'')
              '
IF @EMAILKH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (EMAILKH LIKE ''%'+@EMAILKH+'%'')
             '
IF @SDTKH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (SDTKH LIKE ''%'+@SDTKH+'%'')
              '
	EXEC SP_EXECUTESQL @SqlStr
END
GO
CREATE PROCEDURE NhanVien_TimKiem
    @IDNV nvarchar(6)=NULL,
	@HOTENNV nvarchar(50)=NULL,
	@SDTNV nvarchar(10)= NULL,
	@EMAILNV nvarchar(50)= NULL,
	@DIACHINV nvarchar(100)= NULL

AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM NHANVIEN
       WHERE  (1=1)
       '
IF @IDNV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (IDNV LIKE ''%'+@IDNV+'%'')
              '
IF @HOTENNV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (HOTENNV LIKE ''%'+@HOTENNV+'%'')
              '
IF @SDTNV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (SDTNV LIKE ''%'+@SDTNV+'%'')
             '
IF @EMAILNV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (EMAILNV LIKE ''%'+@EMAILNV+'%'')
             '
IF @DIACHINV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (DIACHINV LIKE ''%'+@DIACHINV+'%'')
              '
	EXEC SP_EXECUTESQL @SqlStr
END
GO
CREATE PROCEDURE SanPham_TimKiem
    @IDSP nvarchar(6)=NULL,
	@TENSP nvarchar(150)=NULL,
	@GIASPMIN nvarchar(15)= NULL,
	@GIASPMAX nvarchar(15)= NULL,
	@SOLUONG nvarchar(10)= NULL,
	@BH nvarchar(8)= NULL,
	@IMGSP nvarchar(1500)= NULL

AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM SANPHAM
       WHERE  (1=1)
       '
IF @IDSP IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (IDSP LIKE ''%'+@IDSP+'%'')
              '
IF @TENSP IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (TENSP LIKE ''%'+@TENSP+'%'')
              '
IF @GIASPMIN IS NOT NULL and @GIASPMAX IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (GIASP Between Convert(int,'''+@GIASPMIN+''') AND Convert(int, '''+@GIASPMAX+'''))
             '
IF @SOLUONG IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (SOLUONG LIKE ''%'+@SOLUONG+'%'')
             '
IF @BH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (BH LIKE ''%'+@BH+'%'')
              '
IF @IMGSP IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (IMGSP LIKE ''%'+@IMGSP+'%'')
              '
	EXEC SP_EXECUTESQL @SqlStr
END
