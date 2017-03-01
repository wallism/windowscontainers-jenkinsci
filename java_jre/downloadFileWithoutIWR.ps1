<#
.SYNOPSIS
    Downloads a file
.DESCRIPTION
    Downloads a file
.PARAMETER Url
    URL to file/resource to download
.PARAMETER Filename
    file to save it as locally
.EXAMPLE
    C:\PS> .\wget.ps1 https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
#>




# use when Invoke-WebRequest is not available (i.e. on Nano)
function downloadFileWithoutIWR
{
    Param(
      [Parameter(Position=0,mandatory=$true)]
      [string]$Url,
      [Parameter(Position=1)]
      [string]$Filename = ''
    )

    # Get filename
    if (!$Filename) {
        $Filename = [System.IO.Path]::GetFileName($Url)    
    }

    "Add the Http .NET assembly"
    Add-Type -AssemblyName System.Net.Http

    Write-Host "Download: $Url to $Filename"

    # Make absolute local path
    if (![System.IO.Path]::IsPathRooted($Filename)) {
        $FilePath = Join-Path (Get-Item -Path ".\" -Verbose).FullName $Filename
    }

    if (($Url -as [System.URI]).AbsoluteURI -ne $null)
    {
        # Download the bits
        $handler = New-Object System.Net.Http.HttpClientHandler
        $client = New-Object System.Net.Http.HttpClient($handler)
        $client.Timeout = New-Object System.TimeSpan(0, 30, 0)
        $cancelTokenSource = [System.Threading.CancellationTokenSource]::new()
        $responseMsg = $client.GetAsync([System.Uri]::new($Url), $cancelTokenSource.Token)
        $responseMsg.Wait()
        if (!$responseMsg.IsCanceled)
        {
            $response = $responseMsg.Result
            if ($response.IsSuccessStatusCode)
            {
                $downloadedFileStream = [System.IO.FileStream]::new($FilePath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
            
                $copyStreamOp = $response.Content.CopyToAsync($downloadedFileStream)
                # TODO: Progress bar? Total size?
                Write-Host "Downloading ..."
                $copyStreamOp.Wait()

                $downloadedFileStream.Close()
                if ($copyStreamOp.Exception -ne $null)
                {
                    throw $copyStreamOp.Exception
                }
            }
        }
    }
    else
    {
        throw "Cannot download from $Url"
    }
}

downloadFileWithoutIWR 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185' 'yay.exe'
