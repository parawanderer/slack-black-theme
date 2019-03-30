# Discord Dark Theme for Slack

Original code/idea for Slack Styling overrules @ https://github.com/widget-/slack-black-theme

This builds on that idea by overruling Slack Styles to resemble https://discordapp.com/

This also updates Slack's default emojis to Twitter's Emojis (credit https://github.com/iamcal/emoji-data)

# Preview

![Screenshot](https://raw.githubusercontent.com/parawanderer/slack-black-theme/master/example1.png)

# Installing into Slack

Find your Slack's application directory.

* Windows: `%homepath%\AppData\Local\slack\`
* Mac: `/Applications/Slack.app/Contents/`
* Linux: `/usr/lib/slack/` (Debian-based)


Open up the most recent version (e.g. `app-3.3.8`) then open
`resources\app.asar.unpacked\src\static\ssb-interop.js`

At the very bottom, add

```js
// First make sure the wrapper app is loaded
document.addEventListener("DOMContentLoaded", function() {
 
   // Then get its webviews
   let webviews = document.querySelectorAll(".TeamView webview");
 
   // Fetch our CSS in parallel ahead of time
   const cssPath = 'https://raw.githubusercontent.com/parawanderer/slack-black-theme/master/custom.css';
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
               let script = `
                     let s = document.createElement('style');
                     s.type = 'text/css';
                     s.id = 'slack-custom-css';
                     s.innerHTML = \`${css}\`;
                     document.head.appendChild(s);
                     `
               webview.executeJavaScript(script);

            })

      });
   });
});
``` 
That's it! Restart Slack and see how well it works.


The CSS within this repo will be updated and maintained for the latest version of Slack for as long as I am interested in using it personally.

You will have to redo this each time Slack updates. 

# Sidebar Styling

Sidebar styling remains available through the "Preferences" tab. You can apply any styling you want to the sidebar. 

If you would like the same style as shown in the preview above, use these style values:

```#2B2D32,#2B2D32,#484a4f,#ffffff,#3d3f45,#d9d9d9,#43B581,#EB4D5C```


# License

Apache 2.0
