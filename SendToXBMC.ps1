$xbmcip = "172.16.51.5"
$xbmcport = "80"
$xbmcusr =
$xbmcpwd =
$i=1
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
write-host [$i]
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

    "*.ted.com*"{
        write-host Ted Talks Video detected, calling TedTalks Plugin
        $urltoplay = [System.Web.HttpUtility]::UrlEncode($urltoplay)
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"plugin://plugin.video.ted.talks/?url='+$urltoplay+'&mode=playVideo&icon=http%3A%2F%2Fassets.tedcdn.com%2Fimages%2Fted_logo.gif"}}, "id" : 1}'
        }
    "*.youtube.com*"{
        write-host YouTube Video detected, calling YouTube Plugin
        $urltoplay=$urltoplay.split('/').split('?')[4].split('=')[1]
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"plugin://plugin.video.youtube/?path=/root/video&action=play_video&videoid='+$urltoplay+'"}}, "id" : 1}'
        }
    {($_ -like "*.mp4") -or ($_ -like "*.flv") -or ($_ -like "*.avi") -or ($_ -like "*.mpg") -or ($_ -like "*.mkv") }{
        write-host Sending link to the default XBMC player.
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"'+$urltoplay+'"}}, "id" : 1}' 
        ; break
        }  
    default{
        write-host Sending link to the SendToXBMC Plugin.
        $urltoplay = [System.Web.HttpUtility]::UrlEncode($urltoplay)
        $command = '{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item":{"file":"plugin://plugin.video.sendtoxbmc/?url='+$urltoplay+'/"}}, "id" : 1}'
        ; break
        }
}

write-host "JSON Command:    $command"

#The following command is only available with PowerShell 3.0 and later.
Invoke-WebRequest -uri $xbmcurl -ContentType "application/json" -Method POST -Body $command -TimeoutSec 60 | fl

#Looping back to prompt for another URL.
$i++
$urltoplay = $null
sleep 5
clear
}