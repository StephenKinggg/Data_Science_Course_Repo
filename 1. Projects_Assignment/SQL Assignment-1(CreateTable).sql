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

SELECT
FROM Transactions
GR