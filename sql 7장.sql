-- CONSTRAINT(제약 조건) : 테이블에 올바른 데이터만 입력받고 잘못된 데이터는 들어오지 못하도록 컬럼마다 정하는 규칙
/*
제약 조건 종류
NOT NULL : NULL값이 입력되지 못함
UNIQUE KEY : 중복된 값이 입력되지 못함
PRIMARY KEY : NOT NULL + UNIQUE의 특징. 테이블 내에서 데이터끼리의 유일성을 보장, 테이블 당 1개만 설정 가능
FOREIGN KEY : 다른(부모) 테이블의 컬럼을 참조해서 검사
REFERENCE KEY : 부모 테이블 쪽에서 참조되는 컬럼에 설정되는 제약 조건
    자식 테이블에 데이터 1건을 입력하기 위해 부모 테이블에 있는 데이터를 전부 읽어 검사함
    반대로 부모 테이블 데이터를 삭제하기 위해 참조하고 있는 자식 테이블을 전부 읽어 검사함
    -> 적절한 인덱스를 생성해 성능을 좋게 만들어야 함
CHECK : 이 조건에서 설정된 값만 입력 허용하고 나머지는 거부
*/

-- 테이블 생성 시 제약 조건 지정하기
CREATE TABLE new_emp1 (
    no NUMBER(4) CONSTRAINT emp1_no_pk PRIMARY KEY,
    name VARCHAR2(20) CONSTRAINT emp1_name_nn NOT NULL,
    jumin VARCHAR2(13) CONSTRAINT emp1_jumin_nn NOT NULL CONSTRAINT emp1_jumin_uk UNIQUE,
    loc_code NUMBER(1) CONSTRAINT emp1_area_ck CHECK (0 <= loc_code and loc_code < 5),
    deptno VARCHAR2(6) CONSTRAINT emp1_deptno_fk REFERENCES dept2(dcode)
    );
    
CREATE TABLE new_emp2 (
    no NUMBER(4) PRIMARY KEY,
    name VARCHAR2(20) NOT NULL,
    jumin VARCHAR2(13) NOT NULL UNIQUE,
    loc_code NUMBER(1) CHECK (0 <= loc_code and loc_code < 5),
    deptno VARCHAR2(6) REFERENCES dept2(dcode)
    );
-- 제약조건의 이름을 설정하지 않으면 오라클이 자동으로 설정하기 때문에 제약 조건의 관리가 불편해지므로 꼭 설정하자

-- 테이블 생성 후 제약 조건 지정학기
-- new_emp2 테이블 name 컬럼에 unique제약 조건을 추가하라
ALTER TABLE new_emp2 ADD CONSTRAINT emp2_name_uk UNIQUE(name);

-- null/not null을 추가하는 방법 -> MODIFY 사용
ALTER TABLE new_emp2 MODIFY (loc_code CONSTRAINT emp2_loccode_nn NOT NULL);

-- new_emp2 테이블의 no 컬럼이 emp2 테이블의 empno 컬럼의 값을 참조하도록 설정하라(new_emp2 테이블이 자식 테이블)
ALTER TABLE new_emp2 ADD CONSTRAINT emp2_no_fk FOREIGN KEY(no) REFERENCES emp2(empno);
-- 부모 테이블 쪽에 설정되는 컬럼이 pk나 uk가 설정되어 있어야 함

-- ALTER TABLE new_emp2 ADD CONSTRAINT emp2_name_fk FOREIGN KEY(name) REFERENCES emp2(name);
-- emp2 테이블의 name에는 pk나 uk 설정 안되어 있어서 오류 발생

-- 부모 테이블의 데이터를 지우고 싶은데 fk때문에 안된다면 fk를 생성할 때 on delete cascade 옵션 부여 가능
-- ON DELETE CASCADE : 부모 테이블의 데이터가 지워지면 자식 테이블의 데이터도 지워짐
-- ON DELETE SET NULL : 부모 테이블의 데이터가 지워지면 자식 테이블의 값을 NULL로 설정
CREATE TABLE c_test1(no NUMBER, name VARCHAR2(6), deptno NUMBER);
CREATE TABLE c_test2(no NUMBER, name VARCHAR2(10));

-- 두 테이블에 제약 조건 설정 후 데이터 입력
-- ALTER TABLE c_test1 ADD CONSTRAINT ctest1_deptno_fk FOREIGN KEY(deptno) REFERENCES c_test2(no); pk / uk가 없어서 오류
ALTER TABLE c_test2 ADD CONSTRAINT ctest2_no_uk UNIQUE(no);
ALTER TABLE c_test1 ADD CONSTRAINT ctest1_deptno_fk FOREIGN KEY(deptno) REFERENCES c_test2(no) ON DELETE CASCADE;
INSERT INTO c_test2 VALUES(10, 'AAAA');
INSERT INTO c_test2 VALUES(20, 'BBBB');
INSERT INTO c_test2 VALUES(30, 'CCCC');
commit;
select * from c_test2;

INSERT INTO c_test1 VALUES(1, 'apple', 10);
INSERT INTO c_test1 VALUES(2, 'banana', 20);
INSERT INTO c_test1 VALUES(3, 'cherry', 30);

-- ON DELETE CASCADE 실행
DELETE FROM c_test2 WHERE no=10;
select * from c_test2;
select * from c_test1; -- deptno=10인 데이터 사라졌음을 확인 가능

-- ON DELETE SET NULL 실행
ALTER TABLE c_test1 DROP CONSTRAINT ctest1_deptno_fk; -- 제약 조건을 삭제
ALTER TABLE c_test1 ADD CONSTRAINT ctest_deptno_fk FOREIGN KEY(deptno) REFERENCES c_test2(no) ON DELETE SET NULL;
select * from c_test1;
select * from c_test2;
DELETE FROM c_test2 WHERE no=20;
select * from c_test1; -- c_test2에서 참조할 데이터가 없으므로 null로 표시됨

-- 만약 deptno가 not null 로 제약이 걸려있다면?
UPDATE c_test1 SET deptno=30 WHERE no=2;
commit;
ALTER TABLE c_test1 MODIFY(deptno CONSTRAINT ctest1_deptno_nn NOT NULL);
-- DELETE FROM c_test2; c_test1의 deptno는 c_test2를 삭제하면 null이 되기 때문에 not null 제약으로 인해 오류 발생

-- 제약 조건 관리하기
-- 제약 조건들은 작업이나 필요에 의해 일시적으로 disable(비활성화)/enable(활성화) 가능
SELECT * FROM t_novalidate;
SELECT * FROM t_validate;
SELECT * FROM t_enable;

-- 제약 조건 disable(비활성화) 하기 : novalidate, validate
-- novalidate : 해당 제약 조건이 없어서 데이터가 전부 입력됨
-- disable novalidate 사용
-- INSERT INTO t_novalidate VALUES(1,'DDD'); -- 오류
ALTER TABLE t_novalidate DISABLE NOVALIDATE CONSTRAINT SYS_C007604;
INSERT INTO t_novalidate VALUES(1,'DDD'); -- 입력됨
SELECT * FROM t_novalidate;

-- validate : 해당 컬럼의 데이터를 변경할 수 없게 하는 옵션
-- disable validate 사용
-- INSERT INTO t_validate VALUES(4, NULL); -- name 컬럼에 not null 제약이 설정되어 있어 null입력 불가능
-- not null 조건을 disable validate한 후 다시 입력
-- ALTER TABLE t_validate DISABLE VALIDATE CONSTRAINT tv_name_nn;
-- INSERT INTO t_validate VALUES(4, NULL); -- 여전히 불가능

-- DISABLE VALIDATE 옵션 설정 후 다른 컬럼 내용 변경하기 -> 오류 발생

-- 제약 조건 enable(활성화) 하기 : novalidate, validate
-- enable novalidate : 제약 조건을 enable한 시점 이후부터 새롭게 입력되는 데이터만 제약 조건을 적용하여 검사
-- enable validate : 제약 조건을 enable하는 시점까지 테이블에 입력되어 있던 모든 데이터를 전부 검사 + 신규 입력 데이터도 전부 검사

/*
해당 제약 조건을 enable validate하게 되면 오라클은 lock을 설정하고 작업하는데
이런 특성 때문에 테이블의 데이터를 많이 변경하는 시점에는 절대로 이 작업하면 안됨
제약 조건을 enable validate하는 동안 해당 테이블에 수행하는 작업들이 모두 일시 중단 될 수도...
만약 enable validate를 하기 위해 검사하다가 해당 제약 조건을 위반하는 값이 발견되면 제약 조건 enable 작업을 취소함
이렇게 되면 조건을 위반하는 데이터를 찾아 적절히 조치 후 다시 enable작업 반복 시도 일일이 해야함
이 문제를 해결하기 위해 enable validate일 경우 exceptions라는 테이블 사용하여 에러사항 별도로 기록하게 해야 함
*/

-- t_enable 테이블에 데이터 입력
INSERT INTO t_enable VALUES(1,'AAA');
INSERT INTO t_enable VALUES(2,'BBB');
-- INSERT INTO t_enable VALUES(3, NULL); not null에 걸려 오류 발생
SELECT * FROM t_enable;
ALTER TABLE t_enable DISABLE CONSTRAINT te_name_nn;
INSERT INTO t_enable VALUES(3, NULL);
SELECT * FROM t_enable;

-- enable novalidate로 name 컬럼 제약 조건 enable하기
ALTER TABLE t_enable ENABLE NOVALIDATE CONSTRAINT te_name_nn;
select * from t_enable; -- 새롭게 입력되는 데이터만 제약 조건을 적용하여 검사하기 때문에 null 조회 됨
-- INSERT INTO t_enable VALUES(4, NULL); -- 새롭게 입력되므로 오류 발생

-- enable validate로 name 컬럼 제약 조건 enable하기
ALTER TABLE t_enable DISABLE CONSTRAINT te_name_nn;
-- ALTER TABLE t_enable ENABLE VALIDATE CONSTRAINT te_name_nn;
-- 테이블에 null인 데이터가 있기 때문에 enable validate가 불가능

-- exceptions 테이블을 사용하여 enable validate하기(sys 계정)
/*
conn / as SYSDBA;
@?/rdbms/admin/utlexcpt.sql
create table scott.tt500(no NUMBER CONSTRAINT tt500_ck CHECK(no > 5));
alter table scott.tt500 disable constraint tt500_ck;
insert into scott.5500 values(1);
insert into scott.5500 values(6);
insert into scott.5500 values(7);
commit;
select * from soctt.tt500;
alter table scott.tt500 enable validate constraint tt500_ck exceptions into sys.exceptions;
select rowid, no from scott.tt500 where rowid in (select row_id from exceptions);
update scott.tt500 set no=8 where rowid='rowid컬럼 내용으로 대체';
commit;
truncate table sys.exceptions;
alter table scott.tt500 enable validate constraint tt500_ck exceptions into sys.exceptions;
select * from scott.t500;
insert into scott.t500 values(1);
*/

-- exceptions 테이블을 사용하여 enable validate하기(scott 계정)
/*
conn / as scott/tiger;
@?/rdbms/admin/utlexcpt.sql
create table tt551(no NUMBER, name VARCHAR2(10) CONSTRAINT tt551_name_ck UNIQUE);
alter table tt551 disable constraint tt551_name_uk;
insert into tt551 values(1, 'aaa');
insert into tt551 values(2, 'aaa');
insert into tt551 values(3, 'aaa');
commit;
select * from tt551;
alter table tt551 enable validate constraint tt551_name_uk exceptions into sys.exceptions;
select rowid, no from tt551 where rowid in (select row_id from exceptions);
update tt551 set name='bbb' where rowid='rowid컬럼 내용으로 대체';
update tt551 set name='ccc' where rowid='rowid컬럼 내용으로 대체';
commit;
select rowid, no from tt551 where rowid in (select row_id from exceptions);
truncate table sys.exceptions;
alter table tt551 enable validate constraint tt551_name_uk exceptions into sys.exceptions;
select * from tt551;
*/

-- 제약 조건 조회하기
-- 테이블에 제약 조건을 설정하면 그 내용이 딕셔너리에 저장되어 있음
-- 사용하는 딕셔너리는 user_constraints, user_cons_columns, db전체의 제약 조건을 조회하려면 user부분을 dba로 바꾸면 됨

-- new_emp2 테이블에 설정된 제약 조건 조회
select owner, constraint_name, constraint_type, status from user_constraints where table_name = 'NEW_EMP2';
-- p: primary key, u: unique, c: check, r:외래키

-- 특정 테이블의 특정 컬럼에 설정된 제약 조건 조회
select owner, constraint_name, table_name, column_name from user_cons_columns where table_name='EMP';

-- FORIEGN KEY 조회
SELECT constraint_name, column_name, table_name FROM user_cons_columns;
COL child_table FOR a15
COL child_column FOR a15
COL child_cons_name FOR a15
COL parent_table FOR a15
COL parent_column FOR a15
COL parent_cons_name FOR a15
SELECT a.table_name child_table,
       c.column_name child_column,
       a.constraint_name child_cons_name,
       b.table_name parent_table,
       a.r_constraint_name parent_cons_name,
       d.column_name parent_column
FROM  user_constraints a, user_constraints b, user_cons_columns c, 
    (SELECT constraint_name, column_name, table_name FROM user_cons_columns) d
WHERE a.r_constraint_name = b.constraint_name
AND a.constraint_name = c.constraint_name
AND a.r_constraint_name = d.constraint_name
AND a.constraint_type = 'R';

-- 제약 조건 삭제
ALTER TABLE new_emp2 DROP CONSTRAINT emp2_name_fk;

-- p.353 연습문제
-- 테이블을 생성하면서 제약 조건을 설정하라
CREATE TABLE tcons (no NUMBER(5) CONSTRAINT tcons_no_pk PRIMARY KEY,
                    name VARCHAR2(20) CONSTRAINT tcons_name_nn NOT NULL,
                    jumin VARCHAR2(13) CONSTRAINT tcons_jumin_nn NOT NULL CONSTRAINT tcons_jumin_uk UNIQUE,
                    area NUMBER(1) CONSTRAINT tcons_area_ck CHECK (area BETWEEN 1 AND 4),
                    deptno VARCHAR2(6) CONSTRAINT tcons_deptno_fk REFERENCES dept2(dcode)
                    );

-- tcons 테이블의 name 컬럼이 emp2 테이블의 name 컬럼의 값을 참조하도록 참조키 제약 조건을 추가설정하는 쿼리를 작성(tcons가 자식)
select * from emp2;
select owner, constraint_name, constraint_type, status from user_constraints where table_name = 'EMP2';
select owner, constraint_name, table_name, column_name from user_cons_columns where table_name = 'EMP2';
ALTER TABLE emp2 ADD CONSTRAINT emp2_name_u UNIQUE(name); -- 기존 emp2 테이블의 name 컬럼이 uk나 pk가 아니어서 fk생성시 오류가 발생해 uk 제약 추가
ALTER TABLE tcons ADD CONSTRAINT tcons_name_fk FOREIGN KEY(name) REFERENCES emp2(name);

/*
tcons 테이블의 jumin 컬럼에 만들어져 있는 unique 제약 조건을 '사용안함'으로 변경하되
해당 테이블의 데이터에 dml까지 안되도록 변경하는 쿼리를 사용하라(제약 이름은 tcons_jumin_uk)
*/
-- 제약 조건을 '사용안함'으로 변경 -> disable하라
-- dml까지 안되도록 변경 -> validate하라
ALTER TABLE tcons DISABLE VALIDATE CONSTRAINT tcons_jumin_uk;

/*
위의 문제에서 '사용안함'으로 설정한 제약 tcons_jumin_uk를 사용함으로 변경하되
기존에 있던 내용과 새로 들어올 내용 모두 체크하는 옵션으로 변경하라
문제가 되는 데이터들은 scott.exceptions 테이블에 저장하라
*/
-- tcons_jumin_uk를 사용함으로 변경 -> enable하라
-- 기존에 있던 내용과 새로 들어올 내용 모두 체크 -> validate하라
ALTER TABLE tcons ENABLE VALIDATE CONSTRAINT tcons_jumin_uk;


-- emp 테이블에 설정되어 있는 제약 중 자신이 생성한 제약을 테이블명, 컬럼명, 제약 명으로 검색하는 쿼리를 작성하라(fk는 제외)
select owner, constraint_name, constraint_type, status from user_constraints where table_name = 'EMP' and constraint_type != 'R';

commit;