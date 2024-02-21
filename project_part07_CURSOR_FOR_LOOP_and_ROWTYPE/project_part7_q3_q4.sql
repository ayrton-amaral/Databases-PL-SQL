SPOOL C:\DB2\project_part7\project_part7_q3_q4.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 3
-- Run script 7clearwater in schemas des02
-- Using CURSOR FOR LOOP syntax 2 in a procedure
-- to display all items (item_id, item_desc, cat_id)
-- under each item, display all the inventories belong to it.
CREATE OR REPLACE PROCEDURE P7Q3 AS
BEGIN
        FOR I_ITEM IN (SELECT ITEM_ID, ITEM_DESC, CAT_ID FROM ITEM) LOOP
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- ITEM ---------------');
            DBMS_OUTPUT.PUT_LINE('Item ' || I_ITEM.ITEM_ID || ' is ' || I_ITEM.ITEM_DESC || ' of the category ' || I_ITEM.CAT_ID || '.');

            DBMS_OUTPUT.PUT_LINE('--------------- INVENTORY ---------------');
            FOR I_INV IN (SELECT INV_ID, COLOR, INV_SIZE, INV_PRICE, INV_QOH FROM INVENTORY WHERE ITEM_ID = I_ITEM.ITEM_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('Item ID: ' || I_INV.INV_ID || ', Color: ' || I_INV.COLOR || ', Size: '|| I_INV.INV_SIZE || 
                                        ', Price $' || I_INV.INV_PRICE || ', Quantity: ' || I_INV.INV_QOH || '.');
            END LOOP;
        END LOOP;
END;
/

EXEC P7Q3


-- Question 4
-- Modify question 3 to display beside the item description
-- the value of the item (value = inv_price * inv_qoh).
CREATE OR REPLACE PROCEDURE P7Q4 AS
BEGIN
    FOR I_ITEM IN 
    (SELECT I.ITEM_ID, I.ITEM_DESC, I.CAT_ID, SUM(INV_PRICE * INV_QOH) "TOTAL_VALUE" 
        FROM ITEM I
        JOIN INVENTORY INV ON INV.ITEM_ID = I.ITEM_ID
        GROUP BY I.ITEM_ID, I.ITEM_DESC, I.CAT_ID) LOOP        
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- ITEM ---------------');
            DBMS_OUTPUT.PUT_LINE('Item ' || I_ITEM.ITEM_ID || ' is ' || I_ITEM.ITEM_DESC || ', with a total value of $' ||
                                    I_ITEM.TOTAL_VALUE || '. Category ID is ' || I_ITEM.CAT_ID || '.');

            DBMS_OUTPUT.PUT_LINE('--------------- INVENTORY ---------------');
            FOR I_INV IN (SELECT INV_ID, COLOR, INV_SIZE, INV_PRICE, INV_QOH FROM INVENTORY WHERE ITEM_ID = I_ITEM.ITEM_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('Item ID: ' || I_INV.INV_ID || ', Color: ' || I_INV.COLOR || ', Size: '|| I_INV.INV_SIZE || 
                                        ', Price $' || I_INV.INV_PRICE || ', Quantity: ' || I_INV.INV_QOH || '.');
            END LOOP;
        END LOOP;
END;
/

EXEC P7Q4


SPOOL OFF
