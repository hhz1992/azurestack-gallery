﻿Configuration InstallServiceFabricConfiguration
{
    param
    (
    [Parameter(Mandatory = $false)]
    [Int] $DeploymentNodeIndex = 0,

    [Parameter(Mandatory = $true)]
    [string] $ClusterName,

    [Parameter(Mandatory = $true)]
    [string] $VMNodeTypePrefix,

    [Parameter(Mandatory = $true)]
    [Int[]] $VMNodeTypeInstanceCounts,

    [Parameter(Mandatory = $true)]
    [Int] $CurrentVMNodeTypeIndex,

    [parameter(Mandatory = $true)]
    [string] $SubnetIPFormat,

    [Parameter(Mandatory = $true)]
    [string] $clientConnectionEndpointPort,

    [Parameter(Mandatory = $true)]
    [string] $httpGatewayEndpointPort,

    [Parameter(Mandatory = $true)]
    [string] $reverseProxyEndpointPort,

    [Parameter(Mandatory = $true)]
    [string] $ephemeralStartPort,

    [Parameter(Mandatory = $true)]
    [string] $ephemeralEndPort,

    [Parameter(Mandatory = $true)]
    [string] $applicationStartPort,

    [Parameter(Mandatory = $true)]
    [string] $applicationEndPort,

    [Parameter(Mandatory = $true)]
    [string] $ConfigPath,

    [Parameter(Mandatory = $false)]
    [string] $serviceFabricUrl = "http://go.microsoft.com/fwlink/?LinkId=730690",

    [Parameter(Mandatory = $false)]
    [string] $serviceFabricRuntimeUrl = "NULL",

    [Parameter(Mandatory = $true)]
    [PSCredential] $Credential,

    [Parameter(Mandatory = $true)]
    [string] $DiagStoreAccountName,

    [Parameter(Mandatory = $true)]
    [string] $DiagStoreAccountKey,

    [Parameter(Mandatory = $true)]
    [string] $DiagStoreAccountBlobUri,

    [Parameter(Mandatory = $true)]
    [string] $DiagStoreAccountTableUri,

    [Parameter(Mandatory = $true)]
    [string] $certificateStoreValue,

    [Parameter(Mandatory = $true)]
    [string] $clusterCertificateThumbprint,

    [Parameter(Mandatory = $true)]
    [string] $serverCertificateThumbprint,

    [Parameter(Mandatory = $false)]
    [AllowEmptyString()]
    [string] $reverseProxyCertificateThumbprint = @(),

    [Parameter(Mandatory = $false)]
    [string] $DNSService = "No",

    [Parameter(Mandatory = $false)]
    [string] $RepairManager = "No",

    [Parameter(Mandatory = $false)]
    [Int] $diagLogAge = 7,

    [Parameter(Mandatory = $false)]
    [AllowEmptyString()]
    [string[]] $adminClientCertificateThumbprint = @(),

    [Parameter(Mandatory = $false)]
    [AllowEmptyString()]
    [string[]] $nonAdminClientCertificateThumbprint = @(),

    [Parameter(Mandatory = $true)]
    [string] $ClientConnectionEndpoint
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration,xServiceFabricSecureCluster,xDisk

    Node localhost {

        xWaitforDisk Disk2
        {
             DiskNumber = 2
             RetryIntervalSec = 30
             RetryCount = 100
        }
        
		xDisk DataDisk
        {
            DiskNumber = 2
            DriveLetter = "E"
            DependsOn = '[xWaitforDisk]Disk2'
        }
		
        xServiceFabricSecureClusterDeployment DeployServiceFabricSecureConfiguration
        {
            DeploymentNodeIndex = $DeploymentNodeIndex
            ClusterName = $ClusterName
            VMNodeTypePrefix = $VMNodeTypePrefix
            VMNodeTypeInstanceCounts=$VMNodeTypeInstanceCounts
            CurrentVMNodeTypeIndex=$CurrentVMNodeTypeIndex
            SubnetIPFormat=$SubnetIPFormat
            ClientConnectionEndpointPort = $clientConnectionEndpointPort
            HTTPGatewayEndpointPort = $httpGatewayEndpointPort
            ReverseProxyEndpointPort = $reverseProxyEndpointPort
            EphemeralStartPort = $ephemeralStartPort
            EphemeralEndPort = $ephemeralEndPort
            ApplicationStartPort = $applicationStartPort
            ApplicationEndPort = $applicationEndPort
            ConfigPath = $ConfigPath
            ServiceFabricUrl = $serviceFabricUrl
            ServiceFabricRuntimeUrl = $serviceFabricRuntimeUrl
            DiagStoreAccountName = $DiagStoreAccountName
            DiagStoreAccountKey = $DiagStoreAccountKey
            DiagStoreAccountBlobUri = $DiagStoreAccountBlobUri
            DiagStoreAccountTableUri = $DiagStoreAccountTableUri
            CertificateStoreValue = $certificateStoreValue
            ClusterCertificateThumbprint = $clusterCertificateThumbprint
            ServerCertificateThumbprint = $serverCertificateThumbprint
            ReverseProxyCertificateThumbprint = $reverseProxyCertificateThumbprint
            AdminClientCertificateThumbprint = $adminClientCertificateThumbprint
            NonAdminClientCertificateThumbprint = $nonAdminClientCertificateThumbprint
            ClientConnectionEndpoint = $ClientConnectionEndpoint
            PsDscRunAsCredential = $Credential
            DNSService = $DNSService
            RepairManager = $RepairManager
            diagLogAge = $diagLogAge
            DependsOn = '[xDisk]DataDisk'
        }

        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
        }
    }
}