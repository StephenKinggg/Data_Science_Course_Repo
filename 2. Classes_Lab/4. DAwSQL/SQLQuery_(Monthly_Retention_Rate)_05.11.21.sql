create table log_val(login_date date, user_id int, id int not null , primary key (id));

insert into log_val(login_date,user_id,id)
     values('2020-01-01',10,1),('2020-01-02',12,2),('2020-01-03',15,3),
     ('2020-01-04',11,4),('2020-01-05',13,5),('2020-01-06',9,6),
     ('2020-01-07',21,7),('2020-01-08',10,8),('2020-01-09',10,9),
     ('2020-01-10',2,10),('2020-01-11',16,11),('2020-01-12',12,12),
     ('2020-01-13',10,13),('2020-01-14',18,14),('2020-01-15',15,15),
     ('2020-01-16',12,16),('2020-01-17',10,17),('2020-01-18',18,18),
     ('2020-01-19',14,19),('2020-01-20',16,20),('2020-01-21',12,21),
     ('2020-01-22',21,22),('2020-01-23',13,23),('2020-01-24',15,24),
     ('2020-01-25',20,25),('2020-01-26',14,26),('2020-01-27',16,27),
     ('2020-01-28',15,28),('2020-01-29',10,29),('2020-01-30',18,30);

SELECT *
FROM log_val

--1. Bucket Visits By Week
---To calculate retention rate in SQL, first, we will group each visit by its week of login.


SELECT user_id, DATEPART(WEEK, login_date) AS login_week
FROM log_val
GROUP BY user_id, DATEPART(WEEK, login_date);

--2.Calculate FIRST WEEK of login for each user

--Next, to calculate retention rate in SQL, we need to calculate the first week of login for each user. We will simply use MIN function and GROUP BY to calculate first login week for each user

SELECT user_id, min(DATEPART(WEEK, login_date)) AS first_week
FROM log_val
GROUP BY user_id;

--3. Merge the 2 tables for login_week and first_week

--Next, we get login_week and first_week side by side for each user using the query below, with an INNER JOIN, to calculate retention rate in SQL.

Select a.user_id,a.login_week,b.first_week as first_week  
from (SELECT user_id, DATEPART(WEEK, login_date) AS login_week
      FROM log_val
      GROUP BY user_id,DATEPART(WEEK, login_date)) a,
      (	SELECT user_id, min(DATEPART(WEEK, login_date)) AS first_week
		FROM log_val
		GROUP BY user_id) b
where a.user_id=b.user_id;

--4. Calculate Week number

--From here on, it is easy to calculate retention rate in SQL. Next, we calculate the difference between login_week and first_week to calculate week_number (number of week)

Select a.user_id,a.login_week,b.first_week as first_week,
	  a.login_week-first_week as week_number 
from (SELECT user_id, DATEPART(WEEK, login_date) AS login_week
      FROM log_val
      GROUP BY user_id,DATEPART(WEEK, login_date)) a,
      (	SELECT user_id, min(DATEPART(WEEK, login_date)) AS first_week
		FROM log_val
		GROUP BY user_id) b
where a.user_id=b.user_id;

--5. Pivot the result

--Finally, we need to pivot the result, to calculate retention rate in SQL, and generate cohort table. In our pivot table, we will have one row for each first_week value, and one column for each week_number containing the number of users who have back after ‘n’ weeks to use your product/service. For this, we use the following query.

select first_week,
	   SUM(CASE WHEN week_number = 0 THEN 1 ELSE 0 END) AS week_0,
       SUM(CASE WHEN week_number = 1 THEN 1 ELSE 0 END) AS week_1,
       SUM(CASE WHEN week_number = 2 THEN 1 ELSE 0 END) AS week_2,
       SUM(CASE WHEN week_number = 3 THEN 1 ELSE 0 END) AS week_3,
       SUM(CASE WHEN week_number = 4 THEN 1 ELSE 0 END) AS week_4,
       SUM(CASE WHEN week_number = 5 THEN 1 ELSE 0 END) AS week_5,
       SUM(CASE WHEN week_number = 6 THEN 1 ELSE 0 END) AS week_6,
       SUM(CASE WHEN week_number = 7 THEN 1 ELSE 0 END) AS week_7,
       SUM(CASE WHEN week_number = 8 THEN 1 ELSE 0 END) AS week_8,
       SUM(CASE WHEN week_number = 9 THEN 1 ELSE 0 END) AS week_9
from  
(
    
       Select a.user_id,a.login_week,b.first_week as first_week,
	  a.login_week-first_week as week_number 
from (SELECT user_id, DATEPART(WEEK, login_date) AS login_week
      FROM log_val
      GROUP BY user_id,DATEPART(WEEK, login_date)) a,
      (	SELECT user_id, min(DATEPART(WEEK, login_date)) AS first_week
		FROM log_val
		GROUP BY user_id) b
where a.user_id=b.user_id
    
) as with_week_number
    
group by first_week
order by first_week;