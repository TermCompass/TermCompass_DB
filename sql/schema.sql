CREATE DATABASE IF NOT EXISTS termcompass;
USE termcompass;

-- -------- [현재 등급 심사 현황 테이블] ----------
CREATE TABLE company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,  -- 기업 ID (자동 증가)
    name VARCHAR(255),  -- 사명
    url VARCHAR(255),  -- 링크
    rank ENUM('A', 'B', 'C') NOT NULL,  -- 현재 등급 (A: 문제 없음, B: 문제 가능성, C: 명백한 문제)
    fluctuate ENUM('UP', 'NONE', 'DOWN') NOT NULL,  -- 등급 변동 (UP: 상승, NONE: 변동 없음, DOWN: 하락)
    file TEXT,  -- 약관 전문 (파일 경로 또는 내용 저장)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- 생성 시점 (=마지막 갱신 시점)
);

-- ---------- [문제] ----------
CREATE TABLE problem ( 
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 문제 ID (자동 증가)
    company_id INT,  -- 어느 회사의 문제인지
    content TEXT  -- 문제 내용 (약관 O번조항 O번항목이 XX법 X조 X항 위반 또는 표준 약관과 상충됨 등)
);

-- ---------- [문제 목록] ----------
CREATE TABLE problem_list (
    problem_id INT, -- 문제 ID
    target TEXT, -- 약관의 몇조 몇항이 문제인지
    case_id INT NULL, -- 문제되는 판례
    case_target VARCHAR(255) NULL, -- 핵심 내용
    standard_id INT NULL, -- 문제되는 표준
    standard_target VARCHAR(255) NULL, -- N조 N항
    regulation_id INT NULL, -- 문제되는 법령
    regulation_target VARCHAR(255) NULL -- N조 N항
);

-- ---------- [특정기업 등급 심사이력] ----------
CREATE TABLE company_history (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 심사이력 ID
    company_id INT, -- 기업 ID
    name VARCHAR(255), -- 사명
    url VARCHAR(255), -- 링크
    rank ENUM('A', 'B', 'C'), -- 당시 등급
    fluctuate ENUM('UP', 'NONE', 'DOWN'), -- 등급 변동 (UP: 상승, NONE: 변동 없음, DOWN: 하락)
    file TEXT, -- 약관 전문 (파일??? 텍스트???)
    created_at TIMESTAMP -- 생성시점
);

-- ---------- [히스토리] ----------
CREATE TABLE problems_history (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    history_id INT, -- 어느 히스토리에 관한 문제인지
    content TEXT -- 문제 내용
);

-- ---------- [히스토리 리스트] ----------
CREATE TABLE problem_history_list (
    problem_history_id INT, -- 문제 기록 ID
    target TEXT, --약관의 몇조 몇항이 문제인지
    case_id INT NULL, -- 문제되는 판례
    case_target VARCHAR(255) NULL, -- 핵심 내용
    standard_id INT NULL, -- 문제되는 표준
    standard_target VARCHAR(255) NULL, -- N조 N항
    regulation_id INT NULL, -- 문제되는 법령
    regulation_target VARCHAR(255) NULL -- N조 N항
);

-- ----------------------- 표준 약관 / 판례 / 법령 데이터
-- ----------------------- 표준 약관 / 판례 / 법령 데이터
-- ----------------------- 표준 약관 / 판례 / 법령 데이터

-- ---------- [분류] ----------
CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(255)
);

-- ---------- [표준약관 테이블] ----------
CREATE TABLE standard (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    category_id INT, -- 분류 코드
    name VARCHAR(255), -- 약관 명칭
    updated_at TIMESTAMP, --db상 업데이트가 아닌 실제 개정 날짜 관리자가 직접 기입
    created_at TIMESTAMP, 
    file TEXT, -- 표준약관 파일 경로
    updated BOOLEAN -- 최신인지 여부
);

-- ---------- [판례 데이터] ----------
CREATE TABLE `case` ( -- case는 MySQL에서 조건문으로 쓰이는 예약어임. ``으로 감싸면 해결됨.
    id INT AUTO_INCREMENT PRIMARY KEY, 
    category_id INT, -- 분류 코드
    name VARCHAR(255), -- 판례 제목
    case_end_at TIMESTAMP, -- db상 업데이트가 아닌 실제 판결 날짜 관리자가 직접 기입
    created_at TIMESTAMP
);

-- ---------- [규제 법령 정보] ----------
CREATE TABLE regulations (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 규제 고유 ID
    category_id INT, -- 분류 코드
    is_active BOOLEAN, -- 활성상태 여부 (개정, 폐지 등으로 무효 가능성)
    law_name VARCHAR(255), -- 법률 이름 (약관법, 개인정보 보호법 등)
    effect_at TIMESTAMP, -- 공표 날짜 직접 기입
    created_at TIMESTAMP -- 생성시점
);

-- ----------------------- 사용자 / 기록 / 사용자 요청 기록
-- ----------------------- 사용자 / 기록 / 사용자 요청 기록
-- ----------------------- 사용자 / 기록 / 사용자 요청 기록

-- ---------- [사용자] ----------
CREATE TABLE IF NOT EXISTS user (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account_type ENUM('PERSONAL', 'COMPANY'),
  email VARCHAR(255),
  number VARCHAR(255),
  password VARCHAR(255), -- (암호화 필요)
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ---------- [고객 타입 enum] ----------
-- PERSONAL 개인
-- COMPANY 기업
CREATE TABLE account_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('PERSONAL', 'COMPANY') NOT NULL
);

-- ---------- [기록] ----------
CREATE TABLE IF NOT EXISTS record (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  record_type ENUM('REVIEW', 'GENERATE', 'CHAT'),
  result TEXT
);

-- ---------- [작업 타입 enum] ----------
-- REVIEW 검토
-- GENERATE 생성
-- CHAT 채팅
CREATE TABLE record_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('REVIEW', 'GENERATE', 'CHAT') NOT NULL
);

-- ---------- [사용자 요청 기록] ----------
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


-- ---------- [외래 키 설정 (참조 무결성)] ----------
-- Ref: "category"."id" < "standard"."category_id"
ALTER TABLE standard 
ADD CONSTRAINT fk_standard_category 
FOREIGN KEY (category_id) REFERENCES category(id);

-- Ref: "user"."id" < "record"."user_id"
ALTER TABLE record 
ADD CONSTRAINT fk_record_user 
FOREIGN KEY (user_id) REFERENCES user(id);

-- Ref: "record"."id" < "request"."record_id"
ALTER TABLE request 
ADD CONSTRAINT fk_request_record 
FOREIGN KEY (record_id) REFERENCES record(id);

-- Ref: "request"."standard_id" > "standard"."id"
ALTER TABLE request 
ADD CONSTRAINT fk_request_standard 
FOREIGN KEY (standard_id) REFERENCES standard(id);

-- Ref: "case"."id" < "request"."case_id"
ALTER TABLE request 
ADD CONSTRAINT fk_request_case 
FOREIGN KEY (case_id) REFERENCES `case`(id);

-- Ref: "company"."company_id" < "problem"."company_id"
ALTER TABLE problem 
ADD CONSTRAINT fk_problem_company 
FOREIGN KEY (company_id) REFERENCES company(company_id);

-- Ref: "company_history"."id" < "problems_history"."history_id"
ALTER TABLE problems_history 
ADD CONSTRAINT fk_problems_history_company_history 
FOREIGN KEY (history_id) REFERENCES company_history(id);

-- Ref: "problem"."id" < "problem_list"."problem_id"
ALTER TABLE problem_list 
ADD CONSTRAINT fk_problem_list_problem 
FOREIGN KEY (problem_id) REFERENCES problem(id);

-- Ref: "problems_history"."id" < "problem_history_list"."problem_history_id"
ALTER TABLE problem_history_list 
ADD CONSTRAINT fk_problem_history_list_problems_history 
FOREIGN KEY (problem_history_id) REFERENCES problems_history(id);

-- Ref: "regulations"."id" < "problem_list"."regulation_id"
ALTER TABLE problem_list 
ADD CONSTRAINT fk_problem_list_regulation 
FOREIGN KEY (regulation_id) REFERENCES regulations(id);

-- Ref: "regulations"."id" < "problem_history_list"."regulation_id"
ALTER TABLE problem_history_list 
ADD CONSTRAINT fk_problem_history_list_regulation 
FOREIGN KEY (regulation_id) REFERENCES regulations(id);

-- Ref: "standard"."id" < "problem_list"."standard_id"
ALTER TABLE problem_list 
ADD CONSTRAINT fk_problem_list_standard 
FOREIGN KEY (standard_id) REFERENCES standard(id);

-- Ref: "standard"."id" < "problem_history_list"."standard_id"
ALTER TABLE problem_history_list 
ADD CONSTRAINT fk_problem_history_list_standard 
FOREIGN KEY (standard_id) REFERENCES standard(id);

-- Ref: "case"."id" < "problem_list"."case_id"
ALTER TABLE problem_list 
ADD CONSTRAINT fk_problem_list_case 
FOREIGN KEY (case_id) REFERENCES `case`(id);

-- Ref: "case"."id" < "problem_history_list"."case_id"
ALTER TABLE problem_list 
ADD CONSTRAINT fk_problem_list_case 
FOREIGN KEY (case_id) REFERENCES `case`(id);

-- ---------- [법령 임베딩 테이블] ----------
CREATE TABLE reg_embedding (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 임베딩 ID (자동 증가)
    regulation_id INT,  -- 관련 법령 ID
    article_number TEXT,  -- 조항 번호 (N조 N항)
    content TEXT,  -- 원문 내용
    embedding TEXT  -- 임베딩 데이터 (벡터 값 저장)
);

-- ---------- [표준 약관 임베딩 테이블] ----------
CREATE TABLE standard_embedding (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 임베딩 ID (자동 증가)
    standard_id INT,  -- 관련 표준 약관 ID
    article_number TEXT,  -- 조항 번호 (N조 N항)
    content TEXT,  -- 원문 내용
    embedding TEXT  -- 임베딩 데이터 (벡터 값 저장)
);

-- ---------- [판례 임베딩 테이블] ----------
CREATE TABLE case_embedding (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 임베딩 ID (자동 증가)
    case_id INT,  -- 관련 판례 ID
    article_number TEXT,  -- 조항 번호 (N조 N항)
    content TEXT,  -- 원문 내용
    embedding TEXT  -- 임베딩 데이터 (벡터 값 저장)
);

-- ---------- [외래 키 설정 (참조 무결성)] ----------
-- Ref: "regulations"."id" < "reg_embeding"."regulation_id"
ALTER TABLE reg_embedding 
ADD CONSTRAINT fk_reg_embedding_regulation 
FOREIGN KEY (regulation_id) REFERENCES regulations(id);

-- Ref: "standard"."id" < "standard_embeding"."standard_id"
ALTER TABLE standard_embedding 
ADD CONSTRAINT fk_standard_embedding_standard 
FOREIGN KEY (standard_id) REFERENCES standard(id);

-- Ref: "case"."id" < "case_embeding"."case_id"
ALTER TABLE case_embedding 
ADD CONSTRAINT fk_case_embedding_case 
FOREIGN KEY (case_id) REFERENCES `case`(id);

-- Ref: "category"."id" < "regulations"."category_id"
ALTER TABLE regulations 
ADD CONSTRAINT fk_regulations_category 
FOREIGN KEY (category_id) REFERENCES category(id);

-- Ref: "category"."id" < "case"."category_id"
ALTER TABLE `case` 
ADD CONSTRAINT fk_case_category 
FOREIGN KEY (category_id) REFERENCES category(id);