# Discord Dark Theme for Slack

Original code/idea for Slack Styling overrules @ https://github.com/widget-/slack-black-theme

This builds on that idea by overruling Slack Styles to resemble https://discordapp.com/

This also updates Slack's default emojis to Twitter's Emojis (credit https://github.com/iamcal/emoji-data)

# Preview

![Screenshot](https://raw.githubusercontent.com/parawanderer/slack-black-theme/master/example1.png)

# Installing into Slack

### v4.0.0+ (Windows only)

Credit https://github.com/tarantulae/slack-black-theme-4.0PS for this solution. 

1. Download and install [7-Zip](https://www.7-zip.org/) and the [Asar plugin for 7-Zip](http://www.tc4shell.com/en/7zip/asar/), install Asar plugin following steps provided on official page.

1. Download this repo as a zip (green "Clone or Download" button, top of page), extract and place `blackTheme.ps1` in a convenient location.

1. Run cmd with command `PowerShell.exe -ExecutionPolicy Bypass -File Your/Path/To/blackTheme.ps1` (one-time bypass on execution policy)

That's it. The script will do everything that is needed to install this theme. Once it pops an alert stating it has been installed successfully, you can restart Slack and see how well it works. 

You will have to run this again each time Slack updates.

The CSS within this repo will be updated and maintained for the latest version of Slack for as long as I am interested in using it personally.


### Before v4.0.0

Find your Slack's application directory.

* Windows: `%homepath%\AppData\Local\slack\`
* Mac: `/Applications/Slack.app/Contents/`
* Linux: `/usr/lib/slack/` (Debian-based)


Open up the most recent version (e.g. `app-3.3.8`) then open
`resources\app.asar.unpacked\src\static\ssb-interop.js`

At the very bottom, add [all of this Javascript](https://github.com/parawanderer/slack-black-theme/blob/master/old/loader.js). 

The CSS pre 4.0.0 will no longer be updated. If you for whatever reason manage to and insist on using older versions of slack, you'll have to do with the old CSS.

# Sidebar Styling

Sidebar styling remains available through the "Preferences" tab. You can apply any styling you want to the sidebar. 

If you would like the same style as shown in the preview above, use these style values:

```#2B2D32,#2B2D32,#484a4f,#ffffff,#3d3f45,#d9d9d9,#43B581,#EB4D5C```


# License

Apache 2.0
