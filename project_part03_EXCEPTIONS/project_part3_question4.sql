SPOOL C:\DB2\project_part3_question4.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 4
-- We need to INSERT or UPDATE data of table consultant_skill,
-- create needed functions, procedures...
-- that accepts consultant id, skill id, and certification status for the task.

-- The procedure should be user friendly enough to handle all possible errors such as:
-- consultant id / skill id do not exist NO_DATA_FOUND
-- OR certification status is different than 'Y', 'N'.

-- Make sure to display:
-- Consultant last, first name, skill description and the confirmation of the DML performed.

-- Hint: do not forget to add COMMIT inside the procedure.
CREATE OR REPLACE FUNCTION consultant_validation (p_consultant_id NUMBER)
RETURN BOOLEAN AS
v_consultant_id NUMBER;
BEGIN
    SELECT C_ID
    INTO v_consultant_id
    FROM CONSULTANT
    WHERE C_ID = p_consultant_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION skill_validation (p_skill_id NUMBER)
RETURN BOOLEAN AS
v_skill_id NUMBER;
BEGIN
    SELECT SKILL_ID
    INTO v_skill_id
    FROM SKILL
    WHERE SKILL_ID = p_skill_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION consultant_skill_verification (p_consultant_id NUMBER, p_skill_id NUMBER) 
RETURN BOOLEAN AS
v_c_id NUMBER;
v_skill_id NUMBER;
BEGIN
    SELECT C_ID, SKILL_ID
    INTO v_c_id, v_skill_id
    FROM CONSULTANT_SKILL
    WHERE C_ID = p_consultant_id AND SKILL_ID = p_skill_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END;
/
    
CREATE OR REPLACE PROCEDURE p3q4 (p_consultant_id NUMBER, p_skill_id NUMBER, p_certification VARCHAR2) AS
v_lname VARCHAR2(20);
v_fname VARCHAR2(20);
v_skill_description VARCHAR2(50);
v_input_valid BOOLEAN;
BEGIN
    v_input_valid := TRUE; -- flag
    
    IF consultant_verification(p_consultant_id) = FALSE THEN
        v_input_valid := FALSE;
        DBMS_OUTPUT.PUT_LINE('The consultant ID ' || p_consultant_id || ' does not exist, my friend!');
    END IF;
    
    IF skill_verification(p_skill_id) = FALSE THEN
        v_input_valid := FALSE;
        DBMS_OUTPUT.PUT_LINE('The skill  ID ' || p_skill_id || ' does not exist, my friend!');
    END IF;
    
    IF UPPER(p_certification) != 'Y' AND UPPER(p_certification) != 'N' THEN
        v_input_valid := FALSE;
        DBMS_OUTPUT.PUT_LINE('The p_certification must be Y or N.');
    END IF;
    
    IF v_input_valid THEN
        
        SELECT C_LAST, C_FIRST
        INTO v_lname, v_fname
        FROM CONSULTANT
        WHERE C_ID = p_consultant_id;
        
        SELECT SKILL_DESCRIPTION
        INTO v_skill_description
        FROM SKILL
        WHERE SKILL_ID = p_skill_id;
        
        IF consultant_skill_verification(p_consultant_id, p_skill_id) = TRUE THEN
            UPDATE CONSULTANT_SKILL
            SET CERTIFICATION = p_certification
            WHERE C_ID = p_consultant_id AND SKILL_ID = p_skill_id;
            DBMS_OUTPUT.PUT_LINE('The certification was updated.');
        ELSE
            INSERT INTO CONSULTANT_SKILL (C_ID, SKILL_ID, CERTIFICATION)
            VALUES (p_consultant_id, p_skill_id, p_certification);
            DBMS_OUTPUT.PUT_LINE('The data were inserted.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('The consultant full name is ' || v_lname || ' ' 
                                || v_fname || ' and the correspondant skill description is ' || v_skill_description || '.');
        COMMIT;
    END IF;
END;
/

EXEC p3q4(100, 3, 'n')
EXEC p3q4(102, 2, 'Y')
EXEC p3q4(200, 10, 'b')

SPOOL OFF
