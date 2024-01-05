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