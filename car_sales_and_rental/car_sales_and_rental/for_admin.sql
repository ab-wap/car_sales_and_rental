select * from resources.view_Available_Cars()
select * from resources.view_All_Cars()
select * from resources.view_Suspended_Cars()
select * from resources.view_Reserved_Cars()
select * from resources.view_Rented_Cars()
select * from resources.view_Sold_Cars()
select * from resources.view_Reservation_History()
select * from resources.view_All_Active_Reservation()
select * from resources.view_Reservation_Today()
select * from resources.view_Reservation_At_Given_Date(@year int,@month int,@day int)
select * from resources.view_All_Rented()
select * from resources.view_Not_Returned()
select * from resources.view_Passed_Deadline_Not_Returned()
select * from resources.view_To_Be_Returned_Today()
select * from resources.view_Managed_Rents(@manager_ID int)
select * from resources.view_Rented_By_Admin()
select * from resources.view_Rented_Returned()
select * from resources.view_Rented_Returned_Today()
select * from resources.view_Rented_Returned_At_Given_Date(@year int,@month int,@day int)
select * from resources.view_Customer_Rental_History(@customer_ID int)
select * from resources.view_Managed_Returns(@manager_ID int)
select * from resources.view_Returned_Through_Admin()
select * from resources.view_All_Sales()
select * from resources.view_All_Sales_Today()
select * from resources.view_All_Sales_At_Given_Date(@year int, @month int, @day int)
select * from resources.view_Customer_Sales_History(@customer_ID int)
select * from resources.view_Managed_Sales(@manager_ID int)
select * from resources.view_Sales_By_Admin()
select * from resources.search_By_Sales_Price(@max int, @min int)
select * from resources.search_By_Rental_Price(@max int, @min int)
select * from resources.search_By_Model(@model varchar(30))
select * from resources.search_By_Mark(@mark varchar(30))
select * from resources.search_By_Manufacture_Year(@manufacture_Year int)
select * from resources.search_By_Transmission_Type(@transmission_Type varchar(30))
select * from resources.search_By_Horse_Power(@horse_Power int)
select * from resources.manager_Daily_Audit(@manager_ID int)
select * from resources.admin_Daily_Audit()
select * from resources.total_Money_From_Canceled_And_Expired_Reservations()

select * from resources.calc_Reserve_Date(@payment money)
select * from resources.calc_Rent_Payment(@rental_Price_Per_Day money,@no_Of_Days_Rented int,@reserve_Payment money)
select * from resources.calc_Punishment(@rent_ID int)
select * from resources.check_Customer_Free(@reservation_ID int)



exec system_Users.view_Customer_Info(@customer_ID int)
exec system_Users.view_Manager_Info(@manager_ID int)
exec system_Users.create_Customer_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@driving_Licence_No int, @birth_Date date, @email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
exec system_Users.add_Customer_Phone_Number(@customer_ID int,@phone_Number int)
exec system_Users.create_Admin_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
exec system_Users.add_Admin_Phone_Number(@admin_ID int,@phone_Number int)
exec system_Users.create_Manager_Account(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@email varchar(30),@password varchar(15),@phone_Number int,@city varchar(15),@kebele varchar(15))
exec system_Users.add_Manager_Phone_Number(@manager_ID int,@phone_Number int)
exec resources.reserve_Car(@car_ID int, @customer_ID int,@r_Type int,@reserve_Payment money)
exec resources.add_New_Car(@color varchar(15),@manufactured_Year int,@mark varchar(30),@model varchar(30),
							 @type varchar(30),@transmission_Type varchar(30),@fuel_Type varchar(30),@horse_Power int,
							 @sales_Price money,@plate_Number int)
exec resources.add_Used_Car(@color varchar(15),@manufactured_Year int,@mark varchar(30),@model varchar(30),
                              @type varchar(30),@transmission_Type varchar(30),@fuel_Type varchar(30),@horse_Power int,
							  @sales_Price money,@total_Rented_Date int,@plate_Number int)
exec resources.cancel_Reservation(@customer_ID int,@reservation_ID int)
exec resources.rent_Car(@manager_ID int,@reservation_ID int,@no_Of_Days_Rented int)
exec resources.return_Car(@manager_ID int,@rent_ID int,@damage_Compensation money)
exec resources.sell_Car(@manager_ID int,@reservation_ID int)
exec resources.admin_Rent_Car(@reservation_ID int,@no_Of_Days_Rented int)
exec resources.admin_Sell_Car(@reservation_ID int)
exec resources.admin_Return_Car(@rent_ID int,@damage_Compensation money)
exec system_Users.record_Customer_Info_In_Person(@f_Name varchar(20),@m_Name varchar(20),@l_Name varchar(20),@driving_Licence_No int, @birth_Date date,@phone_Number int,@city varchar(15),@kebele varchar(15))
exec system_Users.add_Phone_Number_In_Person(@customer_ID int,@phone_Number int)
exec resources.suspend_Car(@car_ID int)
exec resources.restore_Suspended_Car(@car_ID int)
exec resources.update_Color(@car_ID int,@color varchar(20))
exec resources.update_Plate_Number(@car_ID int,@plate_Number varchar(20))


--41 functions and 25 procedures and 18 tables and 15 triggers