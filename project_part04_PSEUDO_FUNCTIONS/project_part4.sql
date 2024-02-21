SPOOL C:\DB2\project_part4.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 1
-- Create a procedure that accepts 3 parameters,
-- the first two are of mode IN with datatype NUMBER
-- and the third one is of mode OUT in form of VARCHAR2.
-- The procedure will compare the first two numbers
-- and output the result as EQUAL or DIFFERENT.
CREATE OR REPLACE PROCEDURE p4q1 (p_num1 NUMBER, p_num2 NUMBER, p_output OUT VARCHAR2) AS
BEGIN
    IF p_num1 = p_num2 THEN
        p_output := 'EQUAL';
    ELSE
        p_output := 'DIFFERENT';
    END IF;
END;
/

-- Create a second procedure called L4Q1 that accepts the two sides of a rectangle.
-- The procedure will calculate the Area and the Perimeter of the rectangle.
-- Use the procedure created previously to display if the shape is a square or a rectangle.
-- The following are the example on how we execute the procedure and the expeceted output.

-- SQL > exec L4Q1(2,2)
-- The area of a square size 2 by 2 is 4. It's perimeter is 8. 

-- SQL > exec L4Q1(2,3)
-- The area of a rectangle size 2 by 3 is 6. It's perimeter is 10. 

CREATE OR REPLACE PROCEDURE L4Q1 (p_side1 NUMBER, p_side2 NUMBER) AS
v_area NUMBER;
v_perimeter NUMBER;
v_square_or_rectangle VARCHAR2(15);
BEGIN
    v_area := p_side1 * p_side2;
    v_perimeter := (p_side1 + p_side2) * 2;
    p4q1(p_side1, p_side2, v_square_or_rectangle); -- calling the previous procedure
    IF v_square_or_rectangle = 'EQUAL' THEN
        DBMS_OUTPUT.PUT_LINE('The area of a square size ' || p_side1 || ' by '
                                || p_side2 || ' is ' || v_area || '. It''s perimeter is ' || v_perimeter || '.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' || p_side1 || ' by '
                                || p_side2 || ' is ' || v_area || '. It''s perimeter is ' || v_perimeter || '.');
    END IF;
END;
/

EXEC L4Q1(2, 2)
EXEC L4Q1(2, 3)


-- Question 2
-- Create a pseudo function called pseudo_fun that accepts 2 parameters 
-- representing the height and width of a rectangle.
-- The pseudo function should return the area and the perimeter of the rectangle.

-- Create a second procedure called L4Q2 that accepts the two sides of a rectangle.
-- The procedure will use the pseudo function to display the shape, the area and the perimeter.
CREATE OR REPLACE PROCEDURE pseudo_fun (p_height IN OUT NUMBER, p_width IN OUT NUMBER) AS
v_area NUMBER;
v_perimeter NUMBER;
BEGIN
    v_area := p_height * p_width;
    v_perimeter := (p_height + p_width) * 2;
    p_height := v_area;
    p_width := v_perimeter;
END;
/

CREATE OR REPLACE PROCEDURE L4Q2 (p_rec_side1 NUMBER, p_rec_side2 NUMBER) AS
v_is_square BOOLEAN;
v_side1 NUMBER;
v_side2 NUMBER;
BEGIN
    v_side1 := p_rec_side1;
    v_side2 := p_rec_side2;
    v_is_square := p_rec_side1 = p_rec_side2;
    pseudo_fun(v_side1, v_side2);
    IF v_is_square = TRUE THEN
        DBMS_OUTPUT.PUT_LINE('The area of a square size ' || p_rec_side1 || ' by '
                                || p_rec_side2 || ' is ' || v_side1 || '. It''s perimeter is ' || v_side2 || '.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' || p_rec_side1 || ' by '
                                || p_rec_side2 || ' is ' || v_side1 || '. It''s perimeter is ' || v_side2 || '.');
    END IF;
END;
/

EXEC L4Q2(2, 2)
EXEC L4Q2(2, 3)


-- Question 3
-- Create a pseudo function that accepts 2 parameters representing the inv_id, 
-- and the percentage increase in price.
-- The pseudo function should first update the database with the new price
-- then return the new price and the quantity on hand.

-- Create a second procedure called L4Q3 that accepts the inv_id and the percentage increase in price.
-- The procedure will use the pseudo function to display the new value of the inventory
-- (hint: value = price X quantity on hand)
CREATE OR REPLACE PROCEDURE p4q3 (p_inv_id IN OUT NUMBER, p_percentage_increase IN OUT NUMBER) AS
BEGIN
    UPDATE INVENTORY SET INV_PRICE = INV_PRICE + (INV_PRICE * p_percentage_increase / 100)
    WHERE inv_id = p_inv_id;
    
    SELECT INV_PRICE, INV_QOH
    INTO p_inv_id, p_percentage_increase
    FROM INVENTORY
    WHERE inv_id = p_inv_id;
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE L4Q3 (p_inv_id IN NUMBER, p_percentage_increase IN NUMBER) AS
v_new_value NUMBER;
v_inv_id NUMBER;
v_percentage_increase NUMBER;
BEGIN
    v_inv_id := p_inv_id;
    v_percentage_increase := p_percentage_increase;
    p4q3(v_inv_id, v_percentage_increase);
    v_new_value := v_inv_id * v_percentage_increase; -- o novo valor multiplicado pelo inventory
    DBMS_OUTPUT.PUT_LINE('The new value of the inventory is ' || v_new_value );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The inventory id does not exist, my friend. So, we cannot increase the percentage.');
END;
/

EXEC L4Q3(1, 10)
EXEC L4Q3(40, 5)

SPOOL OFF