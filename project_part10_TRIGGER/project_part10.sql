SPOOL C:\DB2\project_part10\project_part10.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;

-- Question 1
-- (use schemas des02 with script 7clearwater)
-- We need to know WHO and WHEN the table CUSTOMER is modified.
-- Create table, sequence, and trigger to record the needed information.
-- Test your trigger!
DROP TABLE customer_audit;
CREATE TABLE customer_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE);

DROP SEQUENCE customer_audit_sequence;
CREATE SEQUENCE customer_audit_sequence;

    CREATE OR REPLACE TRIGGER customer_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON CUSTOMER
    BEGIN
        INSERT INTO customer_audit
        VALUES(customer_audit_sequence.NEXTVAL, user, sysdate);
    END;
    /


-- Tests:
SELECT * FROM customer_audit;

INSERT INTO CUSTOMER(C_ID, C_LAST, C_FIRST, C_CITY)
VALUES (100,'Amaral','Ayrton', 'Montreal');

UPDATE CUSTOMER
SET C_LAST = 'Senna'
WHERE C_ID = 6;

DELETE FROM CUSTOMER
WHERE C_ID = 100;

COMMIT;

SELECT row_id, updating_user, TO_CHAR(updating_time, 'DD Month Year HH:MI:SS') FROM customer_audit;


-- Question 2:
-- Table ORDER_LINE is subject to INSERT, UPDATE, and DELETE, create a trigger
-- to record who, when, and the action performed on the table order_line in a table called order_line_audit.
-- (hint: use UPDATING, INSERTING, DELETING to verify for action performed. For example: IF UPDATING THEN …)
-- Test your trigger!
DROP TABLE order_line_audit;
CREATE TABLE order_line_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, action_performed VARCHAR2(25));

DROP SEQUENCE ol_audit_sequence;
CREATE SEQUENCE ol_audit_sequence;

CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON ORDER_LINE
BEGIN
    IF INSERTING THEN
        INSERT INTO order_line_audit
        VALUES (ol_audit_sequence.NEXTVAL, user, sysdate, 'INSERT');
	ELSIF UPDATING THEN
        INSERT INTO order_line_audit
        VALUES (ol_audit_sequence.NEXTVAL, user, sysdate, 'UPDATE');
	ELSIF DELETING THEN
        INSERT INTO order_line_audit
        VALUES (ol_audit_sequence.NEXTVAL, user, sysdate, 'DELETE');
	END IF;
END;
/


-- Tests:
SELECT * FROM order_line_audit;

INSERT INTO ORDER_LINE(O_ID, INV_ID, OL_QUANTITY)
VALUES (135, 15, 50);

UPDATE ORDER_LINE
SET OL_QUANTITY = 20
WHERE O_ID = 2 AND INV_ID = 19;

DELETE FROM ORDER_LINE
WHERE O_ID = 135 AND INV_ID = 15;

COMMIT;

SELECT row_id, updating_user, TO_CHAR(updating_time, 'DD Month Year HH:MI:SS'), action_performed FROM order_line_audit;


-- Question 3:
-- (use script 7clearwater)
-- Create a table called order_line_row_audit to record who, when, 
-- and the OLD value of ol_quantity every time the data of table ORDER_LINE is updated.
-- Test your trigger!
DROP TABLE order_line_row_audit;
CREATE TABLE order_line_row_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, 
                                    old_o_id NUMBER, old_inv_id NUMBER, old_ol_quantity NUMBER(4));

DROP SEQUENCE ol_row_audit_sequence;
CREATE SEQUENCE ol_row_audit_sequence;

CREATE OR REPLACE TRIGGER ol_row_audit_trigger
AFTER UPDATE ON ORDER_LINE
FOR EACH ROW
BEGIN
	INSERT INTO order_line_row_audit
	VALUES (ol_row_audit_sequence.NEXTVAL, user, sysdate, :OLD.O_ID, :OLD.INV_ID, :OLD.OL_QUANTITY);
END;
/


-- Tests:
SELECT * FROM order_line_row_audit;

UPDATE ORDER_LINE
SET OL_QUANTITY = 20
WHERE O_ID = 3 AND INV_ID = 24;

COMMIT;

SELECT row_id, updating_user, TO_CHAR(updating_time, 'DD Month Year HH:MI:SS'), old_ol_quantity FROM order_line_row_audit;


SPOOL OFF
