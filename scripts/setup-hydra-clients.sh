#!/bin/sh

# kubectl exec deployment/ory-hydra -- hydra clients delete --endpoint http://127.0.0.1:4445 b9f62a18-faae-43cc-a9b7-e15613e00273 2e8808cf-5889-469b-b2c3-01f0cc58c4af 8ff5c14f-60e2-41b9-b594-a641dc5013be 97853a31-d7fc-424b-a4c2-f8cd053d10d2

kubectl exec deployment/ory-hydra -- hydra create oauth2-client \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --id b9f62a18-faae-43cc-a9b7-e15613e00273 \
    --secret banana \
    --name faforever.xyz \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-type authorization_code,refresh_token \
    --scope openid,offline,public_profile,write_account_data,create_user \
    --redirect-uri http://localhost:3000/callback

kubectl exec deployment/ory-hydra -- hydra create oauth2-client \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --id 2e8808cf-5889-469b-b2c3-01f0cc58c4af \
    --name fafClient \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-type authorization_code,refresh_token \
    --scope openid,offline,public_profile,lobby,upload_map,upload_mod \
    --redirect-uri http://127.0.0.1 \
    --token-endpoint-auth-method none
	
kubectl exec deployment/ory-hydra -- hydra create oauth2-client \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --id 8ff5c14f-60e2-41b9-b594-a641dc5013be \
    --name faf-moderator-client \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-type authorization_code,refresh_token \
    --scope upload_avatar,administrative_actions,read_sensible_userdata,manage_vault \
    --redirect-uri http://127.0.0.1 \
    --token-endpoint-auth-method none

kubectl exec deployment/ory-hydra -- hydra create oauth2-client \
    --skip-tls-verify \
    --endpoint http://127.0.0.1:4445 \
    --id 97853a31-d7fc-424b-a4c2-f8cd053d10d2 \
    --name forum.faforever.com \
    --logo-uri https://faforever.com/images/faf-logo.png \
    --grant-type authorization_code,refresh_token \
    --token-endpoint-auth-method client_secret_post \
    --scope openid,public_profile \
    --redirect-uri http://127.0.0.1/auth/faf-nodebb/callback