go install github.com/opentdf/otdfctl@latest

cp opentdf-dev.yaml opentdf.yaml
sudo ./.github/scripts/init-temp-keys.sh
sudo cp ./keys/localhost.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates

# Ensure Keycloak container (runs as non-root uid 1000) can read the TLS files
# When host-bind-mounting keys into the container they must be readable by the container UID.
# Safely set ownership to uid 1000 (Keycloak user) and secure permissions for the private key.
if [ -f ./keys/localhost.key ] || [ -f ./keys/localhost.crt ]; then
	echo "Fixing ownership and permissions for ./keys/localhost.{key,crt} -> chown 1000:0 && chmod"
	sudo chown 1000:0 ./keys/localhost.key ./keys/localhost.crt || true
	sudo chmod 600 ./keys/localhost.key || true
	sudo chmod 644 ./keys/localhost.crt || true
fi

# Kill existing containers and start fresh
sudo docker ps -aq | sudo xargs -r docker rm -f

sh ./startup.sh
