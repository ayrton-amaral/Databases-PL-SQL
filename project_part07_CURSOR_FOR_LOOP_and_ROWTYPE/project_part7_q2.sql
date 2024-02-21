SPOOL C:\DB2\project_part7\project_part7_q2.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2
-- Run script 7software in schemas des04
-- Using %ROWTYPE in a procedure, display all the consultants.
-- Under each consultant display all his/her skill (skill description)
-- and the status of the skill (certified or not)
CREATE OR REPLACE PROCEDURE P2Q7 AS
    CURSOR CONSULTANT_CURSOR IS
        SELECT C_ID, C_LAST, C_FIRST
        FROM CONSULTANT;
        v_consultant_row CONSULTANT_CURSOR%ROWTYPE;

    CURSOR SKILL_CERTI_CURSOR (P_C_ID v_consultant_row.C_ID%TYPE) IS
        SELECT CS.SKILL_ID, S.SKILL_DESCRIPTION, CS.CERTIFICATION
        FROM SKILL S
        JOIN CONSULTANT_SKILL CS ON CS.SKILL_ID = S.SKILL_ID
        WHERE C_ID = P_C_ID;
        v_certification_row SKILL_CERTI_CURSOR%ROWTYPE;

BEGIN
    OPEN CONSULTANT_CURSOR;
    FETCH CONSULTANT_CURSOR INTO v_consultant_row;
    WHILE CONSULTANT_CURSOR%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('--------------- CONSULTANT ---------------');
        DBMS_OUTPUT.PUT_LINE('Consultant ' || v_consultant_row.C_ID || ' is ' || v_consultant_row.C_LAST || ' ' || v_consultant_row.C_FIRST || '.');

        OPEN SKILL_CERTI_CURSOR (v_consultant_row.C_ID);
        FETCH SKILL_CERTI_CURSOR INTO v_certification_row;
        WHILE SKILL_CERTI_CURSOR%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------- SKILLS ---------------');
            DBMS_OUTPUT.PUT_LINE('Skill ' || v_certification_row.SKILL_ID || ' is ' || v_certification_row.SKILL_DESCRIPTION ||
                                    '. Certification: ' || v_certification_row.CERTIFICATION || '.');
            FETCH SKILL_CERTI_CURSOR INTO v_certification_row;
        END LOOP;
        CLOSE SKILL_CERTI_CURSOR;
    FETCH CONSULTANT_CURSOR INTO v_consultant_row;
    END LOOP;
    CLOSE CONSULTANT_CURSOR;
END;
/

EXEC P2Q7


SPOOL OFF