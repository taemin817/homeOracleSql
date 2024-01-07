/*
emp 테이블을 조회하여 사원 중 sal와 comm를 합친 금액이 가장 많은 경우와 가장 적은 경우, 평균 금액을 구하라.
단, comm이 없을 경우 0으로 계산하고 출력 금액은 모두 소수점 첫째 자리까지만
*/
SELECT 
    MAX(sal+NVL(comm, 0)) MAX, 
    MIN(sal+NVL(comm, 0)) MIN, 
    ROUND(AVG(sal+NVL(comm, 0)), 1) AVG 
FROM emp;

/*
student 테이블의 birthday를 참조하여 월별로 생일자 수를 출력하라.
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
student 테이블의 tel을 참고하여 지역별 인원수를 출력하라.
단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM으로
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
먼저 emp 테이블에 아래 두 건의 데이터를 입력한 후 emp 테이블을 조회하여 부서별, 직급별 급여 합계 결과를 출력하라.
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
    -- NVL2 : job이 null이 아니면 sal반환하고 null이면 0 반환
    SUM(NVL2(job, sal, 0)) "TOTAL" -- 직급별 합계
FROM emp
      -- rollup(deptno) : 부서별(컬럼) 합계
GROUP BY ROLLUP(deptno) ORDER BY deptno;
DELETE FROM emp WHERE ename IN ('Tiger','Cat');
/*
emp 테이블을 조회하여 직원들의 급여와 전체 급여의 누적 급여금액을 출력하라. 단, 급여를 오름차순으로 정렬.
                                        sum() over
*/
SELECT deptno, ename, sal, SUM(sal) OVER(ORDER BY sal) TOTAL FROM emp;

/*
fruit 테이블을 출력하라.
*/
SELECT SUM(DECODE(name, 'apple', price)) APPLE, 
       SUM(DECODE(name, 'grape', price)) GRAPE, 
       SUM(DECODE(name, 'orange', price)) ORANGE
FROM fruit;

/*
student 테이블의 tel 컬럼을 사용해 지역별 인원수와 전체 대비 차지하는 비율을 출력하라.
단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM으로
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
emp 테이블을 조회하여 부서별로 급여 누적 합계를 출력하라. 단, 부서 번호로 오름차순으로
*/
SELECT deptno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal) TOTAL FROM emp;

/*
emp 테이블을 조회하여 전체 직원 급여 총액에서 각 사원의 급여액의 비율을 출력하라. 단, 급여비중을 내림차순으로
*/
SELECT deptno, ename, sal, 
    SUM(sal) OVER() TOTAL_SAL, 
    ROUND(RATIO_TO_REPORT(SUM(sal)) OVER()*100, 2) "%" 
FROM emp GROUP BY deptno, ename, sal ORDER BY sal desc;

/*
emp 테이블을 조회하여 부서 급여 총액에서 각 사원들의 급여액 비율을 출력하라. 단, 부서 번호 오름차순으로
*/
SELECT deptno, ename, sal, 
    SUM(sal) OVER(PARTITION BY deptno) SUM_DEPT, 
    ROUND(RATIO_TO_REPORT(SUM(sal)) OVER(PARTITION BY deptno)*100, 2) "%" 
FROM emp GROUP BY deptno, ename, sal;

/*
loan 테이블을 조회하여 1000번 지점의 대출 내역을 대출일자, 대출종목코드, 대출건수, 대출총액, 누적대출금액을 출력하라
*/
SELECT * FROM loan;
SELECT l_date 대출일자, l_code 대출종목코드, l_qty 대출건수, l_total 대출총액, 
    SUM(l_total) OVER(ORDER BY l_date) 누적대출금액 FROM loan WHERE l_store = 1000;

/*
loan 테이블을 조회하여 전체 지점의 대출종목코드, 대출지점, 대출일자, 대출건수, 대출액과 대출코드와 대출지점별 누적 합계를 출력하라
*/
SELECT l_code 대출종목코드, l_store 대출지점, l_date 대출일자, l_qty 대출건수, l_total 대출액,
    SUM(l_total) OVER(PARTITION BY l_code, l_store ORDER BY l_date) 누적대출금액 FROM loan;

/*
loan 테이블을 조회하여 1000번 지점의 대출내역을 대출종목코드별로 합쳐서 대출일자, 코드, 대출건수, 대출총액, 누적대출금액을 출력하라
*/
SELECT l_date 대출일자, l_code 대출종목코드,  l_qty 대출건수, l_total 대출액,
    SUM(l_total) OVER(PARTITION BY l_code ORDER BY l_qty) 누적대출금액 FROM loan WHERE l_store = 1000;

/*
professor 테이블에서 각 교수들의 급여를 구하고 그 급여액이 전채 교수의 급여 합계에서 차지하는 비율을 출력하라
*/
SELECT * FROM professor;
SELECT deptno, name, pay, SUM(pay) OVER() "TOTAL PAY", ROUND(RATIO_TO_REPORT(SUM(PAY)) OVER()*100, 2) "RATIO %"
FROM professor GROUP BY deptno, name, pay ORDER BY pay DESC;

/*
professor 테이블을 조회하여 학과번호, 교수명, 급여, 학과별 급여 합계를 구하고 각 교수의 급여가 해당 학과별 급여 합계에서 차지하는 비율을 출력하라
*/
SELECT deptno, name, pay, SUM(PAY) OVER(PARTITION BY deptno) TOTAL_DEPTNO, 
    ROUND(RATIO_TO_REPORT(SUM(PAY)) OVER(PARTITION BY deptno)*100, 2) "RATIO %"
FROM professor GROUP BY deptno, name, pay;


commit;