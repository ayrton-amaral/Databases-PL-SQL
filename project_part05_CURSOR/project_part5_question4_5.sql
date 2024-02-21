SPOOL C:\DB2\project_part5\project_part5_question4_5.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 4
-- Run script scott_emp_dept.
-- Create a procedure that accepts a number represent the number of employees 
-- who earns the highest salary.
-- Display employee name and his/her salary
-- Ex: SQL> exec L5Q4(2)
-- SQL> top 2 employees are
-- KING 5000
-- FORD 3000
CREATE OR REPLACE PROCEDURE P5Q4 (p_number_of_employees NUMBER) AS
CURSOR q4p5_cursor IS
    SELECT ENAME, SAL
    FROM EMP
    ORDER BY SAL DESC;
v_ename EMP.ENAME%TYPE;
v_sal EMP.SAL%TYPE;
v_counter NUMBER := 0;
BEGIN
    OPEN q4p5_cursor;
    DBMS_OUTPUT.PUT_LINE(' The top ' || p_number_of_employees || ' employees who earn the highest salary are: ');
    FETCH q4p5_cursor INTO v_ename, v_sal;
    WHILE q4p5_cursor%FOUND AND v_counter < p_number_of_employees LOOP -- WHILE q5p5_cursor%FOUND AND q5p5_cursor%ROWCOUNT <= p_number_of_employees LOOP
                                                                       -- Esse ROWCOUNT vai ser um contador de fileiras até ser menor ou igual o parâmetro inserido
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE( v_ename || ' ' || v_sal);
        FETCH q4p5_cursor INTO v_ename, v_sal;
    END LOOP;
    CLOSE q4p5_cursor;
END;
/

EXEC P5Q4(5)


-- Question 5
-- Modify question 4 to display ALL employees who make the top salary entered.
-- Ex: SQL> exec L5Q5(2)
-- SQL> Employee who make the top 2 salary are
-- KING 5000
-- FORD 3000
-- SCOTT 3000
CREATE OR REPLACE PROCEDURE P5Q5 (p_number_of_employees NUMBER) AS
CURSOR q5p5_cursor IS
    SELECT ENAME, SAL
    FROM EMP
    ORDER BY SAL DESC;
v_ename EMP.ENAME%TYPE;
v_sal EMP.SAL%TYPE; 
v_counter NUMBER := 0;
v_lower_sal NUMBER;
BEGIN
    OPEN q5p5_cursor;
    DBMS_OUTPUT.PUT_LINE(' The employees who earn the top ' || p_number_of_employees || ' salaries are: ');

    FETCH q5p5_cursor INTO v_ename, v_sal;

    WHILE q5p5_cursor%FOUND AND v_counter < p_number_of_employees LOOP
        IF v_lower_sal = v_sal THEN
            v_counter := v_counter - 1;
        END IF;

        v_counter := v_counter + 1;
        v_lower_sal := v_sal;
        FETCH q5p5_cursor INTO v_ename, v_sal;
    
    END LOOP;
    CLOSE q5p5_cursor;  

    OPEN q5p5_cursor;
    FETCH q5p5_cursor INTO v_ename, v_sal;
    
    WHILE v_sal >= v_lower_sal LOOP
        DBMS_OUTPUT.PUT_LINE( v_ename || ' ' || v_sal);		
        FETCH q5p5_cursor INTO v_ename, v_sal;
	END LOOP;
	CLOSE q5p5_cursor;    
END;
/

EXEC P5Q5(1)
EXEC P5Q5(2)
EXEC P5Q5(3)
EXEC P5Q5(4)


SPOOL OFF
