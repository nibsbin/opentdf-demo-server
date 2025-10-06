
sudo docker compose up -d --wait

sleep 3

sudo go run ./service provision keycloak
sudo go run ./service provision fixtures
sudo go run ./service start

