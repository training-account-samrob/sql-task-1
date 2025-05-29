/* 1. Select the movie name & release date of every movie */
SELECT title, release_year FROM film;

/* 2. Select the first and last names of all united states actors */
-- Don't think this is correct because the actor_id doesn't seem to link to the address table directly
SELECT first_name, last_name FROM actor 
JOIN address ON actor.actor_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country_id = 103;

/* 3. Select all male actors born after the 1st of January 1970 */
-- no DOB or gender columns

/* 4. Select the names of all movies which are over 90 minutes long and movie language is English */
SELECT title FROM film
JOIN language ON film.language_id = language.language_id
WHERE film.length > 90 AND LOWER(language.name) = 'english'
ORDER BY film.title ASC;

/* 5. Select the movie names & movie language of all movies with a movie language of English, Spanish, or Korean */
-- there are only English films in the database
SELECT film.title, language.name FROM film
JOIN language ON film.language_id = language.language_id
WHERE LOWER(language.name) IN ('english', 'spanish', 'korean')
ORDER BY language.name ASC;

/* 6. Select the first and last names of the customers whose last name begins with M and were born between 01/01/1940 and 31/12/1969 */
-- no DOBs
select first_name, last_name from customer
WHERE lower(last_name) LIKE 'm%';

/* 7. Select the first and last names of the customers with nationality of British, French or German born between 01/01/1950 and 31/12/1980 */
-- no DOBs
-- France = 34
-- Germany = 38
-- UK = 102

SELECT first_name, last_name FROM customer 
JOIN address ON customer.actor_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country_id = 103;


/* 8. Write a query to find the highest rented movie in each store */
SELECT DISTINCT film.title, film.rental_rate, inventory.store_id FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE film.rental_rate = ( SELECT MAX(rental_rate) FROM film )
ORDER BY film.title ASC
LIMIT 2;

/* 9. Write a query to display languages for movie available */
SELECT name FROM language;

/* 10. List the top 5 customers who have spent the most on rentals */
SELECT customer.first_name || ' ' || customer.last_name AS full_name FROM customer
JOIN payment on payment.customer_id = customer.customer_id
ORDER BY payment.amount DESC
LIMIT 5;

/* 11. Find the number of movies available in each category */
SELECT category.name, COUNT(film_category.film_id) AS film_count FROM film_category
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name;

/* 12. Display the list of actors who have acted in more than 20 films */
SELECT actor.first_name || ' ' || actor.last_name AS full_name, COUNT(film_actor.film_id) AS film_count FROM film_actor
JOIN actor ON actor.actor_id = film_actor.actor_id
GROUP BY full_name
HAVING COUNT(film_actor.film_id) > 20;
-- can't use alias in "HAVING" clauses

/* 13. Find the most popular movie category by rental count */
SELECT category.name AS category_name, COUNT(rental.rental_id) AS rental_count FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY rental_count DESC
LIMIT 1;