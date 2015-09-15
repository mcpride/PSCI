############################################################
        {
            StorageAccountName       = $Node.StorageAccountName
            ConfigurationPath        = Join-Path $workingdir $Node.DSCExtensionFiles
        }
    AllNodes = @(     
                    @{  
                        NodeName = 'localhost' 
                        #CertificateFile = Join-Path $workingdir 'publicKey.cer'
                        #Thumbprint = ''
                        PSDscAllowPlainTextPassword=$true
                        AffinityGroup = "TestVMWestUS$Instance"
                        AffinityGroupLocation = 'West US'
                        AffinityGroupDescription = 'Affinity Group for Test Virtual Machines'
                        StorageAccountName = "testvmstorage$Instance"
                        ServiceName = "testvmservice$Instance"
                        ServiceDescription = 'Service created for Test Virtual Machines'
                        Configuration = 'ServerCoreTest'
                        ConfigurationArchive = 'ServerCoreTest.ps1.zip'
                        DSCExtensionFiles = 'ServerCoreTest\ServerCoreTest.ps1'
                        
                    }
                )
} 