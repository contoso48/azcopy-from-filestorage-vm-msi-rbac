# Usin gPowerShell and User-Managed Identity
# azcopy login --login-type=MSI
azcopy login --identity --identity-client-id '[ServiceIdentityClientID]'
azcopy copy 'https://<storageaccountname>.file.core.windows.net/<directory-path>' 'C:\demo' --recursive --preserve-smb-permissions=true --preserve-smb-info=true
