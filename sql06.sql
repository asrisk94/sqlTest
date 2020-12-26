--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.

select to_char(to_date(20201225), 'day') as "2020년 12월 25일"
from dual;



--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.

select * from department;
select * from job;

select E.emp_name 사원명, E.emp_no 주민번호, D.dept_title 부서명, J.job_name 직급명
from employee E 
        join department D   on E.dept_code = D.dept_id
        join job J          using(job_code)
where (substr(E.emp_no, 1, 2) between 70 and 79)
        and (substr(E.emp_no, instr(E.emp_no, '-')+1, 1) in ('2', '4'))
        and E.emp_name like '전%';



--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.

select 
E.emp_id 사번, E.emp_name 사원명,
        extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(E.emp_no, 1, 6))))+1 나이,
        D.dept_title 부서명, J.job_name 직급명
from employee E 
        join department D   on E.dept_code = D.dept_id
        join job J          using(job_code)
where extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(E.emp_no, 1, 6))))+1
        =
        (select min
        (
        extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(emp_no, 1, 6))))+1
        ) 
        from employee);
-- 서브쿼리문 : 가장 어린 나이 추출
-- 메인쿼리문 : 나이가 (서브쿼리문)인 사람의 컬럼들 추출



--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.

select E.emp_id 사번, E.emp_name 사원명, d.dept_title 부서명
from employee E, department D
where (E.dept_code = D.dept_id)
    and (E.emp_name like '%형%');



--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

select * from nation;
select * from location;
select * from employee;
select * from department;

select E.emp_name 사원명, J.job_name 직급명, E.dept_code 부서코드, D.dept_title 부서명
from employee E 
        join job J          using(job_code)
        join department D   on E.dept_code = D.dept_id
where D.dept_title like '%해외영업%'
        or D.dept_title like '%해외 영업%';



--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

select E.emp_name 사원명, E.bonus 보너스포인트, D.dept_title 부서명, l.local_name 근무지역명
from employee E
        join department D   on E.dept_code = D.dept_id
        join location L     on D.location_id = L.local_code
where E.bonus is not null;



--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

select E.emp_name 사원명, J.job_name 직급명, D.dept_title 부서명, l.local_name 근무지역명
from employee E
        join department D   on E.dept_code = D.dept_id
        join job J          using(job_code)
        join location L     on D.location_id = L.local_code
where E.dept_code = 'D2';
        


--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)

select * from sal_grade;

select E.emp_name 사원명, J.job_name 직급명, E.salary 급여, E.salary*12 연봉
from employee E
        join sal_grade SG   using(sal_level)
        join job J          using(job_code)
where E.salary > SG.max_sal;



--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.

select E.emp_name 사원명, D.dept_title 부서명, L.local_name 지역명, N.national_name 국가명
from employee E
        join department D   on E.dept_code = D.dept_id
        join location L     on d.location_id = l.local_code
        join nation N       using(national_code)
where national_code in ('KO', 'JP');



--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용

select A.emp_name 사원명, dept_code 부서코드, B.emp_name 동료이름
from employee A
        join employee B     using(dept_code);



--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.

select E.emp_name 사원명, J.job_name 직급명, E.salary 급여
from employee E
        join job J      using(job_code)
where E.bonus is null
        and J.job_name in ('차장', '사원');



--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

select count(decode(quit_yn, 'N', 1)) "재직중인 직원 수", count(decode(quit_yn, 'Y', 1)) "퇴사한 직원 수"
from employee;
