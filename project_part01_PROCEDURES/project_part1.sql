SPOOL C:\DB2\project_part1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1:
-- Create a procedure that accepts a number to display the triple of its value
-- to the screen as follow:
-- The triple of... is...
CREATE OR REPLACE PROCEDURE L1q1 (p_num IN NUMBER) AS
BEGIN
DBMS_OUTPUT.PUT_LINE('The triple of ' || p_num || ' is ' || p_num * 3 || '.');
END;
/

EXEC L1q1(2)

EXEC L1q1(3)

-- Question 2:
-- Create a procedure that accepts a number which represents the temperature in Celsius.
-- The procedure will convert the temperature into Fahrenheit using the following formula:
CREATE OR REPLACE PROCEDURE L1q2 (p_TC IN NUMBER) AS
v_TF NUMBER;
BEGIN
v_TF := (9 / 5) * p_TC + 32;
v_TF := ROUND(v_TF, 2);
DBMS_OUTPUT.PUT_LINE(p_TC || ' degree in C is equivalent to ' || v_TF || ' in F.');
END;
/

EXEC L1q2(0)
EXEC L1q2(38)
EXEC L1q2(-12)

-- Question 3:
-- Create a procedure that accepts a number which represents the temperature in Fahrenheit.
-- The procedure will convert the temperature into Celsius using the following formula:
CREATE OR REPLACE PROCEDURE L1q3 (p_TF IN NUMBER) AS
v_TC NUMBER;
BEGIN
v_TC := (5 / 9) * p_TF - 32;
v_TC := ROUND(v_TC, 2);
DBMS_OUTPUT.PUT_LINE(p_TF || ' degree in F is equivalent to ' || v_TC || ' in C.');
END;
/

EXEC L1q3(0)
EXEC L1q3(98)
EXEC L1q3(400)

-- Question 4:
-- Create a procedure that accepts a number used to calculate the
-- 5% GST, 9.98% QST, the total of the 2 tax, the grand total, and
-- to display everything to the screen as follow:
CREATE OR REPLACE PROCEDURE L1q4(p_price IN NUMBER) AS
v_GST NUMBER;
v_QST NUMBER;
v_GST_QST NUMBER;
v_total NUMBER;
BEGIN
v_GST := (p_price * 0.05);
v_GST := ROUND(v_GST, 2);
v_QST := (p_price * 0.0998);
v_QST := ROUND(v_QST, 2);
v_GST_QST := (v_GST + v_QST);
v_total := (p_price + v_GST_QST);
DBMS_OUTPUT.PUT_LINE('For the price of $ ' || p_price);
DBMS_OUTPUT.PUT_LINE('You will have to pay $ ' || v_GST || ' GST');
DBMS_OUTPUT.PUT_LINE('$ ' || v_QST || ' QST for a total of $ ' || v_GST_QST);
DBMS_OUTPUT.PUT_LINE('The GRAND TOTAL is $ ' || v_total);
END;
/

EXEC L1q4(100)

-- Question 5:
-- Create a procedure that accepts 2 numbers represented the width and height of rectangular shape.
-- The procedure will calculate the area and the perimeter using the following formula:
CREATE OR REPLACE PROCEDURE L1q5(p_width IN NUMBER, p_height IN NUMBER) AS
v_area NUMBER;
v_perimeter NUMBER;
BEGIN
v_area := (p_width * p_height);
v_perimeter := ((p_width + p_height) * 2);
DBMS_OUTPUT.PUT_LINE('The area of a ' || p_width || ' by ' || p_height || ' rectangle is ' || v_area || '.' 
                        || ' It''s perimeter is ' || v_perimeter || '.');
END;
/

EXEC L1q5(2,3)

-- Question 6:
CREATE OR REPLACE FUNCTION L1q6 (p_TC IN NUMBER) 
RETURN NUMBER AS
v_TF NUMBER;
BEGIN
v_TF := (9 / 5) * p_TC + 32;
v_TF := ROUND(v_TF, 2);
RETURN v_TF;
END;
/

SELECT L1q6(0) FROM dual;
SELECT L1q6(27) FROM dual;
SELECT L1q6(18) FROM dual;

-- Question 7:
CREATE OR REPLACE FUNCTION L1q_final (p_TF IN NUMBER)
RETURN NUMBER AS
v_TC NUMBER;
BEGIN
v_TC := (5 / 9) * p_TF - 32;
v_TC := ROUND(v_TC, 2);
RETURN v_TC;
END;
/

SELECT L1q_final(80) FROM dual;
SELECT L1q_final(74) FROM dual;
SELECT L1q_final(450) FROM dual;

SPOOL OFF