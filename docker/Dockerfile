# 1. MySQL 8.0 공식 이미지 사용
FROM mysql:8.0

# 2. MySQL 설정 파일 복사 (커스텀 설정 적용)
COPY ./docker/my.cnf /etc/mysql/my.cnf

# 3. 초기 데이터베이스 및 스키마 파일 복사 (자동 실행되도록)
COPY ./sql /docker-entrypoint-initdb.d/

# 4. CMD 생략 (MySQL 공식 컨테이너는 기본적으로 mysqld 실행됨)
# CMD ["mysqld"]
