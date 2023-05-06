--Q1 : who is the senior most employee based on job title?

select * from employee
Order by levels desc
limit 1

--Q2 : which countries have the most invoices?

select count (*) as c , billing_country from invoice
group by billing_country
order by c desc

--Q3 : what are the top three values of total invoice?

select * from invoice
order by total desc
limit 3

--Q4 : which city has the best customers? one city that has highest 
--sum of invoice total. city name and sum of invoice total should be seen.

select sum(total) as invoice_total, billing_city from invoice
group by billing_city
order by invoice_total desc
limit 1

--Q5 : who is the best customer(customer who spend the most money)

select customer.customer_id,customer.first_name,customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc 
limit 1

--Q6 : write query to return the email, first name, last name and genre of all rock music listeners.
-- alphatical email order.

select * from customer
select * from genre
select * from invoice
select * from invoice_line
select * from track

select distinct email,first_name,last_name, 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
select track_id from track
join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock' 
)
order by email;

--Q7 :artist name and total track count of top 10 rock bands

select * from artist
select * from album
select * from track
select * from genre

select artist.artist_id,artist.name,count(artist.name) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc 
limit 10

--Q8 :Return track names that have song length more than average song length.
-- return name and milliseconds of track and order by longest listed first.

select name, milliseconds
from track 
where milliseconds>(
select avg(milliseconds) 
	from track
)
order by milliseconds desc;

--Q9 : We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre with the highest amount of purchases.
--Write a query that returns each country along with the top Genre. 
--For countries where the maximum number of purchases is shared return all Genres. */

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

--Q10 :Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount. 

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1


