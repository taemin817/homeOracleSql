SELECT * FROM emp;
-- ��ü �÷��� �ִ��� ��ȸ
DESC dept;
-- ���ϴ� �÷��� ��ȸ
SELECT empno, ename FROM emp;

-- �� ȭ�鿡 ��� ������ �� ���� ����(���� ���� ����)
-- SET SIZELINE 100
-- �� �������� ��� ������ �� �� ����(���� ���� ����)
SET PAGESIZE 50
-- �����Ͱ� ������ ��� 20����Ʈ���� ���� ����
COL name FOR a20

SELECT * FROM professor;

-- select�� ǥ������ ����Ͽ� ���
--              ǥ����       ,     �÷���
SELECT name, 'good morning~', 'Good Morning' FROM professor;
--              '��� ���� ''�� ���
SELECT dname, ',it''s deptno: ', deptno "DNAME AND DEPTNO" FROM dept;
-- q�� ���ȣ�� �̿��ϴ� ���
SELECT dname, q'[, it's deptno :]', deptno "DANME AND DEPTNO" FROM dept;

-- �÷� ��Ī ����Ͽ� ���
-- �������� ���
SELECT profno, name, pay FROM professor;
-- ��Ī ��� : ��ĭ ��� ū����ǥ+��Ī, ��ĭ ��� AS+ū����ǥ+��Ī
SELECT profno "Prof's NO", name AS "Prof's NAME", pay Prof_Pay FROM professor;

-- DISTINCT : �ߺ� ���� �����ϰ� ���
SELECT deptno FROM emp;
SELECT DISTINCT deptno FROM emp;

SELECT job, ename FROM emp ORDER BY 1,2;
-- DISTINCT�� 1���� �÷����� ��� ��� �÷��� �����
SELECT DISTINCT job FROM emp;
SELECT DISTINCT job, ename FROM emp ORDER BY 1,2;

-- ���� �����ڷ� �÷� �ٿ��� ��� : ����� �÷��� 1���� �ν�
SELECT ename ||'-'|| job FROM emp;
SELECT ename ||'-'|| job as "name and job" FROM emp;

-- p39
-- �������� 1
desc student;
SELECT name||'''s id:'||id||' , weight is '||weight||'kg' "id and weight" from student;
-- �������� 2
desc emp;
select ename||'('||job||'), '||ename||''''||job||'''' "name and job" from emp;
-- �������� 3
select ename||'''s sal is $'||sal "name and sal" from emp;

-- WHERE: ���ϴ� ���Ǹ� ��󳻱�
SELECT empno, ename FROM emp WHERE empno=7900;
SELECT ename, sal FROM emp WHERE sal <900;
-- ���� ��ȸ �� ��ҹ��� ����
SELECT empno, ename, sal FROM emp WHERE ename='SMITH';
SELECT empno, ename, sal FROM emp WHERE ename='smith';
SELECT ename, hiredate FROM emp WHERE ename='SMITH';
-- ��¥ ��ȸ �� �ݵ�� ��������ǥ ���
SELECT empno, ename, hiredate, sal FROM emp WHERE hiredate='80/12/17';

-- ��� ������ ���
SELECT ename, sal, sal+100 FROM emp WHERE deptno=10;
SELECT ename, sal, sal*1.1 FROM emp WHERE deptno=10;

-- �پ��� ������ Ȱ��
/*
=   ���� ���� �˻�
!=  ���� ���� ���� �˻�
>, <    ū, ���� ���� �˻�
>=, <=  ũ�ų� ����, �۰ų� ���� ���� �˻�
between a and b     a�� b ���̿� �ִ� ���� �� ��� �˻�
in(a,b,c)   a / b / c�� ���� �˻�(= ���� a+b+c�� �� �˻�)
like    Ư�� ������ ������ �ִ� ���� �˻�
is null/ is not null    null �� �˻�/ null �ƴ� �� �˻�
a and b     ���� a�� b ��θ� �����ϴ� �� �˻�
a or b      ���� a Ȥ�� b�� �����ϴ� �� �˻�
not a       a�� �ƴ� ��� ���� �˻�
*/
-- �� ������
SELECT empno, ename, sal FROM emp WHERE sal >=4000;
SELECT empno, ename, sal FROM emp WHERE ename>='W';
-- ��¥�� �ֱ� ��¥�� ū ��¥, ���� ��¥�ϼ��� ���� ��¥
SELECT ename, hiredate FROM emp WHERE hiredate >= '81/12/25';
-- between���� ���� ������ ��ȸ(�̻� ����)
SELECT empno, ename, sal FROM emp WHERE sal between 2000 and 3000;
-- Ư�� ���� ���� �˻��� �� between���ٴ� �񱳿����ڸ� ����
SELECT empno, ename, sal FROM emp WHERE sal >= 2000 and sal <= 3000;
SELECT ename FROM emp WHERE ename BETWEEN 'JAMES' and 'MARTIN' ORDER BY ename;
-- in �����ڷ� ���� ���� �����ϰ� �˻�
SELECT empno, ename, deptno FROM emp WHERE deptno IN (10, 20);
-- like �����ڷ� ����� �͵� ��� ã��
-- % : ���� ���� ������ ����(0�� ����) � ���ڰ� �͵� ��� ����
-- _ : ���� ���� �ѱ��ڸ� �� �� �ְ� � ���ڰ� �͵� ��� ����
SELECT empno, ename, hiredate FROM emp;
SELECT empno, ename, sal FROM emp WHERE sal LIKE '1%';
SELECT empno, ename, sal FROM emp WHERE ename LIKE 'A%';
-- ����� _�� %�� LIKE �ٷ� ������ ���� �ȵȴ�
SELECT empno, ename, hiredate FROM emp WHERE hiredate LIKE '___12%';
-- is null / is not null, null���� = �� �� �� ����
SELECT empno, ename, comm FROM emp;
SELECT empno, ename, comm FROM emp WHERE comm is null;
SELECT empno, ename, comm FROM emp WHERE comm is not null;
-- �˻� ������ �� �� �̻��� ��� ��ȸ
SELECT ename, hiredate, sal FROM emp WHERE hiredate > '82/01/01' AND sal >= 1300;
-- ����ڿ��� ������ &�� ����Ͽ� �Է¹޾� ���ǿ� �´� �� ���
SELECT empno, ename, sal FROM emp WHERE empno=&empno;

-- ORDER BY : �����Ͽ� ���(�⺻ ��������), asc:��������(���ڰ� �ö�) desc:��������
-- �ǵ��� order by�� ���� �ʵ�������
SELECT ename, sal, hiredate FROM emp ORDER BY ename;
SELECT deptno, sal, ename FROM emp ORDER BY deptno ASC, sal DESC;
-- ������ �÷��� �÷����� �ƴ� �÷� ������ ǥ��
select * from emp;
SELECT ename, sal, hiredate FROM emp WHERE sal>1000 ORDER BY 3;

-- ���� ������
/*
union : �� ������ ����� ���ļ� ���, �ߺ� �� �����ϰ� ����
union all : �� ������ ����� ���ļ� ���, �ߺ� �� �������� �ʰ� ���ĵ� ��������
intersect : �� ������ ������ ����� ��� �� ����
minus : �� ������ ������ ����� ��� �� ����, ������ ������ �߿�
*/
/*
���ǻ���
1. �� ������ select ���� ���� �÷� ������ �����ؾ� ��
2. �� ������ select ���� ���� �÷��� ������ ���� �����ؾ� ��
3. �� ������ �÷����� �޶� �������
*/
