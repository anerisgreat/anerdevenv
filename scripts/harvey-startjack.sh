#!/bin/bash
jack_control stop
#pulseaudio -k
sleep 1
#pulseaudio &
jack_control start
jack_control ds alsa
jack_control dps device hw:HD2
jack_control dps rate 44100
jack_control dps nperiods 2
jack_control dps period 64
sleep 2
#a2jmidid -e &
#sleep 2
qjackctl &

#/usr/bin/alsa_out -j "Digitech_RP360_In" -d hw:RP360 -q 1 2>&1 1> /dev/null &
#/usr/bin/alsa_in -j "Digitech_RP360_Out" -d hw:RP360 -q 1 2>&1 1> /dev/null &
sleep 2
cadence &
