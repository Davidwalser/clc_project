import os
import exoscale
import json
import time
import signal
import sys

def signalHandler(signum, frame):
    sys.exit(0)

signal.signal(signal.SIGINT, signalHandler)
signal.signal(signal.SIGTERM, signalHandler)

def writeIpsIntoConfig(directory, filename, jsonData):
    if not os.path.isdir(directory):
        os.mkdir(directory)
    fullpath = os.path.join(directory, filename)
    with open(fullpath, 'w') as outfile:
        json.dump(jsonData, outfile)

exoscale_key = os.getenv('EXOSCALE_KEY')
exoscale_secret = os.getenv('EXOSCALE_SECRET')
exoscale_zone = os.getenv('EXOSCALE_ZONE')
exoscale_instancepool_id = os.getenv('EXOSCALE_INSTANCEPOOL_ID')
target_port = os.getenv('TARGET_PORT')

exo = exoscale.Exoscale(api_key=exoscale_key, api_secret=exoscale_secret) 

try:
  zone = exo.compute.get_zone(id=exoscale_zone)
except:
  print("Error getting zone", flush=True)

while True:
    try:
        vms = exo.compute.get_instance_pool(exoscale_instancepool_id,zone).instances
    except:
        print("Error getting instances", flush=True)

    ips = []
    for vm in vms:
        ips.append(vm.ipv4_address + ":" + target_port)

    # need array to get right format
    jsonObj = []
    jsonObj.append({
        "targets": ips,
        "labels": {}
    })

    print(jsonObj, flush=True)
    writeIpsIntoConfig('/srv/service-discovery','config.json',jsonObj)
    time.sleep(10)