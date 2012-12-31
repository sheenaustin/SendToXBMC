$xbmcip = ""
$xbmcport = "80"
$xbmcusr = 
$xbmcpwd = 
if ($xbmcusr.Length -eq 0) {
    $xbmcurl = "http://$xbmcip"+":"+"$xbmcport/jsonrpc"
    }
    else {
    $xbmcurl = "http://$xbmcusr"+":"+"$xmbcpwd@$xbmcip"+":"+"$xbmcport/jsonrpc"
    }
Add-Type -AssemblyName System.Web
for(;;) {
#The while loop is in place to ensure that the script re-prompts for a URL if the user just hits enter.
#The value read into the variable is stripped off any spaces.
while ($urltoplay.Length -eq 0){$urltoplay = $(Read-Host 'Enter/Paste the URL you want to play') -replace '\s+', ''}

write-host 

switch -wildcard ($urltoplay)
{
    "http://www.collegehumor.com*"{
        write-host CollegeHumor video detected, calling CollegeHumor Plugin.
        $ch1 = $($urltoplay.split("/"))[3]
        $ch2 = $($urltoplay.split("/"))[4]
        $ch3 = $($urltoplay.split("/"))[5]
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"plugin://plugin.video.collegehumor/watch/'+$ch1+'%2F'+$ch2+'%2F'+$ch3+'/"}}, "id" : 1}'
        ; break
        }
    {($_ -like "*youtu.be*") -or ($_ -like "*daclips*") -or  ($_ -like "*videozer*") -or  ($_ -like "*180upload*") -or  ($_ -like "*nolimitvideo*") -or  ($_ -like "*rapidvideo*") -or  ($_ -like "*filenuke*") -or  ($_ -like "*2gbhosting*") -or  ($_ -like "*novamov*") -or  ($_ -like "*vidxden*") -or  ($_ -like "*ovile*") -or  ($_ -like "*ufliq*") -or  ($_ -like "*xvidstage*") -or  ($_ -like "*veoh*") -or  ($_ -like "*override_me*") -or  ($_ -like "*putlocker*") -or  ($_ -like "*sockshare*") -or  ($_ -like "*sharefiles*") -or  ($_ -like "*movdivx*") -or  ($_ -like "*hostingcup*") -or  ($_ -like "*stagevu*") -or  ($_ -like "*movpod*") -or  ($_ -like "*skyload*") -or  ($_ -like "*movshare*") -or  ($_ -like "*ecostream*") -or  ($_ -like "*seeon.tv*") -or  ($_ -like "*stream2k*") -or  ($_ -like "*youtube*") -or  ($_ -like "*flashx*") -or  ($_ -like "*vimeo*") -or  ($_ -like "*jumbofiles*") -or  ($_ -like "*videobb*") -or  ($_ -like "*override_me*") -or  ($_ -like "*realdebrid*") -or  ($_ -like "*divxstage*") -or  ($_ -like "*videoweed.es*") -or  ($_ -like "*gorillavid*") -or  ($_ -like "*zshare*") -or  ($_ -like "*vidstre*") -or  ($_ -like "*uploadc*") -or  ($_ -like "*dailymotion*") -or  ($_ -like "*veeHD*") -or  ($_ -like "*zalaa*") -or  ($_ -like "*filebox*") -or  ($_ -like "*tubeplus.me*")} {
        write-host Sending link to the 1Channel Plugin.
        $urltoplay = [System.Web.HttpUtility]::UrlEncode($urltoplay)
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"plugin://plugin.video.1channel/?mode='+"PlaySource"+'&url='+$urltoplay+'/"}}, "id" : 1}'
        ; break
        }
    default {
        write-host Sending link to the default XBMC player.
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"'+$urltoplay+'"}}, "id" : 1}' 
        ; break
        }  
}

write-host "JSON Command:    $command"

#The following command is only available with PowerShell 3.0 and later.
Invoke-RestMethod -uri $xbmcurl -ContentType "application/json" -Method POST -Body $command -TimeoutSec 60

#Looping back to prompt for another URL.
$i ; $i++
$urltoplay = $null
clear
}