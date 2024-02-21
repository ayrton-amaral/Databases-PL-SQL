SPOOL C:\DB2\project_part2.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1
-- Create a function that accepts 2 numbers to calculate the product of them.
CREATE OR REPLACE FUNCTION question1 (p_num1 IN NUMBER, p_num2 IN NUMBER) 
RETURN NUMBER AS
v_nums_product NUMBER;
BEGIN
v_nums_product := p_num1 * p_num2;
RETURN v_nums_product;
END;
/

SELECT question1(2, 3) FROM dual;
SELECT question1(3, 10) FROM dual;
SELECT question1(2, 5) FROM dual;

-- Question 2
-- Create a procedure that accepts 2 numbers and use the function created in question 1
-- to display the following:
-- For a rectangle of size x by y the area is z.
-- where x and y are the values supplied on run time by the user
-- and z is the value calculted using the function of question 1.
CREATE OR REPLACE PROCEDURE question2(p_num1 IN NUMBER, p_num2 IN NUMBER) AS
v_area NUMBER;
BEGIN
v_area := question1 (p_num1, p_num2);
DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || p_num1 || ' by ' || p_num2 || ' the area is ' || v_area || '.');
END;
/

EXEC question2(2,3)
EXEC question2(5,10)

-- Question 3
-- Modify procedure of question 2 to display "square"
-- when x and y are enqual in length
CREATE OR REPLACE PROCEDURE question3(p_num1 IN NUMBER, p_num2 IN NUMBER) AS
v_area NUMBER;
BEGIN
v_area := question1 (p_num1, p_num2);
    IF p_num1 = p_num2 THEN
        DBMS_OUTPUT.PUT_LINE('For a square of size ' || p_num1 || ' by ' || p_num2 || ' the area is ' || v_area || '.');
    ELSIF p_num1 != p_num2 THEN
DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || p_num1 || ' by ' || p_num2 || ' the area is ' || v_area || '.');
    END IF;
END;
/

EXEC question3(2,2)
EXEC question3(3,5)

-- Question 4
-- Create a procedure that accepts a number represent Canadian dollar
-- and a letter represent the new currency.
-- The procedure will convert the Canadian dollar to the new currency
-- using the following exchange rate:
-- E EURO 1.50
-- Y YEN 100
-- V Viet Nam DONG 10,000
-- Z Endora ZIP 1,000,000
-- Display Canadian money and the new currency in a sentence as following:
-- For "x" dollars Canadian, you will have "y" ZZZ
-- Where x is canadian dollar, y is the result of the exchange and ZZZ is the currency
-- EX: exec L2Q4(2,'Y')
-- For 2 dollars Canadian, you will have 200 YEN
CREATE OR REPLACE PROCEDURE question4(p_cad_convert IN NUMBER, p_letter IN VARCHAR2) AS
v_exchange_result NUMBER;
v_currency VARCHAR2(15);
BEGIN
    IF UPPER(p_letter) = 'E' THEN 
        v_exchange_result := p_cad_convert * 1.5;
        v_currency := 'EURO';
        
    ELSIF UPPER(p_letter) = 'Y' THEN
        v_exchange_result := p_cad_convert * 100;
        v_currency := 'YEN';

    ELSIF UPPER(p_letter) = 'V' THEN
        v_exchange_result := p_cad_convert * 10000;
        v_currency := 'Viet Nam DONG';
        
    ELSIF UPPER(p_letter) = 'Z' THEN
        v_exchange_result := p_cad_convert * 1000000;
        v_currency := 'Endora ZIP';
    END IF;
DBMS_OUTPUT.PUT_LINE('For ' || p_cad_convert || ' dollars Canadian, you will have ' 
                        ||  ROUND(v_exchange_result,2) || ' ' || v_currency);
END;
/

EXEC question4(2,'y')

-- Question 5 EVEN eh PAR   ODD IMPAR
-- Create a function called YES_EVEN that accepts a number to determine
-- if the number is EVEN or not.
-- The function will return TRUE if the number inserted is EVEN
-- otherwise the function will return FALSE
CREATE OR REPLACE FUNCTION YES_EVEN (p_number_in IN NUMBER)
RETURN BOOLEAN AS
v_result BOOLEAN;
BEGIN  
    IF MOD(p_number_in, 2) = 0 THEN 
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END;
/

-- Question 6
-- Create a procedure that accepts a numbers and 
-- uses the function of question 5 to print out either the following:
-- Number ... is EVEN
-- Number ... is ODD
CREATE OR REPLACE PROCEDURE question6 (p_number_in IN NUMBER) AS
v_odd_even BOOLEAN;
v_display VARCHAR2(4);
BEGIN
v_odd_even := YES_EVEN(p_number_in);
    IF v_odd_even = TRUE THEN
        v_display := 'EVEN';
    ELSE
        v_display := 'ODD';
    END IF;
DBMS_OUTPUT.PUT_LINE('Number ' || p_number_in || ' is ' || v_display);
END;
/

EXEC question6(6)
EXEC question6(5)

-- Bonus Question







SPOOL OFF