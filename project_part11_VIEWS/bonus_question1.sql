SPOOL C:\DB2\project_part11\bonus_question1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;

-- Question 1:
-- (use script 7clearwater)
-- Create a view containing 
-- item description, item_id, price, color, inventory_id,
-- size of all the inventory of clearwater database.
CREATE OR REPLACE VIEW INVENTORY_VIEW AS
SELECT I.ITEM_DESC, INV.ITEM_ID, INV.INV_PRICE, INV.COLOR, INV.INV_ID, INV.INV_SIZE
FROM ITEM I, INVENTORY INV
WHERE I.ITEM_ID = INV.ITEM_ID;


-- Can we UPDATE, INSERT directly TO the view? If NOT, can you provide a solution?
SELECT * FROM INVENTORY_VIEW;


-- UPDATE
UPDATE INVENTORY_VIEW
SET COLOR = 'Red'
WHERE INV_ID = 3 AND ITEM_ID = 3;
-- Update yes, we can.


-- INSERT
-- INSERT INTO INVENTORY_VIEW VALUES ('Summer t-shirt', 10, 5000, 'Blue', 40, 'M');
-- It's not possible to insert directly into the view like this way above,
-- because is needed to preserve the primary key and because we are working with two different tables.
-- A solution would be a creation of an Instead of Trigger.


-- INSTEAD OF TRIGGER
CREATE OR REPLACE TRIGGER INVENTORY_VIEW_TRIGGER
INSTEAD OF INSERT ON INVENTORY_VIEW
FOR EACH ROW
BEGIN
    INSERT INTO ITEM (ITEM_DESC, ITEM_ID)
    VALUES (:NEW.ITEM_DESC, :NEW.ITEM_ID);
    
    INSERT INTO INVENTORY (INV_ID, ITEM_ID, COLOR, INV_SIZE, INV_PRICE)
    VALUES (:NEW.INV_ID, :NEW.ITEM_ID, :NEW.COLOR, :NEW.INV_SIZE, :NEW.INV_PRICE);
END;
/


INSERT INTO INVENTORY_VIEW VALUES ('Summer shorts', 9, 6000, 'Sky Blue', 35, 'S');
SELECT * FROM INVENTORY_VIEW;
-- Now, we can insert.


SPOOL OFF
