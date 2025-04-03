#!/bin/bash

if [[ -z "$CODESPACES" ]]; then
  echo "Not in a Codespace, not running setup"
  exit 1
fi

echo "Setting up Codespace..."

DOMAIN="${CODESPACE_NAME}-80.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"

# if .env doesn't exist, copy from .env.template
if [[ ! -f .env ]]; then
  echo "Creating .env file from from .env.template and domain ${DOMAIN}..."

  cp .env.template .env
  sed -i "s|^DOMAIN=.*|DOMAIN=${DOMAIN}|" .env
else
  echo ".env file already exists"
fi

echo "Generating CODESPACES.md..."
cat <<EOF > CODESPACES.md
# The Pier on Codespaces

Hello! Your dev server will be accessible at https://${DOMAIN} shortly. Be patient, it may take 5 minutes or so.

It may be slow to load in development, that is normal. It will be faster to load when built for production.

The \`.env\` file has been configured with your Codespace's domain and the build process has begun. The dev server will start automatically once the build is complete.

Installing NPM modules, please wait...
EOF

echo "Installing NPM modules..."
npm install --global bun
bun install
rm bun.lock
(cd messages && npm run ts-proto)

cat <<EOF >> CODESPACES.md

NPM modules have been installed! Starting the dev server with this command:

\`\`\`sh
docker compose -f docker-compose-base.yaml -f docker-compose-codespaces.yaml up --force-recreate
\`\`\`

Once the dev server is running, you can access the application at https://${DOMAIN}
EOF