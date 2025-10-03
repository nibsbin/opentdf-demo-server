sudo docker compose up -d --wait

sleep 3

go run ./service provision keycloak
go run ./service provision fixtures
go run ./service start &

