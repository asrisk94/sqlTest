--1. 학번, 학생명, 학과명 조회

select * from tb_student;
select * from tb_department;

select S.student_no 학번,
        S.student_name 학생명,
        D.department_name 학과명
from tb_student S join tb_department D
                using(department_no);



--2. 학번, 학생명, 담당교수명 조회 (담당교수가 없는 학생도 포함해서 조회할것.)

select * from tb_student;
select * from tb_professor;

select S.student_no,
        S.student_name,
        P.professor_name
from tb_student S left join tb_professor P
                on S.coach_professor_no = P.professor_no;



--3. 수업번호, 수업명, 교수번호, 교수명 조회

select * from tb_class;
select * from tb_class_professor;
select * from tb_professor;

select class_no,
        C.class_name,
        professor_no,
        P.professor_name
from tb_class C join tb_class_professor CP
                using(class_no)
            join tb_professor P
                using(professor_no);
    


--4. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)

select * from tb_grade;
select * from tb_class;
select * from tb_student;

select g.term_no 학기,
        student_no 학번,
        S.student_name 학생명,
        C.class_name 수업명,
        G.point 점수
from tb_grade G join tb_class C
                    using(class_no)
                join tb_student S
                    using(student_no)
where S.student_name = '송박선'
order by G.term_no;



--5. 학생별 과목별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)

select * from tb_student;
select * from tb_class;
select * from tb_grade;

select student_no, S.student_name, C.class_name, trunc(avg(G.point), 2) 평점
from tb_grade G join tb_class C
                    using(class_no)
                join tb_student S
                    using(student_no, department_no)
group by student_no, S.student_name, C.class_name
order by student_no;

/*   
select * from tb_student where student_name = '최민건';
select * from tb_grade where student_no = 'A631359';
select * from tb_class where class_name = '노사관계론';
*/