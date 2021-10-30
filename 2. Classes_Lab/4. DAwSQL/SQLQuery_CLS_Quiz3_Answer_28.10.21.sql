--Mini Quiz:
--1.Answer:
SELECT first_name, 
	last_name, 
	hire_date, 
	term_date, 
	JULIANDAY(term_date) - JULIANDAY(hire_date) AS date_diff

FROM employees;