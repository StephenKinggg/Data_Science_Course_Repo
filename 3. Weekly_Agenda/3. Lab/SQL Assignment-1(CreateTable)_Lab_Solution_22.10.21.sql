CREATE TABLE Transactions 
	(sender_id INT,
	receiver_id INT NOT NULL,
	amount INT NOT NULL,
	transaction_date DATE)

INSERT INTO Transactions (sender_id,receiver_id,amount,transaction_date )
VALUES  (55, 22, 500, '2021-05-18'),
		(11, 33, 350, '2021-05-19'),
		(22, 11, 650, '2021-05-19'),
		(22, 33, 900, '2021-05-20'),
		(33, 11, 500, '2021-05-21'),
		(33, 22, 750, '2021-05-21'),
		(11, 44, 300, '2021-05-22')

SELECT *
FROM Transactions

SELECT sender_id, SUM(amount) debit
FROM Transactions
GROUP BY sender_id
ORDER BY sender_id


SELECT receiver_id, SUM(amount) credit
FROM Transactions
GROUP BY receiver_id
ORDER BY receiver_id

SELECT *
FROM (SELECT sender_id, SUM(amount) debit
		FROM Transactions
		GROUP BY sender_id
		) S
FULL OUTER JOIN
		(SELECT receiver_id, SUM(amount) credit
		FROM Transactions
		GROUP BY receiver_id
		) R
ON S.sender_id=R.receiver_id


SELECT COALESCE(S.sender_id , R.receiver_id) Account_id,
	   COALESCE(credit, 0)-COALESCE(debit,0) Net_change
FROM (SELECT sender_id, SUM(amount) debit
		FROM Transactions
		GROUP BY sender_id
		) S
FULL OUTER JOIN
		(SELECT receiver_id, SUM(amount) credit
		FROM Transactions
		GROUP BY receiver_id
		) R
ON S.sender_id=R.receiver_id


--markalara ve kategorilere göre ortalama bisiklet fiyatlarýný bulalým.

SELECT B.brand_name, AVG(P.list_price) average_price
FROM product.brand B, product.product P
WHERE B.brand_id=P.brand_id
GROUP BY B.brand_name

