
sudo docker compose up -d --wait

sleep 3

sudo go run ./service provision keycloak && \
sudo go run ./service provision fixtures && \
sudo go run ./service start

# test
otdfctl decrypt test_text.txt.tdf --host http://localhost:8080 --with-client-creds '{"clientId":"opentdf","clientSecret":"secret"}' --tls-no-verify -o test_decrypted.txt
