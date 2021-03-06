#Creds https://github.com/tarantulae/slack-black-theme-4.0PS 
#Must have 7Zip and ASAR addin installed 
#Check Prerequisites
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

if (!(Test-Path $env:LOCALAPPDATA\slack\app-4*))
{   
    Write-Host "Slack v4 could not be found at %LocalAppdata%..." -ForegroundColor red
    if (!(Test-Path -Path "C:\Program Files\WindowsApps\*.Slack_4*\app")) 
    {   
        #For UWP Slack
        Write-Host "Slack v4 could not be found at C:\Program Files\WindowsApps..." -ForegroundColor red
        [System.Windows.Forms.MessageBox]::Show('Slack version 4 not installed','Error: Exiting...')
        exit   

    } else {
        Write-Host "Slack v4 found at C:\Program Files\WindowsApps..."
        $SlackPath = "C:\Program Files\WindowsApps"

        #Get directories
        $AppDirectory = Get-ChildItem -Directory -Path $SlackPath -Filter "*.Slack_4*" | Sort-Object LastAccessTime -Descending | Select-Object -First 1 -ExpandProperty Name
        $SlackDirectory = $SlackPath + $AppDirectory + "\app\resources"
   }
}
else {
    Write-Host "Slack v4 found at %LocalAppdata%..."
    $SlackPath = $env:LOCALAPPDATA

   #Get directories
   $AppDirectory = Get-ChildItem -Directory -Path $SlackPath\slack -Filter "app-4*" | Sort-Object LastAccessTime -Descending | Select-Object -First 1 -ExpandProperty Name
   $SlackDirectory = $SlackPath + "\slack\" + $AppDirectory + "\resources"
}

#Get 7zip directory
$7zipInstall = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip |  Select-Object -ExpandProperty InstallLocation

#Check for 7z install
if(!$7zipInstall)
{
   [System.Windows.Forms.MessageBox]::Show('7zip not detected. Install 7zip and ASAR addin. Download & install: https://www.7-zip.org/ and http://www.tc4shell.com/en/7zip/asar/','Error: Exiting...')
    exit
}

#Check for ASAR 7z addin
if (!(Test-Path 'C:\Program Files\7-Zip\Formats\Asar*'))
{
   [System.Windows.Forms.MessageBox]::Show('ASAR addin must be installed. Download from: http://www.tc4shell.com/en/7zip/asar/','Error: Exiting...')
    exit
}

#Stop slack and Extract to temp directory
Get-Process slack -ErrorAction SilentlyContinue | Stop-Process -PassThru
& $7zipInstall\7z.exe x $SlackDirectory\app.asar "-o$SlackDirectory\app" -y

try {
   #Add css to ssb-interop
   $SlackDirectoryOuter = $SlackDirectory
   Add-Content $SlackDirectoryOuter\blacktheme.txt -Value "
   // First make sure the wrapper app is loaded
   document.addEventListener('DOMContentLoaded', function() {
   
      // Then get its webviews
      let webviews = document.querySelectorAll('.TeamView webview');
   
      // Fetch our CSS in parallel ahead of time
      const cssPath = 'https://raw.githubusercontent.com/parawanderer/slack-black-theme/master/custom-4.css';
      let cssPromise = fetch(cssPath).then(response => response.text());
   
      // Insert a style tag into the wrapper view
      cssPromise.then(css => {
         let s = document.createElement('style');
         s.type = 'text/css';
         s.innerHTML = css;
         document.head.appendChild(s);
      });
   
      // Wait for each webview to load
      webviews.forEach(webview => {
         webview.addEventListener('ipc-message', message => {
            if (message.channel == 'didFinishLoading')
               // Finally add the CSS into the webview
               cssPromise.then(css => {
                  let script = ``
                        let s = document.createElement('style');
                        s.type = 'text/css';
                        s.id = 'slack-custom-css';
                        s.innerHTML = \```${css}\``;
                        document.head.appendChild(s);
                        ``
                  webview.executeJavaScript(script);
   
               })
   
         });
      });
   });
   " -ErrorAction Stop

   $blackcss = Get-Content $SlackDirectoryOuter\blacktheme.txt -ErrorAction Stop
   Add-Content $SlackDirectory\app\dist\ssb-interop.bundle.js -Value $blackcss -ErrorAction Stop
   Remove-Item $SlackDirectoryOuter\blacktheme.txt -ErrorAction Stop

   #Rename old archive
   Move-Item $SlackDirectory\app.asar $SlackDirectory\app.asar.original

   #Archive new asar
   & $7zipInstall\7z.exe a $SlackDirectory\app.asar $SlackDirectory\app

   [System.Windows.Forms.MessageBox]::Show("Slack Dark Theme has been installed! Restart slack to see the results.","Installation Complete",0)

} catch {
   [System.Windows.Forms.MessageBox]::Show("Something went wrong when trying to write to slack files.","Error: Exiting...",0)
}
