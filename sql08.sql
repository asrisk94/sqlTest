--1. 영어영문학과(학과코드002) 학생들의학번과이름, 입학년도를 
--입학년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
--(단, 헤더는"학번", "이름", "입학년도" 가표시되도록핚다.)

select * from tb_class;
select * from tb_student;
select * from tb_department;
select * from tb_class_professor;
select * from tb_professor;
select * from tb_grade;

select student_no 학번, student_name 이름, to_char(entrance_date, 'yyyy-mm-dd') 입학년도
from tb_student
where department_no = '002'
order by extract(year from entrance_date);



--2. 춘 기술대학교의 교수중 이름이 세글자가 아닌 교수가 한명 있다고 한다. 
--그교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해보자.
--(*이때 올바르게 작성한 SQL 문장의 결과값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)

select professor_name, professor_ssn
from tb_professor
where professor_name not like '___';



--3. 춘 기술대학교의 남자교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 
--단 이때 나이가 적은 사람에서 많은사람 순서로 화면에 출력되도록 만드시오. 
--(단, 교수중 2000년 이후 출생자는 없으며 출력헤더는 "교수이름", "나이"로 한다.나이는‘만’으로 계산한다.)

select professor_name 교수이름,
    trunc(months_between(sysdate, to_date(
        decode(substr(professor_ssn, instr(professor_ssn, '-')+1, 1), 1, 19, 2, 19, 20) || substr(professor_ssn, 1, 6)
                                    )
                    ) / 12) 나이
from tb_professor
where substr(professor_ssn, instr(professor_ssn, '-')+1, 1) in (1, 3)
order by 나이;



--4. 교수들의 이름중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오.
--출력헤더는‚ "이름"이 찍히도록 한다.(성이 2자인 경우의 교수는 없다고 가정하시오)

select substr(professor_name, 2) 이름
from tb_professor;



--5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 
--이때, 19살에 입학하면 재수를 하지 않은것으로 간주한다.

select student_no, student_name, 
        (extract(year from entrance_date) - 
        (decode(substr(student_ssn, instr(student_ssn, '-')+1, 1), 1, 19, 2, 19, 20) || 
        substr(student_ssn, 1, 2)) + 1) 입학나이
from tb_student
where (extract(year from entrance_date) - 
        (decode(substr(student_ssn, instr(student_ssn, '-')+1, 1), 1, 19, 2, 19, 20) || 
        substr(student_ssn, 1, 2)) + 1) > 20;



--6. 2020년크리스마스는무슨요일인가?

select to_char(to_date('20201225'), 'day') "크리스마스 요일"
from dual;



--7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')은 각각 몇년 몇월 몇일을 의미할까?
--   또TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')은 각각몇년 몇월 몇일을 의미할까?

-- 예측 : yy는 해당 날짜 그대로.
--       rr은 반세기를 기준으로 한다고 했으니, 49/10/11은 2049/10/11가 나올듯
select
to_date('99/10/11', 'yy/mm/dd') 기본, extract(year from  to_date('99/10/11', 'yy/mm/dd')) 연도,
to_date('49/10/11', 'yy/mm/dd') 기본, extract(year from  to_date('49/10/11', 'yy/mm/dd')) 연도,
to_date('99/10/11', 'rr/mm/dd') 기본, extract(year from  to_date('99/10/11', 'rr/mm/dd')) 연도,
to_date('49/10/11', 'rr/mm/dd') 기본, extract(year from  to_date('49/10/11', 'rr/mm/dd')) 연도
from dual;
-- 결과 : 1900년대라는 입력 없이 99를 yy로 받을 때에는 무조건 현세기인 2000년을 기준으로 해버린다.
--       rr은 예측이 맞아서 1999년, 2049년이 나왔다.



--8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 
--2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.

select student_no 학번, student_name 이름
from tb_student
where entrance_date < to_date('2000/01/01');

select student_no 학번, student_name 이름
from tb_student
where student_no not like 'A%';



--9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
--단,이때 출력화면의 헤더는 "평점"이라고 찍히게 하고, 점수는 반올림하여 소수점이하 한자리까지만 표시핚다.

select round(avg(point), 1) 평점
from tb_grade
where student_no = 'A517178';



--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.

select department_no 학과번호, count(*) "학생수(명)"
from tb_student
group by department_no
order by department_no;



--11. 지도교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 SQL 문을 작성하시오.

select count(*) 학생수
from tb_student
where coach_professor_no is null;


--12. 학번이 A112113인 김고운 학생의 년도별 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력화면의 헤더는 "년도", "년도별평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점이하 한자리까지만 표시핚다.

select substr(term_no, 1, 4) 연도, round(avg(point), 1) 연도별평점
from tb_grade
where student_no = 'A112113'
group by substr(term_no, 1, 4)
order by 연도;



--13. 학과별 휴학생 수를 파악하고자 한다. 학과번호와 휴학생수를 표시하는 SQL 문장을 작성하시오.

select department_no 학과번호, count(*) 휴학생수
from tb_student
where absence_yn = 'Y'
group by department_no
order by department_no;



--14.춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 어떤 SQL 문장을 사용하면 가능하겠는가?

select student_name, count(*) 사람수
from tb_student
group by student_name
having count(*) > 1;



--15. 학번이 A112113 인 김고운학생의 년도, 학기별 평점과 년도별 누적평점, 총평점을 구하는 SQL 문을작성하시오.
--(단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)

select nvl(substr(term_no, 1, 4), '총평균') 연도, nvl(term_no, '연평균') 학기, round(avg(point), 2) 평점
from tb_grade
where student_no = 'A112113'
group by rollup(substr(term_no, 1, 4), term_no)
order by substr(term_no, 1, 4), term_no;

-- 학기별 누적평점
select term_no, round(avg(point) over(order by term_no), 2) 누적평균
from tb_grade
where student_no = 'A112113';
