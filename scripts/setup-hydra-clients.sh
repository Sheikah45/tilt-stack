kubectl exec deployment/ory-hydra -- hydra clients delete --endpoint http://127.0.0.1:4445 faf-lobby-server faf-website faf-java-client faf-moderator-client faf-forum

kubectl exec deployment/ory-hydra -- hydra clients create \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --fake-tls-termination \
    --id faf-lobby-server \
    --name faf-lobby-server \
    --secret banana \
    --scope write_achievements,write_events \
    --token-endpoint-auth-method client_secret_post \
    -g client_credentials

kubectl exec deployment/ory-hydra -- hydra clients create \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --fake-tls-termination \
    --id faf-website \
    --secret banana \
    --name faforever.xyz \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-types authorization_code,refresh_token \
    --response-types code \
    --scope openid,offline,public_profile,write_account_data,create_user \
    --callbacks http://localhost:3000/callback

kubectl deployment/ory-hydra -- hydra clients create \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --fake-tls-termination \
    --id faf-java-client \
    --name fafClient \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-types authorization_code,refresh_token \
    --response-types code \
    --scope openid,offline,public_profile,lobby,upload_map,upload_mod \
    --callbacks http://127.0.0.1 \
    --token-endpoint-auth-method none
	
kubectl exec deployment/ory-hydra -- hydra clients create \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --fake-tls-termination \
    --id faf-moderator-client \
    --name faf-moderator-client \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-types authorization_code,refresh_token \
    --response-types code \
    --scope upload_avatar,administrative_actions,read_sensible_userdata,manage_vault \
    --callbacks http://127.0.0.1 \
    --token-endpoint-auth-method none

kubectl exec deployment/ory-hydra -- hydra clients create \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --fake-tls-termination \
    --id faf-forum \
    --name forum.faforever.com \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-types authorization_code,refresh_token \
    --response-types code \
    --token-endpoint-auth-method client_secret_post \
    --scope openid,public_profile \
    --callbacks http://127.0.0.1/auth/faf-nodebb/callback