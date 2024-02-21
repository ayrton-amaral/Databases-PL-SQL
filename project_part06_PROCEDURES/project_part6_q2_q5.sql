SPOOL C:\DB2\project_part6\project_part6_q2_q5.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2
-- Run script 7software in schemas des04
-- Create a procedure to display all the consultants.
-- Under each consultant display all his/her skill (skill description)
-- and the status of the skill (certified or not)
CREATE OR REPLACE PROCEDURE P6Q2 AS
    CURSOR CONSULTANT_CURSOR IS
        SELECT C_ID, C_LAST, C_FIRST
        FROM CONSULTANT;
    
    CURSOR SKILLS_CURSOR (P_C_ID NUMBER) IS
        SELECT S.SKILL_ID, S.SKILL_DESCRIPTION, CS.CERTIFICATION
        FROM SKILL S
        JOIN CONSULTANT_SKILL CS ON CS.SKILL_ID = S.SKILL_ID
        WHERE C_ID = P_C_ID;

BEGIN
        FOR CONSULTS IN CONSULTANT_CURSOR LOOP
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- CONSULTANT ---------------');
            DBMS_OUTPUT.PUT_LINE('Consultant ' || CONSULTS.C_ID || ' is ' || CONSULTS.C_LAST || ' ' || CONSULTS.C_FIRST || '.');

            DBMS_OUTPUT.PUT_LINE('--------------- SKILLS ---------------');
            
            FOR CSKILL IN SKILLS_CURSOR(CONSULTS.C_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('Skill ' || CSKILL.SKILL_ID || ' is ' || CSKILL.SKILL_DESCRIPTION || '. Certification: ' || CSKILL.CERTIFICATION || '.');
            END LOOP;
        END LOOP;
END;
/

EXEC P6Q2

-- Question 5
-- Run script 7software in schemas des04
-- Create a procedure that accepts a consultant id, and a character used to update the status (certified or not) 
-- of all the SKILLs belonged to the consultant inserted.
-- Display 4 information about the consultant such as id, name, …
-- Under each consultant display all his/her skill (skill description)
-- and the OLD and NEW status of the skill (certified or not).
CREATE OR REPLACE PROCEDURE P6Q5 (p_consultant_id NUMBER, p_char VARCHAR2) AS
    CURSOR CONSULT_CURR (p_consultant_id NUMBER) IS
        SELECT C_ID, C_LAST, C_FIRST, C_CITY
        FROM CONSULTANT
        WHERE C_ID = p_consultant_id;
    
    CURSOR SKILLS_CURR (P_C_ID NUMBER) IS
        SELECT S.SKILL_ID, S.SKILL_DESCRIPTION, CS.CERTIFICATION
        FROM SKILL S
        JOIN CONSULTANT_SKILL CS ON CS.SKILL_ID = S.SKILL_ID
        WHERE C_ID = P_C_ID
        FOR UPDATE OF CS.CERTIFICATION; -- it's being used to lock the data CS.CERTIFICATION.
        
BEGIN
    IF UPPER(p_char) != 'Y' AND UPPER(p_char) != 'N' THEN
        DBMS_OUTPUT.PUT_LINE('The character used to update the status must be: Y or N.');
    ELSE
        FOR I_CONSULT IN CONSULT_CURR(p_consultant_id) LOOP
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('--------------- CONSULTANT ---------------');
            DBMS_OUTPUT.PUT_LINE('Consultant ' || I_CONSULT.C_ID || ' is ' || I_CONSULT.C_LAST || ' ' || I_CONSULT.C_FIRST || ', from ' || I_CONSULT.C_CITY || '.');
    
            DBMS_OUTPUT.PUT_LINE('--------------- SKILLS ---------------');
                
            FOR I_SKILL IN SKILLS_CURR(I_CONSULT.C_ID) LOOP
                DBMS_OUTPUT.PUT_LINE('His/her skill is ' || I_SKILL.SKILL_DESCRIPTION || '. Old certification status: ' || UPPER(I_SKILL.CERTIFICATION) || '; ' ||
                                        ' New certification status: ' || UPPER(p_char) || '.');
            END LOOP;
        END LOOP;
        
        UPDATE CONSULTANT_SKILL
        SET CERTIFICATION = p_char
        WHERE C_ID = p_consultant_id;
        COMMIT;
    END IF;
END;
/

EXEC P6Q5(100, 'y')
EXEC P6Q5(100, 'b')
EXEC P6Q5(100, 'n')


SPOOL OFF