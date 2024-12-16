create database Magaz_DB_4
collate Cyrillic_General_CI_AS --задаём кодировку для БД по умолчаниючанию
go


use Magaz_DB_4 
go
create table  Users
(
Id_User bigint identity(1,1) not null  
,name nvarchar(100) null 
,mail nvarchar(200) null
,data_reg datetime not null default  getdate()
,Users_json nvarchar(max) null
constraint PK_Id_User Primary key  (Id_User)
)
go

create table  Products
(
Id_Products bigint identity(1,1) not null  
,name nvarchar(100) null 
,Category nvarchar(300) null 
,Products_json nvarchar(max) null
,Price float null
constraint PK_Id_Products Primary key  (Id_Products)
)
go

create table  Orders
(
Id_Order bigint identity(1,1) not null 
,Id_User bigint null
,DateOrder datetime not null default  getdate()
,Order_json nvarchar(max) null
constraint PK_Id_Orders Primary key  (Id_Order),
constraint FK_Id_Orders_Id_User Foreign key  (Id_User) references  Users(Id_User) on delete set null on Update cascade 
)
go

create table  Order_Items
(
Id_Products bigint null 
,Id_Order bigint null
,quantity int null
constraint FK_Id_Order_Items_Id_Products Foreign key  (Id_Products) references  Products(Id_Products) on delete set null on Update cascade ,
constraint FK_Id_Order_Items_Id_Order Foreign key  (Id_Order) references  Orders(Id_Order) on delete set null on Update cascade 
)
go

create table  Transactions
(
Id_Transactions  bigint identity(1,1) not null   
,Id_Order bigint null
,AmountTransactions Float null
,DateTransactions datetime not null  default  getdate()
,stateTransactions nvarchar(100) null check (stateTransactions in ('Оплачено','Отменено','В Обработке'))
,Transactions_JSON  nvarchar(max) null
constraint PK_Id_Transactions Primary key (Id_Transactions),
constraint FK_Id_Transactions_Orders Foreign key  (Id_Order) references  Orders(Id_Order) on delete set null on Update cascade 
)
go

use  Magaz_DB_4 
go

begin tran
declare @i int  =1;
 while @i < = 10
  begin 
  insert into  Users(name,mail,data_reg,Users_json)
  values 
  (
     case when round(rand()*5,0) = 1 then  'Андрей'
	      when round(rand()*5,0) = 2 then  'Владимир'
		  when round(rand()*5,0) = 3 then  'Сергей'
		  when round(rand()*5,0) = 4 then  'Антон'
		  when round(rand()*5,0) = 5 then  'Василий'
		  when round(rand()*5,0) = 1 then  'Константин'
		  when round(rand()*5,0) = 2 then  'Трафим'
		  when round(rand()*5,0) = 3 then  'Олег'
		  when round(rand()*5,0) = 4 then  'Дмитрий'
		  when round(rand()*5,0) = 5 then  'Павел'
		  when round(rand()*5,0) = 6 then  'Николай'
	 else 'Евгений'end,
	 case when round(rand()*5,0) = 1 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@zoho.com'
	      when round(rand()*5,0) = 2 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@Mail.com'
	 	  when round(rand()*5,0) = 3 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@yandex.ru'
	 	  when round(rand()*5,0) = 4 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@outlook.com'
	 	  when round(rand()*5,0) = 5 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@yandex.ru'
	 	  when round(rand()*5,0) = 1 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@mail.ru'
	 	  when round(rand()*5,0) = 2 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@yandex.ru'
	 	  when round(rand()*5,0) = 3 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@yahoo.com'
	 	  when round(rand()*5,0) = 4 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@hotmail.com'
	 	  when round(rand()*5,0) = 5 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@yandex.ru'
	 	  when round(rand()*5,0) = 6 then  (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@gmail.com'
	 else   (REPLACE(SUBSTRING(CONVERT(varchar(36), NEWID()), 1, 10), '-', '')) + '@icloud.com'end,
	 DATEADD(DAY, -ROUND(RAND() * 950, 0), GETDATE()),
	 CONCAT(
            '{"favorites": ["', 
            (CASE WHEN RAND() < 0.5 THEN 'electronics' ELSE 'clothing' END), 
            '", "', 
            (CASE WHEN RAND() < 0.5 THEN 'books' ELSE 'music' END), 
            '"], "last_viewed": ["', 
            (CASE WHEN RAND() < 0.5 THEN 'laptop' ELSE 'tablet' END), 
            '", "', 
            (CASE WHEN RAND() < 0.5 THEN 'smartphone' ELSE 'headphones' END), 
            '"]}'
        )
	);
  set @i = @i +1
  print ' Добавлено строк' +  ' - число   ' + convert(nvarchar(10),@i);

end
commit

go

begin tran
INSERT INTO Products (name, Category, Products_json, Price) VALUES
('HP 245 G8', 'Ноутбук', '{"color": "black", "size": "15.6 inch", "battery": "5000mAh", "RAM": "8GB"}', 65000.00),
('Apple MacBook Air M2', 'Ноутбук', '{"color": "gold", "size": "13.3 inch", "battery": "7500mAh", "RAM": "8GB"}', 100000.00),
('Honor Magicbook X16', 'Ноутбук', '{"color": "silver", "size": "16 inch", "battery": "6000mAh", "RAM": "16GB"}', 70000.00),
('ASUS Vivobook Pro 14X OLED', 'Ноутбук', '{"color": "blue", "size": "14 inch", "battery": "4000mAh", "RAM": "16GB"}', 80000.00),
('MSI Prestige 15', 'Ноутбук', '{"color": "gray", "size": "15.6 inch", "battery": "4500mAh", "RAM": "32GB"}', 90000.00),
('Apple iPhone 15', 'Сотовый телефон', '{"color": "black", "storage": "128GB", "battery": "3500mAh", "camera": "48MP"}', 80000.00),
('Huawei nova 11 Pro', 'Сотовый телефон', '{"color": "silver", "storage": "256GB", "battery": "4500mAh", "camera": "50MP"}', 40000.00),
('Samsung Galaxy A54 5G', 'Сотовый телефон', '{"color": "blue", "storage": "128GB", "battery": "5000mAh", "camera": "64MP"}', 35000.00),
('Xiaomi 13 Pro', 'Сотовый телефон', '{"color": "white", "storage": "256GB", "battery": "4820mAh", "camera": "50MP"}', 75000.00),
('Samsung Galaxy Tab A7 Lite', 'Планшет', '{"color": "black", "size": "10.4 inch", "battery": "7040mAh", "storage": "32GB"}', 20000.00),
('Huawei MatePad SE', 'Планшет', '{"color": "gray", "size": "10.4 inch", "battery": "5100mAh", "storage": "64GB"}', 25000.00);
--rollback
commit

go


begin tran 
DECLARE @i INT = 0;
WHILE @i < 20
BEGIN
    DECLARE @randomUserId BIGINT = REPLACE((CAST(ROUND((RAND() * 10)+1, 0) AS BIGINT)),11,1);
    DECLARE @randomCity NVARCHAR(50) = CASE WHEN (ABS(CHECKSUM(NEWID())) % 2 = 0) THEN 'New York' ELSE 'Los Angeles' END;
    DECLARE @randomZip NVARCHAR(4) = CAST(ROUND(RAND() * 8999 + 1000, 0) AS NVARCHAR(4));
    
    INSERT INTO Orders (Id_User,DateOrder, Order_json)
    VALUES (
        @randomUserId,
		DATEADD(DAY, -ROUND(RAND() * 150, 0), GETDATE()),
        JSON_QUERY(CONCAT('{"delivery_address": {"street": "', 
            LEFT(NEWID(), 3), ' St", "city": "', 
            @randomCity, 
            '", "zip": "', 
            @randomZip, '"}}'))
    );

    SET @i = @i + 1;
END
commit

go

begin tran 
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
	DECLARE @quantity int = CAST(round((rand() * 9)+1,0)AS INT)
    insert into dbo.Order_Items (Id_Products,Id_Order, quantity)
	values
	(
	(select top 1  Id_Products  from Products order by NEWID()),
	@i,
	@quantity
	)
    SET @i = @i + 1;
END
--rollback
commit

go


begin tran 
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
	declare  @Id_order bigint  
	DECLARE @stateTransactions VARCHAR(50)
	declare  @DateOrder datetime 
    insert into dbo.Transactions (Id_Order,AmountTransactions,DateTransactions,stateTransactions)
	values
	(
	 @i,
	(     
	    (select 
        (ot.quantity * p.Price) as Summa_Transactions
        from Order_Items as ot
        inner join Orders   as o on  o.Id_Order    = ot.Id_Order 
        inner join Products as p on  p.Id_Products = ot.Id_Products 		
	    where @i = ot.ID_order)
	 ),
	 (
	    select 
	    DATEADD (DAY, ROUND(RAND() * 5, 0), o.DateOrder)
        from Order_Items as ot
        inner join Orders   as o on  o.Id_Order    = ot.Id_Order 
        inner join Products as p on  p.Id_Products = ot.Id_Products 
        where ot.Id_Order = @i
	 ),
	 (
	    case when round(rand()*2,0)= 2 then 'Оплачено' 
	         else  case when round(rand()*1,0)= 1 then 'Отменено'
	                else  'В Обработке' 
					 
			 end
		 end
	 )
	);
    SET @i = @i + 1;
END
--rollback
commit	 
go

begin tran 
DECLARE @g INT = 1;
WHILE @g <= 20
     BEGIN
	      update a
		  set Transactions_JSON =
          (
          CASE 
              WHEN stateTransactions = 'Оплачено' THEN '{"Payment method": "non-cash payment", "comments from the bank": "The money has been credited"}' 
              WHEN stateTransactions = 'Отменено' THEN '{"Payment method": "There was no payment", "comments from the bank": "transactions for this order did not arrive"}' 
              WHEN stateTransactions = 'В Обработке' THEN '{"Payment method": "The information is being verified", "comments from the bank": "the account, information about the transaction has been received in the bank s database."}' 
          END 
		  )
		  from  Transactions a  where Id_Order =  @g
    SET @g = @g + 1;
END
--rollback
commit

go

begin tran
declare @i int =1
declare @e nvarchar(50) 
while @i <= 20
   begin
       set @e = (case when round(rand()*4,0)= 4 then 'Express delivery' 
	                  when round(rand()*4,0)= 3 then 'I ll take it myself'
					  when round(rand()*4,0)= 2 then 'Courier delivery'
					  when round(rand()*4,0)= 1 then 'Mail delivery'
					  else 'Express delivery' end
	   )
       UPDATE Orders
       SET Order_json = JSON_MODIFY(Order_json, '$."Shipping method"', @e)
       WHERE Id_Order = @i; -- Замените 1 на необходимый Id_Order
       set @i = @i + 1
	   
   end
commit
--rollback
go

begin tran
declare @i int =1
declare @e nvarchar(50) 
while @i <= 10
   begin
       set @e = (case when round(rand()*4,0)= 4 then 'In cash' 
	                  when round(rand()*4,0)= 3 then 'Cashless payment'
					  when round(rand()*4,0)= 2 then 'Bank transfers'
					  when round(rand()*4,0)= 1 then 'Electronic wallets'
					  else 'Electronic wallets' end
	   )
       UPDATE Users
       SET Users_json = JSON_MODIFY(Users_json, '$.Payment_method', @e)
       WHERE Id_User = @i; -- Замените 1 на необходимый Id_Order
       set @i = @i + 1
	   
   end
commit
--rollback

go


begin tran
ALTER TABLE Users
ADD CONSTRAINT ['Содержимое Users_json является неверным и должно быть отформатировано' as JSON]
 CHECK ( ISJSON( Users_json )> 0 )
go
ALTER TABLE Products
ADD CONSTRAINT ['Содержимое Products_json является неверным и должно быть отформатировано' as JSON]
 CHECK ( ISJSON( Products_json )> 0 )
go
ALTER TABLE Orders
ADD CONSTRAINT ['Содержимое Order_json является неверным и должно быть отформатировано' as JSON]
 CHECK ( ISJSON( Order_json )> 0 )
go
ALTER TABLE Transactions
ADD CONSTRAINT ['Содержимое Transactions_json является неверным и должно быть отформатировано' as JSON]
 CHECK ( ISJSON( Transactions_json )> 0 )
go
--rollback
commit



go
 create view  V_Orders_json
 WITH SCHEMABINDING
   as
   select 
   Id_Order
   ,DateOrder
   ,CAST(JSON_VALUE(Order_json, '$."delivery_address"."street"')as nvarchar(700)) as 'Order_json_delivery_address_street'
   ,CAST(JSON_VALUE(Order_json, '$."delivery_address"."city"')  as nvarchar(700)) as 'Order_json_delivery_address_city'
   ,CAST(JSON_VALUE(Order_json, '$."delivery_address"."zip"')   as nvarchar(700)) as 'Order_json_delivery_address_zip'
   ,CAST(JSON_VALUE(Order_json, '$."Shipping method"')         as nvarchar(700)) as 'Order_json_Shipping_method'
   from  dbo.Orders

go

begin tran
CREATE UNIQUE  CLUSTERED INDEX IX_Id_Order    ON V_Orders_json(Id_Order)
CREATE NONCLUSTERED INDEX IX_Orders_json_delivery_address_street    ON V_Orders_json(Order_json_delivery_address_street)
CREATE NONCLUSTERED INDEX IX_Orders_json_delivery_address_city    ON V_Orders_json(Order_json_delivery_address_city)
CREATE NONCLUSTERED INDEX IX_Orders_json_delivery_address_zip  ON V_Orders_json(Order_json_delivery_address_zip)
CREATE NONCLUSTERED INDEX IX_Orders_json_Shipping_method  ON V_Orders_json(Order_json_Shipping_method)
--rollback
commit

go
 create view  V_Products_json
 with SCHEMABINDING
   as
    select 
    Id_Products,
    name,
    Category,
    Price,
    cast(json_value(Products_json, '$.color')   as nvarchar(700))as Color,
    cast(json_value(Products_json, '$.size')    as nvarchar(700))as Size,
    cast(json_value(Products_json, '$.battery') as nvarchar(700))as Battery,
    cast(json_value(Products_json, '$.RAM')     as nvarchar(700))as RAM,
    cast(json_value(Products_json, '$.storage') as nvarchar(700))as Storage,
    cast(json_value(Products_json, '$.camera')  as nvarchar(700))as Camera
from dbo.Products
go

begin tran
CREATE UNIQUE  CLUSTERED INDEX IX_Id_Products               ON V_Products_json(Id_Products)
CREATE NONCLUSTERED INDEX IX_Products_json_delivery_color   ON V_Products_json(Color)
CREATE NONCLUSTERED INDEX IX_Products_json_delivery_Size    ON V_Products_json(Size)
CREATE NONCLUSTERED INDEX IX_Products_json_delivery_battery ON V_Products_json(Battery)
CREATE NONCLUSTERED INDEX IX_Products_json_Shipping_RAM     ON V_Products_json(RAM)
CREATE NONCLUSTERED INDEX IX_Products_json_Shipping_storage ON V_Products_json(Storage)
CREATE NONCLUSTERED INDEX IX_Products_json_Shipping_camera  ON V_Products_json(Camera)
--rollback
commit

go
 create view  V_Transactions_json
 WITH SCHEMABINDING
   as
   select 
   Id_Transactions
   ,Id_Order
   ,AmountTransactions
   ,DateTransactions
   ,stateTransactions
   ,CAST(JSON_VALUE(Transactions_JSON, '$."Payment method"')as nvarchar(700)) as 'Transactions_JSON_Payment_method'
   ,CAST(JSON_VALUE(Transactions_JSON, '$."comments from the bank"')  as nvarchar(700)) as 'Transactions_JSON_comments_from_the_bank'
   from  dbo.Transactions

go

begin tran
CREATE UNIQUE  CLUSTERED INDEX IX_Id_Transactions    ON V_Transactions_json(Id_Transactions)
CREATE NONCLUSTERED INDEX IX_Transactions_JSON_Payment_method          ON V_Transactions_json(Transactions_JSON_Payment_method)
CREATE NONCLUSTERED INDEX IX_Transactions_JSON_comments_from_the_bank  ON V_Transactions_json(Transactions_JSON_comments_from_the_bank)
--rollback
commit

go
 create view  V_Users_json
   WITH SCHEMABINDING
   as
   select 
   Id_User
   ,name
   ,mail
   ,data_reg
   ,CAST(JSON_VALUE(Users_json, '$.favorites[0]')as nvarchar(700))   as 'Users_json_favorites_0'
   ,CAST(JSON_VALUE(Users_json, '$.favorites[1]')as nvarchar(700))   as 'Users_json_favorites_1'
   ,CAST(JSON_VALUE(Users_json, '$.last_viewed[0]')as nvarchar(700)) as 'Users_json_last_viewed_0'
   ,CAST(JSON_VALUE(Users_json, '$.last_viewed[1]')as nvarchar(700)) as 'Users_json_last_viewed_1'
   ,CAST(JSON_VALUE(Users_json, '$.Payment_method')as nvarchar(700)) as 'Payment_method'
   from  dbo.Users
go

begin tran
CREATE UNIQUE  CLUSTERED INDEX IX_Id_Useru    ON V_Users_json(Id_User)
CREATE NONCLUSTERED INDEX IX_Users_json_favorites_0    ON V_Users_json(Users_json_favorites_0)
CREATE NONCLUSTERED INDEX IX_Users_json_favorites_1    ON V_Users_json(Users_json_favorites_1)
CREATE NONCLUSTERED INDEX IX_Users_json_last_viewed_0  ON V_Users_json(Users_json_last_viewed_0)
CREATE NONCLUSTERED INDEX IX_Users_json_last_viewed_1  ON V_Users_json(Users_json_last_viewed_1)
CREATE NONCLUSTERED INDEX IX_Users_json_Payment_method ON V_Users_json(Payment_method)
--rollback
commit

--И для задание понадобилось дополнительно добавить дпнные в JSON


/*
Пользователи (Users): Хранит информацию о клиентах.
o ID пользователя (PK)
o Имя пользователя
o Электронная почта
o Дата регистрации
o JSON-поле с дополнительной информацией о пользователе (например,
предпочтения, история просмотров товаров и т.д.)
• Товары (Products): Хранит информацию о товарах, которые продаются.
o ID товара (PK)
o Название товара
o Категория
o Цена
o JSON-поле с характеристиками товара (например, цвет, размер,
технические характеристики и т.д.)
• Заказы (Orders): Хранит информацию о заказах.
o ID заказа (PK)
o ID пользователя (FK)
o Дата заказа
o JSON-поле с дополнительной информацией о заказе (например, адрес
доставки, предпочтительный способ доставки и т.д.)
• Товары в заказах (Order_Items): Связующая таблица для заказов и товаров.
o ID товара (FK)
o ID заказа (FK)
o Количество товара
• Транзакции (Transactions): Хранит информацию о платежах.
o ID транзакции (PK)
o ID заказа (FK)
o Сумма транзакции
o Дата транзакции
o Статус (оплачено, отменено и т.д.)
o JSON-поле с деталями транзакции (например, метод оплаты,
дополнительные комментарии от банка)
*/


--select * from Order_Items
--select * from Orders
--select * from Products
--select * from Transactions
--select * from Users