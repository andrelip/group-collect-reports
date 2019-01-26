#!/bin/bash
set -e
docker-compose build builder
docker-compose run builder
cp -R ../.group_collect_docker_cache/build-cache/_build/prod/rel/group_collect/ .build_cache
docker-compose build release
rm -rf .build_cache/
