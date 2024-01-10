-- JOIN : t1테이블에서 a컬럼과 t2테이블에서 d컬럼을 가져와 새로운 결과를 만들어내는 기능
/*
Oracle JOIN문법 : SELECT a.b, c.d FROM t1 a, t2 c WHERE a.b = c.d;
              선행테이블(drive table, inner table) JOIN 후행테이블(driven table, outer table) : 선행테이블은 데이터가 적은 테이블로 해야 빠름
ANSI JOIN문법 : SELECT a.b, c.d FROM t1 a [INNER] JOIN t2 c ON a.b = c.d;
                                          INNER : 조인에 참여하는 모든 테이블에 존재하는 데이터만 출력(기본값이며 입력하지 않아도 됨)
*/


-- Cartesian Product(카티션 곱) : 조인 조건절을 적지 않게 되면 해당 테이블에 대한 모든 데이터를 전부 가져오는 현상
-- join 쿼리 중에 where절에 기술하는 join 조건이 잘못 기술되었거나 아예 없을 경우 발생 => join 작업에 참조되는 테이블 행 수를 모두 곲한 값이 결과로 출력
-- 1. 테스트용 테이블을 생성하고 데이터 입력
CREATE TABLE cat_a (no NUMBER, name VARCHAR2(1));
INSERT INTO cat_a VALUES (1, 'A');
INSERT INTO cat_a VALUES (2, 'B');
CREATE TABLE cat_b (no NUMBER, name VARCHAR2(1));
INSERT INTO cat_b VALUES (1, 'C');
INSERT INTO cat_b VALUES (2, 'D');
CREATE TABLE cat_c (no NUMBER, name VARCHAR2(1));
INSERT INTO cat_c VALUES (1, 'E');
INSERT INTO cat_c VALUES (2, 'F');

-- 2. 생성된 테이블 확인
COL name FOR a5
SELECT * FROM cat_a;
SELECT * FROM cat_b;
SELECT * FROM cat_c;

-- 3. 2개의 테이블로 조인 수행
SELECT a.name, b.name
FROM cat_a a, cat_b b
WHERE a.no = b.no;

-- 4. 2개의 테이블로 카티션 곱을 생성
SELECT a.name, b.name
FROM cat_a a, cat_b b;

-- 5. 3개의 테이블로 정상적인 조인 수행
SELECT a.name, b.name, c.name
FROM cat_a a, cat_b b, cat_c c
WHERE a.no = b.no AND a.no = c.no;

-- 6. 3개 테이블을 조회하되 조인 조건절은 2개 테이블의 조건만으로 카티션 곱을 생성
SELECT a.name, b.name, c.name
FROM cat_a a, cat_b b, cat_c c
WHERE a.no = b.no;

-- 카티션 곱을 사용하는 이유 2가지
-- 1. 데이터를 복제해서 원본 테이블을 반복해서 읽는 것을 피하기 위해
    -- 1.1. 부서 번호가 10번인 사원 정보를 조회
    SELECT empno, ename, job, sal FROM emp WHERE deptno=10;
    -- 1.2. 임의의 3건 추출
    SELECT LEVEL c1 FROM DUAL connect by level <=3;
    -- 1.3. 카티션 곱을 사용하여 부서 번호 10번인 집합 3세트 생성
    SELECT * FROM 
        (SELECT empno, ename, job, sal FROM emp WHERE deptno=10),
        (SELECT LEVEL c1 FROM DUAL connect by level <= 3)
    -- c1이 1일 때 부서 번호 10번 집합 한 세트, 2일 때, 3일 때 총 3개 세트 집합이 생성됨
        -- * 참고 : break on은 sqlplus 툴의 옵션으로 중복된 값은 한 번만 보여주는 기능
        break ON empno;
            SELECT empno,
            -- C1의 값에 따라 제목을 할당
                CASE WHEN C1 = 1 THEN 'ENAME'
                     WHEN C1 = 2 THEN 'JOB'
                     WHEN C1 = 3 THEN 'HIREDATE'
                END TITLE, 
            -- C1의 값에 따라 컬럼을 선택
                CASE WHEN C1 = 1 THEN ename
                     WHEN C1 = 2 THEN job
                     WHEN C1 = 3 THEN hiredate
                END CONTENTS
                FROM
            (SELECT empno, ename, job, sal, to_char(hiredate, 'YYYY/MM/DD') hiredate
                FROM scott.emp WHERE deptno = 10), 
            (SELECT LEVEL c1 FROM DUAL connect by level <= 3) ORDER BY 1,2;
-- 2. 실수로 조인 조건 컬럼 중 일부를 빠뜨리는 경우



-- EQUI Join(등가 조인) : 가장 많이 사용되는 조인 방법.
/*선행 테이블에서 데이터를 가져온 후 조인 조건절을 검사하여 동일한 조건을 가진 데이터를 후행 테이블에서 꺼냄
조건절에서 = 를 사용해서 EQUI Join이라고 함
*/
-- emp 테이블과 dept 테이블을 조회하여 empno, ename, dname을 출력하라
-- Oracle Join 문법
SELECT e.empno, e.ename, d.dname FROM emp e, dept d WHERE e.deptno = d.deptno;
-- ANSI Join 문법
SELECT e.empno, e.ename, d.dname FROM emp e JOIN dept d ON e.deptno = d.deptno;
-- 컬럼 이름이 한 쪽의 테이블에만 있을 경우(dname) 테이블 이름 생략해도 자동으로 테이블 이름을 찾아서 실행
select * from emp;
select * from dept;
SELECT empno, ename, dname FROM emp e, dept d WHERE e.deptno = d.deptno;
-- 양쪽 테이블 모두 있는 컬럼일 경우(deptno) 반드시 테이블 이름을 적지 않으면 에러 발생
SELECT empno, ename, deptno, dname FROM emp e, dept d WHERE e.deptno = d.deptno;
-- 테이블명을 적어줘야 제대로 기능함
SELECT e.empno, e.ename, d.deptno, d.dname FROM emp e, dept d WHERE e.deptno = d.deptno;

-- student와 professor 테이블을 조인하여 학생의 이름과 지도교수의 이름을 출력하라
select * from student;
select * from professor;
SELECT s.name "stu_name", p.name "prof_name" FROM student s JOIN professor p ON s.profno = p.profno;

-- student와 department, professor 테이블을 조인하여 학생의 이름과 학과 이름, 지도교수 이름을 출력하라
select * from department;
SELECT s.name stu_name, d.dname dept_name , p.name prof_name 
--                  첫번째 조인으로 수행한 후 나온 결과를 가지고 두번째 조인을 수행
    FROM student s JOIN department d ON s.deptno1 = d.deptno JOIN professor p ON s.profno = p.profno; 

-- student 테이블을 조회하여 deptno1이 101인 학생들의 이름과 각 학생들의 지도교수 이름을 출력하라
select * from student;
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s JOIN professor p ON s.profno = p.profno AND s.deptno1 = 101;


-- Non-Equi Join(비등가 조인) : 같은 조건이 아닌 크거나 작거나 하는 경우의 조건으로 조회할 때 사용
/*
customer 테이블과 gift 테이블을 조인하여 고객별로 마일리지 포인트를 조회한 후, 
해당 마일리지 점수로 받을 수 있는 상품을 조회하여 고객의 이름과 받을 수 있는 상품명을 출력하라
*/
select * from customer;
select * from gift;
SELECT c.gname CUST_NAME, TO_CHAR(c.point, '999,999') POINT, g.gname GIFT_NAME 
FROM customer c JOIN gift g ON c.point >= g.g_start AND c.point <= g.g_end;

-- student, score, hakjum테이블을 조회하여 학생들의 이름과 점수, 학점을 출력하라
select * from student;
select * from score;
select * from hakjum;
SELECT st.name STU_NAME, sc.total SCORE, h.grade GRADE
FROM student st JOIN score sc ON st.studno = sc.studno JOIN hakjum h ON sc.total >= h.min_point AND sc.total <= h.max_point;

-- 이 위의 조인은 모두 이너 조인
-- OUTER Join(아우터 조인) : 한쪽 테이블에는 데이터가 있고 한쪽 테이블에는 없는 경우 있는 쪽 테이블의 내용을 전부 출력
-- a라는 테이블에 인덱스가 있어도 인덱스를 쓰지 않고 전부 스캔. 조인 순서가 고정되어 사용자의 뜻대로 변경할 수 없음.

-- student, professor 테이블을 조인하여 학생이름과 지도교수 이름을 출력하라. 단, 지도교수가 결정되지 않은 학생의 명단도 함께 출력
-- Oracle Outer Join : 데이터가 없는 쪽에 (+) 표시
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno = p.profno(+);
-- ANSI Outer Join : 데이터가 있는 쪽에 LEFT/RIGHT OUTER JOIN 표시
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s LEFT OUTER JOIN professor P ON s.profno = p.profno;

-- student, professor 테이블을 조인하여 학생이름과 지도교수 이름을 출력하라. 단, 지도학생이 결정되지 않은 교수의 명단도 함께 출력
-- Oracle Outer Join
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno(+) = p.profno;
-- ANSI Outer Join
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s RIGHT OUTER JOIN professor P ON s.profno = p.profno;

-- student, professor 테이블을 조인하여 학생이름과 지도교수 이름을 출력하라. 단, 지도교수 및 지도학생이 결정되지 않은 명단도 전부 출력
-- Oracle Outer Join : WHERE절에서 아우터 조인되는 컬럼 전부 (+)를 붙여줘야 함
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno(+) = p.profno
UNION SELECT s.name STU_NAME, p.name PROF_NAME FROM student s, professor p WHERE s.profno = p.profno(+);
-- ANSI Full Outer Join
SELECT s.name STU_NAME, p.name PROF_NAME FROM student s FULL OUTER JOIN professor P ON s.profno = p.profno;

-- dept 테이블 정보를 모두 출력하고 부서 번호가 20인 사원의 사원번호, 이름, 급여를 출력하라
select * from dept;
select * from emp;
SELECT d.deptno, d.dname, d.loc, e.empno, e.ename, e.sal 
FROM dept d, emp e WHERE d.deptno = e.deptno(+) 
and e.deptno = 20 ORDER BY 1;
-- dept 테이블 정보를 전부 출력하라고 했는데 부서번호가 20인 정보만 출력.

SELECT d.deptno, d.dname, d.loc, e.empno, e.ename, e.sal 
FROM dept d, emp e WHERE d.deptno = e.deptno(+) 
and e.deptno(+) = 20 ORDER BY 1;
-- 부서번호가 10, 20, 40인 dept 테이블 정보 전부 출력됨

-- 직업이 CLERK인 사원 번호, 이름, 직업을 출력하고 그중 CHICAGO에 위치한 부서에 소속된 사원의 부서 번호, 부서명, 위치를 출력하라
select * from emp where job='CLERK';
SELECT e.empno, e.ename, e.job, d.deptno, d.dname, d.loc 
FROM emp e LEFT OUTER JOIN dept d ON (e.deptno = d.deptno and d.loc = 'CHICAGO') WHERE e.job = 'CLERK';

SELECT e.empno, e.ename, e.job, d.deptno, d.dname, d.loc 
FROM emp e LEFT OUTER JOIN dept d ON (e.deptno = d.deptno and d.loc = 'CHICAGO' and e.job = 'CLERK');
-- WHERE의 조건이 없어서 emp 테이블 전체 출력 됨


-- SELF Join : 원하는 데이터가 하나의 테이블에 다 들어있는 경우
-- 원리 : 데이터를 가지고 있는 ㄴ하나의 테이블을 메모리에서 별명을 두 개로 사용하여 호출
-- Oracle Outer Join
SELECT e1.ename "ename", e2.ename "mgr_name" FROM emp e1, emp e2 WHERE e1.mgr = e2.empno;
-- ANSI Outer Join
SELECT e1.ename "ename", e2.ename "mgr_name" FROM emp e1 JOIN emp e2 ON e1.mgr = e2.empno;


-- 연습문제
-- student, department 테이블을 조회하여 학생이름, 1전공 학과번호, 학과이름을 출력하라
select * from student;
select * from department;
-- Oracle Join
SELECT s.name STU_NAME, s.deptno1 DEPTNO1, d.dname FROM student s, department d WHERE s.deptno1 = d.deptno;
-- ANSI Join
SELECT s.name STU_NAME, s.deptno1 DEPTNO1, d.dname FROM student s JOIN department d ON s.deptno1 = d.deptno;

-- emp2, p_grade 테이블을 조회하여 현재 직급이 있는 사원의 이름과 직급, 현재 연봉, 해당 직급의 연봉의 하한 금액과 상한 금액을 출력하라
select * from emp2;
select * from p_grade;
-- Oracle Join
SELECT e.name, e.position, 
TO_CHAR(e.pay, '999,999,999') PAY, TO_CHAR(p.s_pay, '999,999,999') LOW_PAY, TO_CHAR(p.e_pay, '999,999,999') HIGH_PAY
FROM emp2 e, p_grade p WHERE e.position = p.position;
-- ANSI Join
SELECT e.name, e.position, 
TO_CHAR(e.pay, '999,999,999') PAY, TO_CHAR(p.s_pay, '999,999,999') LOW_PAY, TO_CHAR(p.e_pay, '999,999,999') HIGH_PAY
FROM emp2 e JOIN p_grade p ON e.position = p.position;

-- emp2, p_grade 테이블을 조회하여 사원들의 이름, 나이, 현재 직급, 예상 직급을 출력하라
-- 예상 직급은 나이로 계산하고 해당 나이가 받아야하는 직급을 의미함. 나이는 오늘을 기준으로 하되 trunc로 소수점 이하는 절삭하여 계산
-- Oracle Join
SELECT e.name NAME, trunc(months_between(sysdate, e.birthday)/12) AGE, e.position CURR_POSITION, p.position BE_POSITION 
FROM emp2 e, p_grade p 
WHERE trunc(months_between(sysdate, e.birthday) / 12) between p.s_age and p.e_age;
-- ANSI Join
SELECT e.name NAME, trunc(months_between(sysdate, e.birthday)/12) AGE, e.position CURR_POSITION, p.position BE_POSITION 
FROM emp2 e JOIN p_grade p 
ON trunc(months_between(sysdate, e.birthday) / 12) between p.s_age and p.e_age;

/*
customer, gift 테이블을 조인하여 고객이 자기 포인트보다 낮은 포인트의 상품 중 한가지를 선택할 수 있다고 할 때, 
Notebook을 선택할 수 있는 고객명과 포인트, 상품명을 출력하라
*/
select * from customer;
select * from gift;
-- Oracle Join
SELECT c.gname CUST_NAME, c.point POINT, g.gname GIFT_NAME 
FROM customer c, gift g WHERE c.point >= g.g_start and g.gname = 'Notebook';
-- ANSI Join
SELECT c.gname CUST_NAME, c.point POINT, g.gname GIFT_NAME 
FROM customer c JOIN gift g ON c.point >= g.g_start and g.gname = 'Notebook';

/*
professor 테이블에서 교수번호, 이름, 입사일, 자신보다 입사일 빠른 사람 인원수를 출력하라
단, 자신보다 입사일이 빠른 사람 수를 오름차순 순으로 출력
*/
select * from professor;
-- Oracle Join
SELECT p.profno, p.name, TO_CHAR(p.hiredate, 'YYYY/MM/DD') HIREDATE, COUNT(p2.hiredate) COUNT
FROM professor p, professor p2 WHERE p.hiredate > p2.hiredate(+)
GROUP BY p.profno, p.name, p.hiredate ORDER BY 4;
-- ANSI Join
SELECT p.profno, p.name, TO_CHAR(p.hiredate, 'YYYY/MM/DD') HIREDATE, COUNT(p2.hiredate) COUNT
FROM professor p LEFT OUTER JOIN professor p2 ON p.hiredate > p2.hiredate
GROUP BY p.profno, p.name, p.hiredate ORDER BY 4;

/*
emp 테이블에서 사원번호, 이름, 입사일, 자신보다 먼저 입사한 사람 인원수를 출력하라
단, 자신보다 입사일이 빠른 사람 수를 오름차순으로 출력하라
*/
-- Oracle Join
SELECT e.empno EMPNO, e.ename ENAME, TO_CHAR(e.hiredate, 'YY/MM/DD') HIREDATE, COUNT(e2.hiredate) COUNT 
FROM emp e, emp e2 WHERE e.hiredate > e2.hiredate (+) 
GROUP BY e.empno, e.ename, e.hiredate ORDER BY 4;
-- ANSI Join
SELECT e.empno EMPNO, e.ename ENAME, TO_CHAR(e.hiredate, 'YY/MM/DD') HIREDATE, COUNT(e2.hiredate) COUNT 
FROM emp e LEFT OUTER JOIN emp e2 ON e.hiredate > e2.hiredate
GROUP BY e.empno, e.ename, e.hiredate ORDER BY 4;

commit;