
-- DML

-- chun으로 작성

select * from tb_student;
select * from tb_professor;
select * from tb_department;
select * from tb_class;
select * from tb_class_professor;
select * from tb_grade;

-- 1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오

drop sequence seq_tb_class_type_no;

create sequence seq_tb_class_type_no
nocache;

insert into tb_class_type
values(to_char(seq_tb_class_type_no.nextval, 'fm00'), '전공필수');
insert into tb_class_type
values(to_char(seq_tb_class_type_no.nextval, 'fm00'), '전공선택');
insert into tb_class_type
values(to_char(seq_tb_class_type_no.nextval, 'fm00'), '교양필수');
insert into tb_class_type
values(to_char(seq_tb_class_type_no.nextval, 'fm00'), '교양선택');
insert into tb_class_type
values(to_char(seq_tb_class_type_no.nextval, 'fm00'), '논문지도');

select * from tb_class_type;



--2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생 일반정보 테이블을 만들고자 한다. 
--아래내용을 참고하여 적절한 SQL 문을 작성하시오.(서브쿼리를이용하시오)

create table tb_student_normal_info
as
select student_no, student_name, student_address
from tb_student;

select * from tb_student_normal_info;



--3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보테이블을 만들고자 한다. 
--아래내용을 참고하여 적절한 SQL 문을 작성하시오. (힌트: 방법은 다양함, 소신껏 작성하시오)

create table tb_kor_lang_lit
as
select S.student_no, S.student_name,
        (decode(substr(student_ssn, instr(student_ssn, '-')+1, 1), 1, 1900, 2, 1900, 2000) + substr(student_ssn, 1, 2))
        as birth_year,
        P.professor_name
from tb_student S
        join tb_professor P     on S.coach_professor_no = P.professor_no
where S.department_no = (select department_no
                            from tb_department
                            where department_name = '국어국문학과');

select * from tb_kor_lang_lit;



--4. 현 학과들의 정원을 10% 증가 시키게 되었다. 이에 사용할 SQL문을 작성하시오. 
--(단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)

--drop table tb_department_copy;
--
--create table tb_department_copy
--as
--select department_no, department_name, category, open_yn,
--        round(capacity + (capacity*0.1)) as "capacity_1.1"
--from tb_department;
--
--select * from tb_department_copy;

create table tb_department_copy
as
select department_no, department_name, category, open_yn,
        capacity
from tb_department;

update tb_department_copy
set capacity = round(capacity + (capacity*0.1));

select * from tb_department_copy;



--5. 학번 A413042인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21"로 변경되었다고 한다. 
--주소지를 정정하기 위해 사용할 SQL 문을 작성하시오.

create table tb_student_copy
as
select * from tb_student;

update tb_student_copy
set student_address = '서울시 종로구 숭인동 181-21'
where student_no = 'A413042';

select * from tb_student_copy
where student_no = 'A413042';



--6. 주민등록번호 보호법에 따라 학생정보테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 
--이 내용을 반영한 적절한 SQL 문장을 작성하시오. (예. 830530-2124663 ==> 830530 )

update tb_student_copy
set student_ssn = substr(student_ssn, 1, instr(student_ssn, '-')+1) || '******';

select * from tb_student_copy;



--7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강한 '피부생리학' 점수가 잘못되었다는 것을 발견하고는 정정을 요청하였다. 
--담당교수의 확인받은 결과 해당 과목의 학점을 3.5로 변경키로 결정하였다. 적절한 SQL 문을 작성하시오.

create table tb_grade_copy
as
select * from tb_grade;

update tb_grade_copy
set point = 3.5
where student_no = (select student_no
                     from tb_student_copy
                     where student_name = '김명훈'
                        and department_no = (select department_no
                                            from tb_department_copy
                                            where department_name = '의학과')
                    )
    and term_no = '200501'
    and class_no = (select class_no
                    from tb_class
                    where class_name = '피부생리학');

select * 
from tb_grade_copy 
where student_no = (select student_no
                     from tb_student_copy
                     where student_name = '김명훈'
                        and department_no = (select department_no
                                            from tb_department_copy
                                            where department_name = '의학과')
                    )
    and term_no = '200501'
    and class_no = (select class_no
                    from tb_class
                    where class_name = '피부생리학');



--8. 성적테이블(TB_GRADE)에서 휴학생들의 성적 항목을 제거하시오.

delete from tb_grade_copy
where student_no in (select student_no
                    from tb_student_copy
                    where absence_yn = 'Y');

select G.*, s.absence_yn
from tb_grade_copy G
        join tb_student_copy S  on G.student_no = S.student_no
where absence_yn = 'Y';
