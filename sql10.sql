
-- DDL

-- chun으로 작성

select * from tb_student;
select * from tb_professor;
select * from tb_department;
select * from tb_class;
select * from tb_class_professor;
select * from tb_grade;

--1. 계열정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.

create table tb_category (
    name varchar2(10),
    use_yn char(1) default 'Y'
);

desc tb_category;



--2. 과목구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.

drop table tb_class_type;

create table tb_class_type (
    no varchar2(5),
    name varchar2(10),
    constraint pk_tb_class_type_no primary key(no)
);



--3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
--(KEY 이름을 생성하지 않아도 무방함. 만일 KEY를 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.)

alter table tb_category add constraint pk_tb_category_name primary key(name);

select *
from user_cons_columns
where table_name = 'TB_CATEGORY';



--4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.


desc tb_class_type;

alter table tb_class_type modify name not null;



--5. 두 테이블에서 컬럼명이 NO인 것은 기존타입을 유지하면서 크기는 10으로, 
--컬럼명이 NAME인 것은 마찬가지로 기존타입을 유지하면서 크기 20으로 변경하시오.

alter table tb_category modify name varchar2(20);

alter table tb_class_type modify no varchar2(10);
alter table tb_class_type modify name varchar2(20);

desc tb_category;
desc tb_class_type;



--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각각 TB_ 를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.
--(ex. CATEGORY_NAME)

alter table tb_category rename column name to category_name;

alter table tb_class_type rename column no to class_type_no;
alter table tb_class_type rename column name to class_type_name;

desc tb_category;
desc tb_class_type;



--7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
--Primary Key의 이름은 'PK_ + 컬럼이름'으로 지정하시오. (ex. PK_CATEGORY_NAME)

alter table tb_category rename constraint pk_tb_category_name to pk_category_name;

alter table tb_class_type rename constraint pk_tb_class_type_no to pk_class_type_no;

select * from user_cons_columns
where table_name in ('TB_CATEGORY', 'TB_CLASS_TYPE');



--8. 다음과 같은 INSERT 문을 수행한다. 

select * from tb_category;

INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 



--9. TB_DEPARTMENT의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모값으로 참조하도록 FOREIGN KEY를 지정하시오.
--이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY )

select * from tb_department;
select * from tb_category;

alter table tb_department add constraint fk_tb_department_category foreign key(category) 
                                                                    references tb_category(category_name);

select * from user_cons_columns
where table_name = 'TB_DEPARTMENT';



--10. 춘 기술대학교 학생들의 정보만이 포함되어있는 학생일반정보 VIEW를 만들고자 한다. 
--아래내용을 참고하여 적절한 SQL 문을 작성하시오.


create view vw_student_normal_info
as
select student_no, student_name, student_address
from tb_student;

select * from vw_student_normal_info;



--11. 춘 기술대학교는 1년에 두번씩 학과별로 학생과 지도교수가 지도면담을 진행한다. 
--이를 위해 사용할 학생이름, 학과이름, 담당교수이름으로 구성되어 있는 VIEW 를 만드시오.
--이때 지도교수가 없는 학생이 있을 수 있음을 고려하시오
--(단, 이 VIEW는 단순 SELECT만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)

create view vw_guide_talking
as
select S.student_name, D.department_name, P.professor_name
from tb_student S
            join tb_department D    using(department_no)
            left join tb_professor P     on S.coach_professor_no = P.professor_no
order by D.department_name;

select * from vw_guide_talking;



--12. 모든 학과의 학과별 학생수를 확인할 수 있도록 적절한 VIEW를 작성해보자.

create view vw_count_per_department
as
select D.department_name as department_name, count(*) as student_count
from tb_student S
            join tb_department D    using(department_no)
group by D.department_name;

select sum(student_count) from vw_count_per_department;



--13. 위에서 생성한 학생일반정보 View를 통해서 학번이 A213046인 학생의 이름을 본인이름으로 변경하는 SQL 문을 작성하시오.

update vw_student_normal_info
set student_name = '한광희'
where student_no = 'A213046';

select * from vw_student_normal_info
where student_no = 'A213046';

select * from tb_student
where student_no = 'A213046';



--14. 13번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW를 어떻게 생성해야 하는지 작성하시오.

-- 관리자 계정에서 생성 또는 소유자 계졍에서 생성한 뒤 
-- 타 사용자 계정에 select on (읽기 권한)만 부여.



--15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기과목들에 수강신청이 몰려 문제가 되고 있다. 
--최근 3년을 기준으로 수강인원이 가장 많았던 3과목을 찾는 구문을 작성해보시오.

select *
from (select class_no, class_name, count(*)
        from tb_grade G
                join tb_class C     using(class_no)
        where substr(term_no, 1, 4) between 2007 and 2009
        group by class_no, class_name
        order by count(*) desc, class_no asc)
where rownum <= 3;
