--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오

-- 서브쿼리
select emp_name, dept_code, salary
from employee
where dept_code  = (select dept_id
                    from department
                    where dept_title = '기술지원부');

-- 조인
select emp_name, dept_code, salary
from employee E
        join department D   on E.dept_code = D.dept_id
where D.dept_title = '기술지원부';



--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오

-- 조인 & 서브쿼리
select emp_name, dept_code, salary
from employee E
        join department D   on E.dept_code = D.dept_id
where (D.dept_title = '기술지원부')
        and (salary = (select max(salary)
                        from employee E
                            join department D   on E.dept_code = D.dept_id
                        where D.dept_title = '기술지원부'));

-- inline-view & rownum
select emp_name, dept_code, salary
from (select emp_name, dept_code, salary
        from employee E
            join department D   on E.dept_code = D.dept_id
        where D.dept_title = '기술지원부'
        order by salary desc)
where rownum <= 1;



--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오. 

--	1. JOIN을 이용하시오
select E.emp_id, E.emp_name, M.emp_id, E.salary
from employee E
        join (select *
                from employee) M
            on E.manager_id = M.emp_id
where E.manager_id is not null
    and E.salary > (select trunc(avg(salary))
                    from employee);

--	2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기
select E.emp_id, E.emp_name, 
        (select emp_name
            from employee
            where emp_id = E.manager_id) 매니저이름,
            E.salary 급여
from employee E
where E.manager_id is not null
    and E.salary > (select trunc(avg(salary))
                    from employee);



--문제4
--같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회

select E.emp_name, job_code, E.salary, E.sal_level
from employee E
        join job J  using(job_code)
        join (select job_code, round(avg(salary)) 직급별평균
                from employee
                group by job_code) SELF
        using(job_code)
where salary >= SELF.직급별평균;



--문제5
--부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회
--단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리

-- 스칼라 서브쿼리
select nvl(dept_code, '인턴') 부서코드, round(avg(salary)) 평균급여,
        (select dept_title
            from department
            where nvl(dept_id, '인턴') = nvl(E.dept_code, '인턴')) 부서명
from employee E
group by nvl(dept_code, '인턴')
having round(avg(salary)) >= 3000000;

-- join
select nvl(dept_code, '인턴') 부서코드, round(avg(salary)) 평균급여, D.dept_title 부서명
from employee E
        join department D   on E.dept_code = D.dept_id
group by nvl(dept_code, '인턴'), D.dept_title
having round(avg(salary)) >= 3000000;



--문제6
--직급의 연봉 평균보다 적게 받는 여자사원의
--사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여+(급여*보너스))*12    

-- 상관 서브쿼리
select E.emp_name, J.job_name, D.dept_title, (E.salary+(E.salary*nvl(E.bonus, 0)))*12 연봉
from employee E
        join job J  on E.job_code = J.job_code
        join department D   on E.dept_code = D.dept_id
where decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), 1, '남', 3, '남', '여') = '여'
    and (E.salary+(E.salary*nvl(E.bonus, 0)))*12 < (select trunc(avg((salary+(salary*nvl(bonus, 0)))*12))
                                                        from employee
                                                        where job_code = E.job_code)
order by E.emp_name;

-- 셀프조인
select E.emp_name, J.job_name, D.dept_title, (E.salary+(E.salary*nvl(E.bonus, 0)))*12 연봉
from employee E
        join job J  on E.job_code = J.job_code
        join department D   on E.dept_code = D.dept_id
        join (select job_code, trunc(avg((salary+(salary*nvl(bonus, 0)))*12)) "직급별 평균연봉"
                                                        from employee
                                                        group by job_code) S
                on E.job_code = S.job_code
where decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), 1, '남', 3, '남', '여') = '여'
    and (E.salary+(E.salary*nvl(E.bonus, 0)))*12 < S."직급별 평균연봉"
order by E.emp_name;



---문제7
----다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요.

create table tbl_books (
book_title  varchar2(50)
,author     varchar2(50)
,loyalty     number(5)
);

insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);



select * from tbl_books;

select *
from tbl_books
where book_title in (select book_title
                    from tbl_books
                    group by book_title
                    having count(*) >= 2);
