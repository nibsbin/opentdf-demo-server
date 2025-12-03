docker compose down -v --remove-orphans
sudo docker compose up -d --wait

sleep 3

sudo pkill -f "go"

sudo go run ./service provision keycloak
sudo go run ./service provision fixtures
sudo go run ./service start &

sleep 6

otdfctl policy attributes list --host http://localhost:8080 --with-client-creds '{"clientId":"sarah.chen","clientSecret":"password123"}' --tls-no-verify