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