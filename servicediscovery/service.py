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

def getInstances(exo, zone, poolId):
    try:
        return exo.compute.get_instance_pool(poolId,zone).instances
    except:
        return []

exoscale_key = os.getenv('EXOSCALE_KEY')
exoscale_secret = os.getenv('EXOSCALE_SECRET')
exoscale_zone = os.getenv('EXOSCALE_ZONE')
exoscale_instancepool_id = os.getenv('EXOSCALE_INSTANCEPOOL_ID')
target_port = os.getenv('TARGET_PORT')

exo = exoscale.Exoscale(api_key=exoscale_key, api_secret=exoscale_secret) 

print("exoscale_zone (should be zone): "+ exoscale_zone, flush=True)
zone = exo.compute.get_zone(name=exoscale_zone)

while True:
    vms = getInstances(exo,zone,exoscale_instancepool_id)
    ips = []
    for vm in vms:
        print(vm.ipv4_address, flush=True)
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