# PARTE 1 -- Seleccionando de la tabla customer, los datos de nombre y apellido así como seleccionando las peliculas
 # con duracion mayor a 120 minutos
USE sakila;
SELECT first_name, last_name FROM customer;
SELECT * FROM film
WHERE length > 120;

# PARTE 2 -- order by. La lista de clientes ahora es mostrada en orden alfabetico por apellido
SELECT last_name, first_name FROM customer
order by last_name Asc;
SELECT * from film 
where length > 120 
order by length desc LIMIT 5;

# PARTE 3 -- Join entre payment y customer.
 #Cantidad pagada- fecha de pago - nombre y apellido
SELECT payment.amount, payment.payment_date, customer.first_name, customer.last_name FROM payment
JOIN customer on payment.customer_id = customer.customer_id;

 # Peliculas alquiladas
 #Join Rental - Inventory - Film
 # en esta primera seccion teneemos vision de las peliculas que han sido rentadas y su inventory o 
 # la cantidad rentadas registradas pero es obvio que no se ven las que están actualmente en renta. Es dificil decirlo. 
SELECT film.title, film.rental_duration, rental.last_update from rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id;

 # En esta segunda seccion después de verificar, podemos usar el return date para verificar si ya han sido devueltas o no. Esto porque al estar vacio, muestra que la pelicula
 # no ha sido devuelta. Es por eso que usamos null. 
SELECT film.title, rental.rental_date, rental.return_date from rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date is NULL;

#PARTE 4 -- LEFT JOIN
# Muestra datos aunque no estén en ambas tablas. Por ejemplo, mostrar actores que no tengan peliculas. 
#prioridad a la llave izq donde la llave derecha es nula. Peliculas que no tienen actores.
# Para ver clientes sin pagos registrados ( entendiendo que la tabla de payment no los registrará) sería algo así: 
# Este resultado deja ver que no existen clientes sin pagos. 
SELECT customer.first_name, customer.last_name, payment.amount, payment.payment_date FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment.amount IS NULL;

# Sin embargo sí hay clientes con registros de pagos pero que han tenido 0 gasto. 
# esto puede darse debido a promociones o alguna forma de registrar como si existiese un pago cuando en realidad no hay ingreso al negocio. 
SELECT customer.first_name, customer.last_name, payment.amount, payment.payment_date FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment.amount = 0.00;

# en el sgte bloque se lista solo lo especificado "titulo" y "duración" pero en el codigo se ve que se 
# listan solo aquellas peliculas sin actores. Para mostrar esto en el resultado, solo habria que añadir film_actor.actor_id en la select list.
SELECT film.title, film.length FROM film 
LEFT JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IS NULL;

#PARTE 5 -- INSERT, UPDATE, DELETE #Data Definition Language
SELECT first_name, last_name, actor_id FROM actor
ORDER BY actor_id DESC;
	INSERT INTO actor (first_name, last_name)
	VALUES ('Roxana', 'Rico');
UPDATE actor SET first_name = 'ISABEL', last_name = 'CASTRO' WHERE actor_id ='201';

START TRANSACTION;
DELETE FROM actor
WHERE actor_id='201';
select * from actor
commit;

#PARTE 6 -- 
#Primer bloque busca mostrar los clientes con mayor pagos totales, esto viene de la suma de todas las transacciones realizadas por ese cliente e identificadas con su customer_id lo que permite a su vez agruparlas por ese dato. Una vez identificadas y sumadas, se ordenan de forma descendente para que la lista inicie con los totales más altos y con el limit, reducimos la lista a las primeras 5. 
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS Total FROM customer
JOIN payment ON customer.customer_id = payment.customer_id 
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY Total DESC LIMIT 5;

#Lo mismo ocurre con las rentas, creamos una columna nueva para almacenar el conteo de las peliculas, unimos las tablas, agrupamos por el id, organizamos de manera descendiente para visualizar las mayores en el inicio y limitamos la busqueda a 5.
SELECT film.title, COUNT(rental.rental_id) AS Total_veces_alquilada FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.film_id
order by Total_veces_alquilada Desc Limit 5;


























