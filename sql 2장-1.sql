-- ������ �Լ� : �� ���� �ϳ��� ó���ϴ� �Լ�
-- ������(�׷�) �Լ� : ���� ���� �����͸� ���ÿ� �Է� �޾� 1���� ��� ��ȯ
-- ������ �Լ� ���� : ����, ����, ��¥,. ��ȯ(������ �������� ��ȯ, ����� �������� ��ȯ), �Ϲ� �Լ�

/*
�����Լ�
intcap : �Է� ���� ù ���ڸ� �빮�ڷ� ��ȯ intcap('abcd') -> Abcd
lower : �Է� ���� ���� �ҹ��ڷ� ��ȯ lower('ABCD') -> abcd
upper : �Է� ���� ���� �빮�ڷ� ��ȯ upper('abcd') -> ABCD
length : �Էµ� ���ڿ��� ���� ���� ��� length('�ѱ�') -> 2
lengthb : �Էµ� ���ڿ��� ���� ����Ʈ ���� ��� lengthb('�ѱ�') -> 4
concat : �� ���ڿ��� �����ؼ� ���. || �� ���� concat('a', 'b') -> ab
substr : �־��� ���ڿ��� Ư�� ���ڸ� ���� substr('abcd', 1, 2) -> abc���� ù��°���� 2�� ���. ab
substrb : �־��� ���ڿ��� Ư�� ����Ʈ�� ���� substrb('abcde', 1, 3) -> abcde���� ù��°���� 3����Ʈ ���. abc
instr : �־��� ���ڿ��� Ư�� ������ ��ġ ���� instr('a*b#','#') -> #�� ��ġ ���. 4
instrb : �־��� ���ڿ��� Ư�� ������ ��ġ ����Ʈ�� ���� intstrb('�ѱ۷�', '��') -> �� �� �����ϴ� ��ġ 5
lpad : �־��� ���ڿ����� �������� Ư�� ���ڸ� ä�� lpad('love', 10, '#') -> 10����Ʈ �� love(4����Ʈ)�������� #�� ä��
rpad : �־��� ���ڿ����� ���������� Ư�� ���ڸ� ä�� rpad('love', 10, '#') -> 10����Ʈ �� love(4����Ʈ)���������� #�� ä��
ltrim : �־��� ���ڿ����� ������ Ư�� ���ڸ� ���� ltrim('###love','#') -> ###love�� ���ʿ��� #�� ����. love
rtrim : �־��� ���ڿ����� ���������� Ư�� ���ڸ� ���� rtrim('love###','#') -> love###�� �����ʿ��� #�� ����. love
replace : �־��� ���ڿ����� a�� b�� ġȯ replace('abcd', 'a', 'b') -> bbcd
regexp_replace : �־��� ���ڿ����� Ư�� ������ ã�� ġȯ
regexp_instr : �־��� ���ڿ����� Ư�� ������ ���� ��ġ�� ��ȯ
regexp_substr : �־��� ���ڿ����� Ư�� ������ ã�� ��ȯ
regexp_like : �־��� ���ڿ����� Ư�� ������ ã�� ��ȯ
regexp_count : �־��� ���ڿ����� Ư�� ������ Ƚ���� ��ȯ
*/
SELECT ename, INITCAP(ename) "INITCAP" FROM emp WHERE deptno=10;
-- �߰��� ������ ������ ���� ���� ù���ڸ� �빮�ڷ� ���
SELECT name, INITCAP(name) "INITCAP" FROM professor WHERE deptno=101;
SELECT ename, LOWER(ename) "LOWER", UPPER(ename) "UPPER" FROM emp WHERE deptno = 10;
SELECT '���¹�' "NAME", LENGTH('���¹�') "LENGTH", LENGTHB('���¹�') "LENGTHB" FROM DUAL;
SELECT CONCAT(ename, job) FROM emp WHERE deptno=10;
col "3, 2" for a6 -- �÷� �̸� "3, 2"�� �����Ͱ� ������ ��� �÷��� ���̸� 6����Ʈ���� ����
col "-3, 2" for a6
col "-3, 4" for a6
--            3��°���� 2��              ���������� 3��°���� 2��              ������ 3��°���� 4��
select substr('abcde', 3, 2) "3,2", substr('abcde', -3, 2) "-3,2", substr('abcde', -3, 4) "-3,4" from dual;
--                 ù���� ���ڷκ��� 3��° -�� ������ ��ġ
SELECT 'A-B-C-D', INSTR('A-B-C-D', '-', 1, 3) "INSTR" FROM dual;
--            ������ ù���� ���ڷκ��� 3��° -�� ������ ��ġ
SELECT 'A-B-C-D', INSTR('A-B-C-D', '-', -1, 3) "INSTR" FROM dual;
--            ������ �������� ���ڷκ��� 2��° -�� ������ ��ġ
SELECT 'A-B-C-D', INSTR('A-B-C-D', '-', -6, 2) "INSTR" FROM dual;
-- substr, instr����
-- student ���̺��� �����ؼ� deptno1�� 201�� �л��̸��� ��ȭ��ȣ�� ������ȣ ����ϱ�(���� ��ȣ�� ���ڸ�)
SELECT name, tel, SUBSTR(tel, 1, INSTR(tel, ')')-1) "AREA CODE" FROM student WHERE deptno1 = 201;
SELECT name, id, LPAD(id, 10, '*') FROM student WHERE deptno1 = 201;
-- emp���� deptno=10�� ������� ��� �̸��� �� 9����Ʈ�� lpad�ϰ� ���ڸ��� �ش� �ڸ��� ���ڷ� ä���
SELECT LPAD(ename, 9, substr('123456789', 1, 9-LENGTH(ename))) "LPAD" FROM emp WHERE deptno=10;
-- emp���� deptno=10�� ������� ��� �̸��� �� 9����Ʈ�� rpad�ϰ� ���ڸ��� �ش� �ڸ��� ���ڷ� ä���
SELECT RPAD(ename, 9, substr('123456789', LENGTH(ename)+1, 9-LENGTH(ename))) "RPAD" FROM emp WHERE deptno=10;
SELECT LTRIM(ename, 'C') FROM emp WHERE deptno=10; -- ȸ�������� �ޱ� ���� ���� ���̵� �޴µ� ù ���ڰ� �����ϰ�� �� ������ �����ϴ� ��쿡 ���
SELECT RTRIM(ename, 'R') FROM emp WHERE deptno=10;
SELECT ename, REPLACE(ename, SUBSTR(ename, 1, 2), '**') "REPLACE" FROM emp WHERE deptno=10;
-- replace ���� 1
SELECT ename, REPLACE(ename, SUBSTR(ename, 2, 2), '--') "REPALCE" FROM emp WHERE deptno=20;
-- replace ���� 2
SELECT name, jumin, REPLACE(jumin, SUBSTR(jumin, 7, 7), '-/-/-/-') "REPLACE" FROM student WHERE deptno1=101;
-- replace ���� 3
SELECT name, tel, REPLACE(tel, SUBSTR(tel, INSTR(tel, ')')+1, 3), '***') "REPLACE" FROM student WHERE deptno1=102;
-- replace ���� 4
SELECT name, tel, REPLACE(tel, SUBSTR(tel, INSTR(tel, '-')+1, 4), '****') "REPLACE" FROM student WHERE deptno1=102;

/*
���� �Լ�
round : �־��� ���ڸ� n��° �ڸ����� �ݿø��� �� ��� round(12.345, 2) -> 12.35
trunc : �־��� ���ڸ� n��° �ڸ����� ������ �� ��� trunc(12.345, 2) -> 12.34
mod : �־��� ���ڸ� ���� �������� ��� mod(12, 10) -> 2
ceil : �־��� ���ڿ� ���� ������ "ū" ������ ��� ceil(12.345) -> 13
floor : �־��� ���ڿ� ���� ������ "����" ������ ��� floor(12.345) -> 12
power : �־��� ���� 1�� ���� 2���� ��� power(3,2) -> 9
*/
SELECT ROUND(987.654, 2) "ROUND1", ROUND(987.654, 0) "ROUND2", ROUND(987.654, -1) "ROUND3" FROM dual;
SELECT ROUND(987.654, 2) "TRUNC1", TRUNC(987.654, 0) "TRUNC2", TRUNC(987.654, -1) "TRUNC3" FROM dual;
SELECT MOD(121, 10) "MOD", CEIL(123.45) "CEIL", FLOOR(123.45) "FLOOR" FROM dual;
SET pagesize 50
SELECT rownum "ROWNO", CEIL(rownum/3) "TEAMNO", ename FROM emp;
SELECT power(3,2) FROM dual;

/*
��¥ �Լ�
��¥+����=��¥, ��¥-����=��¥, ��¥-��¥=����
sysdate : �ý����� ���� ��¥�� �ð�
months_between : �� ��¥ ������ ���� ��
add_months : �־��� ��¥�� ������ ����
next_day : �־��� ��¥�� �������� ���ƿ��� ���� �ֱ� ������ ��¥ ���
last_day : �־��� ��¥�� ���� ���� ������ ��¥ ���
round : �־��� ��¥�� �ݿø�
trunc : �־��� ��¥�� ����
*/
SELECT sysdate from dual;
-- MONTHS_BETWEEN
-- ū ��¥�� ���� ����
SELECT MONTHS_BETWEEN('14/09/30', '14/08/31') FROM dual;
-- �� ��¥�� ���� �޿� ���� ������ Ư�� ��Ģ���� ���� ���� ���
SELECT MONTHS_BETWEEN('12/02/29', '12/02/01'), MONTHS_BETWEEN('14/04/30', '14/04/01'), MONTHS_BETWEEN('14/05/31', '14/05/01') FROM dual;
-- �Ϲ������� months_between �Լ��� �Ⱦ��� 1����=31��, months_between�� 1����=31�Ϸ� ��������� ����� ���̰� ����
SELECT ename, hiredate, 
ROUND(MONTHS_BETWEEN(TO_DATE('04/05/31'), hiredate), 1) "DATE1", 
ROUND(((TO_DATE('04/05/31')-hiredate)/31),1) "DATE2" 
FROM emp WHERE deptno=10;
-- ADD_MONTHS
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 1) FROM dual;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '��') FROM dual;
SELECT SYSDATE, NEXT_DAY('14/04/01', '��') FROM dual; -- Ư�� ��¥�� �������� �� ��
SELECT SYSDATE, LAST_DAY(SYSDATE), LAST_DAY('14/04/01') FROM dual;
-- ��¥�� round, trunc
-- �Ϸ��� ���� 12:00:00�̱� ������ �� �ð��� ������ round ����� ���� ��¥�� ���
-- �ƴ� ��� ���Ϸ� ���. trunc�� ������ ���Ϸ� ���
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD:HH24:MI:ss';
SELECT SYSDATE, ROUND(SYSDATE), TRUNC(SYSDATE) FROM dual;

/*
�� ��ȯ �Լ�
char(n) : ���������� ���ڸ� ����. �ִ밪�� 2000����Ʈ
varchar2(n) : ���ϴ� ������ ���ڸ� ����. �ִ밪�� 4000����Ʈ
number(p, s) : ���� ���� ����. p�� ��ü �ڸ��� 1~38�ڸ����� ����, s�� �Ҽ��� ���� �ڸ��� -84~127���� ����
date : �� 7����Ʈ, bc 4712�� 1�� 1�Ϻ��� ad 9999�� 12�� 31�ϱ����� ��¥�� ������ �� ����
long : ���� ������ ���ڸ� �����ϸ� �ִ� 2gb���� ���� ����
clob : ���� ������ ���ڸ� �����ϸ� �ִ� 4gb���� ���� ����
blob : ���� ������ ���̳ʸ� �����͸� �ִ� 4gb���� ���� ����
raw(n) : ���� ���� �����ͷ� �ִ� 2000����Ʈ���� ���� ����
long law(n) : ���� ���� �����ͷ� �ִ� 2gb���� ���� ����
bfile : �ܺ� ���Ͽ� ����� �����ͷ� �ִ� 4gb���� ���� ����
*/
-- ������(�ڵ�) �� ��ȯ
SELECT 2+'2' FROM dual;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY') "YYYY",
TO_CHAR(SYSDATE, 'RRRR') "RRRR",
TO_CHAR(SYSDATE, 'YY') "YY",
TO_CHAR(SYSDATE, 'RR') "RR",
TO_CHAR(SYSDATE, 'YEAR') "YEAR" FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'MM') "MM",
TO_CHAR(SYSDATE, 'MON') "MON",
TO_CHAR(SYSDATE, 'MONTH') "MONTH" FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD') "DD",
TO_CHAR(SYSDATE, 'DAY') "DAY",
TO_CHAR(SYSDATE, 'DDTH') "DDTH" FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'RRRR-MM-DD:HH24:MI:SS') FROM dual;
select * from student;
SELECT studno, name, TO_CHAR(birthday, 'YY/MM/DD') "BIRTHDAY" FROM student WHERE TO_CHAR(birthday, 'MM')='01';
SELECT empno, ename, TO_CHAR(hiredate, 'YY/MM/DD') "HIREDATE" FROM emp WHERE TO_CHAR(hiredate, 'MM') in ('01', '02', '03'); 

/*
TO_CHAR
9 : 9�� ������ŭ �ڸ��� ����. TO_CHAR(1234, '99999') -> 1234
0 : ���ڸ��� 0���� ä��. TO_CHAR(1234, '009999') -> 001234
$ : $ǥ�ø� �ٿ��� ǥ��. TO_CHAR(1234, '$9999') -> $1234
. : �Ҽ��� ���ϸ� ǥ�� TO_CHAR(1234, '9999.99') -> 1234.00
, : õ ���� ���� ��ȣ�� ǥ�� TO_CHAR(12345, '99,999') -> 12,345
*/
select * from emp;
SELECT empno, ename, sal, comm, TO_CHAR((sal*12)+comm, '999,999') "SALARY" FROM emp WHERE ename='ALLEN';
SELECT name, pay, bonus, TO_CHAR((pay*12)+bonus, '999,999') "TOTAL" FROM professor WHERE deptno=201;
SELECT empno, ename, hiredate, TO_CHAR((sal*12)+comm, '$99,999') "SAL", TO_CHAR((sal*1.15)+comm, '$99,999') "15% UP" FROM emp WHERE COMM IS NOT NULL;
-- TO_NUMBER
SELECT TO_NUMBER('5') FROM dual;
SELECT ASCII('A') FROM dual;
-- TO_DATE
SELECT TO_DATE('14/05/31') FROM dual;

-- �Ϲ� �Լ� : �ԷµǴ� �� ���о��� �� ��� ����

-- NVL : NULL�� ������ �ٸ� ������ ġȯ�ؼ� ���
SELECT ename, comm, NVL(comm, 0), NVL(COMM, 100) FROM emp WHERE deptno=30;
SELECT profno, name, pay, NVL(bonus, 0) "BONUS", TO_CHAR((pay*12)+NVL(bonus, 0),'9,999') "TOTAL" FROM professor WHERE deptno = 201;
-- NVL2 : NULL�� �ƴ� ��� ����� ���� ���� ����
SELECT empno, ename, sal, comm, NVL2(comm, sal+comm, sal*0) "NVL2" FROM emp WHERE deptno=30;
SELECT empno, ename, comm, NVL2(comm, 'Exist', 'NULL') "NVL2" FROM emp WHERE deptno=30;
-- DECODE(A, B, '1', null) : a�� b�� ��� 1�� ���, �ƴ϶�� null�� ���
SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering') "DNAME" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering', 'ETC') "DNAME" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, DECODE(name, 'Audie Murphy', 'BEST!')) "ETC" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, DECODE(name, 'Audie Murphy', 'BEST!', 'GOOD!')) "ETC" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, DECODE(name, 'Audie Murphy', 'BEST!', 'GOOD!'), 'N/A') "ETC" FROM professor;

SELECT name, jumin, DECODE(SUBSTR(jumin, 7, 1), '1', 'MAN', 'WOMAN') "GENDER" FROM student WHERE deptno1=101;
SELECT name, tel, DECODE(SUBSTR(tel, 1 , INSTR(tel, ')')-1), '02', 'SEOUL', '031', 'GYEONGGI', '051', 'BUSAN', '052', 'ULSAN', '055', 'GYEONGNAM') "LOC" FROM student WHERE deptno1=101;

-- CASE : ũ�ų� ���� ������ ó���� ��� ���. �޸��� ������� �ʴ´�
SELECT name, tel, SUBSTR(jumin, 3, 2) "MONTH", CASE 
WHEN SUBSTR(jumin, 3, 2) BETWEEN '01' AND '03' THEN '1/4'
WHEN SUBSTR(jumin, 3, 2) BETWEEN '04' AND '06' THEN '2/4'
WHEN SUBSTR(jumin, 3, 2) BETWEEN '07' AND '09' THEN '3/4'
WHEN SUBSTR(jumin, 3, 2) BETWEEN '10' AND '12' THEN '4/4'
END "Quarter" FROM student;
SELECT empno, ename, sal, CASE
WHEN sal BETWEEN 1 AND 1000 THEN 'LEVEL 1'
WHEN sal BETWEEN 1001 AND 2000 THEN 'LEVEL 2'
WHEN sal BETWEEN 2001 AND 3000 THEN 'LEVEL 3'
WHEN sal BETWEEN 3001 AND 4000 THEN 'LEVEL 4'
WHEN sal >= 4001 THEN 'LEVEL 5'
END "LEVEL" FROM emp;