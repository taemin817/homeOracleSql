-- ������(�׷�) �Լ� : ���� ���� �����͸� ���ÿ� �Է� �޾� 1���� ��� ��ȯ
/*
count : �ԷµǴ� �������� �� �Ǽ��� ��� count(sal)
sum : �ԷµǴ� �������� �հ� ���� ���ؼ� ��� sum(sal)
avg : �ԷµǴ� �������� ��� ���� ���ؼ� ��� avg(sal)
max : �ԷµǴ� ������ �� ���� ū ���� ��� max(sal)
min : �ԷµǴ� ������ �� ���� ���� ���� ��� min(sal)
stddev : �ԷµǴ� ������ ������ ǥ�� �������� ��� stddev(sal)
variance : �ԷµǴ� ������ ������ �л갪�� ��� variance(sal)
rollup : �ԷµǴ� �������� �Ұ谪�� �ڵ����� ����ؼ� ���
groupingset : �� ���� ������ ���� ���� �Լ����� �׷����� ���� ����
listagg, pivot, lag, lead, rank, dense_rank
*/
-- count : �ԷµǴ� �� �Ǽ��� ���
SELECT COUNT(*), COUNT(comm) FROM emp;
-- sum : �Էµ� �����͵��� �հ� ���� ���
SET null --null-- ;
SELECT COUNT(comm), SUM(comm) FROM emp;
-- avg : �Էµ� �����͵��� ��� ���� ���
SELECT COUNT(comm), SUM(comm), AVG(comm) FROM emp;
-- max, min : ���� ���� �����͸� �Է¹޾� ������� �����ϱ� ������ �ð��� ���� �ɸ��� ������ ��뿡 ����. ��� �ε��� ��õ
SELECT MAX(sal), MIN(sal) FROM emp;
SELECT MAX(hiredate) "MAX", MIN(hiredate) "MIN" FROM emp;
-- stddev : ǥ������, variance : �л�
SELECT ROUND(STDDEV(sal), 2), ROUND(VARIANCE(sal), 2) FROM emp;

/*
GROUP BY : Ư�� �������� �������� �׷�ȭ.
SELECT�� ���� �׷� �Լ� �̿��� �÷��̳� ǥ������ �ݵ�� GROUP BY���� ���Ǿ�� ��(�ʼ� ����).
�ݴ�� GROUP BY�� ���� �÷��̶� SELECT�� ������ �ʾƵ� ��(��� ����).
GROUP BY���� �ݵ�� �÷����� ���Ǿ�� ��.
*/
-- emp���̺��� ��ȸ�Ͽ� �μ����� ��� �޿� �ݾ� ���
SELECT deptno, AVG(NVL(sal, 0)) "AVG" FROM emp GROUP BY deptno;
-- �μ����� ���� �׷��� ���� ���� �а��� ��� ���޺��� �� ���� �з��Ͽ� ��� �޿� ���
SELECT deptno, job, AVG(NVL(sal, 0)) "AVG_SAL" FROM emp GROUP BY deptno, job;
-- ù��° �÷�, �ι�° �÷��� ���Ľ��Ѽ� ���
SELECT deptno, job, AVG(NVL(sal, 0)) "AVG_SAL" FROM emp GROUP BY deptno, job ORDER BY 1, 2;

-- having : gruoping�� �������� �˻�. WHERE�� �׷��Լ��� ���������� ��� �Ұ��ϱ⶧���� ���
SELECT deptno, AVG(NVL(sal, 0)) FROM emp WHERE deptno > 10 GROUP BY deptno HAVING AVG(NVL(sal, 0)) > 2000;

-- �м�(analytic)/���� �Լ� : �ೢ�� �����̳� �񱳸� ���� �������ֱ� ���� �Լ�
-- rollup : �� ���غ� �Ұ踦 ����ؼ� ������. ������ �з��� �����ϰ� �ִ� �������� ���迡 ����. ������ �÷��� ������ �ٲ�� ����� �ٲ�
explain plan for
SELECT deptno, NULL job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY deptno
UNION ALL
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY deptno, job
UNION ALL
SELECT NULL deptno, NULL job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
-- �Ʒ� �������� emp ���̺��� 3�� ���� ���� Ȯ���� �� �ִ�
select * from table(dbms_xplan.display);

-- ���� ������ �ʹ� ���...�Ʒ�ó�� ROLLUP���� ���� �� �ִ�
explain plan for
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY ROLLUP(deptno, job);
col PLAN_TABLE_OUTPUT format a80
-- �Ʒ� �������� emp ���̺��� 1���� ���� ���� Ȯ���� �� �ִ�
select * from table(dbms_xplan.display);

-- position���� ���� �з� �� ���� deptno�� ���� ��� deptno���� rollup
SELECT deptno, position, COUNT(*), SUM(PAY) FROM professor GROUP BY position, ROLLUP(deptno);
-- deptno���� ���� �з� �� ���� position�� ���� ��� position���� rollup
SELECT deptno, position, COUNT(*), SUM(PAY) FROM professor GROUP BY deptno, ROLLUP(position);

CREATE TABLE professor2 AS SELECT deptno, position, pay FROM professor;
insert into professor2 VALUES(101, 'instructor', 100);
insert into professor2 VALUES(101, 'a full professor', 100);
insert into professor2 VALUES(101, 'assistant professor', 100);
select * from professor2 ORDER BY deptno, position;

-- deptno���� ���� �з� �� ���� position�� ���� ��� position���� pay�Ұ谪�� ���ϱ�
SELECT deptno, position, SUM(pay) FROM professor2 GROUP BY deptno, ROLLUP(position);

explain plan for 
SELECT deptno, NULL job, ROUND(AVG(sal),1), COUNT(*) FROM emp GROUP BY deptno 
UNION ALL 
SELECT NULL deptno, job, ROUND(AVG(sal),1), COUNT(*) FROM emp GROUP BY job 
UNION ALL 
SELECT deptno, job, ROUND(AVG(sal),1), COUNT(*) FROM emp GROUP BY deptno, job 
UNION ALL 
SELECT NULL deptno, NULL job, ROUND(AVG(sal),1), COUNT(*) FROM emp ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
select * from table(dbms_xplan.display);
-- cube : �Ұ�� ��ü �հ���� ���. �÷� ������ �ٲ� ��¹��� ����
explain plan for
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY CUBE(deptno, job) ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
select * from table(dbms_xplan.display); -- �ȵǴ� �� ������...��

-- grouping sets : grouping ������ ���� ���� ��� ���
/*
student���̺��� �г⺰�� �л����� �ο� �� �հ�� �а��� �ο� ���� �հ踦 ���ؾ� �ϴ� ���
�������� �г⺰�� �ο� �� �հ踦 ���ϰ� ������ �а��� �ο� �� �հ踦 ���� �� union�ؾ� ����
*/
SELECT grade, COUNT(*) FROM student GROUP BY grade
UNION SELECT deptno1, COUNT(*) FROM student GROUP BY deptno1;
-- grouping sets ���
SELECT grade, deptno1, COUNT(*) FROM student GROUP BY GROUPING SETS(grade, deptno1);
-- student ���̺��� �г⺰, �б����� �ο����� Ű�� �հ� �������� �հ� ���� ���
SELECT grade, deptno1, COUNT(*), SUM(height), SUM(weight) FROM student GROUP BY GROUPING SETS(grade, deptno1);

-- listagg : ���� grouping ����. 4000����Ʈ�� ������ ���� �߻�. �� ��� XMLAGG XML ���
-- �����ϰ� ���� �÷��� ���� �����͵��� ������ �����ڸ� '' ���̿� ���. WITHIN GROUP�� ���η� �����ϰ� ���� ��Ģ�� ORDER BY�� ���.
SET line 200
COL LISTAGG FOR a50
SELECT deptno, LISTAGG(ename, '->') WITHIN GROUP(ORDER BY hiredate) "LISTAGG" FROM emp GROUP BY deptno;
-- xmlagg xml : �����͸� ���������� xml���·� ����. varchar2, clob���°� ����
--                          xml �±׸�(����), ������, ��� �÷���                          varchar2�� �� getStringVal
SELECT deptno, SUBSTR(XMLAGG(XMLELEMENT(X, ',', ename) ORDER BY ename).EXTRACT('//text()').getStringVal(), 2) 
AS DEPT_ENAME_LIST FROM emp A GROUP BY deptno;
--                          xml �±׸�(����), ������, ��� �÷���                          clob�� �� getClobVal
SELECT deptno, SUBSTR(XMLAGG(XMLELEMENT(X, ',', ename) ORDER BY ename).EXTRACT('//text()').getClobVal(), 2) 
AS DEPT_ENAME_LIST FROM emp A GROUP BY deptno;

-- pivot : row������ column����, unpivot : column������ row�� ����
select * from cal;
-- pivot ����� ������� �ʰ� decode �Լ��� Ȱ���Ͽ� �޷� �����
-- �⺻ ��ȸ
SELECT
DECODE(day, 'SUN', dayno) SUN, 
DECODE(day, 'MON', dayno) MON, 
DECODE(day, 'TUE', dayno) TUE, 
DECODE(day, 'WED', dayno) WED, 
DECODE(day, 'THU', dayno) THU, 
DECODE(day, 'FRI', dayno) FRI, 
DECODE(day, 'SAT', dayno) SAT 
FROM cal;
-- �����Ͱ� ���ڷ� �Ǿ��־ �ƽ�Ű�ڵ�� ����Ǿ� �񱳵Ǵµ� �α��� �̻��� ��� ���� �� ���ڸ� ��ȯ�ؼ� ����
SELECT
MAX(DECODE(day, 'SUN', dayno)) SUN, 
MAX(DECODE(day, 'MON', dayno)) MON, 
MAX(DECODE(day, 'TUE', dayno)) TUE, 
MAX(DECODE(day, 'WED', dayno)) WED, 
MAX(DECODE(day, 'THU', dayno)) THU, 
MAX(DECODE(day, 'FRI', dayno)) FRI, 
MAX(DECODE(day, 'SAT', dayno)) SAT
FROM cal;
-- weekno�� grouping, ���ĵ��� ���� ä ���
SELECT
MAX(DECODE(day, 'SUN', dayno)) SUN, 
MAX(DECODE(day, 'MON', dayno)) MON, 
MAX(DECODE(day, 'TUE', dayno)) TUE, 
MAX(DECODE(day, 'WED', dayno)) WED, 
MAX(DECODE(day, 'THU', dayno)) THU, 
MAX(DECODE(day, 'FRI', dayno)) FRI, 
MAX(DECODE(day, 'SAT', dayno)) SAT
FROM cal
GROUP BY weekno;
-- ORDER BY�� ����
COL sun FOR a4
COL mon FOR a4
COL tue FOR a4
COL wed FOR a4
COL thu FOR a4
COL fri FOR a4
COL sat FOR a4
SELECT
MAX(DECODE(day, 'SUN', dayno)) SUN, 
MAX(DECODE(day, 'MON', dayno)) MON, 
MAX(DECODE(day, 'TUE', dayno)) TUE, 
MAX(DECODE(day, 'WED', dayno)) WED, 
MAX(DECODE(day, 'THU', dayno)) THU, 
MAX(DECODE(day, 'FRI', dayno)) FRI, 
MAX(DECODE(day, 'SAT', dayno)) SAT
FROM cal
GROUP BY weekno ORDER BY weekno;

-- pivot ����� ����Ͽ� �޷� �����
/*
PIVOT ���� MAX(dayno) ���� DECODE ���忡�� ���Ǵ� �Լ���,
FOR ������ ȭ�鿡 ����� grouping�� �÷��� �ۼ�.
IN ������ �ڿ��� �������� ��� �Ұ�
*/
COL week FOR a4
SELECT * FROM (SELECT weekno "WEEK", day, dayno FROM cal)
PIVOT(MAX(dayno) FOR day IN (
'SUN' AS "SUN", 
'MON' AS "MON", 
'TUE' AS "TUE", 
'WED' AS "WED", 
'THU' AS "THU", 
'FRI' AS "FRI", 
'SAT' AS "SAT" )) ORDER BY "WEEK";

-- emp ���̺��� �μ����� �� ���޺� �ο��� �� ������ ����ϱ�
-- �ܰ躰�� ���캸��
COL CLERK FOR a8
COL MANAGER FOR a8
COL PRESIDENT FOR a8
COL ANALYST FOR a8
COL SALESMAN FOR a8
SELECT deptno,
DECODE(job, 'CLERK', '0') "CLERK",
DECODE(job, 'MANAGER', '0') "MANAGER",
DECODE(job, 'PRESIDENT', '0') "PRESIDENT",
DECODE(job, 'ANALYST', '0') "ANALYST",
DECODE(job, 'SALESMAN', '0') "SALESMAN"
FROM emp;
-- 0�� �μ��� ���޺��� �� ������
SELECT deptno, 
COUNT(DECODE(job, 'CLERK', '0')) "CLERK", 
COUNT(DECODE(job, 'MANAGER', '0')) "MANAGER", 
COUNT(DECODE(job, 'PRESIDENT', '0')) "PRESIDENT", 
COUNT(DECODE(job, 'ANALYST', '0')) "ANALYST", 
COUNT(DECODE(job, 'SALESMAN', '0')) "SALESMAN"
FROM emp GROUP BY deptno;
-- ORDER BY�� ����
SELECT deptno, 
COUNT(DECODE(job, 'CLERK', '0')) "CLERK", 
COUNT(DECODE(job, 'MANAGER', '0')) "MANAGER", 
COUNT(DECODE(job, 'PRESIDENT', '0')) "PRESIDENT", 
COUNT(DECODE(job, 'ANALYST', '0')) "ANALYST", 
COUNT(DECODE(job, 'SALESMAN', '0')) "SALESMAN"
FROM emp GROUP BY deptno ORDER BY deptno;

-- unpivot : ������ �ִ� ���� Ǯ� �����ִ� ����
CREATE TABLE upivot AS 
SELECT * FROM 
(
    SELECT deptno, job, empno FROM emp
)
PIVOT
(
    COUNT(empno) 
    FOR job IN (
        'CLERK' AS "CLERK",
        'MANAGER' AS "MANAGER",
        'PRESIDENT' AS "PRESIDENT",
        'ANALYST' AS "ANALYST",
        'SALESMAN' AS "SALESMAN"
    )
);
SELECT * FROM upivot;
SELECT * FROM upivot
UNPIVOT(
empno FOR job IN (CLERK, MANAGER, PRESIDENT, ANALYST, SALESMAN));

-- lag : ���� �� ���� ������ �� ���




commit;