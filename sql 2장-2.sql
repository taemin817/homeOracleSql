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