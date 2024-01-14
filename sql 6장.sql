-- INSERT : ���̺� ���ο� ������ �Է��� �� ���, ���� �ܴ̿� ��������ǥ ���

-- dept2 ���̺� �ٷ��� ���� �������� ���ο� �μ�  ������ �Է��ϼ���
-- �μ���ȣ : 9000, �μ��� : temp_1, �����μ� : 1006, ���� : temp area
select * from dept2;
INSERT INTO dept2 (dcode, dname, pdept, area) VALUES(9000, 'temp_1', 1006, 'temp area');
-- ��� �÷��� �����͸� ������ ��� �÷��� ���� ����
INSERT INTO dept2 VALUES(9001, 'temp_2', 1006, 'temp area');

-- �μ���ȣ, �μ���, �����μ� ���� �Ʒ��� ������ �Է��ϼ���
-- 9002, temp_3, Business Department(1006�� �μ�)
INSERT INTO dept2(dcode, dname, pdept) VALUES(9002, 'temp_3', 1006);

-- NULL�� �Է��ϱ�
-- �ڵ� : ������ �Է� �� ���� �Է����� ������ NULL�� ��, ���� : ������ �Է� �� NULL�� �ۼ�

-- ���� �� �Է��ϱ� : t_minus ���̺��� ���� �� ���� ���� �Է��ϴ� �׽�Ʈ ����
CREATE TABLE t_minus (no1 NUMBER, no2 NUMBER(3), no3 NUMBER(3,2));
INSERT INTO t_minus VALUES(1, 1, 1);
INSERT INTO t_minus VALUES(1.1, 1.1, 1.1);
INSERT INTO t_minus VALUES(-1.1, -1.1, -1.1);
select * from t_minus;

-- INSERT�� ���������� ����Ͽ� ���� �� �Է��ϱ�(ITAS)
-- ���� ���� ������ �־� �Ϻη� �����͸� �Է½�Ű�� ����
CREATE TABLE professor3 AS SELECT * FROM professor WHERE 1=2;
INSERT INTO professor3 SELECT * FROM professor;
select * from professor3;
-- ������ �Է��� �� �� ���̺� �÷��� ������ ������ ���� �����ؾ� �ϸ� ������ �� ���� ����
CREATE TABLE professor4 AS SELECT profno, name, pay FROM professor WHERE 1=2;
INSERT INTO professor4 SELECT profno, name, pay FROM professor WHERE profno > 4000;
select * from professor4;

-- INSERT ALL�� �̿��� ���� ���̺� ���� �� �Է��ϱ�
CREATE TABLE prof_3 (profno NUMBER, name VARCHAR2(25));
CREATE TABLE prof_4 (profno NUMBER, name VARCHAR2(25));

/*
professor ���̺��� ������ȣ�� 1000~1999�������� ������ȣ, �����̸��� prof_3 ���̺� �Է��ϰ�
������ȣ�� 2000~2999�������� ������ȣ�� �̸��� prof_4 ���̺� �Է��϶�
*/
INSERT ALL
    WHEN profno BETWEEN 1000 AND 1999 THEN
        INTO prof_3 VALUES(profno, name)
    WHEN profno BETWEEN 2000 AND 2999 THEN
        INTO prof_4 VALUES(profno, name)
    SELECT profno, name
FROM professor;
select * from prof_3;
select * from prof_4;

/*
prof_3, prof_4 ���̺��� �����͸� truncate�� ���� �� 
professor ���̺��� profno�� 3000~3999�� ������ ������ȣ, �̸��� prof_3, 4���̺� ���ÿ� �Է��϶�
*/
TRUNCATE TABLE prof_3;
TRUNCATE TABLE prof_4;
INSERT ALL
    INTO prof_3 VALUES(profno, name)
    INTO prof_4 VALUES(profno, name)
SELECT profno, name FROM professor
WHERE profno BETWEEN 3000 AND 3999;
select * from prof_3;
select * from prof_4;

-- UPDATE : ���� �����͸� �ٸ� �����ͷ� ������ �� ���
-- professor ���̺��� position�� assistant professor�� �������� bonus�� 200���� �����϶�
select * from professor;
UPDATE professor SET bonus = 200 WHERE position = 'assistant professor';
select * from professor WHERE position = 'assistant professor';

-- professor ���̺��� Sharon Stone ������ position�� ������ position�� ���� ������ �� ���� pay�� 250�̸��� �������� �޿��� 15%�λ��϶�
UPDATE professor SET pay = pay*1.15 
    WHERE position = (SELECT position FROM professor WHERE name = 'Sharon Stone') 
    AND pay < 250;
select * from professor;

-- DELETE : ������ ����
-- dept2 ���̺��� dcode�� 9000~9999�� ������ �����϶�
DELETE FROM dept2 WHERE dcode BETWEEN 9000 AND 9999;
-- ��� �����Ǵ� ���� �ƴ϶� ����¡���� ��. BBED���� �̿��ϸ� ���� ����. ���̺� ũ�⸦ Ȯ���ϸ� �� �� �ִ�!

-- MERGE : ���� ���̺��� �����͸� ��ġ�� ������ �ǹ�
-- table1�� table2�� ������ ���� table1�� ������
/*
MERGE INTO table1 USING table2 ON(���� ����) 
    WHEN MATCHED THEN UPDATE SET ������Ʈ ���� DELETE WHERE ����
    WHEN NOT MATECHED THEN INSERT VALUES(�÷� �̸�);
���� ON�� ������ ����(MATCHED)�ϸ� ���� table1�� ������ table2 �������� UPDATE/DELETE����ǰ�
            �Ҹ���(NOT MATCHED)�ϸ� table2�� ������ table1�� INSERT��.
*/
-- MERGE�� ����� �� �������̺�(talbe1)�� �����Ϳ� �ű����̺�(table2)�� ������ ���ؼ� Ȯ����.
-- �̷� Ư�� ������ ���� ���̺� �����Ͱ� ���������� MERGE�� �ӵ��� ������

-- �Ϻ� ��� ��� ���̺��� charge1, 2���̺��� �ְ� ����� ���̺� ch_total ���̺��� �����ϰ� �����͸� �Է��϶�
CREATE TABLE charge_1 (u_date VARCHAR2(6), cust_no NUMBER, u_time NUMBER, charge NUMBER);
CREATE TABLE charge_2 (u_date VARCHAR2(6), cust_no NUMBER, u_time NUMBER, charge NUMBER);

INSERT INTO charge_1 VALUES('141001', 1000, 2, 1000);
INSERT INTO charge_1 VALUES('141001', 1001, 2, 1000);
INSERT INTO charge_1 VALUES('141001', 1002, 1, 500);
select * from charge_1;

INSERT INTO charge_2 VALUES('141002', 1000, 3, 1500);
INSERT INTO charge_2 VALUES('141002', 1001, 4, 2000);
INSERT INTO charge_2 VALUES('141002', 1003, 1, 500);
select * from charge_2;

CREATE TABLE ch_total (u_date VARCHAR2(6), cust_no NUMBER, u_time NUMBER, charge NUMBER);

-- MERGE �۾� ����1(charge_1 + ch_total ����)
MERGE INTO ch_total total USING charge_1 ch1 ON(total.u_date = ch1.u_date)
    WHEN MATCHED THEN UPDATE SET total.cust_no = ch1.cust_no
    WHEN NOT MATCHED THEN INSERT VALUES(ch1.u_date, ch1.cust_no, ch1.u_time, ch1.charge);
select * from ch_total;
-- MERGE �۾� ����2(charge_2 + ch_total ����)
MERGE INTO ch_total total USING charge_2 ch2 ON(total.u_date = ch2.u_date)
    WHEN MATCHED THEN UPDATE SET total.cust_no = ch2.cust_no
    WHEN NOT MATCHED THEN INSERT VALUES(ch2.u_date, ch2.cust_no, ch2.u_time, ch2.charge);
select * from ch_total;
/*
ch1�� total, ch2�� total���� u_date�� �ߺ��Ǵ� ���� ���� ������ ������ ��������� 
ù��° ������ �ٽ� �����ϸ� ���� �ߺ��Ǽ� ���� �߻�
(���� ���� 3���� �ֱ� ������ � ���� ���ؼ� �������� �𸣰� ��)
�̷� ������ ������ �� �Ϲ������� ���谡 �Ǵ� ���̺�(ch_total)�� ���� �÷����� pk�� unique index�� ����
*/

-- UPDATE ���� : �ٸ� ���̺�� �����ϴ� ���. WHERE������ �ٸ� ���̺�� �����ϴ� ���, WHERE���� SET�� ��� �ٸ� ���̺�� �����ϴ� ���
-- �Ϲ����� UPDATE
UPDATE emp SET sal=sal*1.1 WHERE job='CLERK';
SELECT ename, sal FROM emp WHERE job='CLERK';

-- �Ϲ����� UPDATE ���� : WHERE������ �ٸ� ���̺�� ����
select * from dept;
UPDATE emp e SET sal=sal*1.1
WHERE EXISTS (
SELECT 1 FROM dept d WHERE d.loc='DALLAS' AND e.deptno = d.deptno);
select * from emp;

-- �׽�Ʈ�� ���� dept_hist ���̺� ����
CREATE TABLE dept_hist ( 
    empno NUMBER(4), -- �����ȣ PK1
    appointseqno NUMBER(4), -- �߷ɼ��� PK2
    deptno NUMBER(2), -- �μ���ȣ
    appointdd DATE);
    
ALTER TABLE DEPT_HIST
ADD CONSTRAINT PK_DEPT_HIST PRIMARY KEY (empno, appointseqno);

-- �׽�Ʈ �����ͷ� deptno�� 20�� ����� �߷� �μ� ��ȣ�� 99�� �����͸� INSERT
INSERT INTO DEPT_HIST
SELECT empno, 1 appointseqno, 99 deptno, SYSDATE APOINTDD FROM emp WHERE deptno=20;
select * from DEPT_HIST;
commit;

-- emp ���̺� �������� �ʴ� �����ȣ 2���� INSERT
INSERT INTO DEPT_HIST VALUES(9322, 1, 99, SYSDATE);
INSERT INTO DEPT_HIST VALUES(9414, 1, 99, SYSDATE);
select * from DEPT_HIST;
commit;

-- 99�� �������� �ʴ� �μ���ȣ�̱� ������ emp���̺� ���� �Ҽ� �μ� ��ȣ�� update
SELECT e.empno, e.deptno tobe_deptno, d.deptno asis_deptno
    FROM emp e, dept_hist d
    WHERE e.empno = d.empno;

/*
�μ���ȣ 99�� 20���� UPDATE : UPDATE�ϱ� ���� SELECT�� 
UPDATE�� ��� �÷� ��(tobe_deptno)�� UPDATE�Ϸ��� �÷���(asis_deptno)�� ��ȸ
(�Ǽ����� �ʵ���)
*/

-- ��� ���̺� �����ϴ� ��� �� ���� �Ҽӵ� �μ� ��ȣ UPDATE
UPDATE DEPT_HIST d SET d.deptno = (
    SELECT e.deptno FROM emp e WHERE e.empno = d.empno);
select * from DEPT_HIST;
-- �������� �ʴ� ��� ��, UPDATE ������ ���� ����� deptno�� null�� UPDATE�� 
-- �̷� ���� ������ set���� ���� ���̺��� �ִ� ��� �����ؾ���
commit;

-- ���ϴ� emp ���̺� �����ϴ� ��� ��ȣ�� ���ؼ��� UPDATE ��� ������ ���ϰ� UPDATE
UPDATE DEPT_HIST d SET d.deptno = (
    SELECT e.deptno FROM emp e WHERE e.empno = d.empno)
WHERE EXISTS(
    SELECT 1 FROM emp e WHERE e.empno = d.empno);
select * from DEPT_HIST;



























































