SPOOL C:\DB2\project_part6\project_part6_q1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1
-- Run script 7northwoods in schemas des03
-- Create a procedure to display all the 
-- faculty member (f_id, f_last, f_first, f_rank),
-- under each faculty member, 
-- display all the student advised by that faculty member
-- (s_id, s_last, s_first, birthdate, s_class).
CREATE OR REPLACE PROCEDURE P6Q1 AS
    CURSOR FACULTY_CURSOR IS SELECT F_ID, F_LAST, F_FIRST, F_RANK FROM FACULTY;
    
    CURSOR STUDENT_CURSOR (P_F_ID STUDENT.F_ID%TYPE) IS 
        SELECT S_ID, S_LAST, S_FIRST, S_DOB, S_CLASS
        FROM STUDENT
        WHERE F_ID = P_F_ID;
BEGIN
        FOR FAC IN FACULTY_CURSOR LOOP
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- FACULTY MEMBER ---------------');
            DBMS_OUTPUT.PUT_LINE('The faculty member ' || FAC.F_ID || ' is ' || FAC.F_LAST || ' ' || FAC.F_FIRST || ', who has the rank ' || FAC.F_RANK || '.');

            DBMS_OUTPUT.PUT_LINE('--------------- ADVISED STUDENT(S) ---------------');
            
            FOR STUD IN STUDENT_CURSOR(FAC.F_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('The student ' || STUD.S_ID || ' is ' || STUD.S_LAST || ' ' || STUD.S_FIRST || ', who was born in ' || STUD.S_DOB || ' and belongs to the ' || STUD.S_CLASS || '.');
            END LOOP;
        END LOOP;
END;
/

EXEC P6Q1


SPOOL OFF