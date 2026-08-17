CREATE TABLE accounts (
accId INTEGER NOT NULL PRIMARY KEY,
balance DECIMAL(11,2) NOT NULL,
CONSTRAINT empty_account CHECK (balance >= 0.00)
);

SET AUTOCOMMIT ON;

INSERT INTO accounts(accId, balance) VALUES (1,1000.00); 
INSERT INTO accounts(accId, balance) VALUES (2,2000.00); 
INSERT INTO accounts(accId, balance) VALUES (3,3000.00);

SET TRANSACTION READ WRITE;
UPDATE accounts SET balance=balance-300 WHERE accId=1;
UPDATE accounts SET balance=balance+300 WHERE accId=2;
COMMIT;

UPDATE accounts SET balance=balance-300 WHERE accId=1; 
UPDATE accounts SET balance=balance+300 WHERE accId=6;

UPDATE accounts SET balance=balance-300 WHERE accId=1;

/*
ERROR at line 1: ORA-02290: check constraint (SYS.EMPTY_ACCOUNT) violated.
*/

ROLLBACK;
SET AUTOCOMMIT OFF;

SET serveroutput on;

DECLARE a number; b number; balance1 number; balance2 number; VALUE_ERROR EXCEPTION; ACCESS_INTO_NULL EXCEPTION; 
PROCEDURE transfermoney(account1 IN number,account2 IN number) IS
BEGIN SELECT balance INTO balance1 FROM accounts 
WHERE accId=1; SELECT balance INTO balance2 FROM accounts 
WHERE accId=2;
IF balance1>=0 AND balance2>=0 THEN
IF (account1=1 OR account1=2 OR account1=3) AND (account2=1 OR account2=2 OR account2=3) THEN UPDATE accounts SET balance=balance-300 
WHERE accId=account1; UPDATE accounts SET balance=balance+300 WHERE accId=account2; COMMIT; ELSE RAISE VALUE_ERROR; END IF; ELSE RAISE ACCESS_INTO_NULL;
END IF; EXCEPTION WHEN VALUE_ERROR THEN dbms_output.put_line('The balance can not be less than 0.');
dbms_output.put_line('VALUE_ERROR: ORA-06502, -6502'); 
ROLLBACK; 
WHEN ACCESS_INTO_NULL THEN dbms_output.put_line('The account that you gave does not exist.'); dbms_output.put_line('ACCESS_INTO_NULL: ORA-06530, -6530'); 
ROLLBACK;
END; BEGIN a:=&account1; b:=&account2; transfermoney(a,b); END;
/

CREATE OR REPLACE FUNCTION transfermoneyfunc(account1 IN number, account2 IN number) RETURN BOOLEAN IS VALUE_ERROR EXCEPTION; ACCESS_INTO_NULL EXCEPTION;
BEGIN DECLARE balance1 number; DECLARE balance2 number; SELECT balance INTO balance1 FROM accounts WHERE accId=1 FOR UPDATE NOWAIT; SELECT balance INTO balance2 FROM accounts 
WHERE accId=2 FOR UPDATE NOWAIT;
IF balance1>=0 AND balance2>=0 THEN
IF (account1=1 OR account1=2 OR account1=3) AND (account2=1 OR account2=2 OR account2=3) THEN UPDATE accounts SET balance=balance-300 
WHERE accId=account1; UPDATE accounts SET balance=balance+300 WHERE accId=account2; COMMIT; ELSE RAISE VALUE_ERROR; END IF; ELSE RAISE ACCESS_INTO_NULL;
END IF; IF balance1=1000 AND balance2=2000 THEN
dbms_output.put_line('ORA-20001: Row is locked.');
RETURN false; END IF; EXCEPTION WHEN VALUE_ERROR THEN dbms_output.put_line('The balance can not be less than 0.'); RETURN false; 
ROLLBACK; 
WHEN ACCESS_INTO_NULL THEN dbms_output.put_line('The account that you gave does not exist.'); RETURN false; 
ROLLBACK; RETURN true;
END; BEGIN DECLAER a number; DECLAER b number; a:=&account1; b:=&account2; transfermoneyfunc(a,b); END;
/

SELECT balance INTO balance1 FROM accounts WHERE accId=1 FOR UPDATE NOWAIT;

/*
ERROR at line 1: ORA-20001: Row is locked ORA-06512: at line 21
*/

CREATE TABLE accounts (
accId INTEGER NOT NULL PRIMARY KEY,
balance DECIMAL(11,2) NOT NULL,
CONSTRAINT empty_account CHECK (balance >= 0.00)
); 

INSERT INTO accounts(accId, balance) VALUES (1,1000.00); 
INSERT INTO accounts(accId, balance) VALUES (2,2000.00); 
INSERT INTO accounts(accId, balance) VALUES (3,3000.00);

SET AUTOCOMMIT = 0;

SET TRANSACTION READ WRITE;
UPDATE accounts SET balance=balance-300 WHERE accId=1;
UPDATE accounts SET balance=balance+300 WHERE accId=2;
COMMIT;

UPDATE accounts SET balance=balance-300 WHERE accId=1; 
UPDATE accounts SET balance=balance+300 WHERE accId=6;

UPDATE accounts SET balance=balance-300 WHERE accId=1;

/*
ERROR 3819 (HY000) at line 1: check constraint (SYS.EMPTY_ACCOUNT) is violated.
*/

DELIMITER // CREATE PROCEDURE transfermoney(IN account1 INT, IN account2 INT) BEGIN DECLARE balance1 INT;
DECLARE balance2 INT; SELECT balance INTO balance1 FROM accounts WHERE accId=1; SELECT balance INTO balance2 FROM accounts WHERE accId=2;
IF balance1>=0 AND balance2>=0 THEN IF (account1=1 OR account1=2 OR account1=3) AND (account2=1 OR account2=2 OR account2=3) THEN START TRANSACTION; 
UPDATE accounts SET balance=balance-300 WHERE accId=account1; UPDATE accounts SET balance=balance+300 WHERE accId=account2; COMMIT;
ELSE SELECT 'The account that you gave does not exist.'; END IF; ELSE SELECT 'The balance can not be less than 0.'; END IF; END // DELIMITER ;

DELIMITER // CREATE FUNCTION transfermoney(account1 INT, account2 INT) RETURNS INT BEGIN DECLARE balance1 INT; DECLARE balance2 INT;
SELECT balance INTO balance1 FROM accounts WHERE accId=1 FOR UPDATE; SELECT balance INTO balance2 FROM accounts WHERE accId=2 FOR 
UPDATE; IF balance1>=0 AND balance2>=0 THEN IF (account1=1 OR account1=2 OR account1=3) AND (account2=1 OR account2=2 OR account2=3) THEN START TRANSACTION; 
UPDATE accounts SET balance=balance-300 WHERE accId=account1; UPDATE accounts SET balance=balance+300 WHERE accId=account2; COMMIT; 
ELSE SELECT 'The account that you gave does not exist.'; RETURN 0; END IF; ELSE SELECT 'The balance can not be less than 0.'; RETURN 0; 
END IF; IF balance1=1000 AND balance2=2000 THEN dbms_output.put_line('Row is locked.'); RETURN 0; END IF; RETURN 1; END // DELIMITER ;

SELECT balance INTO balance1 FROM accounts WHERE accId=1 FOR 
UPDATE NOWAIT;

/*
ERROR 3572 (HY000): Do not wait for lock.
*/
