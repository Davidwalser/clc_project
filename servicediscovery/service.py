import os
import exoscale
import json
import time

def writeIpsIntoConfig(directory, filename, jsonData):
    print(directory)
    if not os.path.isdir(directory):
        os.mkdir(directory)

    fullpath = os.path.join(directory, filename)

    with open(fullpath, 'w') as outfile:
        json.dump(jsonData, outfile, indent=4)
    print("wroooote in file")
    # fullpath = os.path.join(directory, filename)

    # f = open(fullpath, "w")
    # f.write("[" + str(jsonData) + "]")
    # print("wrote in file")
    # f.close()


print("Start!")
exoscale_key = os.getenv('EXOSCALE_KEY')
exoscale_secret = os.getenv('EXOSCALE_SECRET')
exoscale_zone = os.getenv('EXOSCALE_ZONE_ID')
exoscale_instancepool_id = os.getenv('EXOSCALE_INSTANCEPOOL_ID')
target_port = os.getenv('TARGET_PORT')
print(exoscale_key)
print(exoscale_secret)

exo = exoscale.Exoscale(api_key=exoscale_key, api_secret=exoscale_secret) 

try:
  zone = exo.compute.get_zone(id=exoscale_zone)
except:
  print("Error getting zone", flush=True)

while True:
    print("in while", flush=True)
    try:
        vms = exo.compute.get_instance_pool(exoscale_instancepool_id,zone).instances
    except:
        print("Error getting instances", flush=True)

    ips = []
    for vm in vms:
        ips.append(vm.ipv4_address + ":" + target_port)

    jsonObj = {
        "targets": ips
    }
    print(jsonObj, flush=True)
    writeIpsIntoConfig('/srv/service-discovery','config.json',jsonObj)
    time.sleep(15)