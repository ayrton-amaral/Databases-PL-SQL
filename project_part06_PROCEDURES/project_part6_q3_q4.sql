SPOOL C:\DB2\project_part6\project_part6_q3_q4.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 3
-- Run script 7clearwater in schemas des02
-- Create a procedure to display all items (item_id, item_desc, cat_id)
-- under each item, display all the inventories belong to it.
CREATE OR REPLACE PROCEDURE P6Q3 AS
    CURSOR ITEM_CURSOR IS SELECT ITEM_ID, ITEM_DESC, CAT_ID FROM ITEM;
    CURSOR INVENTORY_CURSOR (P_ITEM_ID NUMBER) IS SELECT INV_ID, COLOR, INV_SIZE, INV_PRICE, INV_QOH FROM INVENTORY WHERE ITEM_ID = P_ITEM_ID;
BEGIN
        FOR I_ITEM IN ITEM_CURSOR LOOP
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- ITEM ---------------');
            DBMS_OUTPUT.PUT_LINE('Item ' || I_ITEM.ITEM_ID || ' is ' || I_ITEM.ITEM_DESC || ' of the category ' || I_ITEM.CAT_ID || '.');

            DBMS_OUTPUT.PUT_LINE('--------------- INVENTORY ---------------');

            FOR I_INV IN INVENTORY_CURSOR (I_ITEM.ITEM_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('Item ID: ' || I_INV.INV_ID || ', Color: ' || I_INV.COLOR || ', Size: '|| I_INV.INV_SIZE || 
                                        ', Price $' || I_INV.INV_PRICE || ', Quantity: ' || I_INV.INV_QOH || '.');
            END LOOP;
        END LOOP;
END;
/

EXEC P6Q3


-- Question 4
-- Modify question 3 to display beside the item description
-- the value of the item (value = inv_price * inv_qoh).
CREATE OR REPLACE FUNCTION F_CALCULATE_ITEM_VALUE (p_ITEM_ID NUMBER)
RETURN NUMBER AS
CURSOR MULT IS
    SELECT INV_PRICE, INV_QOH
    FROM INVENTORY
    WHERE ITEM_ID = p_ITEM_ID;
v_inv_price INVENTORY.INV_PRICE%TYPE;
v_inv_qoh INVENTORY.INV_QOH%TYPE;
v_value NUMBER;
v_total NUMBER := 0;
BEGIN
    OPEN MULT;
    FETCH MULT INTO v_inv_price, v_inv_qoh;
    WHILE MULT %FOUND LOOP
        v_value := v_inv_price * v_inv_qoh;
        v_total := v_total + v_value;
        FETCH MULT INTO v_inv_price, v_inv_qoh;
    END LOOP;
    CLOSE MULT;
RETURN v_total;
END;
/
-- The function is returning the total value of each item

CREATE OR REPLACE PROCEDURE P6Q4 AS
    CURSOR ITEM_CURSOR IS SELECT ITEM_ID, ITEM_DESC, CAT_ID FROM ITEM;
    CURSOR INVENTORY_CURSOR (p_ITEM_ID NUMBER) IS SELECT INV_ID, COLOR, INV_SIZE, INV_PRICE, INV_QOH FROM INVENTORY WHERE ITEM_ID = p_ITEM_ID;
BEGIN
        FOR I_ITEM IN ITEM_CURSOR LOOP
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- ITEM ---------------');
            DBMS_OUTPUT.PUT_LINE('Item ' || I_ITEM.ITEM_ID || ' is ' || I_ITEM.ITEM_DESC || ' of the category ' || I_ITEM.CAT_ID ||
                                    ', and has a total value of $' || F_CALCULATE_ITEM_VALUE(I_ITEM.ITEM_ID) || '.');

            DBMS_OUTPUT.PUT_LINE('--------------- INVENTORY ---------------');

            FOR I_INV IN INVENTORY_CURSOR (I_ITEM.ITEM_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('Item ID: ' || I_INV.INV_ID || ', Color: ' || I_INV.COLOR || ', Size: '|| I_INV.INV_SIZE || 
                                        ', Price $' || I_INV.INV_PRICE || ', Quantity: ' || I_INV.INV_QOH || '.');
            END LOOP;
        END LOOP;
END;
/

EXEC P6Q4


SPOOL OFF
