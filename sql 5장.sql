/*
DDL(DATA DEFINITION LANGUAGE) : CREATE(생성), CALTER(수정), TRUNCATE(잘라내기), DROP(삭제)
DML(DATA MANUPLATION LANGUAGE) : INSERT(입력), UPDATE(변경), DELETE(삭제), MERGE(병합)
DCL(DATA CONTROL LANGUAGE) : GRANT(권한 주기), REVOKE(권한 뺏기)
TCL(TRANSACTION CONTROL LANGUAGE) : COMMIT(확정), ROLLBACK(취소)
SELECT : 어떤 분류에서는 DQL(DATA QUERY LANGUAGE)이라고도 함
*/
/*
오브젝트 : 오라클 디비 내부에 데이터를 관리하기 위한 다양한 저장 객체
세그먼트 : 오브젝트 중에 특별히 데이터를 저장하기 위한 별도의 저장 공간을 가지는 것
*/

-- CREATE : 새로운 오브젝트나 스키마를 생성할 때 사용
/*
주의사항
테이블 이름은 반드시 문자로 시작. 숫자로 불가 특문 가능하지만 큰따옴표 필요
테이블이나 컬럼 이름은 최대 30바이트. 한글로는 15자까지
테이블명은 한 사용자 안에서 중복 불가
테이블 및 오브젝트 이름을 오라클이 사용하는 키워드 사용 금지
*/
-- 일반적인 테이블 생성
CREATE TABLE new_table (no NUMBER(3), name VARCHAR2(10), birth DATE);
-- no 컬럼은 숫자만 가능하며 최대 3자리
-- name 컬럼은 가변형 문자만 가능하며 최대 10바이트
-- birth 컬럼은 날짜만 가능

-- 기본 입력값을 설정하면서 생성
CREATE TABLE tt02 (no NUMBER(3, 1) DEFAULT 0, name VARCHAR2(10) DEFAULT 'NO NAME', birth DATE DEFAULT SYSDATE);
INSERT INTO tt02 (no) VALUES(1);
select * from tt02;

-- Global Temporary Table(임시 테이블) 생성하기 : 디비에 저장할 목적이 아닌 임시 작업용 데이터를 저장하기 위해 만들어짐, 테스트용
/*
1. 뷰처럼 테이블을 생성하면 그 정의만 딕셔너리에 저장되어 있다가 사용자가 해당 테이블에 접근하면 메모리상에 해당 테이블을 만들고 데이터를 호출
2. 트랜잭션이 끝나거나 세션이 끝나는 시점에 사라짐
3. 다른 세션에서 테이블 공유할 수 없음
4. Redo 테이블을 생성하지않음
5. Index, View, Trigger를 생성할 수 있으나 이 오브젝트의 타입도 Temporary
6. 이전이나 백업 불가
CREATE GLOBAL TEMPORARY TABLE 테이블이름
(컬럼1 데이터 타입,
 컬럼2 데이터 타입, ...)
 ON COMMIT [delete|preserve] ROWS;
*/
-- ON COMMIT delete(기본값)/preserve ROWS를 사용하면 commit시/세션 종료시에 데이터를 삭제

-- 명령을 입력하는 터미널을 2개 열어 한쪽에서 생성 후 다른 쪽에서 조회 확인하기
CREATE GLOBAL TEMPORARY TABLE temp01 
(no NUMBER, name VARCHAR2(10)) 
ON COMMIT delete ROWS;

INSERT INTO temp01 VALUES(1, 'AAAA');

SELECT * FROM temp01;

commit;

-- 세션이 종료되므로 데이터는 삭제되고 조회해도 데이터는 없다
SELECT * FROM temp01;

-- 생성되어있는 Temporary Table 조회
SELECT temporary, duration FROM user_tables WHERE table_name = 'TEMP01';
-- temporary가 y이고 duration이 transactiond이므로 'commit이나 rollback을 수행하는 동안 유지된다'라는 뜻

-- CAST : 테이블 복사하기, 새로운 테이블을 생성할 때 기존에 있는 테이블을 참조하여 생성
-- 모든/특정 컬럼 복사하기
CREATE TABLE dept3 AS SELECT * FROM dept2;
select * from dept3;
CREATE TABLE dept4 AS SELECT dcode, dname FROM dept2;
select * from dept4;

-- 테이블의 구조(컬럼)만 복사하기
CREATE TABLE dept5 AS SELECT * FROM dept2 WHERE 1= 2;
-- WHERE에 틀린 조건을 적어 해당하는 데이터가 없도록 설정하여 데이터를 가져오지 못하고 구조만 생성하게 됨
select * from dept5;

-- ALTER : 만들어져있는 오브젝트를 수정(변경), 컬럼 추가/삭제, 컬럼/테이블 이름 변경 등
-- 새로운 컬럼 추가하기
CREATE TABLE dept6 AS SELECT dcode, dname FROM dept2 WHERE dcode IN(1000, 1001, 1002);
select * from dept6;
ALTER TABLE dept6 ADD(location VARCHAR2(10));
ALTER TABLE dept6 ADD(location2 VARCHAR2(10) DEFAULT 'SEOUL');
select * from dept6;

-- 컬럼 이름 변경
ALTER TABLE dept6 RENAME COLUMN location2 TO loc;
select * from dept6;
-- 테이블 이름 변경
RENAME dept6 TO dept7;
select * from dept7;

-- 컬럼의 데이터 크기 변경하기
DESC dept7;
ALTER TABLE dept7 MODIFY(loc VARCHAR2(20));
DESC dept7;

-- 컬럼 삭제하기
ALTER TABLE dept7 DROP COLUMN loc;
-- 참조키로 설정되어있는 부모 테이블의 컬럼을 삭제할 경우
ALTER TABLE dept7 DROP COLUMN loc CASCADE CONSTRAINTS;

-- TRUNCATE : 테이블의 데이터를 전부 삭제하고 사용하고 있던 공간을 반납, 인덱스의 내용도 함께
TRUNCATE TABLE dept7;
select * from dept7;

-- DROP : 오브젝트 자체를 삭제
DROP TABLE dept7;

commit;