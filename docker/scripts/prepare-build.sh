#!/bin/bash
set -e
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix compile
cd assets && npm install && npm run deploy
cd ..
MIX_ENV=prod mix phx.digest
MIX_ENV=prod mix release