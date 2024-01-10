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



-- EQUI Join(� ����) : ���� ���� ���Ǵ� ���� ���.
/*���� ���̺��� �����͸� ������ �� ���� �������� �˻��Ͽ� ������ ������ ���� �����͸� ���� ���̺��� ����
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


-- Non-Equi Join(�� ����) : ���� ������ �ƴ� ũ�ų� �۰ų� �ϴ� ����� �������� ��ȸ�� �� ���
/*
customer ���̺�� gift ���̺��� �����Ͽ� ������ ���ϸ��� ����Ʈ�� ��ȸ�� ��, 
�ش� ���ϸ��� ������ ���� �� �ִ� ��ǰ�� ��ȸ�Ͽ� ���� �̸��� ���� �� �ִ� ��ǰ���� ����϶�
*/
select * from customer;
select * from gift;
SELECT c.gname CUST_NAME, TO_CHAR(c.point, '999,999') POINT, g.gname GIFT_NAME 
FROM customer c JOIN gift g ON c.point >= g.g_start AND c.point <= g.g_end;

-- student, score, hakjum���̺��� ��ȸ�Ͽ� �л����� �̸��� ����, ������ ����϶�
select * from student;
select * from score;
select * from hakjum;
SELECT st.name STU_NAME, sc.total SCORE, h.grade GRADE
FROM student st JOIN score sc ON st.studno = sc.studno JOIN hakjum h ON sc.total >= h.min_point AND sc.total <= h.max_point;

-- �� ���� ������ ��� �̳� ����
-- OUTER Join(�ƿ��� ����) : ���� ���̺��� �����Ͱ� �ְ� ���� ���̺��� ���� ��� �ִ� �� ���̺��� ������ ���� ���
-- a��� ���̺� �ε����� �־ �ε����� ���� �ʰ� ���� ��ĵ. ���� ������ �����Ǿ� ������� ���� ������ �� ����.

-- student, professor ���̺��� �����Ͽ� �л��̸��� �������� �̸��� ����϶�. ��, ���������� �������� ���� �л��� ��ܵ� �Բ� ���
-- Oracle Outer Join : �����Ͱ� ���� �ʿ� (+) ǥ��
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno = p.profno(+);
-- ANSI Outer Join : �����Ͱ� �ִ� �ʿ� LEFT/RIGHT OUTER JOIN ǥ��
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s LEFT OUTER JOIN professor P ON s.profno = p.profno;

-- student, professor ���̺��� �����Ͽ� �л��̸��� �������� �̸��� ����϶�. ��, �����л��� �������� ���� ������ ��ܵ� �Բ� ���
-- Oracle Outer Join
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno(+) = p.profno;
-- ANSI Outer Join
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s RIGHT OUTER JOIN professor P ON s.profno = p.profno;

-- student, professor ���̺��� �����Ͽ� �л��̸��� �������� �̸��� ����϶�. ��, �������� �� �����л��� �������� ���� ��ܵ� ���� ���
-- Oracle Outer Join : WHERE������ �ƿ��� ���εǴ� �÷� ���� (+)�� �ٿ���� ��
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno(+) = p.profno
UNION SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno = p.profno(+);
-- ANSI Full Outer Join
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s FULL OUTER JOIN professor P ON s.profno = p.profno;

-- dept ���̺� ������ ��� ����ϰ� �μ� ��ȣ�� 20�� ����� �����ȣ, �̸�, �޿��� ����϶�
select * from dept;
select * from emp;
SELECT d.deptno, d.dname, d.loc, e.empno, e.ename, e.sal 
FROM dept d, emp e WHERE d.deptno = e.deptno(+) 
and e.deptno = 20 ORDER BY 1;
-- dept ���̺� ������ ���� ����϶�� �ߴµ� �μ���ȣ�� 20�� ������ ���.

SELECT d.deptno, d.dname, d.loc, e.empno, e.ename, e.sal 
FROM dept d, emp e WHERE d.deptno = e.deptno(+) 
and e.deptno(+) = 20 ORDER BY 1;
-- �μ���ȣ�� 10, 20, 40�� dept ���̺� ���� ���� ��µ�

-- ������ CLERK�� ��� ��ȣ, �̸�, ������ ����ϰ� ���� CHICAGO�� ��ġ�� �μ��� �Ҽӵ� ����� �μ� ��ȣ, �μ���, ��ġ�� ����϶�
select * from emp where job='CLERK';
SELECT e.empno, e.ename, e.job, d.deptno, d.dname, d.loc 
FROM emp e LEFT OUTER JOIN dept d ON (e.deptno = d.deptno and d.loc = 'CHICAGO') WHERE e.job = 'CLERK';

SELECT e.empno, e.ename, e.job, d.deptno, d.dname, d.loc 
FROM emp e LEFT OUTER JOIN dept d ON (e.deptno = d.deptno and d.loc = 'CHICAGO' and e.job = 'CLERK');
-- WHERE�� ������ ��� emp ���̺� ��ü ��� ��


-- SELF Join : ���ϴ� �����Ͱ� �ϳ��� ���̺� �� ����ִ� ���
-- ���� : �����͸� ������ �ִ� ���ϳ��� ���̺��� �޸𸮿��� ������ �� ���� ����Ͽ� ȣ��
-- Oracle Outer Join
SELECT e1.ename "ename", e2.ename "mgr_name" FROM emp e1, emp e2 WHERE e1.mgr = e2.empno;
-- ANSI Outer Join
SELECT e1.ename "ename", e2.ename "mgr_name" FROM emp e1 JOIN emp e2 ON e1.mgr = e2.empno;


-- ��������
-- student, department ���̺��� ��ȸ�Ͽ� �л��̸�, 1���� �а���ȣ, �а��̸��� ����϶�
select * from student;
select * from department;
-- Oracle Join
SELECT s.name STU_NAME, s.deptno1 DEPTNO1, d.dname FROM student s, department d WHERE s.deptno1 = d.deptno;
-- ANSI Join
SELECT s.name STU_NAME, s.deptno1 DEPTNO1, d.dname FROM student s JOIN department d ON s.deptno1 = d.deptno;

-- emp2, p_grade ���̺��� ��ȸ�Ͽ� ���� ������ �ִ� ����� �̸��� ����, ���� ����, �ش� ������ ������ ���� �ݾװ� ���� �ݾ��� ����϶�
select * from emp2;
select * from p_grade;
-- Oracle Join
SELECT e.name, e.position, 
TO_CHAR(e.pay, '999,999,999') PAY, TO_CHAR(p.s_pay, '999,999,999') LOW_PAY, TO_CHAR(p.e_pay, '999,999,999') HIGH_PAY
FROM emp2 e, p_grade p WHERE e.position = p.position;
-- ANSI Join
SELECT e.name, e.position, 
TO_CHAR(e.pay, '999,999,999') PAY, TO_CHAR(p.s_pay, '999,999,999') LOW_PAY, TO_CHAR(p.e_pay, '999,999,999') HIGH_PAY
FROM emp2 e JOIN p_grade p ON e.position = p.position;

-- emp2, p_grade ���̺��� ��ȸ�Ͽ� ������� �̸�, ����, ���� ����, ���� ������ ����϶�
-- ���� ������ ���̷� ����ϰ� �ش� ���̰� �޾ƾ��ϴ� ������ �ǹ���. ���̴� ������ �������� �ϵ� trunc�� �Ҽ��� ���ϴ� �����Ͽ� ���
-- Oracle Join
SELECT e.name NAME, trunc(months_between(sysdate, e.birthday)/12) AGE, e.position CURR_POSITION, p.position BE_POSITION 
FROM emp2 e, p_grade p 
WHERE trunc(months_between(sysdate, e.birthday) / 12) between p.s_age and p.e_age;
-- ANSI Join
SELECT e.name NAME, trunc(months_between(sysdate, e.birthday)/12) AGE, e.position CURR_POSITION, p.position BE_POSITION 
FROM emp2 e JOIN p_grade p 
ON trunc(months_between(sysdate, e.birthday) / 12) between p.s_age and p.e_age;

/*
customer, gift ���̺��� �����Ͽ� ���� �ڱ� ����Ʈ���� ���� ����Ʈ�� ��ǰ �� �Ѱ����� ������ �� �ִٰ� �� ��, 
Notebook�� ������ �� �ִ� ����� ����Ʈ, ��ǰ���� ����϶�
*/
select * from customer;
select * from gift;
-- Oracle Join
SELECT c.gname CUST_NAME, c.point POINT, g.gname GIFT_NAME 
FROM customer c, gift g WHERE c.point >= g.g_start and g.gname = 'Notebook';
-- ANSI Join
SELECT c.gname CUST_NAME, c.point POINT, g.gname GIFT_NAME 
FROM customer c JOIN gift g ON c.point >= g.g_start and g.gname = 'Notebook';

/*
professor ���̺��� ������ȣ, �̸�, �Ի���, �ڽź��� �Ի��� ���� ��� �ο����� ����϶�
��, �ڽź��� �Ի����� ���� ��� ���� �������� ������ ���
*/
select * from professor;
-- Oracle Join
SELECT p.profno, p.name, TO_CHAR(p.hiredate, 'YYYY/MM/DD') HIREDATE, COUNT(p2.hiredate) COUNT
FROM professor p, professor p2 WHERE p.hiredate > p2.hiredate(+)
GROUP BY p.profno, p.name, p.hiredate ORDER BY 4;
-- ANSI Join
SELECT p.profno, p.name, TO_CHAR(p.hiredate, 'YYYY/MM/DD') HIREDATE, COUNT(p2.hiredate) COUNT
FROM professor p LEFT OUTER JOIN professor p2 ON p.hiredate > p2.hiredate
GROUP BY p.profno, p.name, p.hiredate ORDER BY 4;

/*
emp ���̺��� �����ȣ, �̸�, �Ի���, �ڽź��� ���� �Ի��� ��� �ο����� ����϶�
��, �ڽź��� �Ի����� ���� ��� ���� ������������ ����϶�
*/
-- Oracle Join
SELECT e.empno EMPNO, e.ename ENAME, TO_CHAR(e.hiredate, 'YY/MM/DD') HIREDATE, COUNT(e2.hiredate) COUNT 
FROM emp e, emp e2 WHERE e.hiredate > e2.hiredate (+) 
GROUP BY e.empno, e.ename, e.hiredate ORDER BY 4;
-- ANSI Join
SELECT e.empno EMPNO, e.ename ENAME, TO_CHAR(e.hiredate, 'YY/MM/DD') HIREDATE, COUNT(e2.hiredate) COUNT 
FROM emp e LEFT OUTER JOIN emp e2 ON e.hiredate > e2.hiredate
GROUP BY e.empno, e.ename, e.hiredate ORDER BY 4;

commit;