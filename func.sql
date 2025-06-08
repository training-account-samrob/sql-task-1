-- Step 1: Create a Simple Table 

-- Let’s create a table called employees: 

-- This table has: 

CREATE TABLE employees (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(100), 
    salary NUMERIC 
);

insert into employees(name, salary) values
('John', 7000),
('Jill', 7890), 
('Andrew', 5689),
('Paul', 4367);


CREATE FUNCTION get_salary(emp_id INT)
RETURNS NUMERIC AS $$
DECLARE
    emp_salary NUMERIC;
BEGIN
    SELECT salary INTO emp_salary
    FROM employees
    WHERE id = emp_id;

    RETURN emp_salary;
END;
$$ LANGUAGE plpgsql

-- new function to get actor first / last name from actor ID 
CREATE FUNCTION get_actor_name(actor_id INT)
RETURNS STRING AS $$
DECLARE
    full_name STRING;
BEGIN
    SELECT actor.first_name || ' ' || actor.last_name AS full_name INTO full_name
    FROM actor
    WHERE actor_id = actor_id;

    RETURN full_name;
END;
$$ LANGUAGE plpgsql



-- new function to get actor first / last name from actor ID 
CREATE OR REPLACE FUNCTION get_actor_name2(a_id INT) -- param name cannot be exact match for column name
RETURNS VARCHAR AS $$ -- define the data type of the return value
DECLARE
    full_name VARCHAR; -- define the name of the return var
BEGIN
    SELECT actor.first_name || ' ' || actor.last_name AS full_name INTO full_name
    FROM actor
    WHERE a_id = actor.actor_id; -- left hand side is param name, right hand side is column name

    RETURN full_name;
END;
$$ LANGUAGE plpgsql -- define flavour of sql



CREATE OR REPLACE FUNCTION score(input_month VARCHAR)
RETURNS VARCHAR AS $$
DECLARE final_score VARCHAR;
BEGIN
SELECT CASE
WHEN COUNT(sales_order_id) > 9 THEN 'Target Achieved'
WHEN COUNT(sales_order_id) BETWEEN 7 AND 9 THEN 'Marginal'
ELSE 'Target Failed'
END INTO final_score
FROM sales_order
WHERE TO_CHAR(time_order_taken, 'MM') = input_month;

RETURN final_score;
END;
$$ LANGUAGE plpgsql;
