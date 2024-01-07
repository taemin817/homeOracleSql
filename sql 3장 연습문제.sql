/*
emp ���̺��� ��ȸ�Ͽ� ��� �� sal�� comm�� ��ģ �ݾ��� ���� ���� ���� ���� ���� ���, ��� �ݾ��� ���϶�.
��, comm�� ���� ��� 0���� ����ϰ� ��� �ݾ��� ��� �Ҽ��� ù° �ڸ�������
*/
SELECT 
    MAX(sal+NVL(comm, 0)) MAX, 
    MIN(sal+NVL(comm, 0)) MIN, 
    ROUND(AVG(sal+NVL(comm, 0)), 1) AVG 
FROM emp;

/*
student ���̺��� birthday�� �����Ͽ� ������ ������ ���� ����϶�.
*/
SELECT COUNT(birthday)||'EA' TOTAL, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '01', '1'))||'EA' JAN, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '02', '1'))||'EA' FEB, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '03', '1'))||'EA' MAR, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '04', '1'))||'EA' APR, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '05', '1'))||'EA' MAY, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '06', '1'))||'EA' JUN, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '07', '1'))||'EA' JUL, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '08', '1'))||'EA' AUG, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '09', '1'))||'EA' SEP, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '10', '1'))||'EA' OCT, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '11', '1'))||'EA' NOV, 
    COUNT(DECODE(SUBSTR(birthday, 4, 2), '12', '1'))||'EA' DEC 
FROM student;

/*
student ���̺��� tel�� �����Ͽ� ������ �ο����� ����϶�.
��, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM����
*/
SELECT COUNT(tel) TOTAL, 
    COUNT(DECODE(SUBSTR(tel, 1, INSTR(TEL, ')')-1), '02', '1')) SEOUL, 
    COUNT(DECODE(SUBSTR(tel, 1, INSTR(TEL, ')')-1), '031', '1')) GYEONGGI, 
    COUNT(DECODE(SUBSTR(tel, 1, INSTR(TEL, ')')-1), '051', '1')) BUSAN, 
    COUNT(DECODE(SUBSTR(tel, 1, INSTR(TEL, ')')-1), '052', '1')) ULSAN, 
    COUNT(DECODE(SUBSTR(tel, 1, INSTR(TEL, ')')-1), '053', '1')) DAEGU, 
    COUNT(DECODE(SUBSTR(tel, 1, INSTR(TEL, ')')-1), '055', '1')) GYEONGNAM
FROM student;

/*
���� emp ���̺� �Ʒ� �� ���� �����͸� �Է��� �� emp ���̺��� ��ȸ�Ͽ� �μ���, ���޺� �޿� �հ� ����� ����϶�.
*/
INSERT INTO emp (empno, deptno, ename, sal) VALUES(1000, 10, 'Tiger', 3600);
INSERT INTO emp (empno, deptno, ename, sal) VALUES(2000, 10, 'Cat', 3000);
SET PAGESIZE 50
SELECT empno, ename, job, sal FROM emp;
SELECT deptno, 
    SUM(DECODE(job, 'CLERK', sal, 0)) "CLERK", 
    SUM(DECODE(job, 'MANAGER', sal, 0)) "MANAGER", 
    SUM(DECODE(job, 'PRESIDENT', sal, 0)) "PRESIDENT", 
    SUM(DECODE(job, 'ANALYST', sal, 0)) "ANALYST", 
    SUM(DECODE(job, 'SALESMAN', sal, 0)) "SALESMAN", 
    -- NVL2 : job�� null�� �ƴϸ� sal��ȯ�ϰ� null�̸� 0 ��ȯ
    SUM(NVL2(job, sal, 0)) "TOTAL" -- ���޺� �հ�
FROM emp
      -- rollup(deptno) : �μ���(�÷�) �հ�
GROUP BY ROLLUP(deptno) ORDER BY deptno;
DELETE FROM emp WHERE ename IN ('Tiger','Cat');
/*
emp ���̺��� ��ȸ�Ͽ� �������� �޿��� ��ü �޿��� ���� �޿��ݾ��� ����϶�. ��, �޿��� ������������ ����.
                                        sum() over
*/
SELECT deptno, ename, sal, SUM(sal) OVER(ORDER BY sal) TOTAL FROM emp;

/*
fruit ���̺��� ����϶�.
*/
SELECT SUM(DECODE(name, 'apple', price)) APPLE, 
       SUM(DECODE(name, 'grape', price)) GRAPE, 
       SUM(DECODE(name, 'orange', price)) ORANGE
FROM fruit;

/*
student ���̺��� tel �÷��� ����� ������ �ο����� ��ü ��� �����ϴ� ������ ����϶�.
��, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM����
*/
SELECT * FROM student;
SELECT
      COUNT(tel) || 'EA (' || ROUND(COUNT(tel) * 100 / COUNT(tel) , 0) || '%)' AS TOTAL,
      COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '02', 0)) || 'EA (' ||
            ROUND(COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '02', 0)) * 100 / COUNT(tel) , 0) || '%)' AS SEOUL,
      COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '031', 0)) || 'EA (' ||
            ROUND(COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '031', 0)) * 100 / COUNT(tel) , 0) || '%)' AS GYEONGGI,
      COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '051', 0)) || 'EA (' ||
            ROUND(COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '051', 0)) * 100 / COUNT(tel) , 0) || '%)' AS BUSAN,
      COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '052', 0)) || 'EA (' ||
            ROUND(COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '052', 0)) * 100 / COUNT(tel) , 0) || '%)' AS ULSAN,
      COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '053', 0)) || 'EA (' ||
            ROUND(COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '053', 0)) * 100 / COUNT(tel) , 0) || '%)' AS DAEGU,
      COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '055', 0)) || 'EA (' ||
            ROUND(COUNT(DECODE(SUBSTR(tel, 0, INSTR(tel, ')') - 1), '055', 0)) * 100 / COUNT(tel) , 0) || '%)' AS GYEONGNAM
FROM student;

/*
emp ���̺��� ��ȸ�Ͽ� �μ����� �޿� ���� �հ踦 ����϶�. ��, �μ� ��ȣ�� ������������
*/
SELECT deptno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal) TOTAL FROM emp;

/*
emp ���̺��� ��ȸ�Ͽ� ��ü ���� �޿� �Ѿ׿��� �� ����� �޿����� ������ ����϶�. ��, �޿������� ������������
*/
SELECT deptno, ename, sal, 
    SUM(sal) OVER() TOTAL_SAL, 
    ROUND(RATIO_TO_REPORT(SUM(sal)) OVER()*100, 2) "%" 
FROM emp GROUP BY deptno, ename, sal ORDER BY sal desc;

/*
emp ���̺��� ��ȸ�Ͽ� �μ� �޿� �Ѿ׿��� �� ������� �޿��� ������ ����϶�. ��, �μ� ��ȣ ������������
*/
SELECT deptno, ename, sal, 
    SUM(sal) OVER(PARTITION BY deptno) SUM_DEPT, 
    ROUND(RATIO_TO_REPORT(SUM(sal)) OVER(PARTITION BY deptno)*100, 2) "%" 
FROM emp GROUP BY deptno, ename, sal;

/*
loan ���̺��� ��ȸ�Ͽ� 1000�� ������ ���� ������ ��������, ���������ڵ�, ����Ǽ�, �����Ѿ�, ��������ݾ��� ����϶�
*/
SELECT * FROM loan;
SELECT l_date ��������, l_code ���������ڵ�, l_qty ����Ǽ�, l_total �����Ѿ�, 
    SUM(l_total) OVER(ORDER BY l_date) ��������ݾ� FROM loan WHERE l_store = 1000;

/*
loan ���̺��� ��ȸ�Ͽ� ��ü ������ ���������ڵ�, ��������, ��������, ����Ǽ�, ����װ� �����ڵ�� ���������� ���� �հ踦 ����϶�
*/
SELECT l_code ���������ڵ�, l_store ��������, l_date ��������, l_qty ����Ǽ�, l_total �����,
    SUM(l_total) OVER(PARTITION BY l_code, l_store ORDER BY l_date) ��������ݾ� FROM loan;

/*
loan ���̺��� ��ȸ�Ͽ� 1000�� ������ ���⳻���� ���������ڵ庰�� ���ļ� ��������, �ڵ�, ����Ǽ�, �����Ѿ�, ��������ݾ��� ����϶�
*/
SELECT l_date ��������, l_code ���������ڵ�,  l_qty ����Ǽ�, l_total �����,
    SUM(l_total) OVER(PARTITION BY l_code ORDER BY l_qty) ��������ݾ� FROM loan WHERE l_store = 1000;

/*
professor ���̺��� �� �������� �޿��� ���ϰ� �� �޿����� ��ä ������ �޿� �հ迡�� �����ϴ� ������ ����϶�
*/
SELECT * FROM professor;
SELECT deptno, name, pay, SUM(pay) OVER() "TOTAL PAY", ROUND(RATIO_TO_REPORT(SUM(PAY)) OVER()*100, 2) "RATIO %"
FROM professor GROUP BY deptno, name, pay ORDER BY pay DESC;

/*
professor ���̺��� ��ȸ�Ͽ� �а���ȣ, ������, �޿�, �а��� �޿� �հ踦 ���ϰ� �� ������ �޿��� �ش� �а��� �޿� �հ迡�� �����ϴ� ������ ����϶�
*/
SELECT deptno, name, pay, SUM(PAY) OVER(PARTITION BY deptno) TOTAL_DEPTNO, 
    ROUND(RATIO_TO_REPORT(SUM(PAY)) OVER(PARTITION BY deptno)*100, 2) "RATIO %"
FROM professor GROUP BY deptno, name, pay;


commit;