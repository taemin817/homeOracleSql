-- INDEX : �������� �ּҰ��� ������ �ִ� ��
-- �ε����� ���� ���� p.359, 360 ����
/*
�ε����� �����϶�� ��� �����ϸ� �ش� ���̺��� ������� ���� �� �о� �޸𸮷� ������
�ε����� ����� ���� �����Ͱ� ����Ǹ� ������ �Ǳ� ������ �ش� �����͵��� ������� ���ϵ��� ��
�� �� �޸�(PGA�� sort area)���� ����, ���� PGA �޸𸮰� �����ϸ� �ӽ� ���̺� �����̽� ���
������ ��� ������ �����͵��� �ε����� �����ϴ� ������ ��Ͽ� ������� ���
** �ε����� �����ϸ� ��ü ���̺� ��ĵ -> ������ -> Block ���  �̶�� ������ ��ħ
*/

-- �ε��� ������ �۵� ����(B-TREE �ε��� ����) p.361~363 ����
-- �����͸� ������ ���� �Է� ����������� �ε����� ���ĵǸ� �����
-- rowid : ��� �����͵��� ����Ǿ� �ִ� �ּ�

/*

*/

-- �ε����� ���� : B-TREE, BITMAP
/*
������ ó�� ���(���������� �� �ƴ�!!!)
OLTP(OnLine Transaction Processing, �ǽð� Ʈ����� ó����) : ��κ��� ��� -> B-TREE
OLAP(OnLine Analtical Processing, �¶��� �м� ó����) : �����͸� �Ѳ����� �Է��� �� �м��̳� ��� ���� ����� ��(������) -> BITMAP
*/

-- B-TREE : �ַ� �������� ���� ����(Cardinality)�� ���� ������(�ߺ��Ǵ�) �����Ͱ� ���� ��� ���      p.365 ����
/*
B(binary, balance) : Root Block�� �������� ���ʿ� ��� �ִ� �������� Balance�� ���� �� ������ ���� ����
Leaf Block : ���� �����͸� �����ϰ� �ִ� ������ ��ϵ��� �ּҰ� ��� �ִ� ��
Branch Block : Leaf Block�� ���� ������ ��� �ִ� ��
Root Block : Branch Block�� ���� ������ ��� �ִ� ��
������ Leaf Block�������� �����͸� ã�� ��쿡�� Root Block���� ã�´�
*/

-- UNIQUE INDEX : �ε����� ����� KEY�� �ߺ��Ǵ� �����Ͱ� ���ٴ� ��
-- ���߿� �ߺ����� �Էµ� ���ɼ��� �ִ� �÷����� ����� �� �ε��� �����ϸ� �ȵ�
-- CREATE UNIQUE INDEX �ε����̸� ON ���̺��(�÷��� ASC | DESC, �÷���);
CREATE UNIQUE INDEX IDX_DEPT2_DNAME ON dept2(dname);
INSERT INTO dept2 VALUES(9100, 'temp01', 1006, 'Seoul Branch');
-- INSERT INTO dept2 VALUES(9101, 'temp01', 1006, 'Busan Branch'); -- dname�� ���� �����ϱ� ������ ����

-- NON-UNIQUE INDEX : �ε����� ����� KEY �����Ͱ� �ߺ��̴�
-- CREATE INDEX �ε����� ON ���̺��(�÷��� ASC | DESC, �÷���);
CREATE INDEX IDX_DEPT2_AREA ON dept2(area);

-- Function Based INDEX(FBI, �Լ���� �ε���)
/*
�ε����� where���� ���� ���� �÷��̳� ���� �÷� � �����(�� ���� ���� select)
���� pay�÷����� �ε����� �����ߴµ� ���� sql���� WHERE pay+1000=2000�̶�� �������� ��ȸ�ϸ� pay�÷��� �ε��� ��� �Ұ� -> INDEX Suppressing Error
�ݵ�� WHERE pay+1000=2000 ���¸� ����ϰ� �ε����� �ݵ�� ����Ѵٸ� �ε����� ������ �� �� ���·� �ε����� �����ϸ� �ǰ� �̷� �ε����� �Լ���� �ε������ ��
���� pay+1000�̶�� �÷��� ������ �Լ�ó�� ������ �ؼ� �ε����� ����ٴ� �ǹ�
*/

CREATE INDEX IDX_PROF_PAY_FBI ON professor(pay+1000); -- pay+1000�̶�� �÷��� ������ ������
-- ����Ŭ�� �ε��� ���� �� �� ������ �����ؼ� �ε����� ������� -> �ӽ� �ذ�å, ������ ������ ����Ǹ� �ε����� �ٽ� ����� ���� �ε��� Ȱ�� ���ϴ� ������ ����

-- DESCENDING INDEX(�������� �ε���)
/*
�ε����� ������ �� ū ���� ���� ������(��������) �ε����� ����, �ַ� ū ���� ���� ��ȸ�ϴ� SQL�� �����ϴ� ���� ����
ex. �ֱٳ�¥��ȸ, ȸ�� ���� ���� ��ȸ ��
���� �ϳ��� �޴��� ���������� ���������� �� ���� ��ȸ�� ��� ���? -> ���� �÷��� �ε����� 2��? -> �ε����� ������ dml���ɿ� �ǿ����� �־ �ȵ�
����Ŭ������ ���� �Ʒ����� �а��ϴ� ��Ʈ��� ����� ����. ��Ʈ�� �̿��Ͽ� Ʃ�׿����� ������ �����ʰ� ������ ȿ���� ���� �ִ�,�ּڰ��� ���ϱ⵵ ��
*/
CREATE INDEX IDX_PROF_PAY ON professor(pay DESC);

-- Composite INDEX(���� �ε���) : �ε����� ������ �� �� �� �̻��� �÷��� ���ļ� �ε����� ����� ��
/*
�ַ� sql ���忡�� WHERE���� ���� �÷��� 2�� �̻� AND�� ����Ǿ� �Բ� ����ϴ� ���
ex. emp���̺� �ο��� 100�� �ִµ� ���� ����(M)�� 50��, ����(F)�� 50���̶� �����ϰ� 50���� ���� �߿� �̸��� 'SMITH'�� ����� ã�� sql �ۼ�
SELECT ename, sal FROM emp WHERE ename = 'SMITH' AND sex='M';
���� �ε��� ���� ����
CREATE INDEX IDX_EMP_COMP ON emp(ename, sex);

���� �� �� �̻��� ������ OR�� ��ȸ�� ��� ���� �ε��� �����ϸ� �� ��
���� �ε������� �߿��� ���� �÷��� ��ġ ����, �÷��� �ΰ��� ��� 2!(factorial)������ ��찡 ����
���� �ε��� �������� ename,sex�� �ƴ϶� sex, ename�̾��ٰ� �غ���
sex�� M�� 50���� �Ÿ��� �ٽ� ename�� SMITH�� 2���� �Ÿ��� �ȴ�
���� ���ô�� ename,sex���ٸ� ename�� SMITH�� 2���� �Ÿ��� sex�� M�� 2���� �ɷ��� ���̴�

���� �ε����� ������ �� ù��° ���ǿ��� �ִ��� ���� �����͸� �ɷ��� �ι�° �˻縦 ���� �������� �Ѵ�
*/


-- BITMAP INDEX : ������ ���� ������ ���� ������ �����Ͱ� ���� ��� ���
/*
ex. emp ���̺��� ����� ���Ƶ� deptno �÷��� ������ ���� ��� BITMAP INDEX�� ����
���� BITMAP INDEX�� ������ ���� ���ο� �����Ͱ� �����ų� ����Ǹ� ������ ������� �ִ� ��� ���� �� ���ľ��ϹǷ� �������� ���淮�� ���ų� ����� ��
CREATE BITMAP INDEX �ε����� ON ���̺��(�÷���);
*/


-- �ε��� ���ǻ���
/*
dml�� �����
dml�� �ε����� ���̰� ���� �ʱ� ������ dml�� �߻��ϴ� ���̺��� �ε����� �ּ��� �۰� ������ ��
                                                �ε����� block�� �ϳ����� �ΰ��� �������� ����
�ε����� �����Ǿ� �ִ� �÷��� ���ο� �����Ͱ� insert�Ǹ� index split������ �߻��Ͽ� insert�۾� ���� ���
index split�� ����ڰ� �ƴ϶� ����Ŭ�� �ڵ����� ���������� index split�� �Ϸ�Ǳ� ������
���� �����Ͱ� �Էµ��� �ʰ� ��� ���� ���� ���·� ��� �� -> ������ �Է�, ���� �ÿ� �ӵ��� ������
*/

/*
insert �۾� �� �ε����� ���ĵǾ��ֱ� ������ �������� �� �� ���� ���ڸ��� �ִٸ� ���������
���ڸ��� ���� ��� ���ο� ����� �����Ͽ� ���� ����� ���� ������ �ű��
���� ��Ͽ� ���� �ڸ��� ���� insert�ϴ� index split ������ �߻���
*/
/*
���̺��� �����Ͱ� delete�Ǹ� �������� �ٸ� �����Ͱ� �� ������ ����� �� ������ index�� ���Ұ� ǥ�ð� ��->�ε����� �����ȴ�
�̷� ������ �ε����� ����ϰ� �Ǹ� �ε����� ����Կ��� ������ ���� �ӵ��� ���� �������� �� -> index rebuild�ؾ� ��
*/
/*
�ε������� update�� ����
*/

-- �ε��� ����
-- ��ȸ
-- Ư�� ����ڰ� ������ �ε��� ��ȸ : user_indexes, user_ind_columns
set line 200
col table_name for a10
col column_name for a10
col index_name for a20
SELECT table_name, column_name, index_name FROM user_ind_columns WHERE table_name = 'EMP2';
-- db ��ü�� ������ �ε��� ��ȸ : dba_indexes, dba_ind_columns
SELECT table_name, index_name FROM user_indexes WHERE table_name = 'DEPT2';

-- ��뿩�� ����͸�
-- emp ���̺� ename �÷��� IDX_EMP_ENAME �ε����� �ִٰ� ����
-- ����͸� ����
ALTER INDEX IDX_EMP_ENAME MONITORING USAGE;
-- ����͸� �ߴ�
ALTER INDEX IDX_EMP_ENAME NOMONITORING USAGE;
-- ��� ���� Ȯ��(�ڽ��� ���� �ε�����)
SELECT index_name, used FROM v$object_usage WHERE index_name = 'IDX_EMP_ENAME';
-- sys �������� ��� �ε����� ��� ������ ��ȸ�ϰ� ������ ������ �並 �����Ͽ� ��ȸ
create or replace view v$all_index_usage(
    index_name, table_name, owner_name, monitoring, used, start_monitoring, end_monitoring) as
        select a.name, b.name, e.name,
               decode(bitAND(c.flags, 65536), 0, 'NO', 'YES'),
               decode(bitAND(d.flags, 1), 0, 'NO', 'YES'),
               d.start_monitoring, d.end_monitoring
        from sys.obj$ a, sys.obj$ b, sys.ind$ c, sys.user$ e, sys.object_usage d
        where c.obj# = d.obj# and a.obj# = d.obj# and b.obj# = c.bo# and e.user# = a.owner#;

select * from v$all_index_usage;

-- scott ������ Ư�� �ε����� ��ȸ�� ����͸� �� ������ ������ �並 �ٽ� ��ȸ
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

-- �ε��� Rebuild �ϱ�
-- �뷮�� dml �۾� ���� ���� �Ŀ��� �Ϲ������� �ε����� �뷱�� ���¸� �����Ͽ� ������ ���� ��� �����ϴ� �۾��� ����

-- �׽�Ʈ�� ���̺� idx_test�� �����ϰ� �����͸� �Է� �� �ε��� ����
CREATE TABLE idx_test (no NUMBER);

BEGIN FOR i IN 1..10000 LOOP INSERT INTO idx_test VALUES(i);
END LOOP;
COMMIT;
END;

CREATE INDEX IDX_IDXTEST_NO ON idx_test(no);

-- �ε����� ���¸� ��ȸ
analyze index idx_idxtest_no VALIDATE STRUCTURE;
SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';

-- ���̺��� 10000���� ������ �� 4000���� ���� �� �ε��� ���¸� ��ȸ
DELETE FROM idx_test WHERE no BETWEEN 1 AND 4000;
SELECT COUNT(*) FROM idx_test;

SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';
analyze index idx_idxtest_no VALIDATE STRUCTURE;
SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';
-- -> �뷫 40�ۼ�Ʈ ���� �뷱���� ������ ����

-- Rebuild �۾����� ����
ALTER INDEX idx_idxtest_no REBUILD;
analyze index idx_idxtest_no VALIDATE STRUCTURE;
SELECT (del_lf_rows_len / lf_rows_len) * 100 BALANCE FROM index_stats WHERE name = 'IDX_IDXTEST_NO';
-- -> �ٽ� �뷱���� 0���� ������

-- Invisible Index : �ε����� �����ϱ� ���� '��� ����' ���·� ����� �׽�Ʈ �غ� �� �ִ� ���

















commit;