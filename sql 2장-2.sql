-- ���Խ�(Regular Expression) �Լ��� �پ��� ���� ��ȸ�ϱ�
/*
^(ĳ��) : �ش� ���ڷ� �����ϴ� line ��� 
$ : �ش� ���ڷ� ������ line ���
. : ���𰡷� �����ؼ� ���𰡷� ������ line ��� s...e -> s�� �����ؼ� e�� ������
* : ���. ���ڼ��� 0�� ���� ����
[] : �ش� ���ڿ� �ش��ϴ� �� ���� [Pp]attern
[^] : �ش� ���ڿ� �ش����� �ʴ� �� ���� [^a-m]attern
*/
select * from t_reg;

-- REGEXP_LIKE : Ư�� ���ϰ� ��Ī�Ǵ� ����� �˻�
-- �����ڰ� ����ִ� �ุ ���
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-z]');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-zA-Z]');
-- �ҹ��ڷ� �����ϰ� ������ �����ϴ� ��� ã��
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-z] ');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-z] [0-9]');
-- ������ �ִ� ������ ���� ã��
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[[:space:]]');
-- �������� ���� �� ����
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]{2}'); -- �� �빮�� 2���� �̻�
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]{3}'); -- �� �빮�� 3���� �̻�
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z]{4}'); -- �� �빮�� 4���� �̻�
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[0-9]{3}'); -- ���� 3���� �̻�
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[A-Z][0-9]{3}'); -- ���� 3���� �̻�
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[0-9][A-Z]{3}'); -- ���� 3���� �̻�
-- �빮�ڰ� ���� ��츦 ���
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[[:upper:]]');
-- Ư�� ��ġ�� �����Ͽ� ���
SELECT  * FROM t_reg WHERE REGEXP_LIKE(text, '^[A-Za-z]'); -- ù ������ �빮�ڳ� �ҹ��ڷ� �����ϴ� ��츦 ���
SELECT  * FROM t_reg WHERE REGEXP_LIKE(text, '^[0-9A-Z]'); -- ù ������ ���ڳ� �빮�ڷ� �����ϴ� ��츦 ���
SELECT  * FROM t_reg WHERE REGEXP_LIKE(text, '^[a-z]|^[0-9]'); -- ù ������ �ҹ��ڳ� ���ڷ� �����ϴ� ��츦 ���
SELECT name, id FROM student WHERE REGEXP_LIKE(id, '^M(a|o)'); -- id �� ù ���ڰ� M���� �����ϰ� �ι�° ���ڰ� a�Ǵ� o�� ���� ��츦 ���
 -- �����ڷ� ������ ��츦 ���
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[a-zA-Z]$');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '[[:alpha:]]$');
-- ^(ĳ��)�� ���ȣ �ȿ� ���� ���ȣ ���� ���� �̿� �͸� ���
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '^[^a-z]'); -- �ҹ��ڷ� ���������ʴ� ��츦 ���
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '^[^0-9]'); -- ���ڷ� ���������ʴ� ��츦 ���
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '^[^0-9a-z]'); -- �ҹ��ڳ� ���ڷ� ���������ʴ� ��츦 ���
-- �ҹ��ڰ� ����ִ� ��츦 �����ϰ� ���
SELECT * FROM t_reg WHERE NOT REGEXP_LIKE(text, '[a-z]');
-- ������ȣ�� 2�ڸ��̰� ������ 4�ڸ��� ��츦 ���
SELECT name, tel FROM student WHERE REGEXP_LIKE(tel, '^[0-9]{2}\)[0-9]{4}');
-- 4��° �ڸ��� �ҹ��� r�� �ִ� ��츦 ���
SELECT name, id FROM student WHERE REGEXP_LIKE(id, '^...r.');

SELECT * FROM t_reg2;
-- �ּҰ� 10.10.10.1�� �ุ ���
SELECT * FROM t_reg2 WHERE REGEXP_LIKE(ip, '^[10]{2}\.[10]{2}\.[10]{2}');
-- ���ȣ �ȿ� �ִ� ������ ��ġ�� ������� �ش� ����(1, 6, 8)�� �ִ� ���� ��� ���
SELECT * FROM t_reg2 WHERE REGEXP_LIKE(ip, '^[172]{3}\.[16]{2}\.[168]{3}');
-- Ư�� ������ ������ ����� ���
-- �����ڰ� ���Ե��� �ʴ� ��츦 ���
SELECT * FROM t_reg WHERE NOT REGEXP_LIKE(text, '[a-zA-Z]');
-- ���ڰ� ���Ե��� ���� ��츦 ���
SELECT * FROM t_reg WHERE NOT REGEXP_LIKE(text, '[0-9]');
-- Ư������ ã�� �� �����ؾ��� �κ� : *�� ?�� '���'�̶�� ���̱� ������ �տ� \�� �ٿ��ش�
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '\*');
SELECT * FROM t_reg WHERE REGEXP_LIKE(text, '\?');
-- ��Ÿ ���� : ���� ��ȣ�� ���� �ƴ� �ٸ� ���� ���� ����
-- Ż�� ���� : ��Ÿ ������ ���� �����ϰ� ������ ������ ���ư��� ���ִ� ����


-- REGEXP_REPLACE : �־��� ���ڿ����� Ư�� ������ ã�� �־��� �ٸ� ������� ġȯ
/*
REGEXP_REPLACE(source_char, pattern [, replace_string[, position [, occurrence[, match_pattern]]]])
source : ���� ������(�÷���, ���ڿ�). ������Ÿ�� : char, varchar2, nchar, nvarchar2, clob, nclob
pattern : ã�����ϴ� ����. ������Ÿ�� : char, varchar2, nchar, nvarchar2
replace_string : ��ȯ�ϰ��� �ϴ� ����. ���Ͽ� ��ġ�ϴ� ����(���ڿ�)�� ã�Ƽ� �� ���·� ��ȯ�ض�.
position : �˻� ���� ��ġ. ���� ���� ���� ����� �⺻�� = 1
occurrence : ���ϰ� ��ġ�� �߻��ϴ� Ƚ��. 0 = ��� ���� ��ü, n = n��° �߻��ϴ� ���ڿ��� ����
match_parameter : �⺻������ �˻��Ǵ� �ɼ� ���� ����.
c = ��ҹ��� �����Ͽ� �˻�, i = ��ҹ��ڸ� �������� �ʰ� �˻�, m = �˻� ������ ���� �ٷ� �� �� ����
c�� i�� �ߺ����� �����Ǹ� �������� ������ ���� ����ϰ� ��
*/
-- ��� ���ڸ� Ư�� ��ȣ�� ����
COL "NO -> CHAR" FOR a20
-- [[:digit:]] : [:����Ŭ����:] ����Ŭ���� = alpha, blank, cntrl, digit, graph, lower, print, space, upper, xdigit
SELECT text, REGEXP_REPLACE(text, '[[:digit:]]', '*') "NO -> CHAR" FROM t_reg; -- [:digit:] = [0-9], [:alpha:] = [A-Za-z]
COL "Add Char" FOR a30
SELECT text, REGEXP_REPLACE(text, '([0-9])', '\1-*') "Add Char" FROM t_reg; -- ���ڸ� ����-*�� ����
SET LINE 200
COL no FOR 999
COL ip FOR a20
COL "Dot Remove" FOR a20
SELECT no, ip, REGEXP_REPLACE(ip, '\.', '') "Dot Remove" FROM t_reg2;
SELECT no, ip, REGEXP_REPLACE(ip, '\.', '/', 1, 1) "Dot Remove" FROM t_reg2;
SELECT REGEXP_REPLACE('aaa bbb','( ){1,}','') FROM dual; -- 'aaa bbb'�� ���� 1ĭ �̻��� ���� ����
SELECT REGEXP_REPLACE('aaa bbb','( ){2,}','') "One", REGEXP_REPLACE('aaa  bbb','( ){2,}','') "Two" FROM dual;
SELECT REGEXP_REPLACE('aaa bbb','( ){2,}','*') "One", 
REGEXP_REPLACE('aaa  bbb','( ){2,}','*') "Two", 
REGEXP_REPLACE('aaa   bbb','( ){2,}','*') "Three" FROM dual;
-- [0-9]{2} : 00~9�� ���� ���� �� �ڸ��� �ǹ�
-- abc[7-9]{2} : abc ���� 7�̳� 8 �Ǵ� 9�� �̷��� ���ڸ� ���ڸ� �ǹ�
-- ����ڰ� �˻��� �Է��� �� ���� ���ڸ� ���� ���� �Է��ϰ� ���̵� �߰����� ������ �־ ��� ������ ����
select * from student;
SET verify OFF
SELECT studno, name, id FROM student WHERE id=REGEXP_REPLACE('&id','( ){1,}','');
SELECT studno, name, id FROM student WHERE id=LOWER(REGEXP_REPLACE('&id','( ){1,}',''));
SELECT REGEXP_REPLACE('20141023', '([[:digit:]]{4})([[:digit:]]{2})', '\1-\2-\3') FROM dual;


-- REGEXP_SUBSTR : Ư�� ���Ͽ��� �־��� ���ڸ� ����
-- �־��� ���ڿ����� ù ���ڰ� ������ �ƴϰ�('[^ ]') �� �Ŀ� DEF�� ������ �κ��� ����
SELECT REGEXP_SUBSTR('ABC* *DEF $GHI%KJL','[^ ]+[DEF]') FROM dual;
-- professor ���̺��� homepage �ּҰ� �ִ� �����鸸 ��ȸ�Ͽ� ���
SELECT * FROM professor;
COL url FOR a20     -- /�� ã�� ���ĺ��̳� ���ں��� .���� 3-4�� �ݺ����� ����ϰ� / ������ ����
SELECT name, LTRIM(REGEXP_SUBSTR(hpage, '/([[:alnum:]]+\.?){3,4}?'), '/') "URL" FROM professor WHERE hpage IS NOT NULL;
-- professor ���̺��� 101�� �а��� 201�� �а� �������� �̸��� ���� �ּ��� ������ �ּҸ� ���(���� �ּҴ� @ �ڿ� �ִ� �ּҸ� ���)
COL email FOR a20
COL name FOR a20
COL domain FOR a20     -- @�� ã�� ���ĺ��̳� ���ں��� .���� 3-4�� �ݺ����� ����ϰ� @ ������ ����
SELECT name, LTRIM(REGEXP_SUBSTR(email, '@([[:alnum:]]+\.?){2,3}?'), '@') domain FROM professor WHERE deptno in (101, 201);
-- Ư�� ��ȣ�� ���ڸ� ������ ������ ����
COL result FOR a10
SELECT REGEXP_SUBSTR('SYS/ORACLE@TESTDB:1521:TESTDB', '[^:]+',1,3) RESULT FROM dual;
SELECT REGEXP_SUBSTR('SYS/ORACLE@TESTDB:1521:TESTDB', '[^/:]+',1,2) RESULT FROM dual;
SELECT REGEXP_SUBSTR('SYS/ORACLE@TESTDB:1521:TESTDB', '[^/:]+',1,1) RESULT FROM dual;


-- REGEXP_COUNT : Ư�� ������ ������ ���ش�
SET PAGESIZE 50
SELECT text, REGEXP_COUNT(text, 'A') "count A" FROM t_reg;
-- 3��° ���� ���ĺ��� 'c'�� ������ ����
SELECT text, REGEXP_COUNT(text, 'c', 3) "count c" FROM t_reg;
-- i(match_parameter) : ��ҹ��ڸ� �������� ����
SELECT text, REGEXP_COUNT(text, 'c') result1, REGEXP_COUNT(text, 'c', 1, 'i') result2 FROM t_reg;
-- Ż�⹮�� ����ϱ�                ����                            .(�޸�)
SELECT text, REGEXP_COUNT(text, '.') result1, REGEXP_COUNT(text, '\.') result2 FROM t_reg;
SELECT text,
REGEXP_COUNT(text, 'aa') RESULT1 , REGEXP_COUNT(text, 'a{2}') RESULT2 ,REGEXP_COUNT(text, '(a)(a)') RESULT3
FROM t_reg;
