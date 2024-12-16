

--select * from Users

--SELECT 
--    Id_User,
--    name,
--    mail,
--    data_reg,
--    JSON_VALUE(Users_json, '$.favorites[0]') AS Favorite1,
--    JSON_VALUE(Users_json, '$.favorites[1]') AS Favorite2
--FROM 
--    Users


--SELECT 
--    Id_User,
--    name,
--    mail,
--    data_reg,
--    value AS Favorite
--FROM 
--    Users
--CROSS APPLY OPENJSON(Users_json, '$.favorites') 
--WHERE 
--    Id_User = 1; 

-------------------------------------------------------------------------------------------------------
--ms sql ��������� ��������, � ������� � "�������������" (JSON-���� �������
--Users) ���� ��������� "electronics".
select Id_User, name, mail, data_reg, Users_json
from Users
where exists (
    select 1 
    from openjson(Users_json, '$.favorites') as favorites
    where favorites.value = 'electronics'
);
--my sql ��������� ��������, � ������� � "�������������" (JSON-���� �������
--Users) ���� ��������� "electronics".
select *
from Users
where json_CONTAINS(json_EXTRACT(Users_json, '$.favorites'), '"electronics"');


----------------------------------------------------------------------------------------------
--ms sql ������� ������, � ������� ����� �������� �������� ����� "New York".
select *
from Orders
where json_value(Order_json,'$.delivery_address.city') ='New York';

--my sql ������� ������, � ������� ����� �������� �������� ����� "New York".
select *
from Orders
where json_UNQUOTE(json_EXTRACT(Order_json,'$.delivery_address.city')) ='New York';

--------------------------------------------------------------------------------------------------
--ms sql �������� ������, � ������� � ��������������� (JSON-���� Products)
--������� ������� ����� 3000mAh.
select p.Id_Products, p.name, p.Category, p.Price
from Products p
cross apply openjson(p.Products_json)
with (
    battery nvarchar(100) '$.battery'
) as prod
where try_convert(int, replace(prod.battery, 'mAh', '')) > 3000;

--my sql �������� ������, � ������� � ��������������� (JSON-���� Products)
--������� ������� ����� 3000mAh.
SELECT p.Id_Products, p.name, p.Category, p.Price
FROM Products p,
     JSON_TABLE(p.Products_json, '$'
        COLUMNS (battery VARCHAR(50) PATH '$.battery')) AS jt
WHERE CAST(SUBSTRING(jt.battery, 1, CHAR_LENGTH(jt.battery) - 3) AS UNSIGNED) > 3000;

-------------------------------------------------------------------------------------��������� ��������------
--ms sql 
--������� ��� ������, ��� ������ �������� � JSON-���� �������� "��������-
--��������".
-------------------------------------�����!!!!!!!!!!������!!!!!!!!!����� � ��� �� �������--------------------------------------------

/*
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
       WHERE Id_Order = @i; -- �������� 1 �� ����������� Id_Order
       set @i = @i + 1
	   
   end
commit
--rollback
go
*/

--ms sql 

select *
from Orders
where json_value(Order_json,'$."Shipping method"') ='Express delivery';

--my sql

select *
from Orders
where json_UNQUOTE(json_EXTRACT(Order_json,'$."Shipping method"')) ='Express delivery';
---------------------------------------------------------------------------------------------------��������� ��������----------------
-- ms sql
--�������� ������ ���� �������� � �� ���������������� ������� ������
--(��������� JSON-������� ��� ���������� ������ �� ����������).
-------------------------------------�����!!!!!!!!!!������!!!!!!!!!����� � ��� �� �������--------------------------------------------
/*
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
       WHERE Id_User = @i; -- �������� 1 �� ����������� Id_Order
       set @i = @i + 1
	   
   end
--commit
rollback
*/
   --������� ������� ��������
   --select *,
   --CONCAT_WS(', ',(JSON_VALUE(Users_json, '$.favorites[0]')),(JSON_VALUE(Users_json, '$.favorites[1]'))) AS Favorites,
   --CONCAT_WS(', ',(JSON_VALUE(Users_json, '$.last_viewed[0]')),(JSON_VALUE(Users_json, '$.last_viewed[1]'))) AS last_viewed,
   --JSON_VALUE(Users_json, '$.Payment_method') AS Payment_method
   --from  Users
   --select *,
   --JSON_VALUE(Users_json, '$.favorites[0]')   as 'Users_json_favorites[0]',
   --JSON_VALUE(Users_json, '$.favorites[1]')   as 'Users_json_favorites[1]',
   --JSON_VALUE(Users_json, '$.last_viewed[0]') as 'Users_json_last_viewed[0]',
   --JSON_VALUE(Users_json, '$.last_viewed[1]') as 'Users_json_last_viewed[1]',
   --JSON_VALUE(Users_json, '$.Payment_method') as 'Payment_method'
   --from  Users


--ms sql 
SELECT 
    Id_User,
    name,
    mail,
    data_reg,
    JSON_VALUE(Users_json, '$.Payment_method') AS '���������������� ������ ������'
FROM 
    Users

--my sql

SELECT 
    Id_User,
    name,
    mail,
    data_reg,
    JSON_EXTRACT(Users_json, '$.Payment_method') AS '���������������� ������ ������'
FROM 
    Users;

--select * from Order_Items
--select * from Orders
--select * from Products
--select * from Transactions
--select * from Users
--select * from V_Users_json

