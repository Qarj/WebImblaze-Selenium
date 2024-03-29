# WebImblaze-Selenium change log

---

## Release History

### Version 0.7.2 - Mar 3, 2022

-   enabled GitHub Actions, got the self test passing again

### Version 0.7.1 - Dec 1, 2020

-   \_get_element now returns offsetLeft and offsetTop which is the x, y for where the element is on the page

### Version 0.7.0 - May 30, 2020

-   new parameter `userdatadir` for setting a specific Chrome profile that can be reused

### Version 0.6.3 - Dec 13, 2019

-   exclude all extensions running in Chrome other than the Blocker addon

### Version 0.6.2 - Dec 12, 2019

-   with `Selenium::Remote::Driver` version 1.36 and ChromeDriver version 78 the method for starting ChromeDriver directly changed
-   use `_scroll_to` instead of `_move_to` due to W3C standards limitations

### Version 0.6.1 - May 16, 2019

-   support UTF-8 enabled WebImblaze

### Version 0.6.0 - Oct 31, 2018

-   rename project from WebInject-Selenium to WebImblaze-Selenium
-   new helper method `_set_dropdown`
-   made a blocker extension for Chrome to block get requests (of resources) you specify
-   useragent parameter now honoured

### Version 0.5.0 - Apr 23, 2018

-   Block urls via a simple Chrome extension called Blocker

### Version 0.4.0 - Mar 25, 2018

-   Now supports Selenium Server Standalone 3 (tested with 3.11.0) - no longer supports 2.53.1
-   Improved installation instructions

### Version 0.3.0 - Nov 25, 2017

-   `--keep-session` and `--resume-session` parameters now supported to make it easier to debug tests deep into a workflow
-   plugin now displays the command line options that are relevant to this plugin instead of the main WebInject code

### Version 0.2.0 - Sept 14, 2017

-   helper methods now simply begin with underscore
-   `$selresp =` is no longer needed in the commands, it is added automatically
-   the trailing `;` was never needed and has been removed from all examples
-   fails more gracefully if it is not possible to connect to the Selenium Server or ChromeDriver
-   automatically retry failed `locators for testers` locates
-   use [WebInject Check](http://webinject-check.azurewebsites.net) for self test and examples
-   support external Selenium grid host, e.g. BrowserStack or Sauce Labs
-   support --headless mode in Chrome and increase ViewPort y pixels to 1568

### Version 0.1.0 - Mar 8, 2017

-   Initial release

---
