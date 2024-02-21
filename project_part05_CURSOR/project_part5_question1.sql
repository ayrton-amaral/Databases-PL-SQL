SPOOL C:\DB2\project_part5\project_part5_question1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1
-- Run script 7northwoods.
-- Using cursor to display many rows of data,
-- create a procedure to display all the rows of table Term.
CREATE OR REPLACE PROCEDURE P5Q1 AS
CURSOR term_cursor IS 
    SELECT * FROM TERM;
v_term_id term.term_id%TYPE;
v_term_desc term.term_desc%TYPE;
v_status term.status%TYPE;
BEGIN
    OPEN term_cursor;
LOOP
FETCH term_cursor INTO v_term_id, v_term_desc, v_status;
    IF term_cursor%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(v_term_id || ' ' || v_term_desc || ' ' || v_status);
    END IF;
EXIT WHEN term_cursor%NOTFOUND;
END LOOP;
CLOSE term_cursor;
END;
/

EXEC P5Q1


SPOOL OFF