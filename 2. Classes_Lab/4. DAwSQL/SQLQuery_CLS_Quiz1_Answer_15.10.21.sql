SELECT tracks.Name as name_track, genres.Name as genre_track
FROM tracks
INNER JOIN genres ON tracks.GenreId=genres.GenreId
LIMIT 10;

SELECT invoices.InvoiceId, customers.FirstName, customers.LastName
FROM invoices 
INNER JOIN customers on invoices.CustomerId=customers.CustomerId
LIMIT 10;

SELECT albums.ArtistId,artists.Name,albums.AlbumId,albums.Title
FROM artists 
LEFT JOIN albums on albums.ArtistId=artists.ArtistId;

SELECT COUNT(DISTINCT artists.ArtistId)
FROM artists

SELECT COUNT(DISTINCT albums.ArtistId)
FROM albums

SELECT COUNT(*)
FROM artists
LEFT JOIN albums on albums.ArtistId=artists.ArtistId
WHERE albums.Title IS NULL;

SELECT *
FROM employees;

SELECT A.FirstName, A.LastName, B.FirstName AS ManagerFirstName, B.LastName AS ManagerLastName
FROM employees A
INNER JOIN employees B ON B.EmployeeId=A.ReportsTo;
