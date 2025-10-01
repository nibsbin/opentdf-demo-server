./.github/scripts/init-temp-keys.sh
sudo cp ./keys/localhost.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates

# Kill existing containers and start fresh
docker ps -aq | xargs -r docker rm -f
docker compose up -d --wait

sleep 4
read -p "Are the docker containers ready? Press Enter to continue..."

go run ./service provision keycloak
go run ./service provision fixtures
go run ./service start &