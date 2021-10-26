DROP TABLE IF EXISTS conver_rate
CREATE TABLE conver_rate
	(Visitor_ID INT NOT NULL,
	Adv_ID VARCHAR(50),
	Actionn VARCHAR(50)
	)

INSERT INTO conver_rate(Visitor_ID, Adv_ID, Actionn )
VALUES  (1, 'A', 'Left'),
		(2, 'A', 'Order'),
		(3, 'B', 'Left'),
		(4, 'A', 'Order'),
		(5, 'A', 'Review'),
		(6, 'A', 'Left'),
		(7, 'B', 'Left'),
		(8, 'B', 'Order'),
		(9, 'B', 'Review'),
		(10, 'A','Review')
		

SELECT *
FROM conver_rate

SELECT Adv_ID, COUNT(Actionn) Total_Action
FROM conver_rate
GROUP BY Adv_ID


SELECT adv_id,subtotal
FROM (SELECT Adv_ID, actionn, COUNT(Actionn) subtotal
FROM conver_rate
GROUP BY Adv_ID, actionn) T1
WHERE T1.actionn='Order'


SELECT C1.adv_id Adv_Type, ((T2.subtotal*1.0) / (C1.Total_Action)*1.0) Conversion_Rate
FROM (SELECT Adv_ID, COUNT(Actionn) Total_Action
FROM conver_rate
GROUP BY Adv_ID) C1 ,
(SELECT adv_id,subtotal
FROM (SELECT Adv_ID, actionn, COUNT (Actionn) subtotal
FROM conver_rate
GROUP BY Adv_ID, actionn) T1
WHERE T1.actionn='Order') T2
WHERE C1.adv_id=T2.Adv_ID


-- 2.yöntem

CREATE VIEW Total_info
AS SELECT Adv_ID, COUNT(CASE WHEN Actionn = 'Order' then 1 ELSE NULL END) as "total_order", COUNT(Actionn) as "total_action"
FROM conver_rate											
GROUP BY Adv_ID

SELECT Adv_ID, ROUND((CAST(total_order AS Float)/total_action), 2) as conversion_rate
FROM Total_info


--3.Yöntem:

SELECT Adv_ID, ROUND((CAST(total_order AS Float)/total_action), 2) as conversion_rate
 FROM (SELECT Adv_ID,COUNT(CASE WHEN actionn = 'Order' then 1 ELSE NULL END) as "total_order", COUNT(Actionn) as "total_action"
		FROM  conver_rate                     
		GROUP BY Adv_ID) as Total_info

--4.Yöntem:

WITH T1 AS
		(
		SELECT Adv_ID, COUNT(Actionn) order_num
		FROM conver_Rate
		WHERE actionn = 'Order'
		GROUP BY Adv_ID
		),
T2 AS
		(
		SELECT Adv_ID,COUNT(Actionn) num_of_action
		FROM conver_Rate
		GROUP BY Adv_ID
		)
SELECT T1.Adv_ID, round((cast(T1.order_num AS FLOAT) / cast(T2.num_of_action AS FLOAT)),2)  AS Conversion_Rate
FROM T1,T2
WHERE T1.Adv_ID = T2.Adv_ID