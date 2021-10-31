/*Practice Question:
The invoice_items table contains the details of the invoice items (tracks). The record of how much the customer paid for which track is store in this table.
Write a query using the window function that returns the top 10 highest paid InvoiceId. Expected columns are 'InvoiceId' and 'Total_Price'
*/

SELECT *
FROM invoice_items
ORDER BY InvoiceId;

SELECT  DISTINCT InvoiceId, 
		SUM (Quantity*UnitPrice) OVER (PARTITION BY InvoiceId) Total_Price
FROM    invoice_items
ORDER BY
        2 DESC
LIMIT 10

--2.yöntem:

SELECT InvoiceId, SUM(UnitPrice) Total_Price
FROM invoice_items
GROUP BY InvoiceId
ORDER BY Total_Price DESC

/*Practice Question:
The invoice table contains the details of the invoices of the customers. The date and address information of the invoices of the customers are stored in this table.
And the invoice_items table contains the details of the invoice items (tracks). 
The record of how much the customer paid for which track is store in this table.
Write a query using the window function that returns the cumulative sum price by InvoiceDate of the invoices billed in Amsterdam. 
Expected columns are 'InvoiceDate' and 'Cumulative_Total_Price'*/


SELECT InvoiceDate, 
	SUM(Total)OVER(ORDER BY InvoiceDate) AS Cumulative_Total_Price
FROM invoices
WHERE BillingCity='Amsterdam'

--2.Yöntem:

SELECT  DISTINCT b.InvoiceDate, SUM(a.UnitPrice*Quantity) OVER (ORDER BY b.InvoiceDate) Cumulative_Total_Price
FROM    invoice_items a, invoices b
WHERE   a.InvoiceId=b.invoiceId
AND     b.BillingCity = 'Amsterdam'
