# This function centralizes most of what you can download/install on CTT
# Anything it doesn't find in that switch ($App){ statement is passed to scoop
 
function Get {
    [alias('g')] # minimalism at it's finest
    param(
        [Array]$Apps
    )

    $FailedToInstall = $null # Reset that variable for later

    ForEach($App in $Apps){ # Scoop exits when it throws

        switch ($App){
            #'Voukoder'{} soonTMTM
            'Upscaler'{
                Install-FFmpeg
                Invoke-RestMethod 'https://github.com/couleur-tweak-tips/utils/raw/main/Miscellaneous/CTT%20Upscaler.cmd' |
                Out-File (Join-Path ([System.Environment]::GetFolderPath('SendTo')) 'CTT Upscaler.cmd') -Encoding ASCII -Force
                Write-Host @"
CTT Upscaler has been installed,
I strongly recommend you open settings to tune it to your PC, there's lots of cool stuff to do there!
"@ -ForegroundColor Green
            }
            'Scoop'{Install-Scoop}
            'FFmpeg'{Install-FFmpeg}
            {$_ -In '7-Zip','7z','7Zip'}{Get-ScoopApp 7zip}
            {$_ -In 'Smoothie','sm'}{Install-FFmpeg;Get-ScoopApp utils/Smoothie}
            {$_ -In 'UTVideo'}{Get-ScoopApp utils/utvideo}
            {$_ -In 'Nmkoder'}{Get-ScoopApp utils/nmkoder}
            {$_ -In 'Librewolf'}{Get-ScoopApp extras/librewolf}
            {$_ -In 'ffmpeg-nightly'}{Get-ScoopApp versions/ffmpeg-nightly}
            {$_ -In 'Graal','GraalVM'}{Get-ScoopApp utils/GraalVM}
            {$_ -In 'DiscordCompressor','dc'}{Get-ScoopApp utils/discordcompressor}
            {$_ -In 'Moony','mn'}{if (-Not(Test-Path "$HOME\.lunarclient")){Write-Warning "You NEED Lunar Client to launch it with Moony"};Get-ScoopApp utils/Moony}
            {$_ -In 'TLShell','TLS'}{Get-TLShell}
            default{Get-ScoopApp $App}
        }

    }
    if ($FailedToInstall){
        
        Write-Host "[!] The following apps failed to install (scroll up for details):" -ForegroundColor Red
        $FailedToInstall
    }
}