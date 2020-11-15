package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"time"

	"github.com/exoscale/egoscale"
)

type IPAddressList struct {
	Targets []string
}

func getIpsWithPort(client *egoscale.Client, zoneID *egoscale.UUID, instancePoolID *egoscale.UUID, targetPort string) ([]string, error) {
	ctx := context.Background()
	res, requestError := client.RequestWithContext(ctx, egoscale.GetInstancePool{
		ZoneID: zoneID,
		ID:     instancePoolID,
	})
	if requestError != nil {
		log.Fatal(requestError)
	}
	//casting interface to specific response
	response := res.(*egoscale.GetInstancePoolResponse)
	if len(response.InstancePools) == 0 {
		log.Fatalf("instance pool not found")
	}
	instancePool := response.InstancePools[0]
	var result []string
	for _, vm := range instancePool.VirtualMachines {
		result = append(result, vm.Nic[0].IPAddress.String()+":"+targetPort)
	}
	return result, nil
}

func main() {
	//os.Getenv("FOO")
	exoscaleKey := "xxx"
	exoscaleSecret := "xxx"
	exoscaleZone := "xxx"
	exoscaleInstancepoolID := "xxx"
	targetPort := "9100"

	fmt.Println("Hello, World!")

	zoneID, err := egoscale.ParseUUID(exoscaleZone)
	if err != nil {
		log.Fatalf("invalid zone ID (%v)", err)
	}
	fmt.Println(zoneID)

	instancePoolID, err := egoscale.ParseUUID(exoscaleInstancepoolID)
	if err != nil {
		log.Fatalf("invalid pool ID (%v)", err)
	}

	fmt.Println(os.Getenv("exoscaleKey"))
	fmt.Println(os.Getenv("exoscaleSecret"))
	fmt.Println(os.Getenv("exoscaleZone"))
	fmt.Println(os.Getenv("exoscaleInstancepoolID"))

	client := egoscale.NewClient("https://api.exoscale.com/v1", exoscaleKey, exoscaleSecret)
	for {
		ips, ipError := getIpsWithPort(client, zoneID, instancePoolID, targetPort)
		if ipError != nil {
			fmt.Println("ERROR: getting ips")
			log.Println(ipError)
		}

		ipAddressList := IPAddressList{ips}
		var jsonData []byte
		jsonData, jsonErr := json.Marshal(ipAddressList)
		if jsonErr != nil {
			fmt.Println("ERROR: creating json")
			log.Println(jsonErr)
		}

		fmt.Println(string(jsonData))
		//might not be the best idea creating new file each
		fileErr := ioutil.WriteFile("writefile", []byte("["+string(jsonData)+"]"), 0777)

		fmt.Println("creating file")
		if fileErr != nil {
			fmt.Println("ERROR: creating file")
			log.Fatal(fileErr)
		}

		fmt.Println("done")
		time.Sleep(10 * time.Second)
	}
}
