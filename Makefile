DB_URL=postgresql://root:ORiBLEcTUrdS@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=ORiBLEcTUrdS -d postgres:12-alpine

dockerclear:
	docker compose down && docker rmi simplebank_api

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" --verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" --verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" --verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" --verbose down 1

sqlc:
	docker run --rm -v ${pwd}:/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb  -destination db/mock/store.go  github.com/nicolasfelippe/simplebank/db/sqlc Store

db_docs:
	dbdocs build .\doc\db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

proto_win:
	del /S /f /q pb\*
	del /S /f /q doc\swagger\*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
		--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
    proto/*.proto
		statik -f -src=./doc/swagger -dest=./doc

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
		--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
    proto/*.proto
		statik -src=./doc/swagger -dest=./doc

evans:
	evans --host localhost --port 9090 -r repl

.PHONY: postgres evans createdb dropdb migrateup migratedown sqlc server mock migrateup1 migratedown1 dockerclear db_docs db_schema proto proto_win