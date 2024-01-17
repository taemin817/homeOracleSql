-- CONSTRAINT(���� ����) : ���̺� �ùٸ� �����͸� �Է¹ް� �߸��� �����ʹ� ������ ���ϵ��� �÷����� ���ϴ� ��Ģ
/*
���� ���� ����
NOT NULL : NULL���� �Էµ��� ����
UNIQUE KEY : �ߺ��� ���� �Էµ��� ����
PRIMARY KEY : NOT NULL + UNIQUE�� Ư¡. ���̺� ������ �����ͳ����� ���ϼ��� ����, ���̺� �� 1���� ���� ����
FOREIGN KEY : �ٸ�(�θ�) ���̺��� �÷��� �����ؼ� �˻�
REFERENCE KEY : �θ� ���̺� �ʿ��� �����Ǵ� �÷��� �����Ǵ� ���� ����
    �ڽ� ���̺� ������ 1���� �Է��ϱ� ���� �θ� ���̺� �ִ� �����͸� ���� �о� �˻���
    �ݴ�� �θ� ���̺� �����͸� �����ϱ� ���� �����ϰ� �ִ� �ڽ� ���̺��� ���� �о� �˻���
    -> ������ �ε����� ������ ������ ���� ������ ��
CHECK : �� ���ǿ��� ������ ���� �Է� ����ϰ� �������� �ź�
*/

-- ���̺� ���� �� ���� ���� �����ϱ�
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
-- ���������� �̸��� �������� ������ ����Ŭ�� �ڵ����� �����ϱ� ������ ���� ������ ������ ���������Ƿ� �� ��������

-- ���̺� ���� �� ���� ���� �����б�
-- new_emp2 ���̺� name �÷��� unique���� ������ �߰��϶�
ALTER TABLE new_emp2 ADD CONSTRAINT emp2_name_uk UNIQUE(name);

-- null/not null�� �߰��ϴ� ��� -> MODIFY ���
ALTER TABLE new_emp2 MODIFY (loc_code CONSTRAINT emp2_loccode_nn NOT NULL);

-- new_emp2 ���̺��� no �÷��� emp2 ���̺��� empno �÷��� ���� �����ϵ��� �����϶�(new_emp2 ���̺��� �ڽ� ���̺�)
ALTER TABLE new_emp2 ADD CONSTRAINT emp2_no_fk FOREIGN KEY(no) REFERENCES emp2(empno);
-- �θ� ���̺� �ʿ� �����Ǵ� �÷��� pk�� uk�� �����Ǿ� �־�� ��

-- ALTER TABLE new_emp2 ADD CONSTRAINT emp2_name_fk FOREIGN KEY(name) REFERENCES emp2(name);
-- emp2 ���̺��� name���� pk�� uk ���� �ȵǾ� �־ ���� �߻�

-- �θ� ���̺��� �����͸� ����� ������ fk������ �ȵȴٸ� fk�� ������ �� on delete cascade �ɼ� �ο� ����
-- ON DELETE CASCADE : �θ� ���̺��� �����Ͱ� �������� �ڽ� ���̺��� �����͵� ������
-- ON DELETE SET NULL : �θ� ���̺��� �����Ͱ� �������� �ڽ� ���̺��� ���� NULL�� ����
CREATE TABLE c_test1(no NUMBER, name VARCHAR2(6), deptno NUMBER);
CREATE TABLE c_test2(no NUMBER, name VARCHAR2(10));

-- �� ���̺� ���� ���� ���� �� ������ �Է�
-- ALTER TABLE c_test1 ADD CONSTRAINT ctest1_deptno_fk FOREIGN KEY(deptno) REFERENCES c_test2(no); pk / uk�� ��� ����
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

-- ON DELETE CASCADE ����
DELETE FROM c_test2 WHERE no=10;
select * from c_test2;
select * from c_test1; -- deptno=10�� ������ ��������� Ȯ�� ����

-- ON DELETE SET NULL ����
ALTER TABLE c_test1 DROP CONSTRAINT ctest1_deptno_fk; -- ���� ������ ����
ALTER TABLE c_test1 ADD CONSTRAINT ctest_deptno_fk FOREIGN KEY(deptno) REFERENCES c_test2(no) ON DELETE SET NULL;
select * from c_test1;
select * from c_test2;
DELETE FROM c_test2 WHERE no=20;
select * from c_test1; -- c_test2���� ������ �����Ͱ� �����Ƿ� null�� ǥ�õ�

-- ���� deptno�� not null �� ������ �ɷ��ִٸ�?
UPDATE c_test1 SET deptno=30 WHERE no=2;
commit;
ALTER TABLE c_test1 MODIFY(deptno CONSTRAINT ctest1_deptno_nn NOT NULL);
-- DELETE FROM c_test2; c_test1�� deptno�� c_test2�� �����ϸ� null�� �Ǳ� ������ not null �������� ���� ���� �߻�

-- ���� ���� �����ϱ�
-- ���� ���ǵ��� �۾��̳� �ʿ信 ���� �Ͻ������� disable(��Ȱ��ȭ)/enable(Ȱ��ȭ) ����
SELECT * FROM t_novalidate;
SELECT * FROM t_validate;
SELECT * FROM t_enable;

-- ���� ���� disable(��Ȱ��ȭ) �ϱ� : novalidate, validate
-- novalidate : �ش� ���� ������ ��� �����Ͱ� ���� �Էµ�
-- disable novalidate ���
-- INSERT INTO t_novalidate VALUES(1,'DDD'); -- ����
ALTER TABLE t_novalidate DISABLE NOVALIDATE CONSTRAINT SYS_C007604;
INSERT INTO t_novalidate VALUES(1,'DDD'); -- �Էµ�
SELECT * FROM t_novalidate;

-- validate : �ش� �÷��� �����͸� ������ �� ���� �ϴ� �ɼ�
-- disable validate ���
-- INSERT INTO t_validate VALUES(4, NULL); -- name �÷��� not null ������ �����Ǿ� �־� null�Է� �Ұ���
-- not null ������ disable validate�� �� �ٽ� �Է�
-- ALTER TABLE t_validate DISABLE VALIDATE CONSTRAINT tv_name_nn;
-- INSERT INTO t_validate VALUES(4, NULL); -- ������ �Ұ���

-- DISABLE VALIDATE �ɼ� ���� �� �ٸ� �÷� ���� �����ϱ� -> ���� �߻�

-- ���� ���� enable(Ȱ��ȭ) �ϱ� : novalidate, validate
-- enable novalidate : ���� ������ enable�� ���� ���ĺ��� ���Ӱ� �ԷµǴ� �����͸� ���� ������ �����Ͽ� �˻�
-- enable validate : ���� ������ enable�ϴ� �������� ���̺� �ԷµǾ� �ִ� ��� �����͸� ���� �˻� + �ű� �Է� �����͵� ���� �˻�

/*
�ش� ���� ������ enable validate�ϰ� �Ǹ� ����Ŭ�� lock�� �����ϰ� �۾��ϴµ�
�̷� Ư�� ������ ���̺��� �����͸� ���� �����ϴ� �������� ����� �� �۾��ϸ� �ȵ�
���� ������ enable validate�ϴ� ���� �ش� ���̺� �����ϴ� �۾����� ��� �Ͻ� �ߴ� �� ����...
���� enable validate�� �ϱ� ���� �˻��ϴٰ� �ش� ���� ������ �����ϴ� ���� �߰ߵǸ� ���� ���� enable �۾��� �����
�̷��� �Ǹ� ������ �����ϴ� �����͸� ã�� ������ ��ġ �� �ٽ� enable�۾� �ݺ� �õ� ������ �ؾ���
�� ������ �ذ��ϱ� ���� enable validate�� ��� exceptions��� ���̺� ����Ͽ� �������� ������ ����ϰ� �ؾ� ��
*/

-- t_enable ���̺� ������ �Է�
INSERT INTO t_enable VALUES(1,'AAA');
INSERT INTO t_enable VALUES(2,'BBB');
-- INSERT INTO t_enable VALUES(3, NULL); not null�� �ɷ� ���� �߻�
SELECT * FROM t_enable;
ALTER TABLE t_enable DISABLE CONSTRAINT te_name_nn;
INSERT INTO t_enable VALUES(3, NULL);
SELECT * FROM t_enable;

-- enable novalidate�� name �÷� ���� ���� enable�ϱ�
ALTER TABLE t_enable ENABLE NOVALIDATE CONSTRAINT te_name_nn;
select * from t_enable; -- ���Ӱ� �ԷµǴ� �����͸� ���� ������ �����Ͽ� �˻��ϱ� ������ null ��ȸ ��
-- INSERT INTO t_enable VALUES(4, NULL); -- ���Ӱ� �ԷµǹǷ� ���� �߻�

-- enable validate�� name �÷� ���� ���� enable�ϱ�
ALTER TABLE t_enable DISABLE CONSTRAINT te_name_nn;
-- ALTER TABLE t_enable ENABLE VALIDATE CONSTRAINT te_name_nn;
-- ���̺� null�� �����Ͱ� �ֱ� ������ enable validate�� �Ұ���

-- exceptions ���̺��� ����Ͽ� enable validate�ϱ�(sys ����)
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
update scott.tt500 set no=8 where rowid='rowid�÷� �������� ��ü';
commit;
truncate table sys.exceptions;
alter table scott.tt500 enable validate constraint tt500_ck exceptions into sys.exceptions;
select * from scott.t500;
insert into scott.t500 values(1);
*/

-- exceptions ���̺��� ����Ͽ� enable validate�ϱ�(scott ����)
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
update tt551 set name='bbb' where rowid='rowid�÷� �������� ��ü';
update tt551 set name='ccc' where rowid='rowid�÷� �������� ��ü';
commit;
select rowid, no from tt551 where rowid in (select row_id from exceptions);
truncate table sys.exceptions;
alter table tt551 enable validate constraint tt551_name_uk exceptions into sys.exceptions;
select * from tt551;
*/

-- ���� ���� ��ȸ�ϱ�
-- ���̺� ���� ������ �����ϸ� �� ������ ��ųʸ��� ����Ǿ� ����
-- ����ϴ� ��ųʸ��� user_constraints, user_cons_columns, db��ü�� ���� ������ ��ȸ�Ϸ��� user�κ��� dba�� �ٲٸ� ��

-- new_emp2 ���̺� ������ ���� ���� ��ȸ
select owner, constraint_name, constraint_type, status from user_constraints where table_name = 'NEW_EMP2';
-- p: primary key, u: unique, c: check, r:�ܷ�Ű

-- Ư�� ���̺��� Ư�� �÷��� ������ ���� ���� ��ȸ
select owner, constraint_name, table_name, column_name from user_cons_columns where table_name='EMP';

-- FORIEGN KEY ��ȸ
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

-- ���� ���� ����
ALTER TABLE new_emp2 DROP CONSTRAINT emp2_name_fk;

-- p.353 ��������
-- ���̺��� �����ϸ鼭 ���� ������ �����϶�
CREATE TABLE tcons (no NUMBER(5) CONSTRAINT tcons_no_pk PRIMARY KEY,
                    name VARCHAR2(20) CONSTRAINT tcons_name_nn NOT NULL,
                    jumin VARCHAR2(13) CONSTRAINT tcons_jumin_nn NOT NULL CONSTRAINT tcons_jumin_uk UNIQUE,
                    area NUMBER(1) CONSTRAINT tcons_area_ck CHECK (area BETWEEN 1 AND 4),
                    deptno VARCHAR2(6) CONSTRAINT tcons_deptno_fk REFERENCES dept2(dcode)
                    );

-- tcons ���̺��� name �÷��� emp2 ���̺��� name �÷��� ���� �����ϵ��� ����Ű ���� ������ �߰������ϴ� ������ �ۼ�(tcons�� �ڽ�)
select * from emp2;
select owner, constraint_name, constraint_type, status from user_constraints where table_name = 'EMP2';
select owner, constraint_name, table_name, column_name from user_cons_columns where table_name = 'EMP2';
ALTER TABLE emp2 ADD CONSTRAINT emp2_name_u UNIQUE(name); -- ���� emp2 ���̺��� name �÷��� uk�� pk�� �ƴϾ fk������ ������ �߻��� uk ���� �߰�
ALTER TABLE tcons ADD CONSTRAINT tcons_name_fk FOREIGN KEY(name) REFERENCES emp2(name);

/*
tcons ���̺��� jumin �÷��� ������� �ִ� unique ���� ������ '������'���� �����ϵ�
�ش� ���̺��� �����Ϳ� dml���� �ȵǵ��� �����ϴ� ������ ����϶�(���� �̸��� tcons_jumin_uk)
*/
-- ���� ������ '������'���� ���� -> disable�϶�
-- dml���� �ȵǵ��� ���� -> validate�϶�
ALTER TABLE tcons DISABLE VALIDATE CONSTRAINT tcons_jumin_uk;

/*
���� �������� '������'���� ������ ���� tcons_jumin_uk�� ��������� �����ϵ�
������ �ִ� ����� ���� ���� ���� ��� üũ�ϴ� �ɼ����� �����϶�
������ �Ǵ� �����͵��� scott.exceptions ���̺� �����϶�
*/
-- tcons_jumin_uk�� ��������� ���� -> enable�϶�
-- ������ �ִ� ����� ���� ���� ���� ��� üũ -> validate�϶�
ALTER TABLE tcons ENABLE VALIDATE CONSTRAINT tcons_jumin_uk;


-- emp ���̺� �����Ǿ� �ִ� ���� �� �ڽ��� ������ ������ ���̺��, �÷���, ���� ������ �˻��ϴ� ������ �ۼ��϶�(fk�� ����)
select owner, constraint_name, constraint_type, status from user_constraints where table_name = 'EMP' and constraint_type != 'R';

commit;