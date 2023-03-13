-- functions and procedures granted for customers
-- functions

select * from resources.view_Available_Cars()
select * from resources.search_By_Sales_Price() 
select * from resources.search_By_Rental_Price()
select * from resources.search_By_Model()
select * from resources.search_By_Mark()
select * from resources.search_By_Manufacture_Year()
select * from resources.search_By_Transmission_Type()
select * from resources.search_By_Horse_Power()
select * from resources.view_Customer_Rental_History()
select * from resources.view_Customer_Sales_History()
select * from resources.calc_Rent_Payment()
select * from resources.calc_Punishment()
select * from resources.calc_Reserve_Date()

--procedures
exec system_Users.view_Customer_Info 
exec system_Users.create_Customer_Account
exec system_Users.add_Customer_Phone_Number 
exec resources.reserve_Car
exec resources.cancel_Reservation