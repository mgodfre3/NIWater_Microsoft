#Name the Pool 
$SPName="Storage Pool Name"

#Create the Storage Pool
New-StoragePool –FriendlyName $SPName –StorageSubsystemFriendlyName (Get-StorageSubSystem).FriendlyName –PhysicalDisks (Get-PhysicalDisk –CanPool $True) -LogicalSectorSizeDefault 4096 -FaultDomainAwarenessDefault PhysicalDisk

#set the Pool Write-Cache
Set-StoragePool -FriendlyName $spname.FriendlyName -WriteCacheSizeDefault 0



#Create the SSD Tier
New-StorageTier -StoragePoolFriendlyName $spname.FriendlyName -FriendlyName SSDMirrorTier -MediaType SSD -ResiliencySettingName Mirror -NumberOfColumns 1 -PhysicalDiskRedundancy 1 -FaultDomainAwareness PhysicalDisk

#Create the HDD Tier

New-StorageTier -StoragePoolFriendlyName $spname.FriendlyName -FriendlyName HDDParityTier -MediaType HDD -ResiliencySettingName Parity -NumberOfColumns 3 -PhysicalDiskRedundancy 1 -FaultDomainAwareness PhysicalDisk



#Create the Volume
New-Volume -StoragePoolFriendlyName $spname.FriendlyName -FriendlyName DPMVOL -FileSystem ReFS -StorageTierFriendlyNames $SSDTier.friendlyname, $HDDTier.friendlyname -StorageTierSizes 13TB, 215TB -DriveLetter s 

#create Volume with Maximum Size instead
New-Volume -StoragePoolFriendlyName $spname.FriendlyName -FriendlyName DPMVOL -FileSystem ReFS -StorageTierFriendlyNames $SSDTier.friendlyname, $HDDTier.friendlyname -UseMaximumSize -DriveLetter s -WriteCacheSize 0GB 


#FSutil settings for Write Back Cache

fsutil behavior set disableWriteAutoTiering s: 1 