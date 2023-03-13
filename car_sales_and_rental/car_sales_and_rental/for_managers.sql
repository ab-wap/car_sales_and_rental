--functions and procedures granted for mamagers
--functions
select * from resources.view_All_Cars()
select * from resources.view_Suspended_Cars()
select * from resources.view_Reserved_Cars()
select * from resources.view_Rented_Cars()
select * from resources.view_Sold_Cars()
select * from resources.view_Reservation_History()
select * from resources.view_All_Active_Reservation()
select * from resources.view_Reservation_Today()
select * from resources.view_Reservation_At_Given_Date()
select * from resources.view_All_Rented()
select * from resources.view_Not_Returned()
select * from resources.view_Passed_Deadline_Not_Returned()
select * from resources.view_To_Be_Returned_Today()
select * from resources.view_Managed_Rents()
select * from resources.view_Rented_Returned()
select * from resources.view_Rented_Returned_Today()
select * from resources.view_Customer_Rental_History()
select * from resources.view_Managed_Returns()
select * from resources.view_All_Sales()
select * from resources.view_All_Sales_Today()
select * from resources.view_All_Sales_At_Given_Date()
select * from resources.view_Customer_Sales_History()
select * from resources.view_Managed_Sales()
select * from resources.search_By_Sales_Price()
select * from resources.search_By_Rental_Price()
select * from resources.search_By_Model()
select * from resources.search_By_Mark()
select * from resources.search_By_Manufacture_Year()
select * from resources.search_By_Transmission_Type()
select * from resources.search_By_Horse_Power()
select * from resources.manager_Daily_Audit()
select * from resources.total_Money_From_Canceled_And_Expired_Reservations()
select * from resources.calc_Rent_Payment()
select * from resources.calc_Punishment()
select * from resources.calc_Reserve_Date()
select * from resources.check_Customer_Free()

--procedures
exec system_Users.view_Customer_Info
exec system_Users.view_Manager_Info
exec system_Users.create_Manager_Account
exec system_Users.add_Manager_Phone_Number
exec resources.reserve_Car
exec resources.rent_Car
exec resources.return_Car
exec resources.sell_Car
exec system_Users.record_Customer_Info_In_Person
exec system_Users.add_Phone_Number_In_Person

alter trigger