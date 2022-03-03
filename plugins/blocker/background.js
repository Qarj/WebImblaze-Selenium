// https://developer.chrome.com/apps/match_patterns
//
// If just one url pattern is not valid, then this addon will fail for all urls
//    to debug, from chrome://extensions/ click on 'background page' for the extension and view in Console
const blocked_urls = ['http://www.example.com/this_url_is_blocked', 'http://www.example.com/this_url_is_also_blocked'];

const cancel_request = function () {
    return { cancel: true };
};

chrome.webRequest.onBeforeRequest.addListener(cancel_request, { urls: blocked_urls }, ['blocking']);
