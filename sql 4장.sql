-- JOIN : t1���̺��� a�÷��� t2���̺��� d�÷��� ������ ���ο� ����� ������ ���
/*
Oracle JOIN���� : SELECT a.b, c.d FROM t1 a, t2 c WHERE a.b = c.d;
              �������̺�(drive table, inner table) JOIN �������̺�(driven table, outer table) : �������̺��� �����Ͱ� ���� ���̺�� �ؾ� ����
ANSI JOIN���� : SELECT a.b, c.d FROM t1 a [INNER] JOIN t2 c ON a.b = c.d;
                                          INNER : ���ο� �����ϴ� ��� ���̺� �����ϴ� �����͸� ���(�⺻���̸� �Է����� �ʾƵ� ��)
*/

-- Cartesian Product(īƼ�� ��) : ���� �������� ���� �ʰ� �Ǹ� �ش� ���̺� ���� ��� �����͸� ���� �������� ����
-- join ���� �߿� where���� ����ϴ� join ������ �߸� ����Ǿ��ų� �ƿ� ���� ��� �߻� => join �۾��� �����Ǵ� ���̺� �� ���� ��� ���� ���� ����� ���
-- 1. �׽�Ʈ�� ���̺��� �����ϰ� ������ �Է�
CREATE TABLE cat_a (no NUMBER, name VARCHAR2(1));
INSERT INTO cat_a VALUES (1, 'A');
INSERT INTO cat_a VALUES (2, 'B');
CREATE TABLE cat_b (no NUMBER, name VARCHAR2(1));
INSERT INTO cat_b VALUES (1, 'C');
INSERT INTO cat_b VALUES (2, 'D');
CREATE TABLE cat_c (no NUMBER, name VARCHAR2(1));
INSERT INTO cat_c VALUES (1, 'E');
INSERT INTO cat_c VALUES (2, 'F');

-- 2. ������ ���̺� Ȯ��
COL name FOR a5
SELECT * FROM cat_a;
SELECT * FROM cat_b;
SELECT * FROM cat_c;

-- 3. 2���� ���̺�� ���� ����
SELECT a.name, b.name
FROM cat_a a, cat_b b
WHERE a.no = b.no;

-- 4. 2���� ���̺�� īƼ�� ���� ����
SELECT a.name, b.name
FROM cat_a a, cat_b b;

-- 5. 3���� ���̺�� �������� ���� ����
SELECT a.name, b.name, c.name
FROM cat_a a, cat_b b, cat_c c
WHERE a.no = b.no AND a.no = c.no;

-- 6. 3�� ���̺��� ��ȸ�ϵ� ���� �������� 2�� ���̺��� ���Ǹ����� īƼ�� ���� ����
SELECT a.name, b.name, c.name
FROM cat_a a, cat_b b, cat_c c
WHERE a.no = b.no;

-- īƼ�� ���� ����ϴ� ���� 2����
-- 1. �����͸� �����ؼ� ���� ���̺��� �ݺ��ؼ� �д� ���� ���ϱ� ����
    -- 1.1. �μ� ��ȣ�� 10���� ��� ������ ��ȸ
    SELECT empno, ename, job, sal FROM emp WHERE deptno=10;
    -- 1.2. ������ 3�� ����
    SELECT LEVEL c1 FROM DUAL connect by level <=3;
    -- 1.3. īƼ�� ���� ����Ͽ� �μ� ��ȣ 10���� ���� 3��Ʈ ����
    SELECT * FROM 
        (SELECT empno, ename, job, sal FROM emp WHERE deptno=10),
        (SELECT LEVEL c1 FROM DUAL connect by level <= 3)
    -- c1�� 1�� �� �μ� ��ȣ 10�� ���� �� ��Ʈ, 2�� ��, 3�� �� �� 3�� ��Ʈ ������ ������
        -- * ���� : break on�� sqlplus ���� �ɼ����� �ߺ��� ���� �� ���� �����ִ� ���
        break ON empno;
            SELECT empno,
            -- C1�� ���� ���� ������ �Ҵ�
                CASE WHEN C1 = 1 THEN 'ENAME'
                     WHEN C1 = 2 THEN 'JOB'
                     WHEN C1 = 3 THEN 'HIREDATE'
                END TITLE, 
            -- C1�� ���� ���� �÷��� ����
                CASE WHEN C1 = 1 THEN ename
                     WHEN C1 = 2 THEN job
                     WHEN C1 = 3 THEN hiredate
                END CONTENTS
                FROM
            (SELECT empno, ename, job, sal, to_char(hiredate, 'YYYY/MM/DD') hiredate
                FROM scott.emp WHERE deptno = 10), 
            (SELECT LEVEL c1 FROM DUAL connect by level <= 3) ORDER BY 1,2;
-- 2. �Ǽ��� ���� ���� �÷� �� �Ϻθ� ���߸��� ���


/*
EQUI Join(� ����) : ���� ���� ���Ǵ� ���� ���.
���� ���̺��� �����͸� ������ �� ���� �������� �˻��Ͽ� ������ ������ ���� �����͸� ���� ���̺��� ����
���������� = �� ����ؼ� EQUI Join�̶�� ��
*/
-- emp ���̺�� dept ���̺��� ��ȸ�Ͽ� empno, ename, dname�� ����϶�
-- Oracle Join ����
SELECT e.empno, e.ename, d.dname FROM emp e, dept d WHERE e.deptno = d.deptno;
-- ANSI Join ����
SELECT e.empno, e.ename, d.dname FROM emp e JOIN dept d ON e.deptno = d.deptno;
-- �÷� �̸��� �� ���� ���̺��� ���� ���(dname) ���̺� �̸� �����ص� �ڵ����� ���̺� �̸��� ã�Ƽ� ����
select * from emp;
select * from dept;
SELECT empno, ename, dname FROM emp e, dept d WHERE e.deptno = d.deptno;
-- ���� ���̺� ��� �ִ� �÷��� ���(deptno) �ݵ�� ���̺� �̸��� ���� ������ ���� �߻�
SELECT empno, ename, deptno, dname FROM emp e, dept d WHERE e.deptno = d.deptno;
-- ���̺���� ������� ����� �����
SELECT e.empno, e.ename, d.deptno, d.dname FROM emp e, dept d WHERE e.deptno = d.deptno;

-- student�� professor ���̺��� �����Ͽ� �л��� �̸��� ���������� �̸��� ����϶�
select * from student;
select * from professor;
SELECT s.name "stu_name", p.name "prof_name" FROM student s JOIN professor p ON s.profno = p.profno;

-- student�� department, professor ���̺��� �����Ͽ� �л��� �̸��� �а� �̸�, �������� �̸��� ����϶�
select * from department;
SELECT s.name stu_name, d.dname dept_name , p.name prof_name 
--                  ù��° �������� ������ �� ���� ����� ������ �ι�° ������ ����
    FROM student s JOIN department d ON s.deptno1 = d.deptno JOIN professor p ON s.profno = p.profno; 

-- student ���̺��� ��ȸ�Ͽ� deptno1�� 101�� �л����� �̸��� �� �л����� �������� �̸��� ����϶�
select * from student;
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s JOIN professor p ON s.profno = p.profno AND s.deptno1 = 101;


-- Non-Equi Join(�� ����)


commit;