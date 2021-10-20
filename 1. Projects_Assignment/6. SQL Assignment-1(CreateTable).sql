DROP TABLE IF EXISTS Transactions
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

SELECT  A.sender_id, B.receiver_id , SUM(DISTINCT B.amount)-SUM(DISTINCT A.amount)
FROM Transactions A
FULL OUTER JOIN Transactions B ON A.sender_id=B.receiver_id
GROUP BY A.sender_id, B.receiver_id


SELECT  COALESCE(SUM(DISTINCT B.amount),0)-COALESCE(SUM(DISTINCT A.amount),0) Net_change
FROM Transactions A
FULL OUTER JOIN Transactions B ON A.sender_id=B.receiver_id
GROUP BY A.sender_id, B.receiver_id

SELECT  COALESCE(A.sender_id , B.receiver_id) Account_id
FROM Transactions A
FULL OUTER JOIN Transactions B ON A.sender_id=B.receiver_id
GROUP BY A.sender_id, B.receiver_id


SELECT  COALESCE(A.sender_id , B.receiver_id) Account_id, COALESCE(SUM(DISTINCT B.amount),0)-COALESCE(SUM(DISTINCT A.amount),0) Net_change
FROM Transactions A
FULL OUTER JOIN Transactions B ON A.sender_id=B.receiver_id
GROUP BY A.sender_id, B.receiver_id


