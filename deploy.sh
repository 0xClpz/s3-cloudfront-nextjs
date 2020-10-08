#!/bin/bash
(cd ./infra && terraform init)
CF_ID=$(cd ./infra && terraform output cf_id)
BUCKET=$(cd ./infra && terraform output bucket)
yarn install
rm -rf ./out
yarn build
yarn next export
AWS_PROFILE=perso aws s3 sync ./out s3://$BUCKET --delete --acl public-read
AWS_PROFILE=perso aws cloudfront create-invalidation --distribution-id $CF_ID --paths "/*"
