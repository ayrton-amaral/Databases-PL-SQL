SPOOL C:\DB2\project_part3\project_part3_question3.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 3
-- Create a function called find_age that accepts a date and return a number.
-- The function will use the sysdate and the date inserted to calculate the age of the person
-- with the birthdate inserted.

-- Create a procedure that accepts a student number to display his full name, 
-- his birthdate, and his age using the function find_age created above.

-- Handle the error (use EXCEPTION).
CREATE OR REPLACE FUNCTION find_age (p_a_date IN DATE)
RETURN NUMBER AS
v_age NUMBER;
BEGIN
v_age := MONTHS_BETWEEN(SYSDATE, p_a_date) / 12;
RETURN TRUNC(v_age);
END;
/

SELECT find_age(TO_DATE('26/10/1994', 'DD/MM/YYYY')) FROM dual;

CREATE OR REPLACE PROCEDURE p3q3 (p_S_ID NUMBER) AS
v_s_last STUDENT.S_LAST%TYPE;
v_s_first STUDENT.S_FIRST%TYPE;
v_bdate STUDENT.S_DOB%TYPE;
v_age NUMBER;
BEGIN
    SELECT S_LAST, S_FIRST, S_DOB
    INTO v_s_last, v_s_first, v_bdate
    FROM STUDENT
    WHERE S_ID = p_S_ID;
v_age := find_age(v_bdate);
DBMS_OUTPUT.PUT_LINE('The student ID ' || p_S_ID || ' refers to the student ' 
                        || v_s_last || ' ' || v_s_first || ' that was born in ' 
                            || v_bdate || ', which he/she has ' || v_age || ' years old.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The student ID ' || p_S_ID || ' does not exist, my friend!');
END;
/

EXEC p3q3(1)
EXEC p3q3(7)

SPOOL OFF
