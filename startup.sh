docker compose down -v --remove-orphans
sudo docker compose up -d --wait

# Wait for Keycloak to be ready
echo "Waiting for Keycloak to be ready..."
until curl -sf http://localhost:8888/auth/realms/master > /dev/null 2>&1; do
  echo "  Keycloak not ready, waiting..."
  sleep 3
done
echo "Keycloak is ready!"

sudo pkill -f "go"

sudo go run ./service provision keycloak
sudo go run ./service provision fixtures
sudo go run ./service start &

sleep 6

otdfctl policy attributes list --host http://localhost:8080 --with-client-creds '{"clientId":"sarah.chen","clientSecret":"mock.jwt.token"}' --tls-no-verify