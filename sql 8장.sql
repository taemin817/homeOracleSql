-- INDEX : 데이터의 주소값을 가지고 있는 것
-- 인덱스는 생성 원리 p.359, 360 참고
/*
인덱스를 생성하라고 명령 실행하면 해당 테이블의 내용들을 전부 다 읽어 메모리로 가져옴
인덱스를 만드는 동안 데이터가 변경되면 문제가 되기 때문에 해당 데이터들이 변경되지 못하도록 함
이 후 메모리(PGA의 sort area)에서 정렬, 만약 PGA 메모리가 부족하면 임시 테이블 스페이스 사용
정렬이 모두 끝나면 데이터들을 인덱스를 저장하는 파일의 블록에 순서대로 기록
** 인덱스를 생성하면 전체 테이블 스캔 -> 저열ㄹ -> Block 기록  이라는 과정을 거침
*/

-- 인덱스 구조와 작동 원리(B-TREE 인덱스 기준) p.361~363 참고
-- 데이터를 저장할 때는 입력 순서대로지만 인덱스는 정렬되며 저장됨
-- rowid : 모든 데이터들이 저장되어 있는 주소

/*

*/

-- 인덱스의 종류 : B-TREE, BITMAP
/*
데이터 처리 방법(무조건적인 건 아님!!!)
OLTP(OnLine Transaction Processing, 실시간 트랜잭션 처리용) : 대부분의 경우 -> B-TREE
OLAP(OnLine Analtical Processing, 온라인 분석 처리용) : 데이터를 한꺼번에 입력한 후 분석이나 통계 정보 출력할 때(빅데이터) -> BITMAP
*/

-- B-TREE : 주로 데이터의 값의 종류(Cardinality)가 많고 동일한(중복되는) 데이터가 적을 경우 사용      p.365 참고
/*
B(binary, balance) : Root Block을 기준으로 양쪽에 들어 있는 데이터의 Balance가 맞을 때 성능이 가장 좋음
Leaf Block : 실제 데이터를 저장하고 있는 데이터 블록들의 주소가 들어 있는 곳
Branch Block : Leaf Block에 대한 정보가 들어 있는 곳
Root Block : Branch Block에 대한 정보가 들어 있는 곳
생성은 Leaf Block부터지만 데이터를 찾을 경우에는 Root Block부터 찾는다
*/

-- UNIQUE INDEX : 인덱스를 만드는 KEY에 중복되는 데이터가 없다는 뜻
-- 나중에 중복값이 입력될 가능성이 있는 컬럼에는 절대로 이 인덱스 생성하면 안됨
-- CREATE UNIQUE INDEX 인덱스이름 ON 테이블명(컬럼명 ASC | DESC, 컬럼명);
CREATE UNIQUE INDEX IDX_DEPT2_DNAME ON dept2(dname);
INSERT INTO dept2 VALUES(9100, 'temp01', 1006, 'Seoul Branch');
-- INSERT INTO dept2 VALUES(9101, 'temp01', 1006, 'Busan Branch'); -- dname이 위와 동일하기 때문에 오류

-- NON-UNIQUE INDEX : 인덱스를 만드는 KEY 데이터가 중복이다
-- CREATE INDEX 인덱스명 ON 테이블명(컬럼명 ASC | DESC, 컬럼명);
CREATE INDEX IDX_DEPT2_AREA ON dept2(area);

-- Function Based INDEX(FBI, 함수기반 인덱스)
/*
인덱스는 where절에 오는 조건 컬럼이나 조인 컬럼 등에 만든다(몇 가지 경우는 select)
만약 pay컬럼으로 인덱스를 생성했는데 정작 sql에서 WHERE pay+1000=2000이라는 조건으로 조회하면 pay컬럼의 인덱스 사용 불가 -> INDEX Suppressing Error
반드시 WHERE pay+1000=2000 형태를 써야하고 인덱스도 반드시 써야한다면 인덱스를 생성할 때 저 형태로 인덱스를 생성하면 되고 이런 인덱스를 함수기반 인덱스라고 함
원래 pay+1000이라는 컬럼이 없지만 함수처럼 연산을 해서 인덱스를 만든다는 의미
*/

CREATE INDEX IDX_PROF_PAY_FBI ON professor(pay+1000); -- pay+1000이라는 컬럼이 없지만 생성됨
-- 오라클이 인덱스 만들 때 저 연산을 수행해서 인덱스를 만들어줌 -> 임시 해결책, 쿼리의 조건이 변경되면 인덱스를 다시 만들고 기존 인덱스 활용 못하는 단점도 있음

-- DESCENDING INDEX(내림차순 인덱스)
/*
인덱스를 생성할 떄 큰 값이 먼저 오도록(내림차순) 인덱스를 생성, 주로 큰 값을 많이 조회하는 SQL에 생성하는 것이 좋다
ex. 최근날짜조회, 회사 상위 매출 조회 등
만약 하나의 메뉴에 오름차순과 내림차순을 한 번에 조회할 경우 어떻게? -> 같은 컬럼에 인덱스를 2개? -> 인덱스가 많으면 dml성능에 악영향이 있어서 안돼
오라클에서는 위나 아래에서 읽게하는 힌트라는 방법을 제공. 힌트를 이용하여 튜닝에서는 정렬을 하지않고 정렬한 효과를 내고 최댓값,최솟값을 구하기도 함
*/
CREATE INDEX IDX_PROF_PAY ON professor(pay DESC);

-- Composite INDEX(결합 인덱스) : 인덱스를 생성할 때 두 개 이상의 컬럼을 합쳐서 인덱스를 만드는 것
/*
주로 sql 문장에서 WHERE절의 조건 컬럼이 2개 이상 AND로 연결되어 함께 사용하는 경우
ex. emp테이블에 인원이 100명 있는데 그중 남자(M)는 50명, 여자(F)는 50명이라 가정하고 50명의 남자 중에 이름이 'SMITH'인 사람을 찾는 sql 작성
SELECT ename, sal FROM emp WHERE ename = 'SMITH' AND sex='M';
결합 인덱스 생성 구문
CREATE INDEX IDX_EMP_COMP ON emp(ename, sex);

만약 두 개 이상의 조건이 OR로 조회될 경우 결합 인덱스 생성하면 안 됨
결합 인덱스에서 중요한 것은 컬럼의 배치 순서, 컬럼이 두개인 경우 2!(factorial)가지의 경우가 있음
위의 인덱스 구문에서 ename,sex가 아니라 sex, ename이었다고 해보자
sex가 M인 50건을 거르고 다시 ename이 SMITH인 2건을 거르게 된다
만약 예시대로 ename,sex였다면 ename이 SMITH인 2건을 거르고 sex가 M인 2건을 걸렀을 것이다

결합 인덱스를 생성할 때 첫번째 조건에서 최대한 많은 데이터를 걸러서 두번째 검사를 쉽게 만들어줘야 한다
*/


-- BITMAP INDEX : 데이터 값의 종류가 적고 동일한 데이터가 많을 경우 사용
/*
ex. emp 테이블에서 사원이 많아도 deptno 컬럼의 종류는 적을 경우 BITMAP INDEX가 적절
만약 BITMAP INDEX가 생성된 곳에 새로운 데이터가 들어오거나 변경되면 기존에 만들어져 있던 모든 맵을 다 고쳐야하므로 데이터의 변경량이 적거나 없어야 함
CREATE BITMAP INDEX 인덱스명 ON 테이블명(컬럼명);
*/


-- 인덱스 주의사항
/*
dml에 취약함
dml과 인덱스는 사이가 좋지 않기 때문에 dml이 발생하는 테이블은 인덱스를 최소한 작게 만들어야 함
                                                인덱스의 block이 하나에서 두개로 나눠지는 현상
인덱스가 생성되어 있는 컬럼에 새로운 데이터가 insert되면 index split현상이 발생하여 insert작업 부하 상승
index split은 사용자가 아니라 오라클이 자동으로 진행하지만 index split이 완료되기 전까지
다음 데이터가 입력되지 않고 계속 진행 중인 상태로 대기 중 -> 데이터 입력, 변경 시에 속도가 느려짐
*/

/*
insert 작업 시 인덱스는 정렬되어있기 때문에 마지막에 들어갈 수 없고 빈자리가 있다면 상관없지만
빈자리가 없을 경우 새로운 블록을 생성하여 기존 블록의 절반 정도를 옮기고
기존 블록에 남는 자리에 새로 insert하는 index split 현상이 발생함
*/
/*
테이블은 데이터가 delete되면 지워지고 다른 데이터가 그 공간을 사용할 수 있지만 index는 사용불가 표시가 뜸->인덱스가 누적된다
이런 상태의 인덱스를 사용하게 되면 인덱스를 사용함에도 쿼리의 수행 속도가 아주 느려지게 됨 -> index rebuild해야 함
*/
/*
인덱스에는 update가 없음
*/

-- 인덱스 관리
-- 조회
-- 특정 사용자가 생성한 인덱스 조회 : user_indexes, user_ind_columns
set line 200
col table_name for a10
col column_name for a10
col index_name for a20
SELECT table_name, column_name, index_name FROM user_ind_columns WHERE table_name = 'EMP2';
-- db 전체에 생성된 인덱스 조회 : dba_indexes, dba_ind_columns
SELECT table_name, index_name FROM user_indexes WHERE table_name = 'DEPT2';

-- 사용여부 모니터링
-- emp 테이블 ename 컬럼에 IDX_EMP_ENAME 인덱스가 있다고 가정
-- 모니터링 시작
ALTER INDEX IDX_EMP_ENAME MONITORING USAGE;
-- 모니터링 중단
ALTER INDEX IDX_EMP_ENAME NOMONITORING USAGE;
-- 사용 유무 확인(자신이 만든 인덱스만)
SELECT index_name, used FROM v$object_usage WHERE index_name = 'IDX_EMP_ENAME';
-- sys 계정으로 모든 인덱스의 사용 유무를 조회하고 싶으면 별도의 뷰를 생성하여 조회
create or replace view v$all_index_usage(
    index_name, table_name, owner_name, monitoring, used, start_monitoring, end_monitoring) as
        select a.name, b.name, e.name,
               decode(bitAND(c.flags, 65536), 0, 'NO', 'YES'),
               decode(bitAND(d.flags, 1), 0, 'NO', 'YES'),
               d.start_monitoring, d.end_monitoring
        from sys.obj$ a, sys.obj$ b, sys.ind$ c, sys.user$ e, sys.object_usage d
        where c.obj# = d.obj# and a.obj# = d.obj# and b.obj# = c.bo# and e.user# = a.owner#;

select * from v$all_index_usage;

-- scott 계정의 특정 인덱스를 조회해 모니터링 후 위에서 생성한 뷰를 다시 조회
select table_name, index_name from dba_indexes WHERE table_name = 'PROFESSOR';
alter index scott.SYS_C0011298 monitoring usage;

col index_name for a15
col table_name for a15
col owner_name for a10
col monitoring for a10
col used for a5
col start_monitoring for a20
col end_monitoring for a20
set line 200
select * from v$all_index_usage;

-- 인덱스 Rebuild 하기
-- 대량의 dml 작업 등을 수행 후에는 일반적으로 인덱스의 밸런싱 상태를 조사하여 문제가 있을 경우 수정하는 작업을 진행

-- 테스트용 테이블 idx_test를 생성하고 데이터를 입력 후 인덱스 생성
CREATE TABLE idx_test (no NUMBER);

BEGIN FOR i IN 1..10000 LOOP INSERT INTO idx_test VALUES(i);
END LOOP;
COMMIT;
END;

CREATE INDEX IDX_IDXTEST_NO ON idx_test(no);

-- 인덱스의 상태를 조회
analyze index idx_idxtest_no VALIDATE STRUCTURE;
SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';

-- 테이블에서 10000건의 데이터 중 4000건을 지운 후 인덱스 상태를 조회
DELETE FROM idx_test WHERE no BETWEEN 1 AND 4000;
SELECT COUNT(*) FROM idx_test;

SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';
analyze index idx_idxtest_no VALIDATE STRUCTURE;
SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';
-- -> 대략 40퍼센트 정도 밸런싱이 망가진 상태

-- Rebuild 작업으로 수정
ALTER INDEX idx_idxtest_no REBUILD;
analyze index idx_idxtest_no VALIDATE STRUCTURE;
SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';
-- -> 다시 밸런싱이 0으로 개선됨

-- Invisible Index : 인덱스를 삭제하기 전에 '사용 안함' 상태로 만들어 테스트 해볼 수 있는 기능

















commit;