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

-- cube : 소계와 전체 합계까지 출력. 컬럼 순서가 바뀌어도 출력물은 같음
explain plan for
SELECT deptno, job, ROUND(AVG(sal),1) avg_sal, COUNT(*) cnt_emp FROM emp GROUP BY CUBE(deptno, job) ORDER BY deptno, job;
col PLAN_TABLE_OUTPUT format a80
select * from table(dbms_xplan.display); -- 왜 안돼??