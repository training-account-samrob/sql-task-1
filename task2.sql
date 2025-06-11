-- 1
-- Write a query to display films that will be ranked within each rating category 
-- Write query using Rank function - You can use rank function.  
-- Write query with subquery

-- version 1 with joins
SELECT
	film.title,
	film.film_id, 
	film.rating,
	RANK() OVER(ORDER BY film.rating) AS rating_rank
FROM film
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
ORDER BY rating_rank;

-- version 2 with subquery
SELECT
	film.title,
	film.film_id, 
	film.rating,
	RANK() OVER(ORDER BY film.rating) AS rating_rank
FROM film
WHERE film.film_id IN (select film_category.film_id FROM film_category 
JOIN category ON category.category_id = film_category.category_id)
ORDER BY rating_rank;

-- version 3 with CTE
WITH ids AS (
	select film_category.film_id 
	FROM film_category 
	JOIN category ON category.category_id = film_category.category_id
)
SELECT
	film.title,
	film.film_id, 
	film.rating,
	RANK() OVER(ORDER BY film.rating) AS rating_rank
FROM film
WHERE film.film_id IN (SELECT film_id FROM ids)
ORDER BY rating_rank;

-------------------------------------------------------------------------------------
 
-- 2
-- List all films that have never been rented. 
-- Write query with subquery 
-- Write query with CTE
SELECT film.film_id, film.title
FROM film
WHERE film.film_id NOT IN (
	SELECT inventory.film_id
	FROM inventory
	JOIN rental ON rental.inventory_id = inventory.inventory_id
);

-- with CTE
WITH rented_films AS (
	SELECT inventory.film_id
	FROM inventory
	JOIN rental ON rental.inventory_id = inventory.inventory_id
)
SELECT film.film_id, film.title
FROM film
WHERE film.film_id NOT IN (
SELECT film_id FROM rented_films
)
ORDER BY film.title ASC;

-------------------------------------------------------------------------------------

-- 3
-- Find the names of customers who live in the same city as customer ID 1. 
-- Write query with subquery 
-- Write query with correlated subquery
select customer_id
from (
	select customer.customer_id, address.city_id
	from customer
	join address on address.address_id = customer.address_id
)
where city_id = (
	select city_id
	from (
	select customer.customer_id, address.city_id
	from customer
	JOIN address ON address.address_id = customer.address_id
	WHERE customer.customer_id = 1
	)
);

-------------------------------------------------------------------------------------
 
-- 4
-- Find the email addresses of customers who have rented the film 'Matrix Snowman'. 
-- Write query with subquery 
-- Write query with joins 
SELECT email
FROM customer
WHERE customer_id IN (
	SELECT rental.customer_id
	FROM rental
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id
	WHERE LOWER(film.title) = 'matrix snowman'
);

SELECT email
FROM customer
JOIN rental on rental.customer_id = customer.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE LOWER(film.title) = 'matrix snowman';

-------------------------------------------------------------------------------------

-- 5
-- Get the titles of the top 5 most rented films. 
-- Write query subquery 
-- Write query with CTE
WITH top_five AS (
	SELECT film_id, COUNT(rental_id) AS times_rented
	FROM inventory
	JOIN rental ON rental.inventory_id = inventory.inventory_id
	GROUP BY film_id
	order by times_rented DESC
	LIMIT 5
)
SELECT title
FROM film
where film_id in (
SELECT film_id FROM top_five
);

-- with subquery 
SELECT title
FROM film
where film_id in (
	SELECT film_id FROM (
		SELECT film_id, COUNT(rental_id) AS times_rented
		FROM inventory
		JOIN rental ON rental.inventory_id = inventory.inventory_id
		GROUP BY film_id
		order by times_rented DESC
		LIMIT 5
	)
);

-------------------------------------------------------------------------------------
 
-- 6
-- List all films that are shorter than the average film length. 
SELECT 
	film.title, 
	film.length 
FROM film
WHERE film.length < (
	SELECT CAST(AVG(film.length) AS INT) FROM film)
ORDER BY film.length DESC;

-------------------------------------------------------------------------------------

-- 7
-- Customers who have made more payments than the average. 
-- Write query with subquery 
-- write with CTE
SELECT *
FROM (
    SELECT 
        customer.customer_id, 
        COUNT(payment.payment_id) AS times_payed,
        (SELECT CAST(AVG(payment_count) AS INT) 
         FROM (
             SELECT COUNT(*) AS payment_count
             FROM payment
             GROUP BY customer_id
         ) AS avg_subquery) AS avg_times_payed
    FROM customer
    JOIN payment ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id
) AS sub_version
WHERE times_payed > avg_times_payed
ORDER BY times_payed DESC;

-- Write query with CTE
WITH cte_version AS (
    SELECT 
        customer.customer_id, 
        COUNT(payment.payment_id) AS times_payed,
        (SELECT CAST(AVG(payment_count) AS INT) 
         FROM (
             SELECT COUNT(*) AS payment_count
             FROM payment
             GROUP BY customer_id
         ) AS avg_subquery) AS avg_times_payed
    FROM customer
    JOIN payment ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id
)
SELECT * from cte_version
WHERE times_payed > avg_times_payed
ORDER BY times_payed DESC;

-------------------------------------------------------------------------------------
 
-- 8
-- Write the query to print the current date and time in this format.  
-- Picture 1, Picture 
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI:SS');

-------------------------------------------------------------------------------------
 
-- 9
-- Write the query to display the count number of rentals by staff per year. 
SELECT staff.staff_id, COUNT(rental.rental_id)
FROM staff
JOIN rental ON rental.staff_id = staff.staff_id
GROUP BY staff.staff_id;

-------------------------------------------------------------------------------------

--10
-- Write a query to display customer details into tiers like Bronze, Silver, Gold, and Platinum based on their total spending, and display their names, total amount spent, and tier. 
-- Hint – use case..when
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id
)
SELECT
    customer_id, total_amount,
    CASE
        WHEN total_amount > 200 THEN 'Platinum'
        WHEN total_amount > 150 THEN 'Gold'
        WHEN total_amount > 100 THEN 'Silver'
        ELSE 'Bronze'
    END AS final_customer_tier
FROM customer_totals
ORDER BY total_amount ASC;

-------------------------------------------------------------------------------------

-- 11
--  List all films that were rented in the month of January 2006, along with the rental date and the name of the customer who rented them. 
-- Hint – use joins 
SELECT 
	film.title,
	rental.rental_date,
	customer.first_name,
	customer.last_name
FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN customer ON customer.customer_id = rental.customer_id
WHERE EXTRACT(MONTH FROM rental.rental_date) = 01 AND EXTRACT(YEAR FROM rental.rental_date) = 2006;

-------------------------------------------------------------------------------------
 
-- 12
-- Write a function check_customer_rental that performs:  
-- Accepts a customer ID and a number of days as parameters.  
-- Checks each rental for that customer.  
-- Logs whether the rental was returned late based on the given number of days.
-- basic query
SELECT customer.customer_id, rental.rental_id, rental.rental_date, rental.return_date
FROM customer
JOIN rental ON rental.customer_id = customer.customer_id
WHERE rental.return_date > rental.rental_date + INTERVAL '7 days' AND customer.customer_id = 368;

-- func
CREATE OR REPLACE FUNCTION check_customer_rental(x_customer_id INT, x_days INT)
RETURNS TABLE (rental_id INT, status TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        rental.rental_id,
        CASE 
            WHEN rental.return_date > rental.rental_date + (x_days || ' days')::INTERVAL THEN 'Late'
            ELSE 'On Time'
        END AS status
    FROM rental
    WHERE rental.customer_id = x_customer_id;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------------
 
-- 13
-- Create a trigger in the DVD Rental database that logs information about customers who are deleted, including their ID and name, into a separate log table for auditing purposes. 
create table customer_audit(
   audit_id SERIAL not null,
   customer_id varchar(30) not null,
   old_first_name varchar(30) not null,
   old_last_name numeric not null,
   operation_time timestamp not null default current_timestamp,
   owner varchar(30)
);

CREATE OR REPLACE FUNCTION customer_audit_trigger_function()
RETURNS TRIGGER 
language plpgsql 
AS $$
BEGIN
    if (TG_OP = 'DELETE') THEN
	insert into customer_audit(customer_id, old_first_name, old_last_name, owner)
	values (old.customer_id, old.first_name, old.last_name, current_user);	
    END IF;
RETURN NULL;
END;
$$;

create trigger cust_audit_trigger
After Delete on customer
For each row
Execute function customer_audit_trigger_function()