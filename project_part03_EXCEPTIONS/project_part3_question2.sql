SPOOL C:\DB2\project_part3\project_part3_question2.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2
-- Create a procedure that accepts an inv_id (inventory)
-- to display the item description, price, color, inv_qoh (inventory), and the value of that inventory.
-- Handle the error (use EXCEPTION)
-- Hint: value is the product of price and quantity on hand.
-- value = price * quantity on hand
CREATE OR REPLACE PROCEDURE p3q2 (inv_id_I IN NUMBER) AS
v_item_desc VARCHAR2 (40);
v_price NUMBER;
v_color VARCHAR2 (30);
v_quantity NUMBER;
v_value NUMBER;
BEGIN
    SELECT IT.ITEM_DESC, I.INV_PRICE, I.COLOR, I.INV_QOH
    INTO v_item_desc, v_price, v_color, v_quantity
    FROM ITEM IT
    JOIN INVENTORY I ON IT.ITEM_ID = I.ITEM_ID
    WHERE I.INV_ID = inv_id_I;
        IF v_price IS NULL OR v_quantity IS NULL THEN
        v_value := 0;
        ELSE
        v_value := ROUND(v_price * v_quantity, 2);
        END IF;
DBMS_OUTPUT.PUT_LINE('The inventory id ' || inv_id_i || ' has the following item description: ' || v_item_desc || '. Its price is ' || v_price  ||
                       ' and the color is ' || v_color || '. The current inventory of this product is ' || v_quantity || ' with a value of ' || v_value || '.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The inventory id ' || inv_id_I || ' does not exist, my friend!');
END;
/

EXEC p3q2(1)
EXEC p3q2(1000)

SPOOL OFF