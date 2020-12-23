--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)

select * from tb_student;

select category,
    trunc(avg(capacity)) "계열별 평균"
from tb_department
group by category
order by avg(capacity) desc;



--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)

select * from tb_department;
select * from tb_student;

select d.department_name, department_no, count(*)
from tb_student S join tb_department D
    using(department_no)
where absence_yn != 'Y'
group by d.department_name, department_no
order by count(*) desc;



--3. 과목별 지정된 교수가 2명이상이 과목번호와 교수인원수를 조회

select * from tb_professor;
select * from tb_class_professor;
select * from tb_class;

select class_no, count(*)
from tb_class_professor
group by class_no
having count(class_no) >= 2;



--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 과목수가 10개 이상인 행의 
-- 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)

select * from tb_class;

select department_no,
        class_type,
        count(department_no) 과목수
from tb_class
where class_type like '전공선택'
group by department_no, class_type
having count(department_no) >= 10
order by department_no;
