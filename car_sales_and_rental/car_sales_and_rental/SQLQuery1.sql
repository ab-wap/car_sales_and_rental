				

				/*---create database---*/

create database car_sales_and_rental
use car_sales_and_rental


				/*---create tables---*/

/*for login*/
create table Login(
email varchar(30) primary key not null,
password char(8) not null,
last_Modified_Date date not null
)

/*for customer*/
create table Customer(
customer_ID int primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
driving_Licence_No varchar(10) not null,
birth_Date date not null,
email varchar(30) constraint email foreign key(email) references Login(email),
customer_Date date not null,
)

create table Customer_Phone_No(
phone_No int primary key not null,
customer_ID int constraint customer_ID foreign key(customer_ID) references Customer(customer_ID) not null
)

create table Customer_Adress(
city varchar(20) not null,
kebele int not null,
customer_ID int constraint customer_ID foreign key(customer_ID) references Customer(customer_ID) not null
)

/*for admin*/
create table Admin(
admin_ID int primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
email varchar(30) constraint email foreign key(email) references Login(email)
)

create table Admin_Phone_No(
phone_No int primary key not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null
)

create table Admin_Adress(
city varchar(20) not null,
kebele int not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null
)

/*for manager*/

create table Manager(
manager_ID int primary key not null,
f_Name varchar(20) not null,
m_Name varchar(20) not null,
l_Name varchar(20) not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null,
email varchar(30) constraint email foreign key(email) references Login(email)
)

create table Manager_Phone_No(
phone_No int primary key not null,
manager_ID int constraint manager_ID foreign key(manager_ID) references Manager(manager_ID) not null
)

create table Manager_Adress(
city varchar(20) not null,
kebele int not null,
manager_ID int constraint manager_ID foreign key(manager_ID) references Manager(manager_ID) not null
)

/*for car*/
create table Car(
car_ID int primary key not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null,
color varchar(15) not null,
manufacture_Year int not null,
mark varchar(30) not null,
model varchar(30) not null,
type varchar(30) not null,
transmission_Type varchar(30) not null,
fuel_Type varchar(30) not null,
status varchar(20) not null,
horse_Power int not null,
sales_Price int not null,
rental_Price_Per_Day int not null,
total_Rented_Date int,
car_Date date not null,
last_Modified_Date date not null
)

/*for reservation*/
create table Reservation(
reservation_ID int primary key not null,
customer_ID int constraint customer_ID foreign key(customer_ID) references Customer(customer_ID),
reserve_Type varchar(5) not null,
reserve_Payment int,
car_ID int constraint car_ID foreign key(car_ID) references Car(car_ID) not null,
reserved_Date date not null,
admin_ID int constraint admin_ID foreign key(admin_ID) references Admin(admin_ID) not null,
status int not null,
)

create table Managers_Manage_Reservation(
reservation_ID int primary key constraint reservation_ID foreign key (reservation_ID) references Reservation(reservation_ID) not null,
manager_ID int constraint manager_ID foreign key (manager_ID) references Manager(manager_ID) not null
)

/*for rent*/
create table Rent(
rent_ID int primary key not null,
reservation_ID int constraint reservation_ID foreign key references Reservation(reservation_ID) not null,
pick_Up_Date date not null,
return_Date date not null,
payment int not null,
)

create table Rent_Invoice(
invoice_ID int primary key not null,
rent_ID int constraint rent_ID foreign key(rent_ID) references Rent(rent_ID) not null,
punishment int,
actual_Return_Date date not null,
damage_Compensation int,
total_Payment int not null
)

/*for purchase*/
create table Purchase(
purchase_ID int primary key not null,
reservation_ID int constraint reservation_ID foreign key(reservation_ID) references Reservation(reservation_ID) not null,
date_Of_Sale date not null
)


								/*---create functions--*/

/*to view all available cars*/
create function view_Available_Cars()
returns table
as
return select car_ID,mark,model,type,color,manufacture_year,transmission_Type,fuel_Type,horse_Power,sales_Price,
              rental_Price_Per_Day, case when total_Rented_Date<=100 then 'new'
			  when total_Rented_Date between 101 and 400 then 'slightly used' else 'used' 
			  end condition
			  from Car where status='available'

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
			  Reservation(status)=NULL order by reserved_Date asc

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
              case Reservation(status) when NULL then 'active' when 1 then 'completed' end reservation_Status,
              mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type from Customer,Reservation,Car
			  where Customer(customer_ID)=Reservation(customer_ID) and Car(car_ID)=Reservation(car_ID) order by reserved_Date asc

/*to view all rented car(both returned and not returned)*/
create function view_All_Rented()
returns table
as
return select rent_ID,f_Name+' '+m_Name+' '+l_Name as 'Customer Name',email,mark+' '+model as 'Car Name',manufacture_year,type,transmission_Type,fuel_Type,
              pick_Up_Date,return_Date,payment from Customer,Rent,Car where reservation_ID in(select reservation_ID from Reservation where 
			  Reservation(customer_ID)=Customer(customer_ID) and Reservation(car_ID)=Car(car_ID)) order by pick_Up_Date asc

/*to view rented but not returned (present in rent table but not rent_invoice table)*/
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


								/*---create procedures---*/

/*to create account and record user info both for customer and
  admin&managers (need auto generated id)*/
/*to reserve cars for rental*/
/*to reserve cars for sales(conformation number should be the id)*/
/*to change password*/
/*to login*/
/*to logout*/
/*to update cars*/
/*to add cars*/
/*to cancel reservation*/
/*to purchase cars for admins and manager*/
/*to rent cars for admins and manager*/

/*---create triggers---*/