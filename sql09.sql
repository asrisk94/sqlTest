
--* MEMBER_CODE(NUMBER) - 기본키                       -- 회원전용코드 
--* MEMBER_ID (varchar2(20) ) - 중복금지                  -- 회원 아이디
--* MEMBER_PWD (char(20)) - NULL 값 허용금지                 -- 회원 비밀번호
--* MEMBER_NAME(varchar2(30))                             -- 회원 이름
--* MEMBER_ADDR (varchar2(100)) - NULL값 허용금지                    -- 회원 거주지
--* GENDER (char(3)) - '남' 혹은 '여'로만 입력 가능             -- 성별
--* PHONE(char(11)) - NULL 값 허용금지                   -- 회원 연락처

create table EX_MEMBER(
    MEMBER_CODE number,
    MEMBER_ID varchar2(20),
    MEMBER_PWD char(20) not null,
    MEMBER_NAME varchar2(30),
    MEMBER_ADDR varchar2(100) not null,
    GENDER char(3),
    PHONE char(11) not null,
    constraint pk_ex_member_member_code primary key (MEMBER_CODE),
    constraint uq_ex_member_member_id unique (member_id),
    constraint ck_ex_member_gender check (gender in ('남', '여'))
);

select * from ex_member;

select * from user_constraints
where table_name = 'EX_MEMBER';

select * from user_cons_columns
where table_name = 'EX_MEMBER';

select constraint_name, ucc.column_name, UC.search_condition
from user_constraints UC
        join user_cons_columns UCC  using(constraint_name)
where UC.table_name = 'EX_MEMBER';



select *
from user_col_comments
where table_name = 'EX_MEMBER';

comment on column ex_member.member_code is '회원전용코드';
comment on column ex_member.member_id is '회원 아이디';
comment on column ex_member.member_pwd is '회원 비밀번호';
comment on column ex_member.member_name is '회원 이름';
comment on column ex_member.member_addr is '회원 거주지';
comment on column ex_member.gender is '성별';
comment on column ex_member.phone is '회원 연락처';

---------------------------------------------------------------------

--2. EX_MEMBER_NICKNAME 테이블을 생성하자. (제약조건 이름 지정할것)
--(참조키를 다시 기본키로 사용할 것.)
--* MEMBER_CODE(NUMBER) - 외래키(EX_MEMBER의 기본키를 참조), 중복금지       -- 회원전용코드
--* MEMBER_NICKNAME(varchar2(100)) - 필수                       -- 회원 이름

create table EX_MEMBER_NICKNAME(
    member_code number,
    member_nickname varchar2(100) not null,
    constraint fk_ex_member_nickname foreign key (member_code)
                                        REFERENCES ex_member(member_code)
                                        on delete cascade,
    constraint pk_ex_member_nickname primary key (member_code)
);

select * from ex_member_nickname;

select *
from user_col_comments
where table_name = 'EX_MEMBER_NICKNAME';

comment on column ex_member_nickname.member_code is '회원전용코드';
comment on column ex_member_nickname.member_nickname is '회원 이름';



select *
from user_constraints
where table_name = 'EX_MEMBER_NICKNAME';

select *
from user_cons_columns
where table_name = 'EX_MEMBER_NICKNAME';

