#!/usr/bin/env bash
# stop script on error
set -e

# Check Wi-Fi connection
if ! iwgetid -r; then
  printf "\nERROR: Not connected to Wi-Fi. Please connect to a Wi-Fi network and try again.\n"
  exit 1
fi

# Check for python 3
if ! python3 --version &> /dev/null; then
  printf "\nERROR: python3 must be installed.\n"
  exit 1
fi

# Check to see if root CA file exists, download if not
if [ ! -f ./root-CA.crt ]; then
  printf "\nDownloading AWS IoT Root CA certificate from AWS...\n"
  curl https://www.amazontrust.com/repository/AmazonRootCA1.pem > root-CA.crt
fi

# run pub/sub app
printf "\nRunning pub/sub application...\n"
python3 /home/pi/RaspberryWeatherStation/raspberry_station/pubsub.py --endpoint a3p0wdy6k4du67-ats.iot.eu-north-1.amazonaws.com --ca_file root-CA.crt --cert raspberry_weather_station.cert.pem --key raspberry_weather_station.private.key --client_id basicPubSub --topic sdk/test/python --count 0
