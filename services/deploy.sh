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
    	sudo cp ${here}/${svc} ${dest}/${svc}
	fi
done

sudo systemctl daemon-reload

for svc in "${services[@]}"; do
	if [ -f "${here}/${svc}" ]; then
    	echo "[Starting ${svc}]"
        sudo systemctl enable ${svc}
    	sudo systemctl restart ${svc}
	fi
done

systemctl --failed
