SPOOL C:\DB2\project_part5\project_part5_question2_3.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2
-- Run script 7clearwater
-- Using cursor to display many rows of data,
-- Create a procedure to display the following data from the database:
-- Item description, price, color, and quantity on hand.
CREATE OR REPLACE PROCEDURE P5Q2 AS
CURSOR q2p5_cursor IS 
    SELECT I.ITEM_DESC, INV.INV_PRICE, INV.COLOR, INV.INV_QOH
    FROM ITEM I
    JOIN INVENTORY INV ON I.ITEM_ID = INV.ITEM_ID;
v_item_desc ITEM.ITEM_DESC%TYPE;
v_inv_price INVENTORY.INV_PRICE%TYPE;
v_inv_color INVENTORY.COLOR%TYPE;
v_inv_qoh INVENTORY.INV_QOH%TYPE;
BEGIN
    OPEN q2p5_cursor;
    FETCH q2p5_cursor INTO v_item_desc, v_inv_price, v_inv_color, v_inv_qoh;
        WHILE q2p5_cursor%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('The ' || v_item_desc || ' costs $' || v_inv_price || ', has the ' 
                                        || v_inv_color || ' color, and the quantity on hand is ' || v_inv_qoh || '.');
            FETCH q2p5_cursor INTO v_item_desc, v_inv_price, v_inv_color, v_inv_qoh;
        END LOOP;
CLOSE q2p5_cursor;
END;
/

EXEC P5Q2


-- Question 3
-- Run script 7clearwater
-- Using cursor to update many rows of data,
-- Create a procedure that accepts a number 
-- representing the percentage increase in price.
-- The procedure will display: old price, new price
-- and Update the database with the new price.
CREATE OR REPLACE PROCEDURE P5Q3 (p_percent_increase NUMBER) AS
CURSOR q3p5_cursor IS 
    SELECT INV_ID, INV_PRICE
    FROM INVENTORY;
v_inv_id INVENTORY.INV_ID%TYPE;
v_inv_price INVENTORY.INV_PRICE%TYPE;
v_new_price INVENTORY.INV_PRICE%TYPE;
BEGIN
    OPEN q3p5_cursor;
    FETCH q3p5_cursor INTO v_inv_id, v_inv_price;
    WHILE q3p5_cursor%FOUND LOOP
        v_new_price := v_inv_price + ((v_inv_price * p_percent_increase)/100);
        DBMS_OUTPUT.PUT_LINE('The old price is $' || v_inv_price || ', and the new price is $' || ROUND(v_new_price, 2) || '.');
        UPDATE INVENTORY SET INV_PRICE = v_new_price WHERE INV_ID = v_inv_id;
        FETCH q3p5_cursor INTO v_inv_id, v_inv_price;
    END LOOP;
CLOSE q3p5_cursor;
COMMIT;
END;
/

EXEC P5Q3(10)


SPOOL OFF