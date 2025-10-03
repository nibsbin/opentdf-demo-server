go install github.com/opentdf/otdfctl@latest

cp opentdf-dev.yaml opentdf.yaml
sudo ./.github/scripts/init-temp-keys.sh
sudo cp ./keys/localhost.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates

# Kill existing containers and start fresh
sudo docker ps -aq | sudo xargs -r docker rm -f

sh ./startup.sh
