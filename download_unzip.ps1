#### #### DO NOT EDIT THIS FILE ##### ####
function Untgz($zipFile, $untgzfolder)
{
  $sz = $thisScript+'\tar\bsdtar.exe'  
  
  set-alias sza $sz
  sza -xzf $zipFile -C $untgzfolder
  write-host "Untgz'ed $zipFile to $untgzfolder"
}

function Unzip($zipFile, $untgzfolder)
{
  $sz = $thisScript+'\tar\unzip.exe'  
  
  set-alias unzip $sz
  unzip -q $zipFile -d $untgzfolder
  write-host "Untgz'ed $zipFile to $untgzfolder"
}


function DownloadFile($url)
{
   $localPath = $thisScript+$downloadFolder+"\"+(Split-Path -Path ([System.Uri]$url).LocalPath -leaf)
   $client = New-Object System.Net.WebClient
   $client.Proxy = [System.Net.WebRequest]::DefaultWebProxy
   $client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F")
   $client.Headers["User-Agent"] = "Safari"


try {

 
  Register-ObjectEvent $client DownloadProgressChanged -action {     

        Write-Progress -Activity "Downloading" -Status `
            ("{0} of {1}" -f $eventargs.BytesReceived, $eventargs.TotalBytesToReceive) `
            -PercentComplete $eventargs.ProgressPercentage    
    }

   
   
   
   Register-ObjectEvent -InputObject $client -EventName DownloadFileCompleted -SourceIdentifier $url
   

    write-host "Download $url to $localPath"
    $client.DownloadFileAsync($url, $localPath)

   
    Wait-Event -SourceIdentifier $url
    Unregister-Event -SourceIdentifier $url
    write-host "$localPath download finished"

} finally { 
    $client.dispose()
}

}