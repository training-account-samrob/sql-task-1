CREATE OR REPLACE PROCEDURE (name VARCHAR(20))
LANGUAGE plpgsql
AS $$
DECLARE
greet VARCHAR(20) := 'Hello';
BEGIN
RAISE NOTICE '%, %', greet, name;
END;
$$;


CREATE OR REPLACE PROCEDURE addNewProduct(catagory INT, catagory_name VARCHAR, supplier VARCHAR, description TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO product VALUES(catagory, catagory_name, supplier, description);
END;
$$;

CALL addNewProduct(800, 'watches', 'HIJ', 'Quality watches')


CREATE OR REPLACE PROCEDURE loopProcedure(number INT)
LANGUAGE plpgsql
AS $$
DECLARE i INT;
BEGIN
for i in 0..number LOOP
RAISE NOTICE '%', i;
END LOOP;
END $$;

CALL loopProcedure(10)

DO $$
CREATE TABLE count(
    count INT
);

CREATE OR REPLACE PROCEDURE incrementCount(number INT)
LANGUAGE plpgsql
AS $$
BEGIN
for i in 0..number LOOP
IF (i % 2) = 0 THEN
INSERT INTO count VALUES(i);
END IF;
END LOOP;
END; 
$$;





