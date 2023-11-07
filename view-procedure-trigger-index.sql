create database index_view;
use  index_view;
create table Users (
 id int,
 name varchar(100) unique
);
create table  product(

id int auto_increment primary key,
name varchar(100),
price double,
stock int
); 

insert into product(name, price, stock) values 
('sp5',50,155),
('sp2',200,50),
('sp3',300,50),
('sp4',400,50);
 create table orders(
 id int auto_increment primary key,
 idPro int not null,
 quantity int,
 constraint fk_1 foreign key(idPro) references product(id) 
 );

Alter table Users
add column phone varchar(11) unique;
Alter table Users
add column address varchar(255);
--  tạo chỉ mục 
create unique index index_name_address
 on Users(name,address);
 -- xóa chỉ mục 
 Alter table users
 drop index index_name_address;
 
 insert into users value 
 (1,'hùng'),
 (9,'anh'),
 (5,'khánh'),
 (7,'nam');
 select * from users;


-- tạo thủ tục thêm mới 1 bản ghi dũ liệu do người dùng truyèn vào 
delimiter //
create procedure proc_insert (IN id_new int,IN name_new varchar(100))
begin
	-- khối code thực thi 
    insert into users(id, name) values (id_new , name_new);
end //
-- tạo thủ tục in ra tên + id của người dùng với mã ngưỡi dùng nhập vào
 
delimiter //
create procedure proc_get_username (id_find int,Out result varchar(100))
begin
	declare rs1  varchar(100);
	-- khối code thực thi 
    select concat(name,'-', id) into rs1 from users where id = id_find;
    
    set result = rs1;
end //

-- drop procedure proc_get_username;-- 
-- Goi/ thực thi thủ tục
call proc_insert(11,'ngọc anh');


call proc_get_username(11,@rs);

select @rs;

-- tạo view 
create view view_name 
as select * from users where name in ('hung', 'ngoc anh', 'đức')
with check option; 

-- chèn dữ liệu với check option 
insert into view_name values(100,'đưc');

select * from view_name;


drop view view_name;


-- Tạo trigger khi thêm mới 1 sản phẩm thì kiểm tra giá tiền và stock có <= 0 
-- , nếu nhỏ hơn hoặc bằng 0 thì ném ra lỗi và 0 chèn vào

-- CREATE TRIGGER trigger_name
-- {BEFORE | AFTER} {INSERT | UPDATE| DELETE }
-- ON table_name FOR EACH ROW
-- trigger_body;

create trigger before_insert_product 
before insert
on product
for each row 
begin
	if (new.price <=0 or new.stock<=0 )
    then 
		 SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'giá tiền hoặc số lượng phải lớn hơn 0';
      
end

-- thêm mới 1 đơn hàng thì số lượng sản phẩm phải tự động trừ đi
create trigger before_create_order
before insert
on orders
for each row 
begin
   declare old_stock int;
-- lấy ra số lượng hiện tại 
	select stock into old_stock from product  where id = new.idpro;
	-- trừ đi số lượng sản phẩm 
    if (old_stock > new.quantity)
    then 
		update product set stock = stock - new.quantity where id = new.idpro;
    else 
		 SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'só lương mua vượt quá số lượng trong kho';
      end if;
end

insert into orders(idpro,quantity) value(1,1);

