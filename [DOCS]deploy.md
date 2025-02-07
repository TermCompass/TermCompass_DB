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

## 📌 실행 방법 (로컬 배포)

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

### 3. MySQL 접속, schema.sql 실행

```bash
## Docker 컨테이너 외부에서 MySQL 접속 후, schema.sql 실행하기
# docker exec -i termcompass_DB mysql -u root -p < ./sql/schema.sql

### or

#Docker 컨테이너 내부에서 MySQL 접속하기
docker exec -it termcompass_DB mysql -u root -p

# (MySQL 접속 상태에서) 수동으로 schema.sql 실행하기
SOURCE /docker-entrypoint-initdb.d/schema.sql;
```

### 4. 컨테이너 실행 확인
```bash
docker ps
```

### 5. 로컬 docker 배포 확인
> 확인

### [필요 시]컨테이너 중지 및 삭제
```bash
docker-compose down

# 컨테이너 볼륨까지 초기화하기
docker-compose down -v
```

---
## 📌 실행 방법 (클라우드 배포)

### 1. 로컬 이미지 태그 변경
```bash
docker tag mysql:8.0 [도커 계정]/mysql:latest
```
### 2. Docker hub push
```bash
docker push [도커 계정]/mysql:latest
```

### Azure VM 생성

```bash
ssh azureuser@10.0.0.5
```


### Azure VM 커맨드에서 도커 설치
```bash
# 도커 설치 확인
docker --version

# 도커 설치
sudo apt update
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo systemctl enable --now docker

# 도커 실행 권한 확인
docker ps

# Permission denied 오류가 발생 시
sudo usermod -aG docker $USER
newgrp docker


docker pull kimdaehyun99/msql

docker images


# 컨테이너 내부로 접속
docker exec -it termcompass bash

# 파일 존재 여부 확인
ls -al /docker-entrypoint-initdb.d/
ls -al /etc/mysql/

# or 

# MySQL 컨테이너 내부 접속
docker exec -it termcompass_DB mysql -u termcompass -p

# 테이블 데이터 확인
SHOW DATABASES;
USE termcompass;
SHOW TABLES;
```
