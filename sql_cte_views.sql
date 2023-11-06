#1
#Create a view: customer's ID, name, email address, and total number of rentals (rental_count)
CREATE VIEW rental_info (customer_ID, name, email, rental_count) AS
	SELECT DISTINCT r.customer_id,
			CONCAT(c.first_name," ",c.Last_name) as name,
            c.email,
            COUNT(r.rental_id) as rental_count
    FROM rental r
    INNER JOIN customer c ON c.customer_id=r.customer_id
	GROUP BY r.customer_id,
			CONCAT(c.first_name," ",c.Last_name),
            c.email;
select * from rental_info;

#2 Temporary table: the total amount paid by each customer (total_paid). 
#Use rental_info view joined with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid
	SELECT R.*, sum(amount) as total_paid
    FROM rental_info R
    LEFT JOIN payment P ON p.customer_id=R.customer_id
    GROUP BY R.customer_id, r.name, r.email;
select * from total_paid;

#3 already done in #2, but will repeat using CTE here:
#CTE that joins the rental summary View with the customer payment summary Temporary Table. 
#The CTE should include the customer's name, email address, rental count, and total amount paid
WITH joint_all AS
(SELECT R.*, sum(amount) as total_paid FROM rental_info R LEFT JOIN payment P ON p.customer_id=R.customer_id
    GROUP BY R.customer_id, r.name, r.email)
#using the CTE, create the query to generate the final customer summary report, which should include: 
#customer name, email, rental_count, total_paid and average_payment_per_rental (total_paid/rental_count).
SELECT j.name as customer_name, j.email, j.rental_count, j.total_paid, round(j.total_paid/j.rental_count,2) as avg_payment_per_rental
FROM joint_all J;