								



								/*---create database---*/



create database car_sales_and_rental
use car_sales_and_rental


								/*---create login, role, schema,granting---*/				


create schema login
create schema system_Users 
create schema resources


create role customer
create role admin
create role manager

/*granting previleges for admin*/
grant control on schema:: system_Users to admin with grant option
grant control on schema:: resources to admin with grant option

/*granting for customer*/
grant select on object::resources.view_Available_Cars to manager
grant select on object::resources.view_rented_cars to manager 
grant select on object::resources.view_rented_cars to manager 
--functions
grant select on object::resources.view_Available_Cars to customer
grant select on object::resources.search_By_Sales_Price to customer
grant select on object::resources.search_By_Rental_Price to customer
grant select on object::resources.search_By_Model to customer
grant select on object::resources.search_By_Mark to customer
grant select on object::resources.search_By_Manufacture_Year to customer
grant select on object::resources.search_By_Transmission_Type to customer
grant select on object::resources.search_By_Horse_Power to customer
grant select on object::resources.view_Customer_Rental_History to customer
grant select on object::resources.view_Customer_Sales_History to customer
grant execute on object::resources.calc_Rent_Payment to customer
grant execute on object::resources.calc_Punishment to customer
grant execute on object::resources.calc_Reserve_Date to customer

--procedures
grant execute on object::system_Users.view_Customer_Info to customer
grant execute on object::system_Users.create_Customer_Account to customer
grant execute on object::system_Users.add_Customer_Phone_Number to customer
grant execute on object::resources.reserve_Car to customer
grant execute on object::resources.cancel_Reservation to customer

--trigger (denying disabling triggers)
deny alter any database ddl trigger to customer


/*granting for manager*/

--functions
grant select on object::resources.view_All_Cars to manager
grant select on object::resources.view_Suspended_Cars to manager
grant select on object::resources.view_Reserved_Cars to manager
grant select on object::resources.view_Rented_Cars to manager
grant select on object::resources.view_Sold_Cars to manager
grant select on object::resources.view_Reservation_History to manager
grant select on object::resources.view_All_Active_Reservation to manager
grant select on object::resources.view_Reservation_Today to manager
grant select on object::resources.view_Reservation_At_Given_Date to manager
grant select on object::resources.view_All_Rented to manager
grant select on object::resources.view_Not_Returned to manager
grant select on object::resources.view_Passed_Deadline_Not_Returned to manager
grant select on object::resources.view_To_Be_Returned_Today to manager
grant select on object::resources.view_Managed_Rents to manager
grant select on object::resources.view_Rented_Returned to manager
grant select on object::resources.view_Rented_Returned_Today to manager
grant select on object::resources.view_Customer_Rental_History to manager
grant select on object::resources.view_Managed_Returns to manager
grant select on object::resources.view_All_Sales to manager
grant select on object::resources.view_All_Sales_Today to manager
grant select on object::resources.view_All_Sales_At_Given_Date to manager
grant select on object::resources.view_Customer_Sales_History to manager
grant select on object::resources.view_Managed_Sales to manager
grant select on object::resources.search_By_Sales_Price to manager
grant select on object::resources.search_By_Rental_Price to manager
grant select on object::resources.search_By_Model to manager
grant select on object::resources.search_By_Mark to manager
grant select on object::resources.search_By_Manufacture_Year to manager
grant select on object::resources.search_By_Transmission_Type to manager
grant select on object::resources.search_By_Horse_Power to manager
grant select on object::resources.manager_Daily_Audit to manager
grant execute on object::resources.total_Money_From_Canceled_And_Expired_Reservations to manager
grant execute on object::resources.calc_Rent_Payment to manager
grant execute on object::resources.calc_Punishment to manager
grant execute on object::resources.calc_Reserve_Date to manager
grant execute on object::resources.check_Customer_Free to manager

--procedure
grant execute on object::system_Users.view_Customer_Info to manager
grant execute on object::system_Users.view_Manager_Info to manager
grant execute on object::system_Users.create_Manager_Account to manager
grant execute on object::system_Users.add_Manager_Phone_Number to manager
grant execute on object::resources.reserve_Car to manager
grant execute on object::resources.rent_Car to manager
grant execute on object::resources.return_Car to manager
grant execute on object::resources.sell_Car to manager
grant execute on object::system_Users.record_Customer_Info_In_Person to manager
grant execute on object::system_Users.add_Phone_Number_In_Person to manager




/* for login and users*/
create login admin1 with password='1234'
create user admin1 for login admin1
exec sp_addRoleMember customer,admin1

create login manager1 with password='1234'
create user manager1 for login manager1
exec sp_addRoleMember manager,manager1

create login customer1 with password='1234'
create user customer1 for login customer1
exec sp_addRoleMember admin,customer1


/* to remove user from role we can use sp_dropsrvrolemember [role name],[user name]*/

								/*---create tables---*/



/*for login*/
create table login.Login(
email varchar(30) primary key not null,
password varchar(15) not null
) 

/*for customer*/
create table system_Users.Customer(
customer_ID int identity(1,1) primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
driving_Licence_No varchar(10) not null,
birth_Date date not null,
email varchar(30) constraint email1 foreign key(email) references login.Login(email) unique,/*if we are using this for in person customers only...it's not relevant*/
)

create table system_Users.Customer_Phone_No(
phone_No int primary key not null,
customer_ID int constraint customer_ID1 foreign key(customer_ID) references system_Users.Customer(customer_ID) not null
)

create table system_Users.Customer_Address(
city varchar(20) not null,
kebele int not null,
customer_ID int constraint customer_ID2 foreign key(customer_ID) references system_Users.Customer(customer_ID) not null
)

/*for admin*/
create table system_Users.Admin(
admin_ID int identity(1,1) primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
email varchar(30) constraint email2 foreign key(email) references login.Login(email) unique not null
)

create table system_Users.Admin_Phone_No(
phone_No int primary key not null,
admin_ID int constraint admin_ID1 foreign key(admin_ID) references system_Users.Admin(admin_ID) not null
)

create table system_Users.Admin_Address(
city varchar(20) not null,
kebele int not null,
admin_ID int constraint admin_ID2 foreign key(admin_ID) references system_Users.Admin(admin_ID) not null
)

/*for manager*/

create table system_Users.Manager(
manager_ID int identity(1,1) primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
email varchar(30) constraint email3 foreign key(email) references login.Login(email) unique not null
)

create table system_Users.Manager_Phone_No(
phone_No int primary key not null,
manager_ID int constraint manager_ID1 foreign key(manager_ID) references system_Users.Manager(manager_ID) not null
)

create table system_Users.Manager_Address(
city varchar(20) not null,
kebele int not null,
manager_ID int constraint manager_ID2 foreign key(manager_ID) references system_Users.Manager(manager_ID) not null
)

/*for car*/
create table resources.Car(
car_ID int identity(1,1) primary key not null,
color varchar(15) not null,
manufacture_Year int not null,
mark varchar(30) not null,
model varchar(30) not null,
type varchar(30) not null, --values will be: either 'luxury' or 'transportation' to indicate the types of the cars use
transmission_Type varchar(30) not null,
fuel_Type varchar(30) not null,
status varchar(20) not null,/*values will be: available(for both rental and sales), rented, sold, service, reserved*/
horse_Power int not null,
sales_Price money not null,
rental_Price_Per_Day money not null,
total_Rented_Date int not null,
car_Date date not null,
plate_Number int not null
)

/*for reservation*/
create table resources.Reservation(
reservation_ID int identity(1,1) primary key not null,
customer_ID int constraint customer_ID3 foreign key(customer_ID) references system_Users.Customer(customer_ID),
reserve_Type varchar(5) not null,
reserve_Payment money not null,
car_ID int constraint car_ID1 foreign key(car_ID) references resources.Car(car_ID) not null,
reserved_Date date not null,
status int not null
)

create table resources.Canceled_Reservation(
reservation_ID int primary key not null,
customer_ID int constraint customer_ID4 foreign key(customer_ID) references system_Users.Customer(customer_ID),
reserve_Type varchar(5) not null,
reserve_Payment money not null,
car_ID int constraint car_ID2 foreign key(car_ID) references resources.Car(car_ID) not null,
reserved_Date date not null,
status int not null,
cancel_Type varchar(10)
)

create table resources.Managers_Manage_Reservation(
reservation_ID int primary key constraint reservation_ID foreign key (reservation_ID) references resources.Reservation(reservation_ID) not null,
manager_ID int constraint manager_ID3 foreign key (manager_ID) references system_Users.Manager(manager_ID)
)

/*for rent*/
create table resources.Rent(
rent_ID int identity(1,1) primary key not null,
reservation_ID int constraint reservation_ID1 foreign key references resources.Reservation(reservation_ID) not null,
pick_Up_Date date not null,
return_Date date not null,
payment money not null,
)

create table resources.Rent_Invoice(
invoice_ID int identity(1,1) primary key not null,
rent_ID int constraint rent_ID1 foreign key(rent_ID) references resources.Rent(rent_ID) not null,
punishment int not null,
actual_Return_Date date not null,
damage_Compensation int ,
total_Payment money not null
)

create table resources.Managers_Manage_Return(
rent_ID int primary key constraint rent_ID2 foreign key (rent_ID) references resources.Rent(rent_ID) not null,
manager_ID int constraint manager_ID4 foreign key (manager_ID) references system_Users.Manager(manager_ID)
)

/*for purchase*/
create table resources.Sale(
sale_ID int identity(1,1) primary key not null,
reservation_ID int constraint reservation_ID2 foreign key(reservation_ID) references resources.Reservation(reservation_ID) not null,
date_Of_Sale date not null,
payment money not null
)
  

  /*login*/ /*different sql statements for retrieving, updating and deleting data from tables ..for the question 2.IV*/
select * from login.Login
Insert into login.Login (email,password) values	
		('seyfekalu@gmail.com','1234'),
		('bekele@gmail.com','1235'),
		('emnettilahun@gmail.com','abc'),
		('sabaabayneh@gmail.com','4321'),
		('yonasmelaku@gmail.com','1236')
/*customer*/
select * from system_Users.Customer
Insert into system_Users.Customer(f_Name,m_Name,l_Name,email,driving_Licence_No,birth_Date)VALUES
		('Saba','Abayneh','Kefele','sabaabayneh@gmail.com','BD123','1883-05-18'),
		('Yonas','Melaku','Kebede','yonasmelaku@gmail.com','AA234','1873-10-22')
	 /*   */
SELECT * FROM system_Users.Customer_Address
INSERT INTO system_Users.Customer_Address(city,kebele,customer_ID)VALUES
		('BAHIRDAR',14,1),
		('ADISS ABEBA',15,2)
	 /*   */
SELECT * FROM system_Users.Customer_Phone_No
INSERT INTO system_Users.Customer_Phone_No(phone_No,customer_ID)VALUES
		(0911785432,1),
		(0912785432,2)
	  /*   */
select * from system_Users.Admin
INSERT INTO system_Users.Admin(f_Name,m_Name,l_Name,EMAIL )VALUES
		('Seyfu','Bekalu','kurabachew','seyfubekalu@gmail.com')
  /*   */
select * from system_Users.Admin_Address
INSERT INTO system_Users.ADMIN_ADDRESS
		(ADMIN_ID,CITY,KEBELE)
VALUES(1,'BAHIRDAR','14')
 /*   */
 select * from system_Users.Admin_Phone_No
INSERT INTO system_Users.Admin_Phone_No
	(ADMIN_ID,phone_No)	
VALUES(1,0983678467)
	  /*   */
select * from system_Users.Manager
	  /*   */
	  select * from system_Users.Manager_Address
	  /*   */
	  select * from system_Users.Manager_Phone_No
	  /* RESERVATION  */

insert into resources.Car(color,manufacture_Year,mark,model,type,transmission_Type,fuel_Type,status,horse_Power,sales_Price,rental_Price_Per_Day,total_Rented_Date,car_Date,plate_Number)
values
		('red',2000,'Toyota','corolla','luxury','automatic','benzene',0,2000,1000000,2500,0,'2/5/2022',12366)
insert into resources.Car(color,manufacture_Year,mark,model,type,transmission_Type,fuel_Type,status,horse_Power,sales_Price,rental_Price_Per_Day,total_Rented_Date,car_Date,plate_Number)
values('white',2000,'Toyota','highroof','transportation','manual','gasoline',50,2200,800000,1800,0,'2/5/2022',234223)
insert into resources.Car(color,manufacture_Year,mark,model,type,transmission_Type,fuel_Type,status,horse_Power,sales_Price,rental_Price_Per_Day,total_Rented_Date,car_Date,plate_Number)
values('black',2000,'Nissan','s32','luxury','automatic','gasoline',0,2000,1500000,2500,0,'2/5/2022',347676)

/*for the matter of simplicity, we recommend inserting other tables by using the procedures provided below on the next pages*/

	  /*   */


  /*---  INDEXS ---*/
		CREATE INDEX reservation_idx
ON resources.RESERVATION (reservation_ID,customer_ID,reserve_Type,reserve_Payment,reserved_Date, status);
 
   CREATE INDEX car_idx
   on resources.CAR(Car_Id,TYPE,MARK,MODEL,TRANSMISSION_TYPE,manufacture_year ,COLOR,STATUS);

   CREATE INDEX CUST_idx 
   on system_Users.customer(F_NAME, m_NAME, EMAIL,driving_licence_no,customer_id);

   CREATE INDEX ADMIN_idx
   on system_Users.admin(F_NAME, m_NAME, EMAIL,admin_id);

    CREATE INDEX Manager_idx
   on system_Users.manager(F_NAME, L_NAME, EMAIL,manager_id)

   create index rent_idx
   on resources.rent(rent_id,pick_up_date, return_date,payment)





								/*--create views--*/


/*for cars*/
create view resources.view_For_Cars
as select car_ID,plate_Number,mark,model,type,color,manufacture_Year,transmission_Type,fuel_Type,horse_Power,sales_Price,
          rental_Price_Per_Day,case when total_Rented_Date<=100 then 'new'
		  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
		  end condition,status from resources.Car

/*for reservation*/
create view resources.view_For_Reservation
as select reservation_ID,system_Users.Customer.customer_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',reserve_Type,reserve_Payment,reserved_Date,
          case Reservation.status when 0 then 'active' when 1 then 'completed' end reservation_Status,
          mark+' '+model as 'Car Name',plate_Number,manufacture_Year,type,transmission_Type,fuel_Type from system_Users.Customer,resources.Reservation,resources.Car
		  where system_Users.Customer.customer_ID=resources.Reservation.customer_ID and resources.Car.car_ID=resources.Reservation.car_ID 

/*for rent not returned*/
create view resources.view_For_Rented
as select rent_ID,system_Users.Customer.customer_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',mark+' '+model as 'Car Name',plate_Number,manufacture_Year,type,transmission_Type,fuel_Type,
          pick_Up_Date,return_Date,payment,manager_ID from system_Users.Customer,resources.Rent,resources.Car,resources.Managers_Manage_Reservation where Rent.reservation_ID in(select reservation_ID from Reservation where 
		  Reservation.customer_ID=Customer.customer_ID and Reservation.car_ID=Car.car_ID) and Rent.reservation_ID=Managers_Manage_Reservation.reservation_ID 

/*for rent and returned*/
create view resources.view_For_Rented_Returned
as select Rent.rent_ID,Customer.customer_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',mark+' '+model as 'Car Name',plate_Number,manufacture_Year,type,transmission_Type,fuel_Type,
          pick_Up_Date,actual_Return_Date,punishment,damage_Compensation,total_Payment,Managers_Manage_Reservation.manager_ID as 'manager_Who_Rented',Managers_Manage_Return.manager_ID as 'manager_Who_Accepted'
		  from system_Users.Customer,resources.Rent,resources.Car,resources.Rent_Invoice,resources.Managers_Manage_Reservation,resources.Managers_Manage_Return where Rent.reservation_ID in(select reservation_ID from Reservation where 
		  Reservation.customer_ID=Customer.customer_ID and Reservation.car_ID=Car.car_ID) and Rent_Invoice.rent_ID=Rent.rent_ID and
		  Rent.reservation_ID=Managers_Manage_Reservation.reservation_ID and Rent.rent_ID=Managers_Manage_Return.rent_ID 

/*for sales*/
create view resources.view_For_Sales
as select sale_ID,customer_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',mark+' '+model as 'Car Name',plate_Number,manufacture_Year,type,transmission_Type,fuel_Type,
          date_Of_Sale,sales_Price,manager_ID from system_Users.Customer,resources.Sale,resources.Car,resources.Managers_Manage_Reservation where Sale.reservation_ID in(select reservation_ID from Reservation where 
		  Reservation.customer_ID=Customer.customer_ID and Reservation.car_ID=Car.car_ID) and Sale.reservation_ID=Managers_Manage_Reservation.reservation_ID



								/*---create functions--*/




				/*--for cars*/

/*to view available cars (for all)*/
create function resources.view_Available_Cars()
returns table
as
return select * from resources.view_For_Cars where status='available'

/*to view all cars (for admin and managers)*/
create function resources.view_All_Cars()
returns table
as
return select *, case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition from resources.Car

/*to view suspended cars for service (for admin and managers)*/
create function resources.view_Suspended_Cars()
returns table
as
return select * from resources.view_For_Cars where status='service'

/*to view reserved cars for service (for admin and managers)*/
create function resources.view_Reserved_Cars()
returns table
as
return select * from resources.view_For_Cars where status='reserved'

/*to view rented cars for service (for admin and managers)*/
create function resources.view_Rented_Cars()
returns table
as
return select * from resources.view_For_Cars where status='rented'

/*to view sold cars (for admin and managers)*/
create function resources.view_Sold_Cars()
returns table
as
return select * from resources.view_For_Cars where status='sold'


				/*--for reservation--*//*check how asc and dsc works for date*/

/*to view the reservation history (for admin and manager)*/
create function resources.view_Reservation_History()  /*view : Customer, Reservatrion, Car*/
returns table
as
return select * from resources.view_For_Reservation

/*to view the reservation list (for admin and managers)*/
create function resources.view_All_Active_Reservation()
returns table
as
return select * from resources.view_For_Reservation where view_For_Reservation.reservation_Status=0

/*to view the reservation list from today (for admin and managers)*/
create function resources.view_Reservation_Today()
returns table
as
return select * from resources.view_For_Reservation where reserved_Date=getDate()

/*to view reservation list from given date (for admin and managers)*/
create function resources.view_Reservation_At_Given_Date(@year int,@month int,@day int)
returns table
as 
return select * from resources.view_For_Reservation where year(reserved_Date)=@year and month(reserved_Date)=@month and day(reserved_Date)=@day




				/*--for rent--*/

/*to view all rented car (both returned and not returned)(for admin and managers)*//*view : Customer, Car, Rent, Mangager...*/
create function resources.view_All_Rented()
returns table
as
return select * from resources.view_For_Rented

/*to view rented but not returned (present in rent table but not rent_invoice table)(for admin and managers)*/
create function resources.view_Not_Returned()
returns table
as
return select * from resources.view_For_Rented where not exists(select * from resources.Rent_Invoice where view_For_Rented.rent_ID=Rent_Invoice.rent_ID)

/*to view not returned and passed deadline (for admin and managers)*/
create function resources.view_Passed_Deadline_Not_Returned()
returns table
as
return select * from view_For_Rented where not exists(select * from Rent_Invoice where view_For_Rented.rent_ID=Rent_Invoice.rent_ID) and datediff(day,return_Date,getdate())>0

/*view car to be returned today (for admin and managers)*/
create function resources.view_To_Be_Returned_Today()
returns table
as
return select * from view_For_Rented where not exists(select * from Rent_Invoice where view_For_Rented.rent_ID=Rent_Invoice.rent_ID) and return_Date=getdate()

/*admin wants to view the rents a manager managed (for admin and managers)*/
create function resources.view_Managed_Rents(@manager_ID int)
returns table
as
return select * from view_For_Rented where manager_ID=@manager_ID 

/*admin wants to view what rents he managed (for admin only)*/
create function resources.view_Rented_By_Admin()
returns table
as
return select * from view_For_Rented where manager_ID=NULL

/*to view rented and returned (for admin and managers)*/
create function resources.view_Rented_Returned() /*view : Customer, Rent, Car, Rent_Invoice, Manager...*/
returns table
as
return select * from view_For_Rented_Returned

/*to view rented and returned today (for admin and managers)*/
create function resources.view_Rented_Returned_Today()
returns table
as
return select * from view_For_Rented_Returned where actual_Return_Date=getDate()

/*to view rented and returned at given date (for admin and managers)*/
create function resources.view_Rented_Returned_At_Given_Date(@year int,@month int,@day int)
returns table
as
return select * from view_For_Rented_Returned where year(actual_Return_Date)=@year and month(actual_Return_Date)=@month and day(actual_Return_Date)=@day

/*view a particular customer's rental history (for admin and managers)*/
create function resources.view_Customer_Rental_History(@customer_ID int)
returns table
as
return select * from view_For_Rented_Returned where view_For_Rented_Returned.customer_ID=@customer_ID 



/*admin wants to view the returns a manager managed (for admin and managers)*/
create function resources.view_Managed_Returns(@manager_ID int)
returns table
as
return select * from view_For_Rented_Returned where manager_Who_Accepted=@manager_ID 

/*admin wants to view what returns he managed (for admin only)*/
create function resources.view_Returned_Through_Admin()
returns table
as
return select * from view_For_Rented_Returned where manager_Who_Accepted=NULL

/*to know how much you a customer is punished when passed date*/




				/*--for sales--*/

/*to view all sales (for admin and managers)*/
create function resources.view_All_Sales() /*view : Customer, Sale, Car, Manager...*/
returns table
as
return select * from view_For_Sales 

/*to view sales from today(for admin and managers)*/
create function resources.view_All_Sales_Today()
returns table
as
return select * from view_For_Sales where date_Of_Sale=getDate()

/*to view sales from given date (for admin and managers)*/
create function resources.view_All_Sales_At_Given_Date(@year int, @month int, @day int)
returns table
as
return select * from view_For_Sales where year(date_Of_Sale)=@year and month(date_Of_Sale)=@month and day(date_Of_Sale)=@day

/*view a particular customer's sales history (for all)*/
create function resources.view_Customer_Sales_History(@customer_ID int)
returns table
as
return select * from view_For_Sales where view_For_Sales.customer_ID=@customer_ID

/*admin wants to view what sales a manager managed (for admin and managers)*/
create function resources.view_Managed_Sales(@manager_ID int)
returns table
as
return select * from view_For_Sales where manager_ID=@manager_ID

/*admin wants to view what sales he managed (for admin only)*/
create function view_Sales_By_Admin()
returns table
as
return select * from resources.view_For_Sales where manager_ID=NULL




				/*--search--*/

	/*to search for cars(search by each attributes)*/
/*search by sales price range*/
create function resources.search_By_Sales_Price(@max int, @min int)
returns table
as
return select * from view_For_Cars where sales_Price between @min and @max


/*search by rent price range*/
create function resources.search_By_Rental_Price(@max int, @min int)
returns table
as
return select * from view_For_Cars where rental_Price_Per_Day between @min and @max

/*search by model*/
create function resources.search_By_Model(@model varchar(30))
returns table
as
return select * from view_For_Cars where model=@model

/*search by mark*/
create function resources.search_By_Mark(@mark varchar(30))
returns table
as
return select * from view_For_Cars where mark=@mark

/*search by manufacture year*/
create function resources.search_By_Manufacture_Year(@manufacture_Year int)
returns table
as
return select * from view_For_Cars where manufacture_Year=@manufacture_Year

/*search by transmission type*/
create function resources.search_By_Transmission_Type(@transmission_Type varchar(30))
returns table
as
return select * from view_For_Cars where transmission_Type=@transmission_Type

/*search by horse power*/
create function resources.search_By_Horse_Power(@horse_Power int)
returns table
as
return select * from view_For_Cars where horse_Power=@horse_Power




				/*--auditing--*/
/*a method for daily auditing like what they sell or rent on that day*/
create function resources.manager_Daily_Audit(@manager_ID int)
returns @audit table (total_Money_From_Rent money,total_Money_From_Return money,total_Money_From_Sales money)
as
begin
	declare @total_Money_From_Rent money,@total_Money_From_Return money,@total_Money_From_Sales money
	set @total_Money_From_Rent=(select sum(payment) from Rent where reservation_ID in(select reservation_ID from Managers_Manage_Reservation where manager_ID=@manager_ID) and pick_Up_Date=getdate())
	set @total_Money_From_Return=(select sum(punishment)+sum(damage_Compensation) from Rent_Invoice where rent_ID in(select rent_ID from Managers_Manage_Return where manager_ID=@manager_ID) and actual_Return_Date=getdate())
	set @total_Money_From_Sales=(select sum(payment) from Sale where reservation_ID in(select reservation_ID from Managers_Manage_Reservation where manager_ID=@manager_ID) and date_Of_Sale=getdate())
	insert into @audit values(@total_Money_From_Rent,@total_Money_From_Return,@total_Money_From_Sales)
	return
end

create function resources.admin_Daily_Audit()
returns @audit table (total_Money_From_Rent money,total_Money_From_Return money,total_Money_From_Sales money)
as
begin
	declare @total_Money_From_Rent money,@total_Money_From_Return money,@total_Money_From_Sales money
	set @total_Money_From_Rent=(select sum(payment) from Rent where reservation_ID in(select reservation_ID from Managers_Manage_Reservation where manager_ID=NULL) and pick_Up_Date=getdate())
	set @total_Money_From_Return=(select sum(punishment)+sum(damage_Compensation) from Rent_Invoice where rent_ID in(select rent_ID from Managers_Manage_Return where manager_ID=NULL) and actual_Return_Date=getdate())
	set @total_Money_From_Sales=(select sum(payment) from Sale where reservation_ID in(select reservation_ID from Managers_Manage_Reservation where manager_ID=NULL) and date_Of_Sale=getdate())
	insert into @audit values(@total_Money_From_Rent,@total_Money_From_Return,@total_Money_From_Sales)
	return
end

/*to know how much we made from canceled and expired reservations*/
create function resources.total_Money_From_Canceled_And_Expired_Reservations()
returns money
as
begin
	return (select sum(reserve_Payment) from Canceled_Reservation)
end

								/*---create procedures---*/


				/*to view customers and managers info*/

/*for customer*/
create procedure system_Users.view_Customer_Info(@customer_ID int)/*(for all)*/
as
begin
	if not exists(select * from system_Users.Customer where customer_ID=@customer_ID)
		print 'there is no customer with this id'
	else
	begin
		select * from system_Users.Customer where customer_ID=@customer_ID
		select * from system_Users.Customer_Address where customer_ID=@customer_ID
		select * from system_Users.Customer_Phone_No where customer_ID=@customer_ID
	end
end

/*for manager*/
create procedure system_Users.view_Manager_Info(@manager_ID int)
as
begin
	if not exists(select * from Manager where manager_ID=@manager_ID)
		print 'there is no customer with this id'
	else
	begin
		select * from Manager where manager_ID=@manager_ID
		select * from Manager_Address where manager_ID=@manager_ID
		select * from Manager_Phone_No where manager_ID=@manager_ID
	end
end

				/*to create account and record user info both for customer and admin&managers (need system generated id)*/

  /* for customer */
create procedure system_Users.create_Customer_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@driving_Licence_No int, @birth_Date date, @email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
	if exists(select * from Customer where email=@email) or exists(select * from Manager where email=@email) or exists(select * from Admin where email=@email)
		print 'there is already a customer account with the email you inserted'
	else if exists(select * from Customer where driving_Licence_No=@driving_Licence_No and email!=null)
		print 'there is already a customer account with the driving licence number you inserted'
	else if datediff(year,@birth_Date,getdate())<18
		print 'age should be above 18'
	else
	  begin
		insert into login.Login values(@email,@password)
		insert into Customer values(@f_Name,@m_Name,@l_Name,@driving_Licence_No,@birth_Date,@email)
	    declare @customer_ID int
		set @customer_ID=(select customer_ID from Customer where email=@email)
		insert into Customer_Phone_No values(@phone_Number,@customer_ID)
		insert into Customer_Address values(@city,@kebele,@customer_ID)
		print 'your customer id is'
		print @customer_ID
	  end
end

/*to add phone number*/
create procedure system_Users.add_Customer_Phone_Number(@customer_ID int,@phone_Number int)
as
begin
	if exists(select * from Customer_Phone_No where phone_No=@phone_Number and customer_ID 
	          in(select customer_ID from Customer where email!=null))
		print 'the phone number you inserted is already there'
	else
		insert into Customer_Phone_No values(@phone_Number,@customer_ID)
end

  /* for admin */
create procedure system_Users.create_Admin_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
	if exists(select * from Customer where email=@email) or exists(select * from Manager where email=@email) or exists(select * from Admin where email=@email)
		print 'there is already an admin account with the email you inserted'
	else
	  begin
		insert into login.Login values(@email,@password)
		insert into Admin values(@f_Name,@m_Name,@l_Name,@email)
		declare @admin_ID int
		set @admin_ID=(select admin_ID from Admin where email=@email)
		insert into Admin_Phone_No values(@phone_Number,@admin_ID)
		insert into Admin_Address values(@city,@kebele,@admin_ID)
		print 'your admin id is'
		print @admin_ID
	  end
end

/*to add phone number*/
create procedure system_Users.add_Admin_Phone_Number(@admin_ID int,@phone_Number int)
as
begin
	if exists(select * from Admin_Phone_No where phone_No=@phone_Number) or exists(select * from Manager_Phone_No where phone_No=@phone_Number)
		print 'you can not add the phone number,it already exists'
	else
		insert into Admin_Phone_No values(@phone_Number,@admin_ID)
end

/* for managers */
create procedure system_Users.create_Manager_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
	if exists(select * from Customer where email=@email) or exists(select * from Manager where email=@email) or exists(select * from Admin where email=@email)
		print 'there is already a manager account with the email you inserted'
	else
	  begin
		insert into login.Login values(@email,@password)
		insert into Manager values(@f_Name,@m_Name,@l_Name,@email)
		declare @manager_ID int
		set @manager_ID=(select manager_ID from Manager where email=@email)
		insert into Manager_Phone_No values(@phone_Number,@manager_ID)
		insert into Manager_Address values(@city,@kebele,@manager_ID)
		print 'your manager id is'
		print @manager_ID
	  end
end

/*to add phone number*/
create procedure system_Users.add_Manager_Phone_Number(@manager_ID int,@phone_Number int)
as
begin
	if exists(select * from Admin_Phone_No where phone_No=@phone_Number) or exists(select * from Manager_Phone_No where phone_No=@phone_Number)
		print 'you can not add the phone number,it already exists'
	else
		insert into Manager_Phone_No values(@phone_Number,@manager_ID)
end

				/*to reserve cars both for rent and sale*/

/*function to calculate number of days reserved taking payment as parameter*/
create function resources.calc_Reserve_Date(@payment money)
returns int
as
begin
	declare @date int
	set @date=@payment/50
return @date
end

/*the procedure for reserving*/
create procedure resources.reserve_Car(@car_ID int, @customer_ID int,@r_Type int,@reserve_Payment money)
as
begin
	if not exists(select * from system_Users.Customer where customer_ID=@customer_ID) or not exists(select * from Car where car_ID=@car_ID)
		print 'invalid input'
	else if not((select status from Car where car_ID=@car_ID)='available')
		print 'sorry, the car you chose is not available'
	else if(@reserve_Payment<50 or @reserve_Payment>250)
		print 'payment range is between 50 and 250'
	else
	  begin
		declare @reserve_Type varchar(5)
		if(@r_Type=0)
		set @reserve_Type='rent'
		else
		set @reserve_Type='sale'
		update Car
		 set status='reserved' where car_ID=@car_ID
		insert into Reservation values(@customer_ID,@reserve_Type,@reserve_Payment,@car_ID,getdate(),0)
		declare @reservation_ID int
		set @reservation_ID=(select reservation_ID from Reservation where customer_ID=@customer_ID and car_ID=@car_ID and status=0)
		print 'the car you chose is reserved for '
		print resources.calc_Reserve_Date(@reserve_Payment)
		print 'days, the reservation will expire after '
		print resources.calc_Reserve_Date(@reserve_Payment)*24
		print 'hours. If you do not buy or rent it before, your reservation will expire'
		print 'your reservation id is '
		print @reservation_ID
	  end
end


				/* adding cars for admin */

/*to add new cars*/
create procedure resources.add_New_Car(@color varchar(15),@manufactured_Year int,@mark varchar(30),@model varchar(30),
							 @type varchar(30),@transmission_Type varchar(30),@fuel_Type varchar(30),@horse_Power int,
							 @sales_Price money,@plate_Number int)
as
begin
	if exists(select * from Car where plate_Number=@plate_Number)
	  print 'the plate number already exists'
	else
	  begin
		insert into Car values(@color,@manufactured_Year,@mark,@model,@type,@transmission_Type,@fuel_Type,
						   'available',@horse_Power,@sales_Price,@sales_Price*0.005,0,getdate(),@plate_Number)
	  end
end



/*to add used cars*/
alter procedure resources.add_Used_Car(@color varchar(15),@manufactured_Year int,@mark varchar(30),@model varchar(30),
                              @type varchar(30),@transmission_Type varchar(30),@fuel_Type varchar(30),@horse_Power int,
							  @sales_Price money,@total_Rented_Date int,@plate_Number int)
as
begin
	if exists(select * from Car where plate_Number=@plate_Number)
	  print 'the plate number already exists'
	else
	  begin
		insert into Car values(@color,@manufactured_Year,@mark,@model,@type,@transmission_Type,@fuel_Type,
	               'available',@horse_Power,@sales_Price,@sales_Price*0.005,@total_Rented_Date,getdate(),@plate_Number)
	  end
end


				/*to cancel reservation (delete the record from reservation table and add to Canceled_Reservation table)*/

create procedure resources.cancel_Reservation(@customer_ID int,@reservation_ID int)
as
begin
	if exists(select * from Reservation where customer_ID=@customer_ID and reservation_ID=@reservation_ID and status=0)
	begin
		insert into Canceled_Reservation select *,'' from Reservation where reservation_ID=@reservation_ID /*incase the columns have to be of the same number I added empty string*/
		update Car 
		  set status='available' where car_ID=(select car_ID from Reservation where reservation_ID=@reservation_ID)
		alter table Reservation disable trigger avoid_Deleting
			delete from Reservation where reservation_ID=@reservation_ID
		alter table Reservation enable trigger avoid_Deleting
		update Canceled_Reservation
		  set cancel_Type='canceled' where reservation_ID=@reservation_ID
	end
	else
		print 'there is no such reservation'
end

				/*to rent cars through managers*/

/*to calculate payment for the rent*/
create function resources.calc_Rent_Payment(@rental_Price_Per_Day money,@no_Of_Days_Rented int,@reserve_Payment money)
returns money
as
begin
	declare @payment money
	set @payment=(@rental_Price_Per_Day*@no_Of_Days_Rented)-@reserve_Payment
	return @payment
end
/*to check if the customer has no cars to return*//*we have to check that customer is free through account and through in person*/
create function resources.check_Customer_Free(@reservation_ID int)
returns int
as
begin
	declare @dirving_Licence_No int,@x int
	set @dirving_Licence_No=(select driving_Licence_No from system_Users.Customer where customer_ID in(select customer_ID from Reservation where reservation_ID=@reservation_ID))
	if exists(select * from Rent where reservation_ID in(select reservation_ID from Reservation where customer_ID in (select customer_ID from Customer where driving_Licence_No=@dirving_Licence_No))) and
	   not exists(select * from Rent_Invoice where rent_ID in(select rent_ID from Rent where reservation_ID in
	   (select reservation_ID from Reservation where customer_ID in(select customer_ID from system_Users.Customer where driving_Licence_No=@dirving_Licence_No))))
		set @x=1
	else
		set @x=0
	   return @x
end

/*the procedure to rent*/
create procedure resources.rent_Car(@manager_ID int,@reservation_ID int,@no_Of_Days_Rented int)/*we have to make sure that the customer has no cars to return before renting new*/
as
begin
	if exists(select * from Canceled_Reservation where reservation_ID=@reservation_ID)
		print 'the reservation has expired or canceled'
	else if not exists(select * from Reservation where reservation_ID=@reservation_ID and reserve_Type='rent')
		print 'there is no such reservation number for rent'
	else if(resources.check_Customer_Free(@reservation_ID)=1)
		print 'return the car you rented before renting new one'
	else if not exists(select * from Rent where reservation_ID=@reservation_ID) and not exists(select * from Sale where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@rental_Price_Per_Day money,@reserve_Payment money
		 set @rental_Price_Per_Day=(select rental_Price_Per_Day from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=resources.calc_Rent_Payment(@rental_Price_Per_Day,@no_Of_Days_Rented,@reserve_Payment)
		insert into Rent values(@reservation_ID,getdate(),dateadd(day,@no_Of_Days_Rented,getdate()),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='rented' where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID)
		insert into Managers_Manage_Reservation values (@reservation_ID,@manager_ID)
		declare @rent_ID int
		set @rent_ID=(select rent_ID from Rent where reservation_ID=@reservation_ID)
		print 'your rent id is '
		print @rent_ID
		print 'you will use this number when returning the car'

	end
	else
		print 'car is already taken'
end

/*to receive when customer returns rented car(but first we have to tell the customer his punishments)*/

/*function to know how much the punishment is*/
create function resources.calc_Punishment(@rent_ID int)
returns money
as
begin
declare @punishment money,@rental_Price_Per_Day money,@return_Date date
	set @rental_Price_Per_Day=(select rental_Price_Per_Day from Car where car_ID in(select car_ID from Reservation where reservation_ID in
		                      (select reservation_ID from Rent where rent_ID=@rent_ID)))
	set @return_Date=(select return_Date from Rent where rent_ID=@rent_ID)
	if(datediff(day,@return_Date,getdate())<=0)
		set @punishment=0 
	else
		set @punishment=(@rental_Price_Per_Day*datediff(day,@return_Date,getdate())*1.3)
return @punishment
end

/*procedure to return the cars*/
create procedure resources.return_Car(@manager_ID int,@rent_ID int,@damage_Compensation money)/* we need to also make this related to managers may be add column to that table to show who manages the rent and the return*/
as
begin
	if not exists(select * from system_Users.Manager where manager_ID=@manager_ID)
		print 'there is no such manager ID'
	else if not exists(select * from Rent where rent_ID=@rent_ID)
		print 'there is no such rent id'
	else if not exists(select * from Rent_Invoice where rent_ID=@rent_ID)
	begin
		declare @punishment money,@total_Payment money,@return_Date date,@payment money,@rented_Date int
		set @punishment=resources.calc_Punishment(@rent_ID)
		if(datediff(day,@return_Date,getdate())<=0)
			set @rented_Date=datediff(day,(select pick_Up_Date from Rent where rent_ID=@rent_ID),@return_Date)
		else
			set @rented_Date=datediff(day,(select pick_Up_Date from Rent where rent_ID=@rent_ID),getdate())
		set @payment=(select payment from Rent where rent_ID=@rent_ID)
		set @total_Payment=@payment+@punishment+@damage_Compensation
		insert into Rent_Invoice values(@rent_ID,@punishment,getdate(),@damage_Compensation,@total_Payment)
	    update Car
	    set status='available' where car_ID=(select car_ID from Car where car_ID in(select car_ID from Reservation where reservation_ID in
		                                    (select reservation_ID from Rent where rent_ID=@rent_ID)))
		update Car
		set total_Rented_Date=total_Rented_Date+@rented_Date where car_ID in(select car_ID from Reservation where reservation_ID in
															(select reservation_ID from Rent where rent_ID=@rent_ID))
		insert into Managers_Manage_Return values(@rent_ID,@manager_ID)
	end
	else if exists(select * from Rent_Invoice where rent_ID=@rent_ID)
		print 'the car is already returned'
	else
		print 'wrong input'
end

/*to sell cars for managers*/
create procedure resources.sell_Car(@manager_ID int,@reservation_ID int)
as
begin
	if exists(select * from Canceled_Reservation where reservation_ID=@reservation_ID)
		print 'the reservation has expired or canceled'
	else if not exists(select * from Reservation where reservation_ID=@reservation_ID and reserve_Type='sale')
		print 'there is no such reservation number for sale'
	else if not exists(select * from Sale where reservation_ID=@reservation_ID) and not exists(select * from Rent where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@reserve_Payment money,@sales_Price money
		 set @sales_Price=(select sales_Price from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=@sales_Price-@reserve_Payment
		insert into Sale values(@reservation_ID,getdate(),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='sold' where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID)
		insert into Managers_Manage_Reservation values (@reservation_ID,@manager_ID)
	end
	else
		print 'car is already taken'
end

/*for admin to rent and sell a car and return car*/
create procedure resources.admin_Rent_Car(@reservation_ID int,@no_Of_Days_Rented int)
as
begin
	if exists(select * from Canceled_Reservation where reservation_ID=@reservation_ID)
		print 'the reservation has expired'
	else if not exists(select * from Reservation where reservation_ID=@reservation_ID and reserve_Type='rent')
		print 'there is no such reservation number for rent'
	else if(resources.check_Customer_Free(@reservation_ID)=1)
		print 'return the car you rented before renting new one'
	else if not exists(select * from Rent where reservation_ID=@reservation_ID) and not exists(select * from Sale where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@rental_Price_Per_Day money,@reserve_Payment money
		 set @rental_Price_Per_Day=(select rental_Price_Per_Day from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=resources.calc_Rent_Payment(@rental_Price_Per_Day,@no_Of_Days_Rented,@reserve_Payment)
		insert into Rent values(@reservation_ID,getdate(),dateadd(day,@no_Of_Days_Rented,getdate()),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car 
		 set status='rented' where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID)
		insert into Managers_Manage_Reservation(reservation_ID) values (@reservation_ID)
		declare @rent_ID int
		set @rent_ID=(select rent_ID from Rent where reservation_ID=@reservation_ID)
		print 'your rent id is '
		print @rent_ID
		print 'you will use this number to return the car'
	end
	else
		print 'car is already taken'
end

create procedure resources.admin_Sell_Car(@reservation_ID int)
as
begin
	if exists(select * from Canceled_Reservation where reservation_ID=@reservation_ID)
		print 'the reservation has expired'
	else if not exists(select * from Reservation where reservation_ID=@reservation_ID and reserve_Type='sale')
		print 'there is no such reservation id for sale'
	else if not exists(select * from Sale where reservation_ID=@reservation_ID) and not exists(select * from Rent where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@reserve_Payment money,@sales_Price money
		 set @sales_Price=(select sales_Price from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=@sales_Price-@reserve_Payment
		insert into Sale values(@reservation_ID,getdate(),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='sold' where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID)
		insert into Managers_Manage_Reservation(reservation_ID) values (@reservation_ID)
	end
	else
		print 'car is already taken'
end

create procedure resources.admin_Return_Car(@rent_ID int,@damage_Compensation money)
as
begin
	if not exists(select * from Rent where rent_ID=@rent_ID)
		print 'there is no such rent id'
	else if not exists(select * from Rent_Invoice where rent_ID=@rent_ID)
	begin
		declare @punishment money,@total_Payment money,@return_Date date,@payment money,@rented_Date int,@reserve_Payment int
		set @punishment=resources.calc_Punishment(@rent_ID)
		if(datediff(day,@return_Date,getdate())<=0)
			set @rented_Date=datediff(day,(select pick_Up_Date from Rent where rent_ID=@rent_ID),@return_Date)
		else
			set @rented_Date=datediff(day,(select pick_Up_Date from Rent where rent_ID=@rent_ID),getdate())
		set @payment=(select payment from Rent where rent_ID=@rent_ID)
		set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID in(select reservation_ID from Rent where rent_ID=@rent_ID))
		set @total_Payment=@payment+@punishment+@damage_Compensation
		insert into Rent_Invoice values(@rent_ID,@punishment,getdate(),@damage_Compensation,@total_Payment)
	    update Car
	    set status='available' where car_ID=(select car_ID from Car where car_ID in(select car_ID from Reservation where reservation_ID in
		                                    (select reservation_ID from Rent where rent_ID=@rent_ID)))
		update Car
		set total_Rented_Date=total_Rented_Date+@rented_Date where car_ID in(select car_ID from Reservation where reservation_ID in
															(select reservation_ID from Rent where rent_ID=@rent_ID))
		insert into Managers_Manage_Return(rent_ID) values(@rent_ID)
	end
	else if exists(select * from Rent_Invoice where rent_ID=@rent_ID)
		print 'the car is already returned'
	else
		print 'wrong input'
end


/*to record info about customers for admins and manager for people coming in person and add phone numbers since it's multivalued(but only for those who have null email)*/
create procedure system_Users.record_Customer_Info_In_Person(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@driving_Licence_No int, @birth_Date date,@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
	insert into Customer(f_Name,m_Name,l_Name,driving_Licence_No,birth_Date) values(@f_Name,@m_Name,@l_Name,@driving_Licence_No,@birth_Date)
    declare @customer_ID int
	set @customer_ID=(select count(*) from Customer)
	insert into Customer_Phone_No values(@phone_Number,@customer_ID)
	insert into Customer_Address values(@city,@kebele,@customer_ID)
	print 'your customer id is'
	print @customer_ID
end

/*to add phone number*/
create procedure system_Users.add_Phone_Number_In_Person(@customer_ID int,@phone_Number int)
as
begin
	if exists(select * from Customer_Phone_No where customer_ID=@customer_ID and phone_No=@phone_Number)
		print 'the phone number is already recorded'
	else
		insert into Customer_Phone_No values(@phone_Number,@customer_ID)
end

/*to suspend car incase of service and make it available again (2 procedures)*/
create procedure resources.suspend_Car(@car_ID int)
as
begin
	if not exists(select * from Car where car_ID=@car_ID)
		print 'such car does not exist'
	else if not((select status from Car where car_ID=@car_ID)='available')
		print 'the car is not available for now'
	else
		update Car
		  set status='service' where car_ID=@car_ID
end

/*to restore suspended car*/
create procedure resources.restore_Suspended_Car(@car_ID int)
as
begin
	if not exists(select * from Car where car_ID=@car_ID)
		print 'such car does not exist'
	else if not((select status from Car where car_ID=@car_ID)='service')
		print 'the car is not suspended'
	else
		update Car
		  set status='available' where car_ID=@car_ID
end

/*update cars attributes (color and plate number)*/
create procedure resources.update_Color(@car_ID int,@color varchar(20))
as
begin
	if not exists(select * from Car where car_ID=@car_ID)
		print 'such car does not exist'
	else if not((select status from Car where car_ID=@car_ID)='available')
		print 'the car is not available for now'
	else
		update Car
		  set color=@color where car_ID=@car_ID 
end

create procedure resources.update_Plate_Number(@car_ID int,@plate_Number varchar(20))
as
begin
	if not exists(select * from Car where car_ID=@car_ID)
		print 'such car does not exist'
	else if not((select status from Car where car_ID=@car_ID)='available')
		print 'the car is not available for now'
	else if exists(select * from Car where plate_Number=@plate_Number)
		print 'there is already a car with the given plate number'
	else
		update Car
		  set plate_Number=@plate_Number where car_ID=@car_ID 
end





								/*---create triggers---*//*didn't create triggers for updates, just for delete and some functional triggers*/




/*to update prices based on total rented date*/
create trigger resources.update_Price on resources.Car for insert 
as 
begin
	if((select total_Rented_Date from Car)%100=0 and (select total_Rented_Date from Car)/100>0 and (select total_Rented_Date from Car)>0 and not(select status from inserted)='sold')
	begin	
		update Car
		set sales_Price=sales_Price*.98
		update Car
		set rental_Price_Per_Day=rental_Price_Per_Day*.98
	end
end

				/*to avoid deleting from end tables(we can't delete from non-end tables like customer and manager cause there will be reference to them)*/

/*for customer*/
create trigger system_Users.avoid_Deleting on system_Users.Customer_Address for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

create trigger system_Users.avoid_Deleting2 on system_Users.Customer_Phone_No for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

/*for manager*/
create trigger system_Users.avoid_Deleting3 on system_Users.Manager_Address for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

create trigger system_Users.avoid_Deleting4 on system_Users.Manager_Phone_No for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

/*for admin*/
create trigger system_Users.avoid_Deleting5 on system_Users.Admin_Address for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

create trigger system_Users.avoid_Deleting6 on system_Users.Admin_Phone_No for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

/*for car*/
create trigger resources.avoid_Deleting7 on resources.Car for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

/*for reservation*/

create trigger resources.avoid_Deleting8 on resources.Reservation for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

/*for rent*/
create trigger resources.avoid_Deleting9 on resources.Rent for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

create trigger resources.avoid_Deleting10 on resources.Rent_Invoice for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

create trigger resources.avoid_Deleting11 on resources.Managers_Manage_Reservation for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

create trigger resources.avoid_Deleting12 on resources.Managers_Manage_Return for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

/*for sale*/
create trigger resources.avoid_Deleting13 on resources.Sale for delete
as
begin
	print 'you can not delete from this table'
	rollback transaction
end

				/*to delete expired reservations from reservations and add them to some table(for expired reservations)*/

create trigger resources.cancel_Expired_Reservation on resources.Reservation after insert /*idk how inserted works, I just	assumed it only refers to the one the trigger is set to*/
as
begin
	if((select resources.calc_Reserve_Date(reserve_Payment) from inserted)<datediff(day,(select reserved_Date from inserted),getdate()) and 
	    not exists(select * from Rent where reservation_ID=(select reservation_ID from inserted)) and 
		not exists(select * from Sale where reservation_ID=(select reservation_ID from inserted)) and
		not exists(select * from Canceled_Reservation where reservation_ID=(select reservation_ID from inserted)))
	begin
	    update Car set status='available' where car_ID=(select car_ID from inserted)
		alter table Reservation disable trigger avoid_Deleting8
			delete from Reservation where reservation_ID=(select reservation_ID from inserted)
		alter table Reservation enable trigger avoid_Deleting8
		insert into Canceled_Reservation select *,'' from deleted /*incase column numbers must be equal*/
		update Canceled_Reservation
		  set cancel_Type='expired' where reservation_ID=(select reservation_ID from inserted)
	end
end


/* to full back up our database */
BACKUP DATABASE [car_sales_and_rental] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\car_sales.bak' WITH NOFORMAT, NOINIT,  NAME = N'car_sales-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

/* to restore the database */

--first let's drop the database
drop database car_sales_and_rental

--then let's restore

USE [master]
RESTORE DATABASE [car_sales_and_rental] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\car_sales.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO

--let's check if it's restored

use car_sales_and_rental
