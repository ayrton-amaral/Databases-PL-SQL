SPOOL C:\DB2\project_part8\project_part8_q1.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- PROJECT PART 8
-- Question 1: (use script 7clearwater)
-- Modify the package order_package (Example of lecture on PACKAGE)
-- by adding function/procedure to verify
-- the quantity on hand before insert a row 
-- in table order_line and 
-- to update also the quantity on hand of table inventory.
-- Test your package with different cases.
CREATE OR REPLACE PACKAGE order_package IS
global_quantity NUMBER;
global_inv_id NUMBER;
    PROCEDURE create_new_order(p_customer_id NUMBER, p_meth_pmt VARCHAR2, p_os_id NUMBER);
    PROCEDURE create_new_order_line(p_order_id NUMBER);
    FUNCTION verify_qoh RETURN BOOLEAN;
END;
/

CREATE OR REPLACE PACKAGE BODY order_package IS
   PROCEDURE create_new_order(p_customer_id NUMBER, p_meth_pmt VARCHAR2, p_os_id NUMBER) AS
	v_order_id NUMBER;
	BEGIN
	   SELECT order_sequence.NEXTVAL
	   INTO v_order_id
	   FROM dual;

	   INSERT INTO orders
	   VALUES(v_order_id, sysdate, p_meth_pmt, p_customer_id, p_os_id);
      	   COMMIT;
        IF verify_qoh THEN
            create_new_order_line(v_order_id);
        END IF;
	END create_new_order;

   PROCEDURE create_new_order_line(p_order_id NUMBER) AS
	BEGIN
        INSERT INTO order_line VALUES(p_order_id, global_inv_id, global_quantity);
        UPDATE INVENTORY SET INV_QOH = (INV_QOH - global_quantity) WHERE global_inv_id = inv_id;
        COMMIT;
	END create_new_order_line;
       
    FUNCTION verify_qoh RETURN BOOLEAN AS 
    V_INV_QOH NUMBER;
        BEGIN 
            SELECT INV_QOH INTO V_INV_QOH FROM INVENTORY WHERE INV_ID = global_inv_id;
            IF V_INV_QOH >= global_quantity THEN
            RETURN TRUE;
            ELSE
            RETURN FALSE;
            END IF;
        END;
END;
/

-- Initializing:
BEGIN
   order_package.global_quantity := 10; -- the quantity the client wants
   order_package.global_inv_id := 3;     -- of which (s)he wants
END;
/

EXEC order_package.create_new_order(2,'CASH',1);

EXEC order_package.create_new_order(6,'CREDIT',2);

SELECT INV_QOH FROM INVENTORY WHERE INV_ID = 3;
SELECT * FROM ORDER_LINE ORDER BY 1;


SPOOL OFF