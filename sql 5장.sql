/*
DDL(DATA DEFINITION LANGUAGE) : CREATE(����), CALTER(����), TRUNCATE(�߶󳻱�), DROP(����)
DML(DATA MANUPLATION LANGUAGE) : INSERT(�Է�), UPDATE(����), DELETE(����), MERGE(����)
DCL(DATA CONTROL LANGUAGE) : GRANT(���� �ֱ�), REVOKE(���� ����)
TCL(TRANSACTION CONTROL LANGUAGE) : COMMIT(Ȯ��), ROLLBACK(���)
SELECT : � �з������� DQL(DATA QUERY LANGUAGE)�̶�� ��
*/
/*
������Ʈ : ����Ŭ ��� ���ο� �����͸� �����ϱ� ���� �پ��� ���� ��ü
���׸�Ʈ : ������Ʈ �߿� Ư���� �����͸� �����ϱ� ���� ������ ���� ������ ������ ��
*/

-- CREATE : ���ο� ������Ʈ�� ��Ű���� ������ �� ���
/*
���ǻ���
���̺� �̸��� �ݵ�� ���ڷ� ����. ���ڷ� �Ұ� Ư�� ���������� ū����ǥ �ʿ�
���̺��̳� �÷� �̸��� �ִ� 30����Ʈ. �ѱ۷δ� 15�ڱ���
���̺���� �� ����� �ȿ��� �ߺ� �Ұ�
���̺� �� ������Ʈ �̸��� ����Ŭ�� ����ϴ� Ű���� ��� ����
*/
-- �Ϲ����� ���̺� ����
CREATE TABLE new_table (no NUMBER(3), name VARCHAR2(10), birth DATE);
-- no �÷��� ���ڸ� �����ϸ� �ִ� 3�ڸ�
-- name �÷��� ������ ���ڸ� �����ϸ� �ִ� 10����Ʈ
-- birth �÷��� ��¥�� ����

-- �⺻ �Է°��� �����ϸ鼭 ����
CREATE TABLE tt02 (no NUMBER(3, 1) DEFAULT 0, name VARCHAR2(10) DEFAULT 'NO NAME', birth DATE DEFAULT SYSDATE);
INSERT INTO tt02 (no) VALUES(1);
select * from tt02;

-- Global Temporary Table(�ӽ� ���̺�) �����ϱ� : ��� ������ ������ �ƴ� �ӽ� �۾��� �����͸� �����ϱ� ���� �������, �׽�Ʈ��
/*
1. ��ó�� ���̺��� �����ϸ� �� ���Ǹ� ��ųʸ��� ����Ǿ� �ִٰ� ����ڰ� �ش� ���̺� �����ϸ� �޸𸮻� �ش� ���̺��� ����� �����͸� ȣ��
2. Ʈ������� �����ų� ������ ������ ������ �����
3. �ٸ� ���ǿ��� ���̺� ������ �� ����
4. Redo ���̺��� ������������
5. Index, View, Trigger�� ������ �� ������ �� ������Ʈ�� Ÿ�Ե� Temporary
6. �����̳� ��� �Ұ�
CREATE GLOBAL TEMPORARY TABLE ���̺��̸�
(�÷�1 ������ Ÿ��,
 �÷�2 ������ Ÿ��, ...)
 ON COMMIT [delete|preserve] ROWS;
*/
-- ON COMMIT delete(�⺻��)/preserve ROWS�� ����ϸ� commit��/���� ����ÿ� �����͸� ����

-- ����� �Է��ϴ� �͹̳��� 2�� ���� ���ʿ��� ���� �� �ٸ� �ʿ��� ��ȸ Ȯ���ϱ�
CREATE GLOBAL TEMPORARY TABLE temp01 
(no NUMBER, name VARCHAR2(10)) 
ON COMMIT delete ROWS;

INSERT INTO temp01 VALUES(1, 'AAAA');

SELECT * FROM temp01;

commit;

-- ������ ����ǹǷ� �����ʹ� �����ǰ� ��ȸ�ص� �����ʹ� ����
SELECT * FROM temp01;

-- �����Ǿ��ִ� Temporary Table ��ȸ
SELECT temporary, duration FROM user_tables WHERE table_name = 'TEMP01';
-- temporary�� y�̰� duration�� transactiond�̹Ƿ� 'commit�̳� rollback�� �����ϴ� ���� �����ȴ�'��� ��

-- CAST : ���̺� �����ϱ�, ���ο� ���̺��� ������ �� ������ �ִ� ���̺��� �����Ͽ� ����
-- ���/Ư�� �÷� �����ϱ�
CREATE TABLE dept3 AS SELECT * FROM dept2;
select * from dept3;
CREATE TABLE dept4 AS SELECT dcode, dname FROM dept2;
select * from dept4;

-- ���̺��� ����(�÷�)�� �����ϱ�
CREATE TABLE dept5 AS SELECT * FROM dept2 WHERE 1= 2;
-- WHERE�� Ʋ�� ������ ���� �ش��ϴ� �����Ͱ� ������ �����Ͽ� �����͸� �������� ���ϰ� ������ �����ϰ� ��
select * from dept5;

-- ALTER : ��������ִ� ������Ʈ�� ����(����), �÷� �߰�/����, �÷�/���̺� �̸� ���� ��
-- ���ο� �÷� �߰��ϱ�
CREATE TABLE dept6 AS SELECT dcode, dname FROM dept2 WHERE dcode IN(1000, 1001, 1002);
select * from dept6;
ALTER TABLE dept6 ADD(location VARCHAR2(10));
ALTER TABLE dept6 ADD(location2 VARCHAR2(10) DEFAULT 'SEOUL');
select * from dept6;

-- �÷� �̸� ����
ALTER TABLE dept6 RENAME COLUMN location2 TO loc;
select * from dept6;
-- ���̺� �̸� ����
RENAME dept6 TO dept7;
select * from dept7;

-- �÷��� ������ ũ�� �����ϱ�
DESC dept7;
ALTER TABLE dept7 MODIFY(loc VARCHAR2(20));
DESC dept7;

-- �÷� �����ϱ�
ALTER TABLE dept7 DROP COLUMN loc;
-- ����Ű�� �����Ǿ��ִ� �θ� ���̺��� �÷��� ������ ���
ALTER TABLE dept7 DROP COLUMN loc CASCADE CONSTRAINTS;

-- TRUNCATE : ���̺��� �����͸� ���� �����ϰ� ����ϰ� �ִ� ������ �ݳ�, �ε����� ���뵵 �Բ�
TRUNCATE TABLE dept7;
select * from dept7;

-- DROP : ������Ʈ ��ü�� ����
DROP TABLE dept7;

-- �б� ���� ���̺�� �����ϱ�
CREATE TABLE t_readonly (no NUMBER, name VARCHAR2(10));
INSERT INTO t_readonly VALUES(1, 'AAA');
commit;
SELECT * FROM t_readonly;
ALTER TABLE t_readonly read only;
-- ������ �߰� �õ�
INSERT INTO t_readonly VALUES(2, 'BBB');
-- �÷� �߰� �õ�
ALTER TABLE t_readonly ADD (tel NUMBER DEFAULT 111);
-- �б� ���� ��带 ����
ALTER TABLE t_readonly read write;
DROP TABLE t_readonly;

-- ���� �÷� ���̺� ����ϱ�
-- ���� �÷��� ������ vt1 ���̺� ����
--                                          col3�� col1+col2�� ����� �ڵ�������
CREATE TABLE vt1 (col1 NUMBER, col2 NUMBER, col3 NUMBER GENERATED ALWAYS AS (col1+col2));
INSERT INTO vt1 VALUES(1, 2, 3); -- col3�� 1,2��° �÷��� ������ �ڵ������Ǵ� �÷��̶� ������ �ԷºҰ�
INSERT INTO vt1 (col1, col2) VALUES(1, 2);
select * from vt1;
UPDATE vt1 SET col1=5;
select * from vt1;
-- ���ο� ���� �÷� �߰�
ALTER TABLE vt1 ADD (col4 NUMBER GENERATED ALWAYS AS ((col1*12)+col2));
select * from vt1;
-- ���� �÷� ���� ��ȸ
SET LINE 200
COL column_name FOR a10
COL data_type FOR a10
COL data_default FOR a25
SELECT column_name, data_type, data_default FROM user_tab_columns 
WHERE table_name = 'VT1' ORDER BY column_id;

-- �������� Ȱ���� ���� �÷� �����ϱ�
CREATE TABLE sales10 (no NUMBER, pcode CHAR(4), pdate CHAR(8), pqty NUMBER, pbungi NUMBER(1) GENERATED ALWAYS AS 
(CASE WHEN SUBSTR(pdate, 5, 2) IN ('01', '02', '03') THEN 1
     WHEN SUBSTR(pdate, 5, 2) IN ('04', '05', '06') THEN 2
     WHEN SUBSTR(pdate, 5, 2) IN ('07', '08', '09') THEN 3
     ELSE 4 END) 
     virtual);
INSERT INTO sales10(no, pcode, pdate, pqty) VALUES (1, '100', '20110112', 10);
INSERT INTO sales10(no, pcode, pdate, pqty) VALUES (2, '200', '20110505', 20);
INSERT INTO sales10(no, pcode, pdate, pqty) VALUES (3, '300', '20110812', 30);
INSERT INTO sales10(no, pcode, pdate, pqty) VALUES (4, '400', '20111024', 40);
commit;
select * from sales10;













commit;