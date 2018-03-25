# WebInject-Selenium change log

---------------------------------
## Release History:

### Version 0.4.0 - Mar 25, 2018
* Now supports Selenium Server Standalone 3 (tested with 3.11.0) - no longer supports 2.53.1
* Improved installation instructions

### Version 0.3.0 - Nov 25, 2017
* --keep-session and --resume-session parameters now supported to make it easier to debug tests deep into a workflow
* plugin now displays the command line options that are relevant to this plugin instead of the main WebInject code

### Version 0.2.0 - Sept 14, 2017
* helper_ functions now simply begin with _
* `$selresp = ` is no longer needed in the commands, it is added automatically
* the trailing `;` was never needed and has been removed from all examples
* fails more gracefully if it is not possible to connect to the Selenium Server or ChromeDriver
* automatically retry failed `locators for testers` locates
* use http://webinject-check.azurewebsites.net for self test and examples
* support external Selenium grid host, e.g. BrowserStack or Sauce Labs
* support --headless mode in Chrome and increase ViewPort y pixels to 1568

### Version 0.1.0 - Mar 8, 2017
* Initial release
    
---------------------------------
