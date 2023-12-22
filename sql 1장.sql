SELECT * FROM emp;
-- 전체 컬럼이 있는지 조회
DESC dept;
-- 원하는 컬럼만 조회
SELECT empno, ename FROM emp;

-- 한 화면에 출력 가능한 줄 길이 설정(가로 길이 설정)
-- SET SIZELINE 100
-- 한 페이지에 출력 가능한 줄 수 설정(세로 길이 설정)
SET PAGESIZE 50
-- 데이터가 문자일 경우 20바이트까지 들어가게 설정
COL name FOR a20

SELECT * FROM professor;

-- select에 표현식을 사용하여 출력
--              표현식       ,     컬럼명
SELECT name, 'good morning~', 'Good Morning' FROM professor;
--              '출력 위해 ''로 사용
SELECT dname, ',it''s deptno: ', deptno "DNAME AND DEPTNO" FROM dept;
-- q와 대괄호를 이용하는 방법
SELECT dname, q'[, it's deptno :]', deptno "DANME AND DEPTNO" FROM dept;

-- 컬럼 별칭 사용하여 출력
-- 오리지널 출력
SELECT profno, name, pay FROM professor;
-- 별칭 사용 : 한칸 띄고 큰따옴표+별칭, 한칸 띄고 AS+큰따옴표+별칭
SELECT profno "Prof's NO", name AS "Prof's NAME", pay Prof_Pay FROM professor;

-- DISTINCT : 중복 값을 제거하고 출력
SELECT deptno FROM emp;
SELECT DISTINCT deptno FROM emp;

SELECT job, ename FROM emp ORDER BY 1,2;
-- DISTINCT는 1개의 컬럼에만 적어도 모든 컬럼에 적용됨
SELECT DISTINCT job FROM emp;
SELECT DISTINCT job, ename FROM emp ORDER BY 1,2;

-- 연결 연산자로 컬럼 붙여서 출력 : 연결된 컬럼은 1개로 인식
SELECT ename ||'-'|| job FROM emp;
SELECT ename ||'-'|| job as "name and job" FROM emp;

-- p39
-- 연습문제 1
desc student;
SELECT name||'''s id:'||id||' , weight is '||weight||'kg' "id and weight" from student;
-- 연습문제 2
desc emp;
select ename||'('||job||'), '||ename||''''||job||'''' "name and job" from emp;
-- 연습문제 3
select ename||'''s sal is $'||sal "name and sal" from emp;

-- WHERE: 원하는 조건만 골라내기
SELECT empno, ename FROM emp WHERE empno=7900;
SELECT ename, sal FROM emp WHERE sal <900;
-- 문자 조회 시 대소문자 구분
SELECT empno, ename, sal FROM emp WHERE ename='SMITH';
SELECT empno, ename, sal FROM emp WHERE ename='smith';
SELECT ename, hiredate FROM emp WHERE ename='SMITH';
-- 날짜 조회 시 반드시 작은따옴표 사용
SELECT empno, ename, hiredate, sal FROM emp WHERE hiredate='80/12/17';

-- 산술 연산자 사용
SELECT ename, sal, sal+100 FROM emp WHERE deptno=10;
SELECT ename, sal, sal*1.1 FROM emp WHERE deptno=10;

-- 다양한 연산자 활용
/*
=   같은 조건 검색
!=  같지 않은 조건 검색
>, <    큰, 작은 조건 검색
>=, <=  크거나 같은, 작거나 같은 조건 검색
between a and b     a와 b 사이에 있는 범위 값 모두 검색
in(a,b,c)   a / b / c인 조건 검색(= 조건 a+b+c인 값 검색)
like    특정 패턴을 가지고 있는 조건 검색
is null/ is not null    null 값 검색/ null 아닌 값 검색
a and b     조건 a와 b 모두를 만족하는 값 검색
a or b      조건 a 혹은 b를 만족하는 값 검색
not a       a가 아닌 모든 조건 검색
*/
-- 비교 연산자
SELECT empno, ename, sal FROM emp WHERE sal >=4000;
SELECT empno, ename, sal FROM emp WHERE ename>='W';
-- 날짜는 최근 날짜가 큰 날짜, 이전 날짜일수록 작은 날짜
SELECT ename, hiredate FROM emp WHERE hiredate >= '81/12/25';
-- between으로 구간 데이터 조회(이상 이하)
SELECT empno, ename, sal FROM emp WHERE sal between 2000 and 3000;
-- 특정 구간 값을 검색할 때 between보다는 비교연산자를 권장
SELECT empno, ename, sal FROM emp WHERE sal >= 2000 and sal <= 3000;
SELECT ename FROM emp WHERE ename BETWEEN 'JAMES' and 'MARTIN' ORDER BY ename;
-- in 연산자로 여러 조건 간편하게 검색
SELECT empno, ename, deptno FROM emp WHERE deptno IN (10, 20);
-- like 연산자로 비슷한 것들 모두 찾기
-- % : 글자 수에 제한이 없고(0개 포함) 어떤 글자가 와도 상관 없음
-- _ : 글자 수는 한글자만 올 수 있고 어떤 글자가 와도 상관 없음
SELECT empno, ename, hiredate FROM emp;
SELECT empno, ename, sal FROM emp WHERE sal LIKE '1%';
SELECT empno, ename, sal FROM emp WHERE ename LIKE 'A%';
-- 절대로 _와 %를 LIKE 바로 다음에 쓰면 안된다
SELECT empno, ename, hiredate FROM emp WHERE hiredate LIKE '___12%';
-- is null / is not null, null에는 = 을 쓸 수 없다
SELECT empno, ename, comm FROM emp;
SELECT empno, ename, comm FROM emp WHERE comm is null;
SELECT empno, ename, comm FROM emp WHERE comm is not null;
-- 검색 조건이 두 개 이상일 경우 조회
SELECT ename, hiredate, sal FROM emp WHERE hiredate > '82/01/01' AND sal >= 1300;
-- 사용자에게 조건을 &를 사용하여 입력받아 조건에 맞는 값 출력
SELECT empno, ename, sal FROM emp WHERE empno=&empno;

-- ORDER BY : 정렬하여 출력(기본 오름차순), asc:오름차순(숫자가 올라감) desc:내림차순
-- 되도록 order by는 쓰지 않도록하자
SELECT ename, sal, hiredate FROM emp ORDER BY ename;
SELECT deptno, sal, ename FROM emp ORDER BY deptno ASC, sal DESC;
-- 정렬할 컬럼을 컬럼명이 아닌 컬럼 순서로 표기
select * from emp;
SELECT ename, sal, hiredate FROM emp WHERE sal>1000 ORDER BY 3;

-- 집합 연산자
/*
union : 두 집합의 결과를 합쳐서 출력, 중복 값 제거하고 정렬
union all : 두 집합의 결과를 합쳐서 출력, 중복 값 제거하지 않고 정렬도 하지않음
intersect : 두 집합의 교집합 결과를 출력 및 정렬
minus : 두 집합의 차집합 결과를 출력 및 정렬, 쿼리의 순서가 중요
*/
/*
주의사항
1. 두 집합의 select 절에 오는 컬럼 개수가 동일해야 함
2. 두 집합의 select 절에 오는 컬럼의 데이터 형이 동일해야 함
3. 두 집합의 컬럼명은 달라도 상관없음
*/
