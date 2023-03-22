package sdk

import (
	"log"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/stretchr/testify/require"
)

var subscriptionId string
var resourceGroupName string
var location string
var endpoint string

var client *Client

func TestMain(m *testing.M) {

	subscriptionId = os.Getenv("AZURE_SUBSCRIPTION_ID")
	resourceGroupName = "MODMTest"
	location = "eastus"
	endpoint = "http://localhost:8080"

	exitVal := m.Run()
	log.Println("Cleaning up resources after the tests here")
	
	os.Exit(exitVal)
}

func InitializeClient() { 
	cred, err := azidentity.NewDefaultAzureCredential(nil) 
	if err != nil { 
		log.Fatal("failed to create credential") 
	} 
	client, err := NewClient("test", cred, nil) //TODO: create deployment 
}