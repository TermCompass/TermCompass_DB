/* =========================================
   1) DB 생성 및 사용
   - 이전에 남아있을 수 있는 DB 자체를 삭제 후 재생성.
   ========================================= */
DROP DATABASE IF EXISTS termcompass;
CREATE DATABASE termcompass;
USE termcompass;


/* =========================================
   2) 테이블 생성
   - rank 컬럼 -> `rank`로 감싸기
   - case 컬럼 -> `case`로 감싸기
   ========================================= */

   
/* -- [현재 등급 심사 현황 테이블] -- */
CREATE TABLE company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    url VARCHAR(255),
    `rank` ENUM('A','B','C') NOT NULL,       -- `rank`
    fluctuate ENUM('UP','NONE','DOWN') NOT NULL,
    file TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* -- [문제 테이블] -- */
CREATE TABLE problem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    content TEXT
);

/* -- [문제 목록] -- */
CREATE TABLE problem_list (
    problem_id INT,
    target TEXT,
    case_id INT NULL,
    case_target VARCHAR(255) NULL,
    standard_id INT NULL,
    standard_target VARCHAR(255) NULL,
    regulation_id INT NULL,
    regulation_target VARCHAR(255) NULL
);

/* -- [특정기업 등급 심사이력] -- */
CREATE TABLE company_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    name VARCHAR(255),
    url VARCHAR(255),
    `rank` ENUM('A','B','C'),           -- rank
    fluctuate ENUM('UP','NONE','DOWN'),
    file TEXT,
    created_at TIMESTAMP
);

/* -- [히스토리] -- */
CREATE TABLE problems_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    history_id INT,
    content TEXT
);

/* -- [히스토리 리스트] -- */
CREATE TABLE problem_history_list (
    problem_history_id INT,
    target TEXT,
    case_id INT NULL,
    case_target VARCHAR(255) NULL,
    standard_id INT NULL,
    standard_target VARCHAR(255) NULL,
    regulation_id INT NULL,
    regulation_target VARCHAR(255) NULL
);

/* -- [분류] -- */
CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(255)
);

/* -- [표준 약관] -- */
CREATE TABLE standard (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255),
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    file TEXT,
    updated BOOLEAN
);

/* -- [판례] -- */
CREATE TABLE `case` ( -- `case`
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255),
    case_end_at TIMESTAMP,
    created_at TIMESTAMP
);

/* -- [규제 법령] -- */
CREATE TABLE regulations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    is_active BOOLEAN,
    law_name VARCHAR(255),
    effect_at TIMESTAMP,
    created_at TIMESTAMP
);

/* -- [사용자] -- */
CREATE TABLE IF NOT EXISTS `user` ( -- `user`
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_type ENUM('PERSONAL','COMPANY'),
    email VARCHAR(255),
    number VARCHAR(255),
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

/* -- [고객 타입 enum 테이블] -- */
CREATE TABLE account_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('PERSONAL', 'COMPANY') NOT NULL
);

/* -- [작업 타입 enum 테이블] -- */
CREATE TABLE record_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('REVIEW', 'GENERATE', 'CHAT') NOT NULL
);

/* -- [기록] -- */
CREATE TABLE IF NOT EXISTS record (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  record_type ENUM('REVIEW', 'GENERATE', 'CHAT'),
  result TEXT
);

/* -- [사용자 요청 기록] -- */
CREATE TABLE IF NOT EXISTS request (
  id INT AUTO_INCREMENT PRIMARY KEY, -- 기록 ID
  record_id INT,
  request TEXT,
  file TEXT,
  standard_id INT DEFAULT 0,
  case_id INT DEFAULT 0,
  answer TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =========================================
   3) 임베딩 테이블
   ========================================= */

/* -- [법령 임베딩] -- */
CREATE TABLE reg_embedding (
    id INT AUTO_INCREMENT PRIMARY KEY,
    regulation_id INT,
    article_number TEXT,
    content TEXT,
    embedding TEXT
);

/* -- [표준 약관 임베딩] -- */
CREATE TABLE standard_embedding (
    id INT AUTO_INCREMENT PRIMARY KEY,
    standard_id INT,
    article_number TEXT,
    content TEXT,
    embedding TEXT
);

/* -- [판례 임베딩] -- */
CREATE TABLE case_embedding (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT,
    article_number TEXT,
    content TEXT,
    embedding TEXT
);

/* =========================================
   4) 외래 키 설정 (ALTER TABLE)
   - 테이블을 모두 생성한 뒤 FK를 추가해야 함
   - 중복 FK 이름 주의
   ========================================= */


/* [category -> standard] */
ALTER TABLE standard 
  ADD CONSTRAINT fk_standard_category 
  FOREIGN KEY (category_id) REFERENCES category(id);

/* [user -> record] */
ALTER TABLE record
  ADD CONSTRAINT fk_record_user
  FOREIGN KEY (user_id) REFERENCES `user`(id);

/* [record -> request] */
ALTER TABLE request 
  ADD CONSTRAINT fk_request_record 
  FOREIGN KEY (record_id) REFERENCES record(id);

/* [request -> standard] */
ALTER TABLE request 
  ADD CONSTRAINT fk_request_standard 
  FOREIGN KEY (standard_id) REFERENCES standard(id);

/* [request -> case] */
ALTER TABLE request 
  ADD CONSTRAINT fk_request_case 
  FOREIGN KEY (case_id) REFERENCES `case`(id);

/* [company -> problem] */
ALTER TABLE problem 
  ADD CONSTRAINT fk_problem_company 
  FOREIGN KEY (company_id) REFERENCES company(company_id);

/* [company_history -> problems_history] */
ALTER TABLE problems_history 
  ADD CONSTRAINT fk_problems_history_company_history 
  FOREIGN KEY (history_id) REFERENCES company_history(id);

/* [problem -> problem_list] */
ALTER TABLE problem_list 
  ADD CONSTRAINT fk_problem_list_problem 
  FOREIGN KEY (problem_id) REFERENCES problem(id);

/* [problems_history -> problem_history_list] */
ALTER TABLE problem_history_list 
  ADD CONSTRAINT fk_problem_history_list_problems_history 
  FOREIGN KEY (problem_history_id) REFERENCES problems_history(id);

/* [regulations -> problem_list] */
ALTER TABLE problem_list 
  ADD CONSTRAINT fk_problem_list_regulation 
  FOREIGN KEY (regulation_id) REFERENCES regulations(id);

/* [regulations -> problem_history_list] */
ALTER TABLE problem_history_list 
  ADD CONSTRAINT fk_problem_history_list_regulation 
  FOREIGN KEY (regulation_id) REFERENCES regulations(id);

/* [standard -> problem_list] */
ALTER TABLE problem_list
  ADD CONSTRAINT fk_problem_list_standard
  FOREIGN KEY (standard_id) REFERENCES standard(id);

/* [standard -> problem_history_list] */
ALTER TABLE problem_history_list
  ADD CONSTRAINT fk_problem_history_list_standard
  FOREIGN KEY (standard_id) REFERENCES standard(id);

/* [case -> problem_list] */
ALTER TABLE problem_list
  ADD CONSTRAINT fk_problem_list_case
  FOREIGN KEY (case_id) REFERENCES `case`(id);

/* [case -> problem_history_list] */
ALTER TABLE problem_history_list
  ADD CONSTRAINT fk_problem_history_list_case
  FOREIGN KEY (case_id) REFERENCES `case`(id);

/* [regulations -> reg_embedding] */
ALTER TABLE reg_embedding
  ADD CONSTRAINT fk_reg_embedding_regulation
  FOREIGN KEY (regulation_id) REFERENCES regulations(id);

/* [standard -> standard_embedding] */
ALTER TABLE standard_embedding
  ADD CONSTRAINT fk_standard_embedding_standard
  FOREIGN KEY (standard_id) REFERENCES standard(id);

  /* [case -> case_embedding] */
ALTER TABLE case_embedding
  ADD CONSTRAINT fk_case_embedding_case
  FOREIGN KEY (case_id) REFERENCES `case`(id);

/* [category -> regulations] */
ALTER TABLE regulations
  ADD CONSTRAINT fk_regulations_category
  FOREIGN KEY (category_id) REFERENCES category(id);

/* [category -> case] */
ALTER TABLE `case`
  ADD CONSTRAINT fk_case_category
  FOREIGN KEY (category_id) REFERENCES category(id);