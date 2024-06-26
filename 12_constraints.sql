/* CONSTRAINTS */
-- 수업 목표 : 제약 조건을 이해한다.

-- 제약조건
-- 테이블 작성 시 각 컬럼에 값 기록에 대한 제약조건을 설정할 수 있다.
-- 입력/수정 하는데이터에 문제가 없는 지 자동으로 검사해 주게 하기 위한 목적
-- primary key, not null, unique, check, foreign key

/* not null */
DROP TABLE IF EXISTS user_notnull;
CREATE TABLE IF NOT EXISTS user_notnull (
	user_no1 int NOT NULL ,
	user_id varchar(255) NOT NULL ,
	user_pwd varchar(255) NOT NULL , 
	user_name varchar(255) NOT NULL ,
	gender varchar(3) ,
	phone varchar(255) NOT NULL ,
	email varchar(255)
) ENGINE = innodb ;

INSERT INTO user_notnull (
	user_no1, user_id, user_pwd, user_name, gender, phone, email
) VALUES
(1, 'user', 'pass', '홍길동', '남', '010-2323-2323', 'hong123@gmail.com') ,
(2, 'user01', 'pass', '유관순', '여', '010-7777-7777', 'you123@gmail.com') ;

SELECT * FROM user_notnull ;

-- not null 제약 조건에 의해 에러가 발생
-- INSERT INTO user_notnull (
-- 	user_no1, user_id, user_pwd, user_name, gender,email
-- ) VALUES
-- (3, 'user03', 'pass03', '홍길동', '남','hong123@gmail.com') ;


/* unique */
-- 중복값을  허용하지 않는다.
CREATE TABLE IF NOT EXISTS user_unique (
	user_no int NOT NULL UNIQUE ,
	user_id varchar(255) NOT NULL ,
	user_pwd varchar(255) NOT NULL , 
	user_name varchar(255) NOT NULL ,
	gender varchar(3) ,
	phone varchar(255) NOT NULL ,
	email varchar(255)
) ENGINE = innodb ;

INSERT INTO user_unique (
	user_no, user_id, user_pwd, user_name, gender, phone, email
) VALUES
(1, 'user', 'pass', '홍길동', '남', '010-2323-2323', 'hong123@gmail.com') ,
(2, 'user01', 'pass', '유관순', '여', '010-7777-7777', 'you123@gmail.com') ;

-- INSERT INTO user_unique (
-- 	user_no, user_id, user_pwd, user_name, gender, phone, email
-- ) VALUES
-- (1, 'user', 'pass', '홍길동', '남', '010-2323-2323', 'hong123@gmail.com') ;

SELECT * FROM user_unique ;

-- primary key 
/* 테이블에서 한 행의 정보를 찾기 위해서 사용할 컬럼을 의미한다.
 * 테이블에 대한 식별자 역할을 한다(한 행씩 구분하는 역할을 한다.)
 * not null + unique 제약조건의 의미
 * 한 테이블 한 개만 설정할 수 있음
 * 컬럼 레벨, 테이블 레벨 둘 다 설정 가능함
 * 한 개 컬럼에 설정할 수도 있고, 여러 개의 컬럼을 묶어서 설정할 수도 있다(복합키)
 */

DROP TABLE If EXISTS user_primaykey;
CREATE TABLE IF NOT EXISTS user_primaykey (
	user_no int PRIMARY KEY ,
	user_id varchar(255) NOT NULL ,
	user_pwd varchar(255) NOT NULL , 
	user_name varchar(255) NOT NULL ,
	gender varchar(3) ,
	phone varchar(255) NOT NULL ,
	email varchar(255)
) ENGINE = innodb ;

INSERT INTO user_primaykey (
	user_no, user_id, user_pwd, user_name, gender, phone, email
) VALUES
(1, 'user', 'pass', '홍길동', '남', '010-2323-2323', 'hong123@gmail.com') ,
(2, 'user01', 'pass', '유관순', '여', '010-7777-7777', 'you123@gmail.com') ;

-- primary key는 not null 과 unique 제약조건을 갖는다.
-- INSERT INTO user_primaykey (
-- 	user_id, user_pwd, user_name, gender, phone, email
-- ) VALUES
-- ('user', 'pass', '홍길동', '남', '010-2323-2323', 'hong123@gmail.com') ;

SELECT * FROM user_primaykey ;


/* foreign key */
-- 참조(references)된 다른 테이블에서 제공하는 값만 사용할 수 있음
-- 참조 무성을 위배하지 않기 위해 사용
-- FORIEGN KEY제약조건에 의해서
-- 테이블 간의 관계가 형성됨
-- 제공되는 값 이외에는 null을 사용할 수 있음
DROP TABLE IF EXISTS user_grade ;

CREATE TABLE IF NOT EXISTS user_grade(
	grade_code int primary key ,
	grade_name varchar(255) not null
) ENGINE =innodb ;

INSERT INTO user_grade
VALUES
(10, '보통강사') ,
(20, '만족강사') ,
(30, '매우만족강사') ;

SELECT * FROM user_grade ;

DROP TABLE IF EXISTS instructor_foreingkey ;

CREATE TABLE IF NOT EXISTS instructor_foreingkey(
	user_no int primary key ,
	user_name varchar(255) not null ,
	gender varchar(3) ,
	phone varchar(255) ,
	grade_code int ,
	foreign key(grade_code)
	REFERENCES user_grade(grade_code)
) ENGINE = innodb ;
	
SELECT * FROM instructor_foreingkey ;

INSERT INTO instructor_foreingkey
VALUES (1, '왕강사', '남', '010-2322-2323', 10) ;

SELECT 
	b.grade_name ,
	a.user_name 
  FROM instructor_foreingkey a
  JOIN user_grade b ON a.grade_code = b.grade_code ;
 
 
 -- on update set null, on delete set null
 CREATE TABLE IF NOT EXISTS instructor_foreingkey2(
	user_no int primary key ,
	user_name varchar(255) not null ,
	gender varchar(3) ,
	phone varchar(255) ,
	grade_code int ,
	foreign key(grade_code)
	REFERENCES user_grade(grade_code)
	ON UPDATE SET NULL
	ON DELETE SET NULL
) ENGINE = innodb ;
	
INSERT INTO instructor_foreingkey2
VALUES (1, '왕강사', '남', '010-2322-2323', 10) ,
(2, '이상우', '남', '010-2323-2222', 30) ;

SELECT * FROM instructor_foreingkey2 ;

-- 기존에 테이블에서 참조에대한 옵션을 설정하지 않았다.
-- 이로인해 아래의 update에서 user_grade를 변경한다면 instructor_foreingkey 테이블이 참조하고 있어
-- 변경할 수 없느 오류가 발생하게 된다.
DROP TABLE IF EXISTS instructor_foreingkey;

-- grade_code = null
-- grade_code는 제약조건으로 primary key조건이 부여되었다.
-- 이로인해 grade_code를 삭제하는 것은 primary key 제약조건에 위배하여 불가능하다.
UPDATE USER_GRADE
SET grade_code = 40
WHERE grade_code = 10 ;

SELECT * FROM user_grade ;
-- 아래의 테이블을 조회하면 grade_code가 변경됨에 따라 grade_code가 null로 변경된다.
-- 이는 on update set null 옵션에 의해 참조하는 테이블이 변경되면 자신의 참조값을 null로 처리하는 것이다.
SELECT
	*
  FROM instructor_foreingkey2;
 
DELETE FROM user_grade
WHERE grade_code = 30 ;

-- 아래의 테이블을 조회하면 grade_code가 변경됨에 따라 grade_code가 null로 변경된다.
-- 이는 on delete set null 옵션에 의해 참조하는 테이블이 변경되면 자신의 참조값을 null로 처리하는 것이다.
SELECT
	*
  FROM instructor_foreingkey2;
  
 /* CHECK */
DROP TABLE IF EXISTS user_check ;

CREATE TABLE IF NOT EXISTS user_check (
    user_no INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    gender CHAR(3) CHECK (gender IN ('남', '여')),
    age INT CHECK (age >= 15)
) ENGINE = InnoDB;

INSERT INTO user_check
VALUES
(NULL, '홍길동', '남', 15) ;
-- 아래의 값은 gender에 '남' 또는 '여' 만 입력할 수 있도록 설정하였으나 '짭'이라는 값을 입력하여 오류가 발생
-- (NULL, '김길동', '짭', 20) ;
-- 아래의 값은 age에 15이상 값만 입력할 수 있도록 설정하였으나 5ㅅ가 입력되어 제약조건을 위배
-- (NULL, '신짱구', '남', 5) ;
 

-- defalut
-- 	컬럼에 null대신 기본 값 적용
-- 컬럼 타입이 date일 시 current_date 만 가능하다.
-- 컬럼 타입이 datetime일 시 current_time과 current_timestamp, now() 모두 사용 가능
DROP TABLE IF EXISTS tbl_country ;

 CREATE TABLE If NOT EXISTS tbl_country (
 	country_code int auto_increment primary key ,
 	country_name varchar(255) default '한국' ,
	poplation varchar(255) default '0명' ,
	add_day date default (current_date) ,
	add_time datetime default (current_time)
) ENGINE = innoDB ;

SELECT * FROM tbl_country;

INSERT INTO tbl_country
VALUES (null, default, default, default, default) ;

SELECT * FROM tbl_country ;









