SPOOL C:\DB2\project_part8\project_part8_q2.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- PROJECT PART 8
-- Question 2: (use script 7software)
-- Create a package with a procedure that accepts the consultant id, skill id, and a
-- letter to insert a new row into table consultant_skill.
-- After the record is inserted, display the consultant last and first name, 
-- skill description and the status of the certification as CERTIFIED or Not Yet Certified.
-- Do not forget to handle the errors such as: Consultant/skill does not exist and 
-- the certification is different than 'Y' or 'N'.
-- Test your package at least 2 times!
CREATE OR REPLACE PACKAGE consultant_skill_package IS
global_c_last CONSULTANT.C_LAST%TYPE;
global_c_first CONSULTANT.C_FIRST%TYPE;
global_skill_description SKILL.SKILL_DESCRIPTION%TYPE;
global_skill_verification BOOLEAN;
global_consultant_verification BOOLEAN;
    PROCEDURE insert_new_row (p_c_id NUMBER, p_skill_id NUMBER, p_status VARCHAR2);
	PROCEDURE consultant_verification (p_c_id NUMBER);
	PROCEDURE skill_verification (p_skill_id NUMBER);
END;
/


CREATE OR REPLACE PACKAGE BODY consultant_skill_package IS 
    PROCEDURE insert_new_row(p_c_id NUMBER, p_skill_id NUMBER, p_status VARCHAR2) AS
v_certification CONSULTANT_SKILL.CERTIFICATION%TYPE;
    BEGIN
        IF p_status = 'Y' OR p_status = 'N' THEN
            consultant_verification(p_c_id);
            skill_verification(p_skill_id);
	
        IF global_consultant_verification AND global_skill_verification THEN
            SELECT CERTIFICATION
            INTO   v_certification
            FROM   CONSULTANT_SKILL
            WHERE  C_ID = p_c_id AND SKILL_ID = p_skill_id;

                IF v_certification = p_status THEN
                    DBMS_OUTPUT.PUT_LINE('The consultant number ' ||p_c_id ||' is ' || global_c_first ||' '|| global_c_last ||
                                            '. Her/His skill is ' || global_skill_description || '. The certification is: ' ||
                                                v_certification || '. It does not need an update.');
                ELSE
                    UPDATE CONSULTANT_SKILL SET CERTIFICATION = p_status
                    WHERE  C_ID = p_c_id AND SKILL_ID = p_skill_id;
                    COMMIT;
                        DBMS_OUTPUT.PUT_LINE('The consultant number ' ||p_c_id ||' is ' || global_c_first ||' '|| global_c_last ||
                                                '. Her/His skill is ' || global_skill_description || '. The status has changed from ' ||v_certification ||
                                                    ' to ' || p_status || '.');
                END IF;  
        END IF; 
       
     	ELSE
       	   DBMS_OUTPUT.PUT_LINE('Insert Y or N, please.');
    	END IF;

      EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO CONSULTANT_SKILL VALUES(p_c_id, p_skill_id, p_status);
        COMMIT;
            DBMS_OUTPUT.PUT_LINE('The consultant number ' ||p_c_id ||' is ' || global_c_first ||' ' || global_c_last ||
                '. Her/His skill is ' || global_skill_description || ', and the status ' || p_status ||' was inserted.');
    END insert_new_row;


    PROCEDURE consultant_verification(p_c_id NUMBER) AS
    BEGIN
        SELECT C_LAST, C_FIRST
        INTO   global_c_last, global_c_first
        FROM   CONSULTANT
        WHERE  C_ID = p_c_id;
        global_consultant_verification := TRUE;
      
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('The consultant number ' ||p_c_id ||' does not exist.');
        global_consultant_verification := FALSE;
    END consultant_verification;


    PROCEDURE skill_verification(p_skill_id NUMBER) AS
    BEGIN
        SELECT SKILL_DESCRIPTION
        INTO   global_skill_description
        FROM   SKILL
        WHERE  SKILL_ID = p_skill_id;
        global_skill_verification := TRUE;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('The skill number ' ||p_skill_id ||' does not exist.');
        global_skill_verification := FALSE;
        END skill_verification;

END;
/

-- test for status
EXEC consultant_skill_package.insert_new_row(100, 1, 'X')

-- test for c_id
EXEC consultant_skill_package.insert_new_row(999, 1, 'Y')

-- test for skill_id
EXEC consultant_skill_package.insert_new_row(100, 88, 'Y')

-- test for combination c_id, skill_id NO change
EXEC consultant_skill_package.insert_new_row(100, 1, 'Y')

-- test for combination c_id, skill_id Exist , Update needed
EXEC consultant_skill_package.insert_new_row(100, 3, 'Y')

-- test for combination c_id, skill_id NOT Exist, insert needed
EXEC consultant_skill_package.insert_new_row(100, 5, 'N')

-- update
EXEC consultant_skill_package.insert_new_row(100, 5, 'Y')


SELECT * FROM CONSULTANT_SKILL;


SPOOL OFF