notify-send -a "CPU temp" -t 3000 $(BASETEMP=$(cat /sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input | cut -c -3 -); printf "+%s.%s°C" "$(echo -n "${BASETEMP}" | cut -c -2 -)" "$(echo -n "${BASETEMP}" | cut -c 3 -)")
