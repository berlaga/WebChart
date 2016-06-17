-- =============================================
-- Author:		Alexey Geller
-- Create date: June 2016
-- Description:	ELMAH table statistics
-- =============================================
CREATE PROCEDURE [dbo].[ELMAH_report] 
	@DistinctErrorTypes int = 6,
	@DaysBack int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @sumValue as int
	declare @sumTotal as int

	select @sumTotal = 
	(
		select sum([Count]) from
		(
			select count ([Type]) as [Count] from [dbo].[ELMAH_Error] as a
			where 
			(   @DaysBack = 1 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(hh, -24, GETDATE())) OR	--24 hours
				@DaysBack = 2 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -3, GETDATE())) OR	--3 days
				@DaysBack = 3 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -7, GETDATE())) OR	--1 week
				@DaysBack = 4 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -1, GETDATE())) OR	--1 month
				@DaysBack = 5 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -12, GETDATE())) OR   --1 year
				@DaysBack = 0 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= dbo.getCurrentDateStartString())  -- today
			)     
			group by [Type]
		) as a
	)

	print @sumTotal


	select @sumValue = 
	(
		select sum([Count]) from
		(
			select top(@DistinctErrorTypes) count ([Type]) as [Count], [Type] from [dbo].[ELMAH_Error] as a
			where 
			(   @DaysBack = 1 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(hh, -24, GETDATE())) OR	--24 hours
				@DaysBack = 2 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -3, GETDATE())) OR	--3 days
				@DaysBack = 3 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -7, GETDATE())) OR	--1 week
				@DaysBack = 4 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -1, GETDATE())) OR	--1 month
				@DaysBack = 5 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -12, GETDATE())) OR   --1 year
				@DaysBack = 0 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= dbo.getCurrentDateStartString())  -- today
			)     
			group by [Type]
			order by [Count] desc
		) as a
	)

	print @sumValue

	select isnull(@sumTotal,0) - isnull(@sumValue,0) as [Count], 'Other types' as [Type], '00000000-0000-0000-0000-000000000000' as [Id]
	UNION
	select * from
	(
		select top(@DistinctErrorTypes) count (a.[Type]) as [Count], a.[Type],
		(
			select top(1) b.ErrorId from [dbo].[ELMAH_Error] as b
			where b.[Type] = a.[Type]
			order by b.TimeUtc desc
		
		) as [Id]		 
		from [dbo].[ELMAH_Error] as a
		where 
		(   @DaysBack = 1 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(hh, -24, GETDATE())) OR	--24 hours
			@DaysBack = 2 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -3, GETDATE())) OR	--3 days
			@DaysBack = 3 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(dd, -7, GETDATE())) OR	--1 week
			@DaysBack = 4 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -1, GETDATE())) OR	--1 month
			@DaysBack = 5 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= DateAdd(mm, -12, GETDATE())) OR   --1 year
			@DaysBack = 0 AND (DATEADD(minute, DATEDIFF(minute,getutcdate(),getdate()), [TimeUtc]) >= dbo.getCurrentDateStartString())  -- today
		)     
		group by [Type]
		order by [Count] desc
		) as z
	order by [Count] desc

END