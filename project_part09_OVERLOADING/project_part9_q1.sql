SPOOL C:\DB2\project_part9\project_part9_q1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1
-- des02, script 7clearwater
-- Create a package with OVERLOADING procedure used to insert a new customer.
-- The user has the choice of providing either
-- a) Last Name, address
-- b) Last Name, birthdate
-- c) Last Name, First Name, birthdate
-- d) Customer id, last name, birthdate
-- In case no customer id is provided, please use a number from a sequence called customer_sequence.
CREATE OR REPLACE PACKAGE new_customer_package IS
    PROCEDURE insert_customer(p_c_last VARCHAR2, p_c_address VARCHAR2);
    PROCEDURE insert_customer(p_c_last VARCHAR2, p_c_birthdate DATE);
    PROCEDURE insert_customer(p_c_last VARCHAR2, p_c_first VARCHAR2, p_c_birthdate DATE);
    PROCEDURE insert_customer(p_c_id NUMBER, p_c_last VARCHAR2, p_c_birthdate DATE);
END;
/

DROP SEQUENCE customer_sequence;

CREATE SEQUENCE customer_sequence START with 7 NOCACHE;

CREATE OR REPLACE PACKAGE BODY new_customer_package IS
    PROCEDURE insert_customer(p_c_last VARCHAR2, p_c_address VARCHAR2) AS
    BEGIN
        INSERT INTO customer(c_id, c_last, c_address)
        VALUES (customer_sequence.NEXTVAL, p_c_last, p_c_address);
        DBMS_OUTPUT.PUT_LINE('The new customer was added with success!');
        COMMIT;
    END;

    PROCEDURE insert_customer(p_c_last VARCHAR2, p_c_birthdate DATE) AS
    BEGIN
        INSERT INTO customer(c_id, c_last, c_birthdate)
        VALUES (customer_sequence.NEXTVAL, p_c_last, p_c_birthdate);
        DBMS_OUTPUT.PUT_LINE('The new customer was added with success!');
        COMMIT;
    END;
    
    PROCEDURE insert_customer(p_c_last VARCHAR2, p_c_first VARCHAR2, p_c_birthdate DATE) AS
    BEGIN
        INSERT INTO customer(c_id, c_last, c_first, c_birthdate)
        VALUES (customer_sequence.NEXTVAL, p_c_last, p_c_first, p_c_birthdate);
        DBMS_OUTPUT.PUT_LINE('The new customer was added with success!');
        COMMIT;
    END;

    PROCEDURE insert_customer(p_c_id NUMBER, p_c_last VARCHAR2, p_c_birthdate DATE) AS
    BEGIN
        INSERT INTO customer(c_id, c_last, c_birthdate)
        VALUES (p_c_id, p_c_last, p_c_birthdate);
        DBMS_OUTPUT.PUT_LINE('The new customer was added with success!');
        COMMIT;
    END;
END;
/


-- a) Last Name, address
EXEC new_customer_package.insert_customer('Leblanc', '1536 René-Lévesque');

-- b) Last Name, birthdate
EXEC new_customer_package.insert_customer('Gauthier', TO_DATE('1970-12-04', 'YYYY-MM-DD'));
    
-- c) Last Name, First Name, birthdate
EXEC new_customer_package.insert_customer('Amaral', 'Ayrton', TO_DATE('1994-10-26', 'YYYY-MM-DD'));

-- d) Customer id, last name, birthdate
EXEC new_customer_package.insert_customer(10, 'Morin', TO_DATE('1991-08-16', 'YYYY-MM-DD'));


SPOOL OFF
