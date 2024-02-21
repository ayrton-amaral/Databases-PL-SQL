SPOOL C:\DB2\project_part9\project_part9_q2.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2
-- des03, script 7northwoods
-- Create a package with OVERLOADING procedure used to insert a new student. 
-- The user has the choice of providing either:
-- a) Student id, last name, birthdate
-- b) Last Name, birthdate
-- c) Last Name, address
-- d) Last Name, First Name, birthdate, faculty id
-- In case no student id is provided, please use a number from a sequence called student_sequence.
-- Make sure that the package with the overloading procedure is user friendly enough to handle error such as:
--  - Faculty id does not exist
--  - Student id provided already existed
--  - Birthdate is in the future
-- Please test for all cases and hand in spool file.
CREATE OR REPLACE PACKAGE new_student_package IS
    PROCEDURE insert_student(p_s_id NUMBER, p_s_last VARCHAR2, p_s_dob DATE);
    PROCEDURE insert_student(p_s_last VARCHAR2, p_s_dob DATE);
    PROCEDURE insert_student(p_s_last VARCHAR2, p_s_address VARCHAR2);
    PROCEDURE insert_student(p_s_last VARCHAR2, p_s_first VARCHAR2, p_s_dob DATE, p_f_id NUMBER);
END;
/


DROP SEQUENCE student_sequence;

CREATE SEQUENCE student_sequence START with 7 NOCACHE;



v_roll_on DATE;
v_roll_off DATE;


    SELECT ROLL_ON_DATE
        INTO v_roll_on
        FROM PROJECT_CONSULTANT
        WHERE;
        
        SELECT ROLL_OFF_DATE
        INTO v_roll_off
        FROM PROJECT_CONSULTANT;
        
        
        
        
' and the start date is ' ||  ||
                                    ' and the end date is ' || || '.');














CREATE OR REPLACE PACKAGE BODY new_student_package IS
    PROCEDURE insert_student(p_s_id NUMBER, p_s_last VARCHAR2, p_s_dob DATE) AS
    v_s_id NUMBER;
    BEGIN
        SELECT s_id
        INTO v_s_id
        FROM student
        WHERE s_id = p_s_id;
        DBMS_OUTPUT.PUT_LINE('The student id given: ' || p_s_id || ' is already being used!');
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
        IF p_s_dob > sysdate THEN
            DBMS_OUTPUT.PUT_LINE('The birthdate given: ' || p_s_dob || ' is in the future!');
        
        ELSE
            INSERT INTO student(s_id, s_last, s_dob)
            VALUES (p_s_id, p_s_last, p_s_dob);
            DBMS_OUTPUT.PUT_LINE('The new student was added with success!');
            COMMIT;
        END IF;
    END;

    PROCEDURE insert_student(p_s_last VARCHAR2, p_s_dob DATE) AS
    BEGIN
        IF p_s_dob > sysdate THEN
            DBMS_OUTPUT.PUT_LINE('The birthdate given: ' || p_s_dob || ' is in the future!');
        
        ELSE
            INSERT INTO student(s_id, s_last, s_dob)
            VALUES (student_sequence.NEXTVAL, p_s_last, p_s_dob);
            DBMS_OUTPUT.PUT_LINE('The new student was added with success!');
            COMMIT;
        END IF;
    END;
    
    PROCEDURE insert_student(p_s_last VARCHAR2, p_s_address VARCHAR2) AS
    BEGIN
        INSERT INTO student(s_id, s_last, s_address)
        VALUES (student_sequence.NEXTVAL, p_s_last, p_s_address);
        DBMS_OUTPUT.PUT_LINE('The new student was added with success!');
        COMMIT;
    END;

    PROCEDURE insert_student(p_s_last VARCHAR2, p_s_first VARCHAR2, p_s_dob DATE, p_f_id NUMBER) AS
    v_f_id NUMBER;
    BEGIN
        IF p_s_dob > sysdate THEN
            DBMS_OUTPUT.PUT_LINE('The birthdate given: ' || p_s_dob || ' is in the future!');
    
        ELSE
            SELECT f_id
            INTO v_f_id
            FROM student
            WHERE f_id = p_f_id;
        
            INSERT INTO student(s_id, s_last, s_first, s_dob, f_id)
            VALUES (student_sequence.NEXTVAL, p_s_last, p_s_first, p_s_dob, p_f_id);
            DBMS_OUTPUT.PUT_LINE('The new student was added with success!');
            COMMIT;
        END IF;
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The faculty id given: ' || p_f_id || ' does not exist!');   
    END;
END;
/


-- a) Student id, last name, birthdate
EXEC new_student_package.insert_student(10, 'Tremblay', TO_DATE('1980-04-19', 'YYYY-MM-DD'));

-- b) Last Name, birthdate
EXEC new_student_package.insert_student('Irineu', TO_DATE('1985-05-22', 'YYYY-MM-DD'));

-- c) Last Name, address
EXEC new_student_package.insert_student('Dubois', '1234 Saint-Catherine');

-- d) Last Name, First Name, birthdate, faculty id
EXEC new_student_package.insert_student('Gagne', 'Mathieu', TO_DATE('1984-06-08', 'YYYY-MM-DD'), 2);

-- Handling Errors:
--  Faculty id does not exist:
EXEC new_student_package.insert_student('Bergeron', 'Marrie', TO_DATE('1988-11-15', 'YYYY-MM-DD'), 5);

--  Student id provided already existed:
EXEC new_student_package.insert_student(10, 'Amaral', TO_DATE('1994-10-26', 'YYYY-MM-DD'));

--  Birthdate is in the future:
EXEC new_student_package.insert_student('Notyet', TO_DATE('2030-04-05', 'YYYY-MM-DD'));


SPOOL OFF
