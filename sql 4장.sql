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


/*
EQUI Join(등가 조인) : 가장 많이 사용되는 조인 방법.
선행 테이블에서 데이터를 가져온 후 조인 조건절을 검사하여 동일한 조건을 가진 데이터를 후행 테이블에서 꺼냄
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


-- Non-Equi Join(비등가 조인)


commit;