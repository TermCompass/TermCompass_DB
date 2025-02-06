# TermCompass_DB
TermCompass DB Server

## 프로젝트 구조
``` bash
📂 my-mysql-db/
│── 📂 sql/              # 초기 데이터 및 스키마 정의 SQL 파일 저장
│   ├── init.sql
│   ├── schema.sql
│── 📂 docker/           # Docker 관련 설정 파일
│   ├── Dockerfile
│   ├── my.cnf
│── .gitignore           # 불필요한 파일 제외
│── docker-compose.yml   # MySQL 환경 설정
│── README.md            # 프로젝트 설명
│── .env                 # 환경 변수 (비밀번호, 포트 등)

```

## 📌 실행 방법

### 0. Docker Desktop 실행
docker 상태 확인
```bash
docker info
```
### 1. `.env` 파일 생성
먼저 `.env` 파일을 생성하고 환경 변수를 설정합니다.
```ini
MYSQL_ROOT_PASSWORD=your_password
MYSQL_DATABASE=my_database
MYSQL_USER=my_user
MYSQL_PASSWORD=my_password

```
### 2. Docker Compose 실행
```bash
docker-compose up -d
```

### 3. MySQL 접속
로컬에서 MySQL 접속:
```bash
mysql -h 127.0.0.1 -P 3306 -u my_user -p
```
Docker 컨테이너 내부에서 MySQL 접속:
```bash
docker exec -it termcompass_DB mysql -u root -p

# (MySQL 접속 상태에서) 수동으로 schema.sql 실행하기
SOURCE /docker-entrypoint-initdb.d/schema.sql;
```

### 4. 컨테이너 중지 및 삭제
```bash
docker-compose down

# 컨테이너 볼륨까지 초기화하기
docker-compose down -v
```

### 5. 컨테이너 실행 확인
```bash
docker ps
```

### 6. 수동으로 schema.sql 실행하기
```bash
docker exec -i termcompass_DB mysql -u root -p < ./sql/schema.sql
```