SPOOL C:\DB2\project_part3_question1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1
-- Create a procedure that accepts an employee number
-- to display the name of the department,
-- where he works, his name, his annual salary (do not forget his one time commission)
-- Note that the salary in table employee is monthly salary.
-- Handle the error (use EXCEPTION)
-- hint: the name of the department can be found from table dept.
CREATE OR REPLACE PROCEDURE p3q1(employee_number IN NUMBER) AS
v_dname VARCHAR2 (40);
v_dloc VARCHAR2 (40);
v_ename VARCHAR2 (40);
v_esal NUMBER;
v_ecomm NUMBER;
v_annual_sal NUMBER;
BEGIN
    SELECT D.DNAME, D.LOC, E.ENAME, E.SAL, E.COMM
    INTO v_dname, v_dloc, v_ename, v_esal, v_ecomm
    FROM DEPT D
    JOIN EMP E ON E.DEPTNO = D.DEPTNO
    WHERE E.EMPNO = employee_number;
        IF v_ecomm IS NULL THEN
        v_annual_sal := ROUND(v_esal * 12, 2);
        ELSE
        v_annual_sal := ROUND((v_esal * 12) + v_ecomm, 2);
        END IF;
DBMS_OUTPUT.PUT_LINE('The employee number ' || employee_number || ' works on ' || v_dname || ' in ' || v_dloc 
                        || '. Her/His name is ' || v_ename || ' and receives an annual salary of ' || v_annual_sal || '.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee number ' || employee_number || ' does not exist, my friend!');
END;
/

EXEC p3q1(7902)
EXEC p3q1(7499)
EXEC p3q1(1)

SPOOL OFF