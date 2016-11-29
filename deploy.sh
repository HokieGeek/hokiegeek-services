#!/bin/bash

if (( $# > 0 )); then
	services=($@)
else
    services=(
              restarter.service
              hgtea.service
              hokiegeek.service
              couchdb.service
              donded.service
              )
fi

dest=/etc/systemd/system

for svc in "${services[@]}"; do
    echo "[Copying ${svc}]"
	if [ ! -f "./${svc}" ]; then
		echo "Not found" >&2
	else
    	cp ./${svc} ${dest}/${svc}
	fi
done

systemctl daemon-reload

for svc in "${services[@]}"; do
    echo "[Starting ${svc}]"
	if [ ! -f "./${svc}" ]; then
		echo "Not found" >&2
	else
        systemctl enable ${svc}
    	systemctl restart ${svc}
	fi
done
