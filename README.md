# azcopy-from-filestorage-vm-msi-rbac
AZCOPY from Azure File Storage using Azure VM Identity MSI or User-Managed Identity example.  

An Azure VM using Managed System Identity (MSI) or User-Managed ID can use AZCOPY to read, write, or sync data from an Azure File Storage account file share using Azure RBAC.  This is a cloud-only user scenario, currently only supporting OAuth HTTPS style authN/authZ to Azure Files (not SMB drive mapping). Thus HTTPS network ports are used, not SMB port 445. 

This example uses Windows OS as the OS.  Linux VMs in Azure also support Managed Identities

# PREREQUISITES
- Install AZCOPY on the VM in a path that allows it to be executed 
- Ensure the Azure VM has a managed identity configured (either System Assigned or User Managed). 
- In EntraID, the system assigned ObjectID was found under "Devices" and not Users or Groups or Enterprise Apps. 
- Or use Azure resource "Managed Identities" in the portal to find the client or object Id
- Ensure PowerShell is enabled if using Windows to run a task automatically
- Create an Azure Storage Account, Files (either standard or premium). 
- Create a file share and configure this to use EntraID Kerberos authorization. 
- Assign the Azure RBAC Role called "Storage File Data Priviledged Reader" (or Contributor) to the VM's identity under the scope of the file share (account scope might work as well)
- Assign your user as well to create a directory and upload sample files to. I used the Azure Portal "Browse" section. 
- Create a local folder as destination for downloading or syncing the cloud storage-based files to.  
        Example:   "mkdir c:\demo"
- Ensure the Azure VM (or other) can reach the Azure File Storage account - review network firewall settings on the storage account and ensure no corporate firewalls or proxy is blocking traffic. Windows Advanced Firewall "File and Printer Sharing SMB-Out" settings is NOT NEEDED for AZCOPY, only for SMB drive mappings, such as with storage account key. 
- Ensure the Azure VM can reach EntraID URLs to login.  

# TASKS
- Create a script file to run on the VM (Windows PowerShell extension used as example)  
    Example:   **``C:\path\azcopyfile.ps1``**
- Use the one of the following AZCOPY LOGIN commands (system managed or user-managed identity) in this script file to "authorize" using the VM's identity and to then "copy" or "sync" files 
- **azcopy login --login-type=MSI**
- **azcopy login --identity --identity-client-id "[ServiceIdentityClientID]"**

 Note that other AZCOPY command options can be used once authorized, not just the "copy" example below  
- **azcopy copy 'https://<storageaccountname>.file.core.windows.net/<directory-path>' 'C:\demo' --recursive --preserve-smb-permissions=true --preserve-smb-info=true**

Note that "xx" double-quotes are for CMD-line and 'xx' single-quotes for PowerShell

## NOTES on TASKS
- Used "--recursive" to copy the subfolders
- AZCOPY parameter "--login-type" is new and replaces "--Identity"
- This is not a production-ready example with any error catches nor any monitoring
- Also note that only provides share-level access, not NTFS file/folder level, which requires Kerberos and ACL config. 
- AZCOPY uses HTTPS blob transfer, so it is not as latency sensitive as SMB/CIFS traffic

# RUN IN BACKGROUND TASK OPTION  (not tested for this "Files" based sample)
- To run this as a background task using the Windows Task Scheduler, for example, consider these steps
- Open Task Scheduler
- Click on the Windows logo, search for Task Scheduler in the Start menu, and open it.
- Create a New Task
- Click on "Create Basic Task" in the right sidebar  
- Enter a name for the task and click Next.
- Choose "When the computer starts" as the trigger and click Next.  Alternatively, you can use other trigger options of when to run the task, such as when the user logs-in or -out, or on a schedule, etc. 
- Select "Start a program" as the action and click Next.
- In the "Program/script" field, enter **powershell.exe**.
- In the "Add arguments" field, enter **-File "C:\path\azcopyfile.ps1"**
- Click Next and then Finish to create the task.

# NOTES on using User Managed Identity
- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-authorize-azure-active-directory#authorize-by-using-a-user-assigned-managed-identity
- https://github.com/Azure/azure-storage-azcopy/wiki/azcopy_login

# LINKS
- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10 
- https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-assign-managed-identity-via-azure-policy
- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-files


