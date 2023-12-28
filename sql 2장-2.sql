-- 정규식(Regular Expression) 함수로 다양한 조건 조회하기
/*
^(캐럿) : 해당 문자로 시작하는 line 출력 
$ : 해당 문자로 끝나는 line 출력
. : 무언가로 시작해서 무언가로 끝나는 line 출력 s...e -> s로 시작해서 e로 끝나는
* : 모든. 글자수가 0일 수도 있음
[] : 해당 문자에 해당하는 한 문자 [Pp]attern
[^] : 해당 문자에 해당하지 않는 한 문자 [^a-m]attern
*/
select * from t_reg;

-- REGEXP_LIKE : 특정 패턴과 매칭되는 결과를 검색
-- 영문자가 들어있는 행만 출력
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-z]');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-zA-Z]');
-- 소문자로 시작하고 공백을 포함하는 경우 찾기
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-z] ');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-z] [0-9]');
-- 공백이 있는 데이터 전부 찾기
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[[:space:]]');
-- 연속적인 글자 수 지정
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]{2}'); -- 영 대문자 2글자 이상
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]{3}'); -- 영 대문자 3글자 이상
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]{4}'); -- 영 대문자 4글자 이상
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[0-9]{3}'); -- 숫자 3글자 이상
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z][0-9]{3}'); -- 숫자 3글자 이상
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[0-9][A-Z]{3}'); -- 숫자 3글자 이상
-- 대문자가 들어가는 경우를 출력
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[[:upper:]]');
-- 특정 위치를 지정하여 출력
SELECT  * FROM t_reg WHERE REGEXP_LIKE(text, '^[A-Za-z]'); -- 첫 시작을 대문자나 소문자로 시작하는 경우를 출력
SELECT  * FROM t_reg WHERE REGEXP_LIKE(text, '^[0-9A-Z]'); -- 첫 시작을 숫자나 대문자로 시작하는 경우를 출력
SELECT  * FROM t_reg WHERE REGEXP_LIKE(text, '^[a-z]|^[0-9]'); -- 첫 시작을 소문자나 숫자로 시작하는 경우를 출력
SELECT name, id FROM student WHERE REGEXP_LIKE(id, '^M(a|o)'); -- id 중 첫 글자가 M으로 시작하고 두번째 글자가 a또는 o가 오는 경우를 출력
 -- 영문자로 끝나는 경우를 출력
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-zA-Z]$');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[[:alpha:]]$');
-- ^(캐럿)이 대괄호 안에 들어가면 대괄호 안의 문자 이외 것만 출력
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '^[^a-z]'); -- 소문자로 시작하지않는 경우를 출력
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '^[^0-9]'); -- 숫자로 시작하지않는 경우를 출력
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '^[^0-9a-z]'); -- 소문자나 숫자로 시작하지않는 경우를 출력
-- 소문자가 들어있는 경우를 제외하고 출력
SELECT * FROM t_reg WHERE NOT REGEXP_LIKE(text, '[a-z]');
-- 지역번호가 2자리이고 국번이 4자리인 경우를 출력
SELECT name, tel FROM student WHERE REGEXP_LIKE(tel, '^[0-9]{2}\)[0-9]{4}');
-- 4번째 자리에 소문자 r이 있는 경우를 출력
SELECT name, id FROM student WHERE REGEXP_LIKE(id, '^...r.');

SELECT * FROM t_reg2;
-- 주소가 10.10.10.1인 행만 출력
SELECT * FROM t_reg2 WHERE REGEXP_LIKE(ip, '^[10]{2}\.[10]{2}\.[10]{2}');
-- 대괄호 안에 있는 숫자의 위치와 상관없이 해당 숫자(1, 6, 8)가 있는 행은 모두 출력
SELECT * FROM t_reg2 WHERE REGEXP_LIKE(ip, '^[172]{3}\.[16]{2}\.[168]{3}');
-- 특정 조건을 제외한 결과를 출력
-- 영문자가 포함되지 않는 경우를 출력
SELECT * FROM t_reg WHERE NOT REGEXP_LIKE(text, '[a-zA-Z]');
-- 숫자가 포함되지 않은 경우를 출력
SELECT * FROM t_reg WHERE NOT REGEXP_LIKE(text, '[0-9]');
-- 특수문자 찾을 때 조심해야할 부분 : *과 ?는 '모든'이라는 뜻이기 때문에 앞에 \를 붙여준다
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '\*');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '\?');
-- 메타 문자 : 원래 기호의 뜻이 아닌 다른 뜻을 가진 문자
-- 탈출 문자 : 메타 문자의 뜻을 중지하고 원래의 뜻으로 돌아가게 해주는 문자


-- REGEXP_REPLACE : 주어진 문자열에서 특정 패턴을 찾아 주어진 다른 모양으로 치환
/*
REGEXP_REPLACE(source_char, pattern [, replace_string[, position [, occurrence[, match_pattern]]]])
source : 원본 데이터(컬럼명, 문자열). 데이터타입 : char, varchar2, nchar, nvarchar2, clob, nclob
pattern : 찾고자하는 패턴. 데이터타입 : char, varchar2, nchar, nvarchar2
replace_string : 변환하고자 하는 형태. 패턴에 일치하는 문자(문자열)을 찾아서 이 형태로 변환해라.
position : 검색 시작 위치. 값을 주지 않을 경우의 기본값 = 1
occurrence : 패턴과 일치가 발생하는 횟수. 0 = 모든 값을 대체, n = n번째 발생하는 문자열을 대입
match_parameter : 기본값으로 검색되는 옵션 변경 가능.
c = 대소문자 구분하여 검색, i = 대소문자를 구분하지 않고 검색, m = 검색 조건을 여러 줄로 줄 수 있음
c와 i가 중복으로 설정되면 마지막에 설정된 값을 사용하게 됨
*/
-- 모든 숫자를 특수 기호로 변경
COL "NO -> CHAR" FOR a20
-- [[:digit:]] : [:문자클래스:] 문자클래스 = alpha, blank, cntrl, digit, graph, lower, print, space, upper, xdigit
SELECT text, REGEXP_REPLACE(text, '[[:digit:]]', '*') "NO -> CHAR" FROM t_reg; -- [:digit:] = [0-9], [:alpha:] = [A-Za-z]
COL "Add Char" FOR a30
SELECT text, REGEXP_REPLACE(text, '([0-9])', '\1-*') "Add Char" FROM t_reg; -- 숫자를 숫자-*로 변경
SET LINE 200
COL no FOR 999
COL ip FOR a20
COL "Dot Remove" FOR a20
SELECT no, ip, REGEXP_REPLACE(ip, '\.', '') "Dot Remove" FROM t_reg2;
SELECT no, ip, REGEXP_REPLACE(ip, '\.', '/', 1, 1) "Dot Remove" FROM t_reg2;
SELECT REGEXP_REPLACE('aaa bbb','( ){1,}','') FROM dual; -- 'aaa bbb'의 공백 1칸 이상인 것을 삭제
SELECT REGEXP_REPLACE('aaa bbb','( ){2,}','') "One", REGEXP_REPLACE('aaa  bbb','( ){2,}','') "Two" FROM dual;
SELECT REGEXP_REPLACE('aaa bbb','( ){2,}','*') "One", 
REGEXP_REPLACE('aaa  bbb','( ){2,}','*') "Two", 
REGEXP_REPLACE('aaa   bbb','( ){2,}','*') "Three" FROM dual;
-- [0-9]{2} : 00~9가 들어가는 숫자 두 자리를 의미
-- abc[7-9]{2} : abc 다음 7이나 8 또는 9로 이뤄진 두자리 숫자를 의미
-- 사용자가 검색어 입력할 때 공백 문자를 가장 먼저 입력하고 아이디 중간에도 공백이 있어서 모든 공백을 제거
select * from student;
SET verify OFF
SELECT studno, name, id FROM student WHERE id=REGEXP_REPLACE('&id','( ){1,}','');
SELECT studno, name, id FROM student WHERE id=LOWER(REGEXP_REPLACE('&id','( ){1,}',''));
SELECT REGEXP_REPLACE('20141023', '([[:digit:]]{4})([[:digit:]]{2})', '\1-\2-\3') FROM dual;


-- REGEXP_SUBSTR : 특정 패턴에서 주어진 문자를 추출
-- 주어진 문자열에서 첫 글자가 공백이 아니고('[^ ]') 그 후에 DEF가 나오는 부분을 추출
SELECT REGEXP_SUBSTR('ABC* *DEF $GHI%KJL','[^ ]+[DEF]') FROM dual;
-- professor 테이블에서 homepage 주소가 있는 교수들만 조회하여 출력
SELECT * FROM professor;
COL url FOR a20     -- /를 찾고 알파벳이나 숫자부터 .까지 3-4번 반복시켜 출력하고 / 왼쪽을 제거
SELECT name, LTRIM(REGEXP_SUBSTR(hpage, '/([[:alnum:]]+\.?){3,4}?'), '/') "URL" FROM professor WHERE hpage IS NOT NULL;
-- professor 테이블에서 101번 학과와 201번 학과 교수들의 이름과 메일 주소의 도메인 주소를 출력(메일 주소는 @ 뒤에 있는 주소만 출력)
COL email FOR a20
COL name FOR a20
COL domain FOR a20     -- @를 찾고 알파벳이나 숫자부터 .까지 3-4번 반복시켜 출력하고 @ 왼쪽을 제거
SELECT name, LTRIM(REGEXP_SUBSTR(email, '@([[:alnum:]]+\.?){2,3}?'), '@') domain FROM professor WHERE deptno in (101, 201);
-- 특정 기호나 문자를 기준을 데이터 추출
COL result FOR a10
SELECT REGEXP_SUBSTR('SYS/ORACLE@TESTDB:1521:TESTDB', '[^:]+',1,3) RESULT FROM dual;
SELECT REGEXP_SUBSTR('SYS/ORACLE@TESTDB:1521:TESTDB', '[^/:]+',1,2) RESULT FROM dual;
SELECT REGEXP_SUBSTR('SYS/ORACLE@TESTDB:1521:TESTDB', '[^/:]+',1,1) RESULT FROM dual;


-- REGEXP_COUNT : 특정 문자의 개수를 세준다
SET PAGESIZE 50
SELECT text, REGEXP_COUNT(text, 'A') "count A" FROM t_reg;
-- 3번째 문자 이후부터 'c'가 나오는 개수
SELECT text, REGEXP_COUNT(text, 'c', 3) "count c" FROM t_reg;
-- i(match_parameter) : 대소문자를 구분하지 않음
SELECT text, REGEXP_COUNT(text, 'c') result1, REGEXP_COUNT(text, 'c', 1, 'i') result2 FROM t_reg;
-- 탈출문자 사용하기                전부                            .(콤마)
SELECT text, REGEXP_COUNT(text, '.') result1, REGEXP_COUNT(text, '\.') result2 FROM t_reg;
SELECT text,
REGEXP_COUNT(text, 'aa') RESULT1 , REGEXP_COUNT(text, 'a{2}') RESULT2 ,REGEXP_COUNT(text, '(a)(a)') RESULT3
FROM t_reg;
