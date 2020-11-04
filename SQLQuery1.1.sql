-- câu 17 Những mặt hàng nào chưa từng được khách hàng đặt mua ?--
SELECT mahang,tenhang
FROM mathang
WHERE NOT EXISTS (SELECT mahang FROM chitietdathang WHERE mahang=mathang.mahang)
-- câu 18 . Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?--
SELECT manhanvien,ho,ten
FROM nhanvien 
WHERE NOT EXISTS (SELECT manhanvien
                  FROM dondathang 
                  WHERE manhanvien = nhanvien.manhanvien
)
--câu 19 Những nhân viên nào của công ty có lương cơ bản cao nhất đặt mua hàng của công ty?
SELECT manhanvien,ho,ten,luongcoban 
FROM nhanvien 
WHERE luongcoban = (SELECT max(luongcoban) FROM nhanvien AS n)
-- câu 20 Tổng số tiền mà khách hàng phải trả cho mỗi đơn đặt hàng là bao nhiêu?
SELECT dondathang.makhachhang,dondathang.sohoadon,tencongty,tengiaodich,SUM(giaban*soluong-soluong*giaban*mucgiamgia/100) AS tongsotien
FROM (dondathang INNER JOIN khachhang ON dondathang.makhachhang = khachhang.makhachhang) INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon
GROUP BY dondathang.makhachhang , tencongty,dondathang.sohoadon,tengiaodich
-- câu 21 Trong năm 2003, những mặt hàng nào chỉ được đặt mua đúng một lần .
SELECT mathang.mahang , mathang.tenhang
FROM (mathang INNER JOIN chitietdathang ON mathang.mahang =chitietdathang.mahang) INNER JOIN
dondathang ON chitietdathang.sohoadon = dondathang.sohoadon
WHERE YEAR(ngaydathang) = 2003
GROUP BY mathang.mahang,mathang.tenhang
HAVING COUNT(chitietdathang.mahang)=1
-- câu 22 . Hãy cho biết mỗi một khách hàng đã phải bỏ ra bao nhiêu tiền để mua hàng
SELECT khachhang.makhachhang , khachhang.tencongty,SUM(soluong*giaban - soluong*giaban*mucgiamgia/100) AS sotienmuahang
FROM (khachhang INNER JOIN dondathang ON khachhang.makhachhang = dondathang.makhachhang)
			INNER JOIN chitietdathang  ON dondathang.sohoadon = chitietdathang.sohoadon
GROUP BY khachhang.makhachhang , khachhang.tencongty
-- câu 23 Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng (nếu nhân viên chưa hề
--lập một hoá đơn nào thì cho kết quả là 0 )
SELECT nhanvien.manhanvien , nhanvien.ho , nhanvien.ten , COUNT(sohoadon) AS sodondathang
FROM nhanvien LEFT OUTER JOIN dondathang ON nhanvien.manhanvien = dondathang.manhanvien
GROUP BY nhanvien.manhanvien , nhanvien.ho,nhanvien.ten
-- câu 24 Cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2003
--(thời gian được tính theo ngày đặt hàng)
SELECT MONTH(ngaydathang) AS tháng,SUM(soluong*giaban - soluong*giaban*mucgiamgia/100) AS sotiencuahangkiemduoc
FROM dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon
WHERE YEAR(ngaydathang)=2003
GROUP BY MONTH(ngaydathang)
-- câu 25 . Hãy cho biết tổng số tiền lời mà công ty thu được từ mỗi mặt hàng trong năm 2003
SELECT mathang.mahang , mathang.tenhang , (SUM(chitietdathang.soluong*giaban - chitietdathang.soluong*giaban*mucgiamgia/100) - SUM(chitietdathang.soluong*giahang)) AS tienloicuacongty
FROM (dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon)
INNER JOIN mathang ON chitietdathang.mahang = mathang.mahang
WHERE YEAR(ngaydathang) = 2003
GROUP BY mathang.mahang,mathang.tenhang
--26. Hãy cho biết tổng số lượng hàng của mỗi mặt hàng mà công ty đã có (tổng số lượng hàng hiện
--có và đã bán)
SELECT mathang.mahang,mathang.tenhang,mathang.soluong + CASE 
											WHEN SUM(chitietdathang.soluong) IS NULL THEN 0
													else SUM(chitietdathang.soluong)
													END AS tongsoluong
FROM mathang LEFT OUTER JOIN chitietdathang ON mathang.mahang = chitietdathang.mahang
GROUP BY mathang.mahang,mathang.tenhang,mathang.soluong
--Nhân viên nào của công ty bán được số lượng hàng nhiều nhất và số lượng hàng bán được của nhân
--viên này là bao nhiêu?
SELECT	nhanvien.manhanvien,nhanvien.ho,nhanvien.ten,SUM(soluong) AS tongSL
FROM (nhanvien INNER JOIN dondathang ON nhanvien.manhanvien = dondathang.manhanvien ) INNER JOIN chitietdathang 
ON dondathang.sohoadon = chitietdathang.sohoadon
GROUP BY nhanvien.manhanvien,nhanvien.ho,nhanvien.ten
HAVING SUM(soluong) >= ALL(SELECT sum(soluong) FROM (nhanvien INNER JOIN dondathang ON nhanvien.manhanvien = dondathang.manhanvien ) INNER JOIN chitietdathang 
ON dondathang.sohoadon = chitietdathang.sohoadon 
                       GROUP BY nhanvien.manhanvien,nhanvien.ho,nhanvien.ten)
--28. Đơn đặt hàng nào có số lượng được đặt mua ít nhất?
SELECT dondathang.sohoadon , SUM(soluong) AS soluong
FROM dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon
GROUP BY dondathang.sohoadon
HAVING SUM(soluong) <= ALL(SELECT SUM(soluong) FROM dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon 
                           GROUP BY dondathang.sohoadon)
--29. Số tiền nhiều nhất mà mỗi khách hàng đã từng bỏ ra để đặt hàng trong các đơn đặt hàng là bao
--nhiêu?
SELECT khachhang.makhachhang,khachhang.tencongty,SUM(chitietdathang.soluong*giaban - chitietdathang.soluong*giaban*mucgiamgia/100) AS sotiennhieunhat
FROM (khachhang INNER JOIN dondathang ON khachhang.makhachhang = dondathang.makhachhang) INNER JOIN 
chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon
GROUP BY khachhang.makhachhang,khachhang.tencongty
ORDER BY sotiennhieunhat DESC


SELECT TOP 1 SUM(chitietdathang.soluong*giaban - chitietdathang.soluong*giaban*mucgiamgia/100)
FROM dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon
ORDER BY 1 DESC


--30. Mỗi một đơn đặt hàng đặt mua những mặt hàng nào và tổng số tiền mà mỗi đơn đặt hàng phải trả là bao
--nhiêu?
SELECT	dondathang.sohoadon,mathang.mahang,mathang.tenhang,SUM(chitietdathang.soluong*giaban-chitietdathang.soluong*giaban*mucgiamgia/100) AS tongsotien
FROM (dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon)
	INNER JOIN mathang ON chitietdathang.mahang = mathang.mahang
GROUP BY dondathang.sohoadon,mathang.mahang,mathang.tenhang


SELECT	dondathang.sohoadon,mathang.mahang,mathang.tenhang,SUM(chitietdathang.soluong*giaban-chitietdathang.soluong*giaban*mucgiamgia/100)
FROM (dondathang INNER JOIN chitietdathang ON dondathang.sohoadon = chitietdathang.sohoadon)
	INNER JOIN mathang ON chitietdathang.mahang = mathang.mahang
ORDER BY dondathang.sohoadon
COMPUTE SUM(chitietdathang.soluong*giaban-chitietdathang.soluong*giaban*mucgiamgia/100) BY dondathang.sohoadon

--31. Hãy cho biết mỗi một loại hàng bao gồm những mặt hàng nào, tổng số lượng hàng của mỗi loại và tổng số
--lượng của tất cả các mặt hàng hiện có trong công ty là bao nhiêu?
SELECT loaihang.maloaihang,loaihang.tenloaihang,mathang.tenhang,SUM(mathang.soluong) AS tongsoluong
FROM loaihang INNER JOIN mathang ON loaihang.maloaihang = mathang.maloaihang
GROUP BY loaihang.maloaihang,loaihang.tenloaihang,mathang.tenhang

--32 . Thống kê xem trong năm 2003, mỗi một mặt hàng trong mỗi tháng và trong cả năm bán được với số lượng bao nhiêu.*/

SELECT B.mahang,tenhang,
         SUM(CASE MONTH(ngaydathang)WHEN 1 THEN B.soluong
               ELSE 0 END) AS thang1,
         SUM(CASE MONTH(ngaydathang)WHEN 2 THEN B.soluong
               ELSE 0 END) AS thang2,
         SUM(CASE MONTH(ngaydathang)WHEN 3 THEN B.soluong
               ELSE 0 END) AS thang3,
         SUM(CASE MONTH(ngaydathang)WHEN 4 THEN B.soluong
               ELSE 0 END) AS thang4,
         SUM(CASE MONTH(ngaydathang)WHEN 5 THEN B.soluong
               ELSE 0 END) AS thang5,
         SUM(CASE MONTH(ngaydathang)WHEN 6 THEN B.soluong
               ELSE 0 END) AS thang6,
         SUM(CASE MONTH(ngaydathang)WHEN 7 THEN B.soluong
               ELSE 0 END) AS thang7,
         SUM(CASE MONTH(ngaydathang)WHEN 8 THEN B.soluong
               ELSE 0 END) AS thang8,
         SUM(CASE MONTH(ngaydathang)WHEN 9 THEN B.soluong
               ELSE 0 END) AS thang9,
         SUM(CASE MONTH(ngaydathang)WHEN 10 THEN B.soluong
               ELSE 0 END) AS thang10,
         SUM(CASE MONTH(ngaydathang)WHEN 11 THEN B.soluong
               ELSE 0 END) AS thang11,
         SUM(CASE MONTH(ngaydathang)WHEN 12 THEN B.soluong
               ELSE 0 END) AS thang12,
         SUM (B.soluong) AS canam
FROM (dondathang AS A INNER JOIN chitietdathang AS B
        ON A.sohoadon=B.sohoadon)
        INNER JOIN mathang AS C ON B.mahang=C.mahang
WHERE YEAR(ngaydathang)=2003
GROUP BY B.mahang,tenhang
