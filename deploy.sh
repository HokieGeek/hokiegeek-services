#!/bin/bash

here=$(cd ${0%/*}; pwd)

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
	if [ ! -f "${here}/${svc}" ]; then
		echo "Not found" >&2
	else
    	cp ${here}/${svc} ${dest}/${svc}
	fi
done

systemctl daemon-reload

for svc in "${services[@]}"; do
	if [ -f "${here}/${svc}" ]; then
    	echo "[Starting ${svc}]"
        systemctl enable ${svc}
    	systemctl restart ${svc}
	fi
done
