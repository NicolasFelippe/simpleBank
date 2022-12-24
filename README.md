# Windows

## Start
1. Install scoop  https://scoop.sh/
2. Install Docker desktop
3. Install chocolatey https://chocolatey.org/install
4. Install migrate (https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)
   1. `scoop install migrate`
5. Install makefile
   1. `choco install make`


## Docker DB

1. Execute on cmd: `docker pull postgres:12-alpine`
2. Execute on cmd `make postgres` on root folder project
3. Execute on cmd `make createdb` on root folder project
4. Execute on cmd `make migrateup` on root folder project

# Docker network
1. docker network create bank-network 
2. docker network connect bank-network postgres12

## Docker Build
1. docker build -t simplebank:latest .
2. docker run --name simplebank --network bank-network -p 8080:8080 -e DB_SOURCE="postgresql://user:password@postgres12:5432/simple_bank?sslmode=disable" -e  GIN_MODE=release  simplebank:latest


## Configure Sqlc
1. docker pull kjconroy/sqlc
2. Execute on cmd
   1. `docker run --rm -v "%cd%:/src" -w /src kjconroy/sqlc generate`
   2. PWSH: `docker run --rm -v "$(pwd):/src" -w /src kjconroy/sqlc generate`

# Create Model Sqlc


# Util
1. openssl rand -hex 64 | head -c 32  // Generate random 32 bytes

# Mock
 1. go install github.com/golang/mock/mockgen@v1.6.0
 2. go get github.com/golang/mock/ 
 3. mockgen -destination db/mock/store.go  github.com/nicolasfelippe/simplebank/db/sqlc Store