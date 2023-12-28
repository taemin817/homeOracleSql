-- 단일행 함수 : 한 번에 하나씩 처리하는 함수
-- 복수행(그룹) 함수 : 여러 건의 데이터를 동시에 입력 받아 1건의 결과 반환
-- 단일행 함수 종류 : 문자, 숫자, 날짜,. 변환(묵시적 데이터형 변환, 명시적 데이터형 변환), 일반 함수

/*
문자함수
intcap : 입력 값의 첫 글자만 대문자로 변환 intcap('abcd') -> Abcd
lower : 입력 값을 전부 소문자로 변환 lower('ABCD') -> abcd
upper : 입력 값을 전부 대문자로 변환 upper('abcd') -> ABCD
length : 입력된 문자열의 길이 값을 출력 length('한글') -> 2
lengthb : 입력된 문자열의 길이 바이트 값을 출력 lengthb('한글') -> 4
concat : 두 문자열을 결합해서 출력. || 과 동일 concat('a', 'b') -> ab
substr : 주어진 문자에서 특정 문자만 추출 substr('abcd', 1, 2) -> abc에서 첫번째부터 2개 출력. ab
substrb : 주어진 문자에서 특정 바이트만 추출 substrb('abcde', 1, 3) -> abcde에서 첫번째부터 3바이트 출력. abc
instr : 주어진 문자에서 특정 문자의 위치 추출 instr('a*b#','#') -> #의 위치 출력. 4
instrb : 주어진 문자에서 특정 문자의 위치 바이트값 추출 intstrb('한글로', '로') -> 로 가 시작하는 위치 5
lpad : 주어진 문자열에서 왼쪽으로 특정 문자를 채움 lpad('love', 10, '#') -> 10바이트 중 love(4바이트)왼쪽으로 #를 채움
rpad : 주어진 문자열에서 오른쪽으로 특정 문자를 채움 rpad('love', 10, '#') -> 10바이트 중 love(4바이트)오른쪽으로 #를 채움
ltrim : 주어진 문자열에서 왼쪽의 특정 문자를 삭제 ltrim('###love','#') -> ###love의 왼쪽에서 #를 삭제. love
rtrim : 주어진 문자열에서 오른쪽쪽의 특정 문자를 삭제 rtrim('love###','#') -> love###의 오른쪽에서 #를 삭제. love
replace : 주어진 문자열에서 a를 b로 치환 replace('abcd', 'a', 'b') -> bbcd
regexp_replace : 주어진 문자열에서 특정 패턴을 찾아 치환
regexp_instr : 주어진 문자열에서 특정 패턴의 시작 위치를 반환
regexp_substr : 주어진 문자열에서 특정 패턴을 찾아 반환
regexp_like : 주어진 문자열에서 특정 패턴을 찾아 반환
regexp_count : 주어진 문자열에서 특정 패턴의 횟수를 반환
*/
SELECT ename, INITCAP(ename) "INITCAP" FROM emp WHERE deptno=10;
-- 중간에 공백이 있으면 공백 이후 첫글자를 대문자로 출력
SELECT name, INITCAP(name) "INITCAP" FROM professor WHERE deptno=101;
SELECT ename, LOWER(ename) "LOWER", UPPER(ename) "UPPER" FROM emp WHERE deptno = 10;
SELECT '박태민' "NAME", LENGTH('박태민') "LENGTH", LENGTHB('박태민') "LENGTHB" FROM DUAL;
SELECT CONCAT(ename, job) FROM emp WHERE deptno=10;
col "3, 2" for a6 -- 컬럼 이름 "3, 2"의 데이터가 문자일 경우 컬럼의 길이를 6바이트까지 설정
col "-3, 2" for a6
col "-3, 4" for a6
--            3번째부터 2개              오른쪽으로 3번째부터 2개              오른쪽 3번째부터 4개
select substr('abcde', 3, 2) "3,2", substr('abcde', -3, 2) "-3,2", substr('abcde', -3, 4) "-3,4" from dual;
--                 첫번재 문자로부터 3번째 -가 나오는 위치
SELECT 'A-B-C-D', INSTR('A-B-C-D', '-', 1, 3) "INSTR" FROM dual;
--            오른쪽 첫번재 문자로부터 3번째 -가 나오는 위치
SELECT 'A-B-C-D', INSTR('A-B-C-D', '-', -1, 3) "INSTR" FROM dual;
--            오른쪽 여섯번재 문자로부터 2번째 -가 나오는 위치
SELECT 'A-B-C-D', INSTR('A-B-C-D', '-', -6, 2) "INSTR" FROM dual;
-- substr, instr퀴즈
-- student 테이블을 참조해서 deptno1이 201인 학생이름과 전화번호와 지역번호 출력하기(지역 번호는 숫자만)
SELECT name, tel, SUBSTR(tel, 1, INSTR(tel, ')')-1) "AREA CODE" FROM student WHERE deptno1 = 201;
SELECT name, id, LPAD(id, 10, '*') FROM student WHERE deptno1 = 201;
-- emp에서 deptno=10인 사원들의 사원 이름을 총 9바이트로 lpad하고 빈자리는 해당 자리의 숫자로 채우기
SELECT LPAD(ename, 9, substr('123456789', 1, 9-LENGTH(ename))) "LPAD" FROM emp WHERE deptno=10;
-- emp에서 deptno=10인 사원들의 사원 이름을 총 9바이트로 rpad하고 빈자리는 해당 자리의 숫자로 채우기
SELECT RPAD(ename, 9, substr('123456789', LENGTH(ename)+1, 9-LENGTH(ename))) "RPAD" FROM emp WHERE deptno=10;
SELECT LTRIM(ename, 'C') FROM emp WHERE deptno=10; -- 회원가입을 받기 위해 고객의 아이디를 받는데 첫 글자가 공백일경우 그 공백을 제거하는 경우에 사용
SELECT RTRIM(ename, 'R') FROM emp WHERE deptno=10;
SELECT ename, REPLACE(ename, SUBSTR(ename, 1, 2), '**') "REPLACE" FROM emp WHERE deptno=10;
-- replace 퀴즈 1
SELECT ename, REPLACE(ename, SUBSTR(ename, 2, 2), '--') "REPALCE" FROM emp WHERE deptno=20;
-- replace 퀴즈 2
SELECT name, jumin, REPLACE(jumin, SUBSTR(jumin, 7, 7), '-/-/-/-') "REPLACE" FROM student WHERE deptno1=101;
-- replace 퀴즈 3
SELECT name, tel, REPLACE(tel, SUBSTR(tel, INSTR(tel, ')')+1, 3), '***') "REPLACE" FROM student WHERE deptno1=102;
-- replace 퀴즈 4
SELECT name, tel, REPLACE(tel, SUBSTR(tel, INSTR(tel, '-')+1, 4), '****') "REPLACE" FROM student WHERE deptno1=102;

/*
숫자 함수
round : 주어진 숫자를 n번째 자리까지 반올림한 후 출력 round(12.345, 2) -> 12.35
trunc : 주어진 숫자를 n번째 자리까지 버림한 후 출력 trunc(12.345, 2) -> 12.34
mod : 주어진 숫자를 나눈 나머지를 출력 mod(12, 10) -> 2
ceil : 주어진 숫자와 가장 근접한 "큰" 정수를 출력 ceil(12.345) -> 13
floor : 주어진 숫자와 가장 근접한 "작은" 정수를 출력 floor(12.345) -> 12
power : 주어진 숫자 1의 숫자 2승을 출력 power(3,2) -> 9
*/
SELECT ROUND(987.654, 2) "ROUND1", ROUND(987.654, 0) "ROUND2", ROUND(987.654, -1) "ROUND3" FROM dual;
SELECT ROUND(987.654, 2) "TRUNC1", TRUNC(987.654, 0) "TRUNC2", TRUNC(987.654, -1) "TRUNC3" FROM dual;
SELECT MOD(121, 10) "MOD", CEIL(123.45) "CEIL", FLOOR(123.45) "FLOOR" FROM dual;
SET pagesize 50
SELECT rownum "ROWNO", CEIL(rownum/3) "TEAMNO", ename FROM emp;
SELECT power(3,2) FROM dual;

/*
날짜 함수
날짜+숫자=날짜, 날짜-숫자=날짜, 날짜-날짜=숫자
sysdate : 시스템의 현재 날짜와 시간
months_between : 두 날짜 사이의 개월 수
add_months : 주어진 날짜에 개월을 더함
next_day : 주어진 날짜를 기준으로 돌아오는 가장 최근 요일의 날짜 출력
last_day : 주어진 날짜가 속한 달의 마지막 날짜 출력
round : 주어진 날짜를 반올림
trunc : 주어진 날짜를 버림
*/
SELECT sysdate from dual;
-- MONTHS_BETWEEN
-- 큰 날짜를 먼저 쓴다
SELECT MONTHS_BETWEEN('14/09/30', '14/08/31') FROM dual;
-- 두 날짜가 같은 달에 속해 있으면 특정 규칙으로 계산된 값이 출력
SELECT MONTHS_BETWEEN('12/02/29', '12/02/01'), MONTHS_BETWEEN('14/04/30', '14/04/01'), MONTHS_BETWEEN('14/05/31', '14/05/01') FROM dual;
-- 일반적으로 months_between 함수를 안쓰면 1개월=31일, months_between도 1개월=31일로 계산하지만 결과에 차이가 있음
SELECT ename, hiredate, 
ROUND(MONTHS_BETWEEN(TO_DATE('04/05/31'), hiredate), 1) "DATE1", 
ROUND(((TO_DATE('04/05/31')-hiredate)/31),1) "DATE2" 
FROM emp WHERE deptno=10;
-- ADD_MONTHS
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 1) FROM dual;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') FROM dual;
SELECT SYSDATE, NEXT_DAY('14/04/01', '월') FROM dual; -- 특정 날짜를 기준으로 할 때
SELECT SYSDATE, LAST_DAY(SYSDATE), LAST_DAY('14/04/01') FROM dual;
-- 날짜의 round, trunc
-- 하루의 반은 12:00:00이기 때문에 이 시간을 넘으면 round 적용시 다음 날짜로 출력
-- 아닐 경우 당일로 출력. trunc는 무조건 당일로 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD:HH24:MI:ss';
SELECT SYSDATE, ROUND(SYSDATE), TRUNC(SYSDATE) FROM dual;

/*
형 변환 함수
char(n) : 고정길이의 문자를 저장. 최대값은 2000바이트
varchar2(n) : 변하는 길이의 문자를 저장. 최대값은 4000바이트
number(p, s) : 숫자 값을 저장. p는 전체 자리수 1~38자리까지 가능, s는 소수점 이하 자리수 -84~127까지 가능
date : 총 7바이트, bc 4712년 1월 1일부터 ad 9999년 12월 31일까지의 날짜를 저장할 수 있음
long : 가변 길이의 문자를 저장하며 최대 2gb까지 저장 가능
clob : 가변 길이의 문자를 저장하며 최대 4gb까지 저장 가능
blob : 가변 길이의 바이너리 데이터를 최대 4gb까지 저장 가능
raw(n) : 원시 이진 데이터로 최대 2000바이트까지 저장 가능
long law(n) : 원시 이진 데이터로 최대 2gb까지 저장 가능
bfile : 외부 파일에 저장된 데이터로 최대 4gb까지 저장 가능
*/
-- 묵시적(자동) 형 변환
SELECT 2+'2' FROM dual;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY') "YYYY",
TO_CHAR(SYSDATE, 'RRRR') "RRRR",
TO_CHAR(SYSDATE, 'YY') "YY",
TO_CHAR(SYSDATE, 'RR') "RR",
TO_CHAR(SYSDATE, 'YEAR') "YEAR" FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'MM') "MM",
TO_CHAR(SYSDATE, 'MON') "MON",
TO_CHAR(SYSDATE, 'MONTH') "MONTH" FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD') "DD",
TO_CHAR(SYSDATE, 'DAY') "DAY",
TO_CHAR(SYSDATE, 'DDTH') "DDTH" FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'RRRR-MM-DD:HH24:MI:SS') FROM dual;
select * from student;
SELECT studno, name, TO_CHAR(birthday, 'YY/MM/DD') "BIRTHDAY" FROM student WHERE TO_CHAR(birthday, 'MM')='01';
SELECT empno, ename, TO_CHAR(hiredate, 'YY/MM/DD') "HIREDATE" FROM emp WHERE TO_CHAR(hiredate, 'MM') in ('01', '02', '03'); 

/*
TO_CHAR
9 : 9의 개수만큼 자릿수 만듦. TO_CHAR(1234, '99999') -> 1234
0 : 빈자리를 0으로 채움. TO_CHAR(1234, '009999') -> 001234
$ : $표시를 붙여서 표시. TO_CHAR(1234, '$9999') -> $1234
. : 소수점 이하를 표시 TO_CHAR(1234, '9999.99') -> 1234.00
, : 천 단위 구분 기호를 표시 TO_CHAR(12345, '99,999') -> 12,345
*/
select * from emp;
SELECT empno, ename, sal, comm, TO_CHAR((sal*12)+comm, '999,999') "SALARY" FROM emp WHERE ename='ALLEN';
SELECT name, pay, bonus, TO_CHAR((pay*12)+bonus, '999,999') "TOTAL" FROM professor WHERE deptno=201;
SELECT empno, ename, hiredate, TO_CHAR((sal*12)+comm, '$99,999') "SAL", TO_CHAR((sal*1.15)+comm, '$99,999') "15% UP" FROM emp WHERE COMM IS NOT NULL;
-- TO_NUMBER
SELECT TO_NUMBER('5') FROM dual;
SELECT ASCII('A') FROM dual;
-- TO_DATE
SELECT TO_DATE('14/05/31') FROM dual;

-- 일반 함수 : 입력되는 값 구분없이 다 사용 가능

-- NVL : NULL을 만나면 다른 값으로 치환해서 출력
SELECT ename, comm, NVL(comm, 0), NVL(COMM, 100) FROM emp WHERE deptno=30;
SELECT profno, name, pay, NVL(bonus, 0) "BONUS", TO_CHAR((pay*12)+NVL(bonus, 0),'9,999') "TOTAL" FROM professor WHERE deptno = 201;
-- NVL2 : NULL이 아닐 경우 출력할 값을 지정 가능
SELECT empno, ename, sal, comm, NVL2(comm, sal+comm, sal*0) "NVL2" FROM emp WHERE deptno=30;
SELECT empno, ename, comm, NVL2(comm, 'Exist', 'NULL') "NVL2" FROM emp WHERE deptno=30;
-- DECODE(A, B, '1', null) : a가 b일 경우 1을 출력, 아니라면 null을 출력
SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering') "DNAME" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering', 'ETC') "DNAME" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, DECODE(name, 'Audie Murphy', 'BEST!')) "ETC" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, DECODE(name, 'Audie Murphy', 'BEST!', 'GOOD!')) "ETC" FROM professor;
SELECT deptno, name, DECODE(deptno, 101, DECODE(name, 'Audie Murphy', 'BEST!', 'GOOD!'), 'N/A') "ETC" FROM professor;

SELECT name, jumin, DECODE(SUBSTR(jumin, 7, 1), '1', 'MAN', 'WOMAN') "GENDER" FROM student WHERE deptno1=101;
SELECT name, tel, DECODE(SUBSTR(tel, 1 , INSTR(tel, ')')-1), '02', 'SEOUL', '031', 'GYEONGGI', '051', 'BUSAN', '052', 'ULSAN', '055', 'GYEONGNAM') "LOC" FROM student WHERE deptno1=101;

-- CASE : 크거나 작은 조건을 처리할 경우 사용. 콤마를 사용하지 않는다
SELECT name, tel, SUBSTR(jumin, 3, 2) "MONTH", CASE 
WHEN SUBSTR(jumin, 3, 2) BETWEEN '01' AND '03' THEN '1/4'
WHEN SUBSTR(jumin, 3, 2) BETWEEN '04' AND '06' THEN '2/4'
WHEN SUBSTR(jumin, 3, 2) BETWEEN '07' AND '09' THEN '3/4'
WHEN SUBSTR(jumin, 3, 2) BETWEEN '10' AND '12' THEN '4/4'
END "Quarter" FROM student;
SELECT empno, ename, sal, CASE
WHEN sal BETWEEN 1 AND 1000 THEN 'LEVEL 1'
WHEN sal BETWEEN 1001 AND 2000 THEN 'LEVEL 2'
WHEN sal BETWEEN 2001 AND 3000 THEN 'LEVEL 3'
WHEN sal BETWEEN 3001 AND 4000 THEN 'LEVEL 4'
WHEN sal >= 4001 THEN 'LEVEL 5'
END "LEVEL" FROM emp;