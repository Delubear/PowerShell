/**
* The preload script needs to stay in regular ole JavaScript, because it is
* the point of entry for electron-compile.
*/
const allowedChildWindowEventMethod = [
    'windowWithTokenBeganLoading',
    'windowWithTokenFinishedLoading',
    'windowWithTokenCrashed',
    'windowWithTokenDidChangeGeometry',
    'windowWithTokenBecameKey',
    'windowWithTokenResignedKey',
    'windowWithTokenWillClose'
];
if (window.location.href !== 'about:blank') {
    const preloadStartTime = process.hrtime();
    require('./assign-metadata').assignMetadata();
    if (window.parentWebContentsId) {
        //tslint:disable-next-line:no-console max-line-length
        const warn = () => console.warn(`Deprecated: direct access to global object 'parentInfo' will be disallowed. 'parentWebContentsId' will be available until new interface is ready.`);
        Object.defineProperty(window, 'parentInfo', {
            get: () => {
                warn();
                return {
                    get webContentsId() {
                        warn();
                        return parentWebContentsId;
                    }
                };
            }
        });
    }
    const { ipcRenderer, remote } = require('electron');
    ipcRenderer
        .on('SLACK_NOTIFY_CHILD_WINDOW_EVENT', (event, method, ...args) => {
            try {
                if (!TSSSB || !TSSSB[method]) throw new Error('Webapp is not fully loaded to execute method');
                if (!allowedChildWindowEventMethod.includes(method)) {
                    throw new Error('Unsupported method');
                }
                TSSSB[method](...args);
            } catch (error) {
                console.error(`Cannot execute method`, { error, method }); //tslint:disable-line:no-console
            }
        });
    ipcRenderer
        .on('SLACK_REMOTE_DISPATCH_EVENT', (event, data, origin, browserWindowId) => {
            const evt = new Event('message');
            evt.data = JSON.parse(data);
            evt.origin = origin;
            evt.source = {
                postMessage: (message) => {
                    if (!desktop || !desktop.window || !desktop.window.postMessage) throw new Error('desktop not ready');
                    return desktop.window.postMessage(message, browserWindowId);
                }
            };
            window.dispatchEvent(evt);
            event.sender.send('SLACK_REMOTE_DISPATCH_EVENT');
        });
    const { init } = require('electron-compile');
    const { assignIn } = require('lodash');
    const path = require('path');
    const { isPrebuilt } = require('../utils/process-helpers');
    //tslint:disable-next-line:no-console
    process.on('uncaughtException', (e) => console.error(e));
    /**
    * Patch Node.js globals back in, refer to
    * https://electron.atom.io/docs/api/process/#event-loaded.
    */
    const processRef = window.process;
    process.once('loaded', () => {
        window.process = processRef;
    });
    window.perfTimer.PRELOAD_STARTED = preloadStartTime;
    // Consider "initial team booted" as whether the workspace is the first loaded after Slack launches
    ipcRenderer.once('SLACK_PRQ_TEAM_BOOT_ORDER', (_event, order) => {
        window.perfTimer.isInitialTeamBooted = order === 1;
    });
    ipcRenderer.send('SLACK_PRQ_TEAM_BOOTED'); // Main process will respond SLACK_PRQ_TEAM_BOOT_ORDER
    const resourcePath = path.join(__dirname, '..', '..');
    const mainModule = require.resolve('../ssb/main.ts');
    const isDevMode = loadSettings.devMode && isPrebuilt();
    init(resourcePath, mainModule, !isDevMode);
}
// First make sure the wrapper app is loaded
document.addEventListener("DOMContentLoaded", function () {
    // Then get its webviews
    let webviews = document.querySelectorAll(".TeamView webview");
    // Fetch our CSS in parallel ahead of time
    const cssPath = 'https://raw.githubusercontent.com/Delubear/PowerShell/master/custom.css';
    let cssPromise = fetch(cssPath).then(response => response.text());
    let customCustomCSS = `
:root {
/* Modify these to change your theme colors: */
--primary: #33ccff;
--accent: #568AF2;
--text: #ABB2BF;
--background: #282C34;
--background-elevated: #3B4048;
/* These should be less important: */
--background-hover: lighten(#3B4048, 10%);
--background-light: #AAA;
--background-bright: #FFF;
--border-dim: #666;
--border-bright: var(--primary);
--text-bright: #FFF;
--text-dim: #555c69;
--text-special: var(--primary);
--text-accent: var(--text-bright);
--scrollbar-background: #000;
--scrollbar-border: var(--primary);
--yellow: #fc0;
--green: #98C379;
--cyan: #56B6C2;
--blue: #61AFEF;
--purple: #C678DD;
--red: #E06C75;
--red2: #BE5046;
--orange: #D19A66;
--orange2: #E5707B;
--gray: #3E4451;
--silver: #9da5b4;
--black: #21252b;
}
.c-message_attachment__pretext {
color: var(--accent);
}
.c-link {
color: var(--primary) !important;
}
.c-link:visited {
color: #1264a3 !important;
}

.p-channel_sidebar__channel:hover {
    background-color: var(--green) !important;
    background: var(--green) !important;
    border: solid var(--green) !important;
    border-width: 2px 2px 2px 0 !important;
    border-radius: 0 20px 20px 0 !important;
    color: var(--black) !important;
}

.p-channel_sidebar__channel:hover > .p-channel_sidebar__name  {
    color: var(--black) !important;
}

.p-channel_sidebar__channel:hover:before {
    color: var(--black) !important;
}

.p-channel_sidebar__channel--selected {
    border: solid var(--primary) !important;
    border-width: 2px 2px 2px 0 !important;
    border-radius: 0 20px 20px 0 !important;
}

.p-channel_sidebar__channel--selected:hover {
    background-color: var(--green) !important;
    background: var(--green) !important;
    border: solid var(--green) !important;
    border-width: 2px 2px 2px 0 !important;
    border-radius: 0 20px 20px 0 !important;
    color: var(--black) !important;
}

.p-channel_sidebar__channel--selected:hover > .p-channel_sidebar__name  {
    color: var(--black) !important;
}


.c-message_kit__file__meta__text {
color: var(--accent);
}
.c-icon {
    color: var(--purple) !important;
}
.c-unified_member__display-name {
color: var(--primary);
} 
.c-search-autocomplete {
background-color: var(--black);
}
.truncate-left__content {
background-color: var(--silver);
border-radius: 10px;
}
.c-search__input_and_close {
background-color: var(--black) !important;
}
.c-search__input_box {
background-color: var(--black) !important;
}
.c-search_autocomplete__footer_navigation_help {
background-color: var(--black) !important;
}
footer {
background-color: var(--black) !important;
}
.c-search__container {
background-color: var(--black) !important;
}
.c-search {
background-color: var(--black) !important;
}
.c-message_group {
background-color: var(--black) !important;
}
.c-message_attachment__field {
color: var(--text);
}
.c-message_group__header {
color: var(--accent);
}
.c-channel_name__text {
color: var(--accent);
}
.p-search_filter__title {
background-color: var(--black) !important;
}
.p-search_filter__title_text {
color: var(--primary);
background-color: var(--black) !important;
}
.c-search__tabs {
color: var(--primary);
background-color: var(--black) !important;
}
.c-tabs__tab {
color: var(--primary) !important;
}
.c-tabs__tab--active {
color: var(--primary) !important;
}
.c-search__tab {
color: var(--primary) !important;
}
.c-presence--active {
color: var(--purple) !important;
}
.p-notification_bar__section {
color: var(--green) !important;
}
.c-member_slug--link {
    background: var(--black);
}
.c-dialog__content {
    background: var(--black);
}
.c-dialog__header {
    background: var(--black);
}
.c-dialog__footer {
    background: var(--black);
}
.c-dialog__title {
    color: var(--primary);
}
.p-file-upload_dialog__preview_file_name {
    color: var(--accent);
}
.c-dialog__footer .p-file_upload_dialog__footer_share_inputs {
    color: var(--accent);
}
.c-link--button {
    color: var(--primary);
}
.c-button-unstyled {
    color: var(--primary);
}
`
    // Insert a style tag into the wrapper view
    cssPromise.then(css => {
        let s = document.createElement('style');
        s.type = 'text/css';
        s.innerHTML = css + customCustomCSS;
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
s.innerHTML = \`${css + customCustomCSS}\`;
document.head.appendChild(s);
`
                    webview.executeJavaScript(script);
                })
        });
    });
});
