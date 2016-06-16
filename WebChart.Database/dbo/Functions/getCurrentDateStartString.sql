-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getCurrentDateStartString]
(

)
RETURNS varchar (30)
AS
BEGIN
	declare @someDate as varchar(30)


	SELECT @someDate =  REPLACE(
		CAST(DATEPART(YEAR, getdate()) as varchar(4)) + '-' + 
		CAST(DATEPART(MONTH, getdate()) as varchar(2)) + '-' + 
		CAST(DATEPART( DAY, getdate()) as varchar(2)), 
		' ', '')

	select @someDate = @someDate + CAST(' 00:01' as varchar(10))

		-- Return the result of the function
	RETURN  @someDate

END