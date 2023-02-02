								
								/*---create login, role, blabla---*/				



								/*---create database---*/

create database car_sales_and_rental
use car_sales_and_rental

								/*---create tables---*/
								/* change data type of price and punishments ... to money*/

/*for login*/
create table Login(
email varchar(30) primary key not null,
password varchar(15) not null
)

/*for customer*/
create table Customer(
customer_ID int identity(1,1) primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
driving_Licence_No varchar(10) not null,
birth_Date date not null,
email varchar(30) constraint email foreign key(email) references Login(email),/*if we are using this for in person customers only...it's not relevant*/
)

create table Customer_Phone_No(
phone_No int primary key not null,
customer_ID int constraint customer_ID foreign key(customer_ID) references Customer(customer_ID) not null
)

create table Customer_Address(
city varchar(20) not null,
kebele int not null,
customer_ID int constraint customer_ID foreign key(customer_ID) references Customer(customer_ID) not null
)

/*for admin*/
create table Admin(
admin_ID int identity(1,1) primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
email varchar(30) constraint email foreign key(email) references Login(email) not null
)

create table Admin_Phone_No(
phone_No int primary key not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null
)

create table Admin_Address(
city varchar(20) not null,
kebele int not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null
)

/*for manager*/

create table Manager(
manager_ID int identity(1,1) primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
email varchar(30) constraint email foreign key(email) references Login(email) not null
)

create table Manager_Phone_No(
phone_No int primary key not null,
manager_ID int constraint manager_ID foreign key(manager_ID) references Manager(manager_ID) not null
)

create table Manager_Address(
city varchar(20) not null,
kebele int not null,
manager_ID int constraint manager_ID foreign key(manager_ID) references Manager(manager_ID) not null
)

/*for car*/
create table Car(
car_ID int identity(1,1) primary key not null,
color varchar(15) not null,
manufacture_Year int not null,
mark varchar(30) not null,
model varchar(30) not null,
type varchar(30) not null,
transmission_Type varchar(30) not null,
fuel_Type varchar(30) not null,
status varchar(20) not null,/*values will be: available(for all), available-for-sales, rented, sold, service, reserved*/
horse_Power int not null,
sales_Price money not null,
rental_Price_Per_Day money not null,
total_Rented_Date int not null,
car_Date date not null
)

/*for reservation*/
create table Reservation(
reservation_ID int identity(1,1) primary key not null,
customer_ID int constraint customer_ID foreign key(customer_ID) references Customer(customer_ID),
reserve_Type varchar(5) not null,
reserve_Payment money,
car_ID int constraint car_ID foreign key(car_ID) references Car(car_ID) not null,
reserved_Date date not null,
status int not null
)

create table Managers_Manage_Reservation(
reservation_ID int primary key constraint reservation_ID foreign key (reservation_ID) references Reservation(reservation_ID) not null,
manager_ID int constraint manager_ID foreign key (manager_ID) references Manager(manager_ID)
)

/*for rent*/
create table Rent(
rent_ID int identity(1,1) primary key not null,
reservation_ID int constraint reservation_ID foreign key references Reservation(reservation_ID) not null,
pick_Up_Date date not null,
return_Date date not null,
payment money not null,
)

create table Rent_Invoice(
invoice_ID int identity(1,1) primary key not null,
rent_ID int constraint rent_ID foreign key(rent_ID) references Rent(rent_ID) not null,
punishment int not null,
actual_Return_Date date not null,
damage_Compensation int ,
total_Payment money not null
)

/*for purchase*/
create table Purchase(
purchase_ID int identity(1,1) primary key not null,
reservation_ID int constraint reservation_ID foreign key(reservation_ID) references Reservation(reservation_ID) not null,
date_Of_Sale date not null,
payment money not null
)


								/*---create functions--*//*we should add managers' id or email on view records cause customers have to know who sold them*/

/*to view all available cars*/
create function view_Available_Cars()
returns table
as
return select car_ID,mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,sales_Price,
              rental_Price_Per_Day, case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' or status='available-for-sales'

/*to view all cars (for admin and managers)*/
create function view_All_Cars()
returns table
as
return select *, case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car

/*to view the reservation list*/
create function view_All_Active_Reservation()
returns table
as
return select reservation_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,reserve_Type,reserve_Payment,reserved_Date,
              mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type from Customer,Reservation,Car
			  where Customer(customer_ID)=Reservation(customer_ID) and Car(car_ID)=Reservation(car_ID) and
			  Reservation(status)=0 order by reserved_Date asc

/*to view the reservation list from today*/
create function view_Reservation_Today()
returns table
as
return select reservation_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,reserve_Type,reserve_Payment,reserved_Date,
              mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type from Customer,Reservation,Car
			  where Customer(customer_ID)=Reservation(customer_ID) and Car(car_ID)=Reservation(car_ID) and
			  reserved_Date=getDate() order by reserved_Date asc

/*to view reservation list from given date*/
create function view_Reservation_At_Given_Date(@year int,@month int,@day int)
returns table
as 
return select reservation_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,reserve_Type,reserve_Payment,reserved_Date,
              mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type from Customer,Reservation,Car
			  where Customer(customer_ID)=Reservation(customer_ID) and Car(car_ID)=Reservation(car_ID) and
			  year(reserved_Date)=@year and month(reserved_Date)=@month and day(reserved_Date)=@day order by reserved_Date asc

/*to view the reservation history*/
create function view_Reservation_History()
returns table
as
return select reservation_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,reserve_Type,reserve_Payment,reserved_Date,
              case Reservation(status) when 0 then 'active' when 1 then 'completed' end reservation_Status,
              mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type from Customer,Reservation,Car
			  where Customer(customer_ID)=Reservation(customer_ID) and Car(car_ID)=Reservation(car_ID) order by reserved_Date asc

/*to view all rented car(both returned and not returned)*/
create function view_All_Rented()
returns table
as
return select rent_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,
              pick_Up_Date,return_Date,payment from Customer,Rent,Car where reservation_ID in(select reservation_ID from Reservation where 
			  Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID)) order by pick_Up_Date asc

/*to view rented but not returned (present in rent table but not rent_invoice table) may be we could add isReturned column on rent table, or if we use exists() system function to check if it's present on invoice table*/
/*to view rented but not returned today*/
/*to view rented but not returned at given date*/

/*to view rented and returned*/
create function view_Rented_Returned()
returns table
as
return select Rent(rent_ID),f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,
              pick_Up_Date,actual_Return_Date,punishment,damage_Compensation,total_Payment from Customer,Rent,Car,Rent_Invoice where reservation_ID 
			  in(select reservation_ID from Reservation where Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID)) order by pick_Up_Date asc

/*to view rented and returned today*/
create function view_Rented_Returned_Today()
returns table
as
return select Rent(rent_ID),f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,
              pick_Up_Date,actual_Return_Date,punishment,damage_Compensation,total_Payment from Customer,Rent,Car,Rent_Invoice where actual_Return_Date=getDate() 
			  and reservation_ID in(select reservation_ID from Reservation where Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID)) 
			  order by pick_Up_Date asc

/*to view rented and returned at given date*/
create function view_Rented_Returned_At_Given_Date(@year int,@month int,@day int)
returns table
as
return select Rent(rent_ID),f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,
              pick_Up_Date,actual_Return_Date,punishment,damage_Compensation,total_Payment from Customer,Rent,Car,Rent_Invoice where year(actual_Return_Date)=@year
			  and month(actual_Return_Date)=@month and day(actual_Return_Date)=@day and reservation_ID in(select reservation_ID from Reservation where 
			  Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID)) order by pick_Up_Date asc

/*to view all purchases*/
create function view_All_Purchased()
returns table
as
return select f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,
              date_Of_Sale,sales_Price from Customer,Purchase,Car where reservation_ID in(select reservation_ID from Reservation where 
			  Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID) and Reservation(status)=1 and reserve_Type='sale') 

/*to view purchases from today*/
create function view_All_Purchased_Today()
returns table
as
return select f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,date_Of_Sale,
              sales_Price from Customer,Purchase,Car where date_Of_Sale=getDate() and reservation_ID in(select reservation_ID from Reservation where 
			  Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID) and Reservation(status)=1 and reserve_Type='sale') 

/*to view purchases from given date*/
create function view_All_Purchased_At_Given_Date(@year int, @month int, @day int)
returns table
as
return select f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,date_Of_Sale,
              sales_Price from Customer,Purchase,Car where year(date_Of_Sale)=@year and month(date_Of_Sale)=@month and day(date_Of_Sale)=@day and reservation_ID 
			  in(select reservation_ID from Reservation where Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID) and 
			  Reservation(status)=1 and reserve_Type='sale')

	/*to search for cars(search by each attribute and also some combos may be*/
/*search by sales price range*/
create function search_By_Sales_Price(@max int, @min int)
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,sales_Price,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and sales_Price between @min and @max

/*search by rent price range*/
create function search_By_Rental_Price(@max int, @min int)
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,rental_Price_Per_Day,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and rental_Price_Per_Day between @min and @max

/*search by model*/
create function search_By_Model(@model varchar(30))
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,rental_Price_Per_Day,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and model=@model

/*search by mark*/
create function search_By_Mark(@mark varchar(30))
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,rental_Price_Per_Day,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and mark=@mark

/*search by manufacture year*/
create function search_By_Manufacture_Year(@manufacture_Year int)
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,rental_Price_Per_Day,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and manufacture_Year=@manufacture_Year

/*search by transmission type*/
create function search_By_Transmission_Type(@transmission_Type varchar(30))
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,rental_Price_Per_Day,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and transmission_Type=@transmission_Type

/*search by horse power*/
create function search_By_Horse_Power(@horse_Power int)
returns table
as
return select mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,rental_Price_Per_Day,
              case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available' and horse_Power=@horse_Power

/*view a particular customer's rental history*/
/*view a particular customer's sales history*/
/*admin wants to view what manager managed a particular reservation;
  all reservations today and from given date*/


								/*---create procedures---*/

/*to create account and record user info both for customer and
  admin&managers (need system generated id)*/
  /* for customer */
create procedure create_Customer_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@driving_Licence_No int, @birth_Date date, @email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
if exists(select * from Customer where email=@email)
	print 'there is already a customer account with the email you inserted'
else if exists(select * from Customer where driving_Licence_No=@driving_Licence_No)
	print 'there is already a customer account with the driving licence number you inserted'
else
  begin
	insert into Customer values(@f_Name,@m_Name,@l_Name,@driving_Licence_No,@birth_Date,@email)
	insert into Login values(@email,@password)
    declare @customer_ID int
	set @customer_ID=(select customer_ID from Customer where email=@email)
	insert into Customer_Phone_No values(@phone_Number,@customer_ID)
	insert into Customer_Address values(@city,@kebele,@customer_ID)
	print 'your customer id is'
	print @customer_ID
  end
end

  /* for admin */
create procedure create_Admin_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
if exists(select * from Admin where email=@email)
	print 'there is already an admin account with the email you inserted'
else
  begin
	insert into Admin values(@f_Name,@m_Name,@l_Name,@email)
	insert into Login values(@email,@password)
	declare @admin_ID int
	set @admin_ID=(select admin_ID from Admin where email=@email)
	insert into Admin_Phone_No values(@phone_Number,@admin_ID)
	insert into Admin_Address values(@city,@kebele,@admin_ID)
  end
end

/* for managers */
create procedure create_Manager_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
as
begin
if exists(select * from Manager where email=@email)
	print 'there is already a manager account with the email you inserted'
else
  begin
	insert into Manager values(@f_Name,@m_Name,@l_Name,@email)
	insert into Login values(@email,@password)
	declare @manager_ID int
	set @manager_ID=(select manager_ID from Manager where email=@email)
	insert into Manager_Phone_No values(@phone_Number,@manager_ID)
	insert into Manager_Address values(@city,@kebele,@manager_ID)
	print 'your manager id is'
	print @manager_ID
  end
end

/*to reserve cars both for rent and sale (user inputs car_id and his customerid
                              and add things on reserve table)(conformation number should be the id)*/
/*function to calculate number of days reserved taking payment as parameter*/
create function calc_Reserve_Date(@payment money)
returns int
as
begin
	declare @date int
	set @date=@payment/50
return @date
end

/*the procedure for reserving*/
create procedure reserve_car(@car_ID int, @customer_ID int,@r_Type int,@reserve_Payment money)
as
begin
if not((select status from Car where car_ID=@car_ID)='available')
	print 'sorry, the car you chose is not available'
else if(@reserve_Payment<50)
	print 'minimum payment is birr 50'
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
	print 'the car you chose is reserved for '
	print dbo.calc_Reserve_Date(@reserve_Payment)
	print 'days, the reservation will expire after '
	print dbo.calc_Reserve_Date(@reserve_Payment)*24
	print 'hours if you do not buy or rent it before'
	print 'your reservation id is '
	print (select reservation_ID from Reservation where customer_ID=@customer_ID and car_ID=@car_ID and status=0)
  end
end
/*to change password*/
/*to login*/
/*to logout*/
/*to update price based on total rented date*/
/*to add new cars*/
create procedure add_New_Car(@color varchar(15),@manufactured_Year int,@mark varchar(30),@model varchar(30),
							 @type varchar(30),@transmission_Type varchar(30),@fuel_Type varchar(30),@horse_Power int,
							 @sales_Price money,@rental_Price_Per_Day money)
	as
	begin
		insert into Car values(@color,@manufactured_Year,@mark,@model,@type,@transmission_Type,@fuel_Type,
							   'available-for-sales',@horse_Power,@sales_Price,@rental_Price_Per_Day,0,getdate())
	end

/*to add old cars*/
create procedure add_Used_Car(@color varchar(15),@manufactured_Year int,@mark varchar(30),@model varchar(30),
                              @type varchar(30),@transmission_Type varchar(30),@fuel_Type varchar(30),@horse_Power int,
							  @sales_Price money,@rental_Price_Per_Day money,@total_Rented_Date int)
	as
	begin
		insert into Car values(@color,@manufactured_Year,@mark,@model,@type,@transmission_Type,@fuel_Type,'available',@horse_Power,@sales_Price,@rental_Price_Per_Day,@total_Rented_Date,getdate())
	end

/*to cancel reservation (I think we can delete the record from reservation table and add to some new table)*/
create procedure cancel_Reservation(@customer_ID int,@reservation_ID int)
	as
	begin
		if exists(select * from Reservation where customer_ID=@customer_ID and reservation_ID=@reservation_ID)
		begin
			delete from Reservation where reservation_ID=@reservation_ID
			update Car set status='available' where car_ID=(select car_ID from Reservation where reservation_ID=@reservation_ID and status=0)
		end
		else
			print 'there is no such reservation'
	end
/*to rent cars for manager*/
/*to calculate payment for the rent*/
create function calc_Rent_Payment(@rental_Price_Per_Day money,@no_Of_Days_Rented int,@reserve_Payment money)
returns money
as
begin
	declare @payment money
	set @payment=(@rental_Price_Per_Day*@no_Of_Days_Rented)-@reserve_Payment
	return @payment
end

/*the procedure to rent*/
create procedure rent_Car(@manager_ID int,@reservation_ID int,@no_Of_Days_Rented int)
as
begin
	if not exists(select * from Rent where reservation_ID=@reservation_ID) and not exists(select * from Rent where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@rental_Price_Per_Day money,@reserve_Payment money
		 set @rental_Price_Per_Day=(select rental_Price_Per_Day from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=dbo.calc_Rent_Payment(@rental_Price_Per_Day,@no_Of_Days_Rented,@reserve_Payment)
		insert into Rent values(@reservation_ID,getdate(),dateadd(day,@no_Of_Days_Rented,getdate()),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='rented'
		insert into Managers_Manage_Reservation values (@reservation_ID,@manager_ID)
		print 'your rent id is '
		print (select rent_ID from Rent where reservation_ID=@reservation_ID)
		print 'you will use this number to return the car'
	end
	else
		print 'car is already taken'
end

/*to receive when customer returns rented car*/
create procedure return_Car(@rent_ID int,@damage_Compensation money)
as
begin
	declare @punishment money,@total_Payment money,@rental_Price_Per_Day money,@return_Date date,@payment money
	 set @rental_Price_Per_Day=(select rental_Price_Per_Day from Car where car_ID in(select car_ID from Reservation where reservation_ID in
	                           (select reservation_ID from Rent where rent_ID=@rent_ID)))
	 set @return_Date=(select return_Date from Rent where rent_ID=@rent_ID)
	 set @punishment=(@rental_Price_Per_Day*datediff(day,getdate(),@return_Date)*1.3)
	 set @payment=(select payment from Rent where rent_ID=@rent_ID)
	 set @total_Payment=@payment+@punishment+@damage_Compensation
	insert into Rent_Invoice values(@rent_ID,@punishment,getdate(),@damage_Compensation,@total_Payment)
end

/*to sell cars for managers*/
create procedure purchase_Car(@manager_ID int,@reservation_ID int)
as
begin
	if not exists(select * from Rent where reservation_ID=@reservation_ID) and not exists(select * from Rent where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@reserve_Payment money,@sales_Price money
		 set @sales_Price=(select sales_Price from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=@sales_Price-@reserve_Payment
		insert into Purchase values(@reservation_ID,getdate(),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='sold'
		insert into Managers_Manage_Reservation values (@reservation_ID,@manager_ID)
	end
	else
		print 'car is already taken'
end

/*for admin to sell and rent a car*/
create procedure admin_Rent_Car(@reservation_ID int,@no_Of_Days_Rented int)
as
begin
	if not exists(select * from Rent where reservation_ID=@reservation_ID) and not exists(select * from Rent where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@rental_Price_Per_Day money,@reserve_Payment money
		 set @rental_Price_Per_Day=(select rental_Price_Per_Day from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=dbo.calc_Rent_Payment(@rental_Price_Per_Day,@no_Of_Days_Rented,@reserve_Payment)
		insert into Rent values(@reservation_ID,getdate(),dateadd(day,@no_Of_Days_Rented,getdate()),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='rented'
		insert into Managers_Manage_Reservation(reservation_ID) values (@reservation_ID)
		print 'your rent id is '
		print (select rent_ID from Rent where reservation_ID=@reservation_ID)
		print 'you will use this number to return the car'
	end
	else
		print 'car is already taken'
end

create procedure admin_Purchase_Car(@reservation_ID int)
as
begin
	if not exists(select * from Rent where reservation_ID=@reservation_ID) and not exists(select * from Rent where reservation_ID=@reservation_ID)
	begin
		declare @payment money,@reserve_Payment money,@sales_Price money
		 set @sales_Price=(select sales_Price from Car where car_ID in(select car_ID from Reservation where reservation_ID=@reservation_ID))
		 set @reserve_Payment=(select reserve_Payment from Reservation where reservation_ID=@reservation_ID)
		 set @payment=@sales_Price-@reserve_Payment
		insert into Purchase values(@reservation_ID,getdate(),@payment)
		update Reservation
		 set status=1 where reservation_ID=@reservation_ID
		update Car
		 set status='sold'
		insert into Managers_Manage_Reservation(reservation_ID) values (@reservation_ID)
	end
	else
		print 'car is already taken'
end
/*to purchase cars for admins and manager (if customer comes in person, we should let the admin and managers
                                           add that customer to customer table without email and password and some null values)*/

								/*---create triggers---*/

/*to restrict date of birth*/
/*to check the email is not repeated when user creates account*/
/*to check driving_licence_no's and not repeated(but for creating account cause user with account can rent in person means same licence_no)*/
/*to make new cars rentable after a year or something (don't know if it's trigger or procedure tho)*/
