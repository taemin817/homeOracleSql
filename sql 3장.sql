-- 복수행(그룹) 함수 : 여러 건의 데이터를 동시에 입력 받아 1건의 결과 반환
/*
count : 입력되는 데이터의 총 건수를 출력 count(sal)
sum : 입력되는 데이터의 합계 값을 구해서 출력 sum(sal)
avg : 입력되는 데이터의 평균 값을 구해서 출력 avg(sal)
max : 입력되는 데이터 중 가장 큰 값을 출력 max(sal)
min : 입력되는 데이터 중 가장 작은 값을 출력 min(sal)
stddev : 입력되는 데이터 값들의 표준 편차값을 출력 stddev(sal)
variance : 입력되는 데이터 값들의 분산값을 출력 variance(sal)
rollup : 입력되는 데이터의 소계값을 자동으로 계산해서 출력
groupingset : 한 번의 쿼리로 여러 개의 함수들을 그룹으로 수행 가능
listagg, pivot, lag, lead, rank, dense_rank
*/
-- count : 입력되는 총 건수를 출력
SELECT COUNT(*), COUNT(comm) FROM emp;
-- sum : 입력된 데이터들의 합계 값을 출력
SET null --null-- ;
SELECT COUNT(comm), SUM(comm) FROM emp;
-- avg : 입력된 데이터들의 평균 값을 출력
SELECT COUNT(comm), SUM(comm), AVG(comm) FROM emp;
-- max, min : 여러 건의 데이터를 입력받아 순서대로 정렬하기 때문에 시간이 오래 걸리기 때문에 사용에 주의. 대신 인덱스 추천
SELECT MAX(sal), MIN(sal) FROM emp;
SELECT MAX(hiredate) "MAX", MIN(hiredate) "MIN" FROM emp;
-- stddev : 표준편자, variance : 분산
SELECT ROUND(STDDEV(sal), 2), ROUND(VARIANCE(sal), 2) FROM emp;

/*
GROUP BY : 특정 조건으로 세부적인 그룹화.
SELECT에 사용된 그룹 함수 이외의 컬럼이나 표현식은 반드시 GROUP BY절에 사용되어야 함(필수 조건).
반대로 GROUP BY에 사용된 컬럼이라도 SELECT에 사용되지 않아도 됨(충분 조건).
GROUP BY에는 반드시 컬럼명이 사용되어야 함.
*/
-- emp테이블을 조회하여 부서별로 평균 급여 금액 출력
SELECT deptno, AVG(NVL(sal, 0)) "AVG" FROM emp GROUP BY deptno;
-- 부서별로 먼저 그룹을 짓고 같은 학과일 경우 직급별로 한 번더 분류하여 평균 급여 출력
SELECT deptno, job, AVG(NVL(sal, 0)) "AVG_SAL" FROM emp GROUP BY deptno, job;
-- 첫번째 컬럼, 두번째 컬럼을 정렬시켜서 출력
SELECT deptno, job, AVG(NVL(sal, 0)) "AVG_SAL" FROM emp GROUP BY deptno, job ORDER BY 1, 2;

-- having : gruoping한 조건으로 검색. WHERE에 그룹함수를 비교조건으로 사용 불가하기때문에 사용
SELECT deptno, AVG(NVL(sal, 0)) FROM emp WHERE deptno > 10 GROUP BY deptno HAVING AVG(NVL(sal, 0)) > 2000;

-- 분석(analytic)/윈도 함수 : 행끼리 연산이나 비교를 쉽게 지원해주기 위한 함수
-- rollup : 각 기준별 소계를 요약해서 보여줌. 계층적 분류를 포함하고 있는 데이터의 집계에 적합. 지정된 컬럼의 순서가 바뀌면 결과도 바뀜
explain plan for
SELECT deptno, NULL job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY deptno
UNION ALL
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY deptno, job
UNION ALL
SELECT NULL deptno, NULL job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
-- 아래 문장으로 emp 테이블을 3번 읽은 것을 확인할 수 있다
select * from table(dbms_xplan.display);

-- 위의 문장은 너무 길다...아래처럼 ROLLUP으로 줄일 수 있다
explain plan for
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY ROLLUP(deptno, job);
col PLAN_TABLE_OUTPUT format a80
-- 아래 문장으로 emp 테이블을 1번만 읽은 것을 확인할 수 있다
select * from table(dbms_xplan.display);

-- position별로 먼저 분류 후 같은 deptno가 있을 경우 deptno별로 rollup
SELECT deptno, position, COUNT(*), SUM(PAY) FROM professor GROUP BY position, ROLLUP(deptno);
-- deptno별로 먼저 분류 후 같은 position이 있을 경우 position별로 rollup
SELECT deptno, position, COUNT(*), SUM(PAY) FROM professor GROUP BY deptno, ROLLUP(position);

CREATE TABLE professor2 AS SELECT deptno, position, pay FROM professor;
insert into professor2 VALUES(101, 'instructor', 100);
insert into professor2 VALUES(101, 'a full professor', 100);
insert into professor2 VALUES(101, 'assistant professor', 100);
select * from professor2 ORDER BY deptno, position;

-- deptno별로 먼저 분류 후 같은 position이 있을 경우 position별로 pay소계값을 구하기
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
-- cube : 소계와 전체 합계까지 출력. 컬럼 순서가 바뀌어도 출력물은 같음
explain plan for
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY CUBE(deptno, job) ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
select * from table(dbms_xplan.display); -- 안되는 것 같은데...흠

-- grouping sets : grouping 조건이 여러 개일 경우 사용
/*
student테이블에서 학년별로 학생들의 인원 수 합계와 학과별 인원 수의 합계를 구해야 하는 경우
기존에는 학년별로 인원 수 합계를 구하고 별도로 학과별 인원 수 합계를 구한 후 union해야 했음
*/
SELECT grade, COUNT(*) FROM student GROUP BY grade
UNION SELECT deptno1, COUNT(*) FROM student GROUP BY deptno1;
-- grouping sets 사용
SELECT grade, deptno1, COUNT(*) FROM student GROUP BY GROUPING SETS(grade, deptno1);
-- student 테이블에서 학년별, 학괍ㄹ로 인원수와 키의 합계 몸무게의 합계 동시 출력
SELECT grade, deptno1, COUNT(*), SUM(height), SUM(weight) FROM student GROUP BY GROUPING SETS(grade, deptno1);

-- listagg : 쉽게 grouping 해줌. 4000바이트가 넘으면 오류 발생. 그 경우 XMLAGG XML 사용
-- 나열하고 싶은 컬럼을 적고 데이터들을 구분할 구분자를 '' 사이에 기록. WITHIN GROUP에 가로로 나열하고 싶은 규칙을 ORDER BY로 기록.
SET line 200
COL LISTAGG FOR a50
SELECT deptno, LISTAGG(ename, '->') WITHIN GROUP(ORDER BY hiredate) "LISTAGG" FROM emp GROUP BY deptno;
-- xmlagg xml : 데이터를 내부적으로 xml형태로 만듦. varchar2, clob형태가 있음
--                          xml 태그명(임의), 구분자, 대상 컬럼명                          varchar2일 때 getStringVal
SELECT deptno, SUBSTR(XMLAGG(XMLELEMENT(X, ',', ename) ORDER BY ename).EXTRACT('//text()').getStringVal(), 2) 
AS DEPT_ENAME_LIST FROM emp A GROUP BY deptno;
--                          xml 태그명(임의), 구분자, 대상 컬럼명                          clob일 때 getClobVal
SELECT deptno, SUBSTR(XMLAGG(XMLELEMENT(X, ',', ename) ORDER BY ename).EXTRACT('//text()').getClobVal(), 2) 
AS DEPT_ENAME_LIST FROM emp A GROUP BY deptno;

-- pivot : row단위를 column으로, unpivot : column단위를 row로 변경
select * from cal;
-- pivot 기능을 사용하지 않고 decode 함수를 활용하여 달력 만들기
-- 기본 조회
SELECT
DECODE(day, 'SUN', dayno) SUN, 
DECODE(day, 'MON', dayno) MON, 
DECODE(day, 'TUE', dayno) TUE, 
DECODE(day, 'WED', dayno) WED, 
DECODE(day, 'THU', dayno) THU, 
DECODE(day, 'FRI', dayno) FRI, 
DECODE(day, 'SAT', dayno) SAT 
FROM cal;
-- 데이터가 문자로 되어있어서 아스키코드로 변경되어 비교되는데 두글자 이상일 경우 가장 앞 글자만 변환해서 비교함
SELECT
MAX(DECODE(day, 'SUN', dayno)) SUN, 
MAX(DECODE(day, 'MON', dayno)) MON, 
MAX(DECODE(day, 'TUE', dayno)) TUE, 
MAX(DECODE(day, 'WED', dayno)) WED, 
MAX(DECODE(day, 'THU', dayno)) THU, 
MAX(DECODE(day, 'FRI', dayno)) FRI, 
MAX(DECODE(day, 'SAT', dayno)) SAT
FROM cal;
-- weekno로 grouping, 정렬되지 않은 채 출력
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
-- ORDER BY로 정렬
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

-- pivot 기능을 사용하여 달력 만들기
/*
PIVOT 절에 MAX(dayno) 절은 DECODE 문장에서 사용되는 함수를,
FOR 절에는 화면에 집계될 grouping할 컬럼을 작성.
IN 연산자 뒤에는 서브쿼리 사용 불가
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

-- emp 테이블에서 부서별로 각 직급별 인원이 몇 명인지 계산하기
-- 단계별로 살펴보자
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
-- 0이 부서의 직급별로 몇 개인지
SELECT deptno, 
COUNT(DECODE(job, 'CLERK', '0')) "CLERK", 
COUNT(DECODE(job, 'MANAGER', '0')) "MANAGER", 
COUNT(DECODE(job, 'PRESIDENT', '0')) "PRESIDENT", 
COUNT(DECODE(job, 'ANALYST', '0')) "ANALYST", 
COUNT(DECODE(job, 'SALESMAN', '0')) "SALESMAN"
FROM emp GROUP BY deptno;
-- ORDER BY로 정렬
SELECT deptno, 
COUNT(DECODE(job, 'CLERK', '0')) "CLERK", 
COUNT(DECODE(job, 'MANAGER', '0')) "MANAGER", 
COUNT(DECODE(job, 'PRESIDENT', '0')) "PRESIDENT", 
COUNT(DECODE(job, 'ANALYST', '0')) "ANALYST", 
COUNT(DECODE(job, 'SALESMAN', '0')) "SALESMAN"
FROM emp GROUP BY deptno ORDER BY deptno;

-- unpivot : 합쳐져 있는 것을 풀어서 보여주는 역할
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

-- lag : 이전 행 값을 가져올 때 사용




commit;