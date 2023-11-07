-- chữa bt
-- 62.Cho biết những sinh viên học những môn bằng đúng những môn mà sinh 
-- viên A02 học

-- b1 tìm những môn học mà A02 học
select distinct MaMH from ketqua where MaSV = 'A02';
-- b2: tìm những kết quả thi của các môn học mà A02 học trừ kết quả của sinh viên A02 ra
select * from ketqua  where MaMH in (select distinct MaMH from ketqua where MaSV = 'A02') and MaSV not like 'A02';
-- b3: lọc những sinh viên có số lượng môn học đúng bằng số lượng môn học mà A02 học
select MaSV 
from ketqua  
where MaMH in 
	(select distinct MaMH from ketqua where MaSV = 'A02') 
and MaSV not like 'A02'
group by MaSV 
having count(distinct MaMH) = (select count(distinct MaMH) from ketqua where MaSV = 'A02');
-- 10.Danh sách các sinh viên của khoa Anh văn và khoa Vật lý, gồm các thông 
-- tin: Mã sinh viên, Mã khoa, Phái.

SELECT dmsv.MaSV,dmsv.MaKhoa,dmsv.Phai FROM dmkhoa join dmsv on dmkhoa.MaKhoa = dmsv.MaKhoa 
where dmkhoa.TenKhoa like 'Anh Văn' or dmkhoa.TenKhoa like 'Vật lý';

-- 28.Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa.
select dmkhoa.TenKhoa,dmsv.Phai,count(dmsv.MaSV) from dmsv
join dmkhoa on dmkhoa.MaKhoa= dmsv.MaKhoa
group by dmkhoa.MaKhoa,dmsv.Phai;


select B1.*,b2.`Nữ`
from
(select MaKhoa,sum(if(phai = 'Nam',1,0)) `Nam` from dmsv
group by MaKhoa) as B1
join
(select MaKhoa,sum(if(phai = 'Nữ',1,0)) `Nữ` from dmsv
group by MaKhoa)as B2
on B1.makhoa=b2.makhoa
; 

-- 41.Cho biết sinh viên khoa anh văn có tuổi lớn nhất.

select *,year(now())-year(ngaysinh)  from dmsv
where year(now())-year(ngaysinh)  >= All(select year(now())-year(ngaysinh) from dmsv where makhoa = 'AV') and MaKhoa='AV';

select * from dmsv where year(now())-year(ngaysinh) =
(select max(year(now())-year(ngaysinh)) from dmsv where makhoa = 'AV')  and MaKhoa='AV';

-- 45.Cho biết sinh viên không học khoa anh văn có điểm thi môn văn phạm lớn hơn 
 -- điểm thi văn phạm của sinh viên học khoa anh văn.
 select v.TenSV from view_diem v where v.MaKhoa not like 'AV' and v.diem >= any 
 (select v.Diem from view_diem v where v.MaKhoa = 'AV' and v.MaMH = '05');
 
 create view view_diem 
 as select s.*,k.mamh,k.lanthi,k.diem from ketqua k join dmsv s on k.masv = s.MaSV;
 
 
 



