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

-- cube : �Ұ�� ��ü �հ���� ���. �÷� ������ �ٲ� ��¹��� ����
explain plan for
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY CUBE(deptno, job) ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
select * from table(dbms_xplan.display); -- �� �ȵ�??