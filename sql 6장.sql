-- INSERT : 테이블에 새로운 데이터 입력할 때 사용, 숫자 이외는 작은따옴표 사용

-- dept2 테이블에 다래와 같은 내용으로 새로운 부서  정보를 입력하세요
-- 부서번호 : 9000, 부서명 : temp_1, 상위부서 : 1006, 지역 : temp area
select * from dept2;
INSERT INTO dept2 (dcode, dname, pdept, area) VALUES(9000, 'temp_1', 1006, 'temp area');
-- 모든 컬럼에 데이터를 삽입할 경우 컬럼명 생략 가능
INSERT INTO dept2 VALUES(9001, 'temp_2', 1006, 'temp area');

-- 부서번호, 부서명, 상위부서 값만 아래의 값으로 입력하세요
-- 9002, temp_3, Business Department(1006번 부서)
INSERT INTO dept2(dcode, dname, pdept) VALUES(9002, 'temp_3', 1006);

-- NULL값 입력하기
-- 자동 : 데이터 입력 시 값을 입력하지 않으면 NULL이 들어감, 수동 : 데이터 입력 시 NULL을 작성

-- 음수 값 입력하기 : t_minus 테이블을 생성 후 음수 값을 입력하는 테스트 진행
CREATE TABLE t_minus (no1 NUMBER, no2 NUMBER(3), no3 NUMBER(3,2));
INSERT INTO t_minus VALUES(1, 1, 1);
INSERT INTO t_minus VALUES(1.1, 1.1, 1.1);
INSERT INTO t_minus VALUES(-1.1, -1.1, -1.1);
select * from t_minus;

-- INSERT와 서브쿼리를 사용하여 여러 행 입력하기(ITAS)
-- 옳지 않은 조건을 주어 일부러 데이터를 입력시키지 않음
CREATE TABLE professor3 AS SELECT * FROM professor WHERE 1=2;
INSERT INTO professor3 SELECT * FROM professor;
select * from professor3;
-- 여러행 입력할 때 두 테이블 컬럼의 개수와 데이터 형이 동일해야 하며 조건을 줄 수도 있음
CREATE TABLE professor4 AS SELECT profno, name, pay FROM professor WHERE 1=2;
INSERT INTO professor4 SELECT profno, name, pay FROM professor WHERE profno > 4000;
select * from professor4;

-- INSERT ALL을 이용한 여러 테이블에 여러 행 입력하기
CREATE TABLE prof_3 (profno NUMBER, name VARCHAR2(25));
CREATE TABLE prof_4 (profno NUMBER, name VARCHAR2(25));

/*
professor 테이블에서 교수번호가 1000~1999번까지인 교수번호, 교수이름은 prof_3 테이블에 입력하고
교수번호가 2000~2999번까지인 교수번호와 이름은 prof_4 테이블에 입력하라
*/
INSERT ALL
    WHEN profno BETWEEN 1000 AND 1999 THEN
        INTO prof_3 VALUES(profno, name)
    WHEN profno BETWEEN 2000 AND 2999 THEN
        INTO prof_4 VALUES(profno, name)
    SELECT profno, name
FROM professor;
select * from prof_3;
select * from prof_4;

/*
prof_3, prof_4 테이블의 데이터를 truncate로 삭제 후 
professor 테이블에서 profno가 3000~3999인 교수의 교수번호, 이름을 prof_3, 4테이블에 동시에 입력하라
*/
TRUNCATE TABLE prof_3;
TRUNCATE TABLE prof_4;
INSERT ALL
    INTO prof_3 VALUES(profno, name)
    INTO prof_4 VALUES(profno, name)
SELECT profno, name FROM professor
WHERE profno BETWEEN 3000 AND 3999;
select * from prof_3;
select * from prof_4;

-- UPDATE : 기존 데이터를 다른 데이터로 변경할 때 사용
-- professor 테이블에서 position이 assistant professor인 교수들의 bonus를 200으로 변경하라
select * from professor;
UPDATE professor SET bonus = 200 WHERE position = 'assistant professor';
select * from professor WHERE position = 'assistant professor';

-- professor 테이블에서 Sharon Stone 교수의 position과 동일한 position을 가진 교수들 중 현재 pay가 250미만인 교수들의 급여를 15%인상하라
UPDATE professor SET pay = pay*1.15 
    WHERE position = (SELECT position FROM professor WHERE name = 'Sharon Stone') 
    AND pay < 250;
select * from professor;

-- DELETE : 데이터 삭제
-- dept2 테이블에서 dcode가 9000~9999인 매장을 삭제하라
DELETE FROM dept2 WHERE dcode BETWEEN 9000 AND 9999;
-- 사실 삭제되는 것이 아니라 보이징낳는 것. BBED툴을 이용하면 복구 가능. 테이블 크기를 확인하면 알 수 있다!

-- MERGE : 여러 테이블의 데이터를 합치는 병합을 의미
-- table1과 table2의 내용을 합쳐 table1로 모으기
/*
MERGE INTO table1 USING table2 ON(병합 조건) 
    WHEN MATCHED THEN UPDATE SET 업데이트 내용 DELETE WHERE 조건
    WHEN NOT MATECHED THEN INSERT VALUES(컬럼 이름);
만약 ON의 조건이 만족(MATCHED)하면 기존 table1의 내용은 table2 내용으로 UPDATE/DELETE수행되고
            불만족(NOT MATCHED)하면 table2의 내용이 table1에 INSERT됨.
*/
-- MERGE가 수행될 때 집계테이블(talbe1)의 데이터와 신규테이블(table2)의 내용을 비교해서 확인함.
-- 이런 특성 때문에 집계 테이블에 데이터가 많아질수록 MERGE의 속도가 느려짐

-- 일별 사용 요금 테이블인 charge1, 2테이블이 있고 집계용 테이블 ch_total 테이블을 생성하고 데이터를 입력하라
CREATE TABLE charge_1 (u_date VARCHAR2(6), cust_no NUMBER, u_time NUMBER, charge NUMBER);
CREATE TABLE charge_2 (u_date VARCHAR2(6), cust_no NUMBER, u_time NUMBER, charge NUMBER);

INSERT INTO charge_1 VALUES('141001', 1000, 2, 1000);
INSERT INTO charge_1 VALUES('141001', 1001, 2, 1000);
INSERT INTO charge_1 VALUES('141001', 1002, 1, 500);
select * from charge_1;

INSERT INTO charge_2 VALUES('141002', 1000, 3, 1500);
INSERT INTO charge_2 VALUES('141002', 1001, 4, 2000);
INSERT INTO charge_2 VALUES('141002', 1003, 1, 500);
select * from charge_2;

CREATE TABLE ch_total (u_date VARCHAR2(6), cust_no NUMBER, u_time NUMBER, charge NUMBER);

-- MERGE 작업 쿼리1(charge_1 + ch_total 병합)
MERGE INTO ch_total total USING charge_1 ch1 ON(total.u_date = ch1.u_date)
    WHEN MATCHED THEN UPDATE SET total.cust_no = ch1.cust_no
    WHEN NOT MATCHED THEN INSERT VALUES(ch1.u_date, ch1.cust_no, ch1.u_time, ch1.charge);
select * from ch_total;
-- MERGE 작업 쿼리2(charge_2 + ch_total 병합)
MERGE INTO ch_total total USING charge_2 ch2 ON(total.u_date = ch2.u_date)
    WHEN MATCHED THEN UPDATE SET total.cust_no = ch2.cust_no
    WHEN NOT MATCHED THEN INSERT VALUES(ch2.u_date, ch2.cust_no, ch2.u_time, ch2.charge);
select * from ch_total;
/*
ch1과 total, ch2와 total에서 u_date가 중복되는 값이 없기 때문에 쿼리가 실행됐으나 
첫번째 쿼리를 다시 실행하면 값이 중복되서 오류 발생
(같은 값이 3개나 있기 때문에 어떤 값과 비교해서 병합할지 모르게 됨)
이런 이유로 병합할 때 일반적으로 집계가 되는 테이블(ch_total)의 조건 컬럼에는 pk나 unique index를 설정
*/

-- UPDATE 조인 : 다른 테이블과 조인하는 경우. WHERE절에만 다른 테이블과 조인하는 경우, WHERE절과 SET절 모두 다른 테이블과 조인하는 경우
-- 일반적인 UPDATE
UPDATE emp SET sal=sal*1.1 WHERE job='CLERK';
SELECT ename, sal FROM emp WHERE job='CLERK';

-- 일반적인 UPDATE 조인 : WHERE절에서 다른 테이블과 조인
select * from dept;
UPDATE emp e SET sal=sal*1.1
WHERE EXISTS (
SELECT 1 FROM dept d WHERE d.loc='DALLAS' AND e.deptno = d.deptno);
select * from emp;

-- 테스트를 위한 dept_hist 테이블 생성
CREATE TABLE dept_hist ( 
    empno NUMBER(4), -- 사원번호 PK1
    appointseqno NUMBER(4), -- 발령순번 PK2
    deptno NUMBER(2), -- 부서번호
    appointdd DATE);
    
ALTER TABLE DEPT_HIST
ADD CONSTRAINT PK_DEPT_HIST PRIMARY KEY (empno, appointseqno);

-- 테스트 데이터로 deptno가 20인 사원의 발령 부서 번호를 99로 데이터를 INSERT
INSERT INTO DEPT_HIST
SELECT empno, 1 appointseqno, 99 deptno, SYSDATE APOINTDD FROM emp WHERE deptno=20;
select * from DEPT_HIST;
commit;

-- emp 테이블에 존재하지 않는 사원번호 2건을 INSERT
INSERT INTO DEPT_HIST VALUES(9322, 1, 99, SYSDATE);
INSERT INTO DEPT_HIST VALUES(9414, 1, 99, SYSDATE);
select * from DEPT_HIST;
commit;

-- 99는 존재하지 않는 부서번호이기 때문에 emp테이블에 현재 소속 부서 번호로 update
SELECT e.empno, e.deptno tobe_deptno, d.deptno asis_deptno
    FROM emp e, dept_hist d
    WHERE e.empno = d.empno;

/*
부서번호 99를 20으로 UPDATE : UPDATE하기 전에 SELECT로 
UPDATE할 대상 컬럼 값(tobe_deptno)과 UPDATE하려는 컬럼값(asis_deptno)을 조회
(실수하지 않도록)
*/

-- 사원 테이블에 존재하는 사원 중 현재 소속된 부서 번호 UPDATE
UPDATE DEPT_HIST d SET d.deptno = (
    SELECT e.deptno FROM emp e WHERE e.empno = d.empno);
select * from DEPT_HIST;
-- 존재하지 않는 사원 즉, UPDATE 원하지 않은 사원도 deptno가 null로 UPDATE됨 
-- 이런 현상 때문에 set절에 조인 테이블이 있는 경우 주의해야함
commit;

-- 원하는 emp 테이블에 존재하는 사원 번호에 대해서만 UPDATE 대상 범위를 정하고 UPDATE
UPDATE DEPT_HIST d SET d.deptno = (
    SELECT e.deptno FROM emp e WHERE e.empno = d.empno)
WHERE EXISTS(
    SELECT 1 FROM emp e WHERE e.empno = d.empno);
select * from DEPT_HIST;
-- emp 테이블을 두 번 읽는 구조가 되어버린다
-- WHERE절에서 이 UPDATE 대상 범위를 지정하지 않으면 조인되지 않은 대상은 NULL로 UPDATE됨 

-- 오라클에서는 비교 테이블을 한 번만 읽는 방법으로 UPDATE JOIN VIEW와 MERGE를 제공, 보통은 MERGE 사용
MERGE INTO DEPT_HIST d USING emp e ON (e.empno = d.empno)
WHEN MATCHED THEN UPDATE SET d.deptno = e.deptno;
commit;
select * from dept_hist;

-- TRANSACTION(논리적인 작업 단위, DML 작업들을 하나의 단위로 묶어둔 것) 관리하기
/*
해당 트랜잭션 내에 있는 모든 DML이 성공해야 해당 트랜잭션이 성공함, 하나라도 실패하면 전체가 실패
트랜잭션의 시작은 DML이고 완려하려면 TCL, DCL, DDL을 입력하면 됨
commit : 트랜잭션 내의 작업의 결과를 확정하는 명령어
rollback : 트랜잭션 내의 모든 명령어를 취소하는 명령어
DML을 작업한 후에는 반드시 COMMIT/ROLLBACK 명령을 수행해야 작업이 마무리 됨
*/

-- DELETE로 삭제 후 테이블 용량 확인
-- 테스트용 테이블을 생성하고 대량의 데이터를 입력
ALTER DATABASE DATAFILE 'C:\neworacle\oradata\TESTDB\UNDOTBS01.DBF' autoextend on;

CREATE TABLE scott.reorg (no NUMBER, name VARCHAR2(20), addr VARCHAR2(20));

BEGIN
    FOR i IN 1..500000 LOOP 
        INSERT INTO scott.reorg
        VALUES (i, DBMS_RANDOM.STRING('B', 19), DBMS_RANDOM.STRING('H', 19));
    END LOOP;
    COMMIT;
END;

SELECT COUNT(*) FROM scott.reorg;

-- 테이블 크기를 측정
ANALYZE TABLE scott.reorg COMPUTE STATISTICS;

SELECT SUM(BYTES)/1024/1024 MB 
FROM dba_segments 
WHERE owner='SCOTT' 
AND segment_name='REORG'; -- 용량 28mb

SELECT table_name, num_rows, blocks, empty_blocks 
FROM dba_tables
WHERE owner='SCOTT' 
AND table_name='REORG';
-- num_rows : 데이터 건수, blocks : 사용 중인 block의 개수, empty_blocks : 빈 블록 개수

SELECT COUNT(DISTINCT DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid)||DBMS_ROWID.ROWID_RELATIVE_FNO(rowid)) "REAL USED"
FROM scott.reorg;

-- 데이터 삭제 후 테이블 크기 확인
DELETE FROM scott.reorg;
commit;
select count(*) from scott.reorg; -- 데이터가 없음을 확인

SELECT SUM(BYTES)/1024/1024 MB 
FROM dba_segments 
WHERE owner='SCOTT' 
AND segment_name='REORG'; -- 용량은 그대로 28mb

SELECT COUNT(DISTINCT DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid)||DBMS_ROWID.ROWID_RELATIVE_FNO(rowid)) "REAL USED"
FROM scott.reorg; -- 실제 사용하는 블럭은 0

-- 용량까지 줄이고 싶으면 reorg 작업을 별도로 해야함
-- DELETE 후 TABLE REORG(재구성) 하기
-- reorg 테이블에 데이터 추가
BEGIN
    FOR i IN 1..50000 LOOP 
        INSERT INTO scott.reorg
        VALUES (i, DBMS_RANDOM.STRING('B', 19), DBMS_RANDOM.STRING('H', 19));
    END LOOP;
    COMMIT;
END;
-- reorg 테이블에서 데이터 10000건 삭제
DELETE FROM scott.reorg WHERE no BETWEEN 1 AND 10000;
commit;

SELECT COUNT(*) FROM scott.reorg;
SELECT SUM(BYTES)/1024/1024 MB 
FROM dba_segments 
WHERE owner='SCOTT' 
AND segment_name='REORG';

-- 테이블 reorg(리오그-재구성) 작업 실행 : 테이블 스페이스를 이동시키는 방법 사용
SELECT table_name, tablespace_name FROM dba_tables WHERE table_name='REORG'; -- 현재 EXAMPLE 테이블 스페이스에 위치
ALTER TABLE scott.reorg MOVE TABLESPACE EXAMPLE;

SELECT SUM(BYTES)/1024/1024 MB 
FROM dba_segments 
WHERE owner='SCOTT' 
AND segment_name='REORG'; -- 용량이 3MB로 줄어든 것을 확인할 수 있음
select count(*) from scott.reorg; -- 데이터는 5000에서 1000을 제한 4000이 남음

-- p.321 연습문제
-- dept2 테이블에 새로운 부서 정보를 입력하라
-- deptno : 9010, dname : temp_10, pdept : 1006, area : temp area
select * from dept2;
INSERT INTO dept2 VALUES(9010, 'temp_10', 1006, 'temp area');

-- dept2 테이블에 특정 컬럼에만 정보를 입력하라
INSERT INTO dept2(dcode, dname, pdept) VALUES(9020, 'temp_20', 1006);
select * from dept2;

/*
professor 테이블에서 profno가 3000번 이하의 교수들의 profno, name, pay를 가져와서 
professor4 테이블에 한꺼번에 입력하는 쿼리를 사용하라(ITAS 방법 사용)
*/
SELECT profno, name, pay FROM professor WHERE profno <= 30000;
INSERT INTO professor4 SELECT profno, name, pay FROM professor WHERE profno <= 30000;
select * from professor4;

-- professor 테이블에서 Sharon Stone 교수의 bonus를 100 추가하라
SELECT * FROM professor WHERE name='Sharon Stone';
UPDATE professor SET bonus = bonus+100 WHERE name='Sharon Stone';
commit;



