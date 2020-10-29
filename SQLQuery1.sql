--------câu 1----------
select * from nhacungcap
--------câu 2----------
select mahang,tenhang,soluong 
from mathang
--------câu 3----------
select ho,ten,ngaylamviec
from nhanvien
--------câu 4----------
select diachi,dienthoai
from nhacungcap 
where tengiaodich=N'VINAMILK'
--------câu 5----------
select mathang.mahang,tenhang
from mathang
where giahang>100000 and soluong<50
--------câu 6----------
select mahang,tenhang,tencongty
from mathang,nhacungcap
where nhacungcap.macongty = mathang.macongty
--------câu 7----------
select mathang.mahang,tenhang,tencongty
from nhacungcap,mathang
where nhacungcap.macongty = mathang.macongty and tencongty=N'Thời trang Việt Tiến - Cần Thơ'
--------câu 8----------
select loaihang.maloaihang, tenloaihang , diachi,tencongty
from loaihang,nhacungcap,mathang
where loaihang.maloaihang = mathang.maloaihang and mathang.macongty = nhacungcap.macongty and tenloaihang=N'Thực phẩm'
--------câu 9----------
select khachhang.makhachhang,khachhang.tengiaodich,nhacungcap.tencongty,mathang.tenhang
from khachhang,dondathang,chitietdathang,nhacungcap,mathang
where khachhang.makhachhang = dondathang.makhachhang and dondathang.sohoadon = chitietdathang.sohoadon
and chitietdathang.mahang = mathang.mahang and mathang.macongty = nhacungcap.macongty and tenhang=N'Sữa hộp XYZ'
--------câu 10----------
select  nhanvien.manhanvien, ho,ten, ngaygiaohang,noigiaohang
from nhanvien,dondathang
where nhanvien.manhanvien = dondathang.manhanvien and sohoadon=1
--------câu 11----------
select ho,ten,(luongcoban+phucap) as luongchomoinhanvien
from nhanvien
--------câu 12----------
select mathang.mahang, tenhang ,(chitietdathang.soluong*giaban*(1-mucgiamgia/100)) as sotienphaitra 
from dondathang,chitietdathang,mathang
where dondathang.sohoadon = chitietdathang.sohoadon and 
chitietdathang.mahang = mathang.mahang and dondathang.sohoadon=3
--------câu 13----------
select khachhang.makhachhang,khachhang.tencongty as khachhang,nhacungcap.tencongty as congtycungcap
from khachhang,dondathang,chitietdathang,mathang,nhacungcap
where khachhang.makhachhang = dondathang.makhachhang and dondathang.sohoadon= chitietdathang.sohoadon
and chitietdathang.mahang = mathang.mahang and mathang.macongty = nhacungcap.macongty
--------câu 14----------
Select v1.MaNhanVien, v1.ho, v1.ten, v2.MaNhanVien, v2.Ho, v2.ten
FROM nhanvien v1
INNER JOIN NHANVIEN v2 ON v2.NgaySinh = v1.NgaySinh 
WHERE v2.MaNhanVien != v1.MaNhanVien

Select v1.manhanvien, v1.ho, v1.ten, v2.manhanvien, v2.ho, v2.ten
From Nhanvien v1 inner join nhanvien v2
on v1.ngaysinh = v2.ngaysinh
and v1.manhanvien <> v2.manhanvien
--------câu 15----------
select sohoadon, dondathang.makhachhang as macongty, khachhang.tencongty,ngaygiaohang,noigiaohang
from dondathang inner join khachhang
on dondathang.makhachhang = khachhang.makhachhang

select * from dondathang
select * from khachhang
--------câu 16----------sai
select tencongty,tengiaodich,diachi,dienthoai
from khachhang
union all
select tencongty,tengiaodich,diachi,dienthoai
from nhacungcap
--------câu 17---------- Những mặt hàng nào chưa từng được khách hàng đặt mua? 
select mahang , tenhang
from mathang
where not exists (select mahang from chitietdathang where mathang.mahang = chitietdathang.mahang)
select * from mathang

