#!/bin/sh

docker-compose up -d selenium-hub
docker-compose run e2e-tests
exitcode=$?

if [ ! $exitcode -eq 0 ]; then
  echo "FAILURE"
  echo "Entropy available: $(docker-compose exec -T firefox sudo cat /proc/sys/kernel/random/entropy_avail)"

  docker-compose logs selenium-hub
  docker-compose logs firefox

  echo "Installing 'ping' in 'firefox' container, please wait..."
  docker-compose exec -T firefox sudo apt update 1>/dev/null 2>/dev/null
  docker-compose exec -T firefox sudo apt install -y iputils-ping 1>/dev/null 2>/dev/null
  docker-compose exec -T firefox ping -c 5 selenium-hub
fi

docker-compose down

exit $exitcode
