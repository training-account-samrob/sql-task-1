-- create an enum that has values 'Insert', 'Update', 'Delete'
CREATE TYPE op_enum AS ENUM ('insert', 'update', delete);


-- create an employee_audit table
create table emp_audit(
   audit_id int not null,
   employee_id varchar(30) not null,
   old_employee_name varchar(30) not null,
   old_employee_salary numeric not null,
   operation op_enum not null,
   operation_time timestamp not null default current_timestamp,
   owner varchar(30)
)

-- create a sequence for audit_id column
CREATE SEQUENCE emp_audit_seq
START WITH 1
INCREMENT BY 1;

-- understand the execution order of trigger
-- a. a trigger event occurs, such as update or delete statement performed on table
-- b. the TG_OP (trigger operation variable) get sets in the trigger 
-- c. the function attached with trigger is executed
-- d. we are in transaction, a commit is executed 

-- create the function to be executed when trigger fires
CREATE OR REPLACE FUNCTION emp_audit_trigger_function()
RETURNS TRIGGER 
language plpgsql 
AS $$
BEGIN
    if (TG_OP = 'UPDATE') THEN
	insert into emp_audit(audit_id, employee_id, old_employee_name, old_employee_salary, operation, owner)
	values (nextval('emp_audit_seq'), old.employee_id, old.name, old.salary, 'Update', current_user);

	ELSEIF (TG_OP = 'DELETE') THEN
	insert into emp_audit(audit_id, employee_id, old_employee_name, old_employee_salary, operation, owner)
	values (nextval('emp_audit_seq'), old.employee_id, old.name, old.salary, 'Delete', current_user);	
    END IF
RETURN NULL;
END;
$$


-- Create the Trigger for employee table
create trigger emp_audit_trigger
After Update or Delete on employee
For each row
Execute function emp_audit_trigger_func()


-- commit a transaction in the employee table 

UPDATE employee 
SET salary=6000
WHERE lower(name)='jill' 

-- check the audit table