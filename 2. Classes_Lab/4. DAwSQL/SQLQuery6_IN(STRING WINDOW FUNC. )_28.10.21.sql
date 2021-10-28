--28.10.21

SELECT *
FROM t_date_time

SELECT A_time, A_date, GETDATE()
		DATEDIFF(minute, A_time, GETDATE()) AS minute_diff
		DATEDIFF(week, A_TIME, '2011-11-30') AS week_diff
FROM t_date_time


SELECT DATEDIFF(DAY,shipped_date, order_date) DATE_DIFF, order_date,shipped_date  -- büyük olaný önce yazmamýz gerekir.
FROM sale.orders


-- ABS mutlak deðeri alýyor.

SELECT ABS(DATEDIFF(DAY,shipped_date, order_date)) DATE_DIFF, order_date,shipped_date  -- büyük olaný önce yazmamýz gerekir.
FROM sale.orders  