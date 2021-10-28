--Mini Quiz:
--1.Answer:
SELECT tracks.TrackId,tracks.Name, albums.AlbumId
FROM tracks,albums
WHERE tracks.AlbumId=albums.AlbumId
AND albums.Title='Outbreak'

--2.Answer:
SELECT CustomerId,customers.FirstName , customers.LastName
FROM customers, employees
WHERE customers.SupportRepId = employees.EmployeeId
AND employees.Country='Canada'
ORDER BY CustomerId

--3.Answer:

SELECT DISTINCT tracks.AlbumId, albums.Title, T1.albumbytes
FROM tracks,albums, (SELECT tracks.AlbumId, albums.Title, SUM(tracks.bytes) albumbytes
FROM tracks, albums
WHERE tracks.AlbumId=albums.AlbumId
GROUP BY tracks.AlbumId) T1
WHERE tracks.AlbumId=T1.AlbumId
AND albums.AlbumId=T1.AlbumId
AND T1.albumbytes < 5000000


WHERE SUM(tracks.bytes) < 5000000
