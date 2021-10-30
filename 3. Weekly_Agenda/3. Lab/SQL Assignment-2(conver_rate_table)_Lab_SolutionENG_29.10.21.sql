--- Oct 29, 2021 Assignmnet 2 Solution


---- CTE and case 


WITH T1 AS
(
SELECT *
FROM ( VALUES  
		(1,'A', 'Left'),
		(2,'A', 'Order'),
		(3,'B', 'Left'),
		(4,'A', 'Order'),
		(5,'A', 'Review'),
		(6,'A', 'Left'),
		(7,'B', 'Left'),
		(8,'B', 'Order'),
		(9,'B', 'Review'),
		(10,'A', 'Review')
		) A (visitor_id, adv_type, [action])
)
SELECT *,
		CASE WHEN [action] = 'Order' THEN 1 ELSE 0 END AS cnt_order
FROM T1



WITH T1 AS
(
SELECT *
FROM ( VALUES  
		(1,'A', 'Left'),
		(2,'A', 'Order'),
		(3,'B', 'Left'),
		(4,'A', 'Order'),
		(5,'A', 'Review'),
		(6,'A', 'Left'),
		(7,'B', 'Left'),
		(8,'B', 'Order'),
		(9,'B', 'Review'),
		(10,'A', 'Review')
		) A (visitor_id, adv_type, [action])
), T2 AS
(
SELECT adv_type, COUNT(*) total_count,
		SUM(CASE WHEN [action] = 'Order' THEN 1 ELSE 0 END) AS cnt_order
FROM T1 
GROUP BY adv_type
)
SELECT adv_type,  CONVERT(NUMERIC(3,2), 1.0 * cnt_order / total_count) CONVERSION_RATE
FROM T2

---Calculate Orders (Conversion) rates for each Advertisement 
--Type by dividing by total count of actions casting as float 
-- by multiplying by 1.0.



----- 2.WAY

CREATE TABLE Actions(
Visitor_ID int,
Adv_Type varchar(255),
Action varchar(255));


INSERT INTO Actions
VALUES	(1,'A','Left'),
		(2,'A','Order'),
		(3,'B','Left'),
		(4,'A','Order'),
		(5,'A','Review'),
		(6,'A','Left'),
		(7,'B','Left'),
		(8,'B','Order'),
		(9,'B','Review'),
		(10,'A','Review');


SELECT *
FROM Actions


SELECT A.Adv_Type,   CAST(CAST(B.Action_count AS float) / COUNT(A.Action) AS NUMERIC(3,2)) ORDER_RATIO
FROM Actions A, (
			SELECT Adv_Type, Action, COUNT(Action) Action_count
			FROM Actions
			WHERE Action = 'Order'
			GROUP BY Adv_Type, Action) B
WHERE A.Adv_Type = B.Adv_Type
GROUP BY A.Adv_Type, B.Action_count





