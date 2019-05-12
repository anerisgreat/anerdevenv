/usr/bin/alsa_out -j "Digitech_RP360_Out" -d hw:RP360 -q 1 2>&1 1> /dev/null &
/usr/bin/alsa_in -j "Digitech_RP360_In" -d hw:RP360 -q 1 2>&1 1> /dev/null &
