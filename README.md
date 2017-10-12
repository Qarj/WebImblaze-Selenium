# WebInject-Selenium 0.2.0
WebInject, the project found at [https://github.com/Qarj/WebInject](https://github.com/Qarj/WebInject), can also drive Selenium using the Chrome browser.

You have the choice of using the Selenium Server (which I find to be more robust), or you can drive ChromeDriver directly (Java not required!).

Selenium WebDriver using ChromeDriver
-------------------------------------

### All platforms

1. Download this project and copy `WebInjectSelenium.pm` from the plugins folder to the plugins folder of the WebInject project.

### Windows (instructions for Linux and Mac below)

1. Open a command prompt as an administrator and issue the following command:
    ```
    cpan Selenium::Remote::Driver
    ```

2. Obtain chromedriver.exe from https://sites.google.com/a/chromium.org/chromedriver/ and place it in `C:\selenium\`

3. Optional - download selenium-server-standalone-2.53.1.jar from http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar
and place it in `C:\selenium`

### Create your first WebInject-Selenium test

In the `tests` folder, create a file called `test_jobs.xml`.

Copy and paste the following into the file and save it.

```xml
<testcases repeat="1">

<case
    id="10"
    description1="Get CWJobs home page and fill out search form"
    method="selenium"
    command1='$driver->get("https://www.cwjobs.co.uk/")'
    command2="_keys_to_element_after('What','test')"
    command3="_keys_to_element('Town, city or postcode','London')"
    command4="_keys_to_element_after('Where','20 miles','SELECT')"
    verifytext="get_current_url,get_body_text"
    verifypositive1="home for tech jobs"
    verifypositive2="Companies hiring"
/>

<case
    id="20"
    description1="Click Search"
    method="selenium"
    command1="_click('Search')"
    command2="_wait_for_text_visible('Explore results',25)"
    verifytext="get_current_url,get_body_text,get_page_source"
    verifypositive1="Found sought text"
    verifypositive2="Test jobs in London \+ 20 miles"
/>

<case
    id="30"
    description1="Click on heading for first job ad on search results to see job details"
    method="selenium"
    command1="_click('See details for')"
    command2="_wait_for_text_visible('Back to search results',25)"
    verifytext="get_current_url,get_body_text"
    verifypositive1="Found sought text"
    verifypositive2="Next job"
/>

</testcases>
```

### Run your first WebInject-Selenium test

1. From an administrator command prompt, `cd C:\git\WebInject`

2. Run the tests with `webinject.pl tests/test_jobs.xml`

If all is ok, you'll see Chrome open and run the test steps. You'll also see output like the following
at the command prompt:

```
C:\git\WebInject>webinject.pl tests/test_jobs.xml

Starting WebInject Engine...

-------------------------------------------------------
Test:  tests\test_jobs.xml - 10
Get CWJobs home page and fill out search form
Verify Positive: "home for tech jobs"
Verify Positive: "Companies hiring"
GET_BODY_TEXT:get_body_text
    [Starting ChromeDriver without Selenium Server]
SELRESP:1
SELRESP:Focused and clicked tag INPUT AFTER[What] OK (exact match) id[keywords] then sent keys OK
SELRESP:Focused and clicked tag INPUT WITH[Town, city or postcode] OK (exact match) id[location] then sent keys OK
SELRESP:Focused and clicked tag SELECT AFTER[Where] OK (exact match) id[Radius] then sent keys OK
get_current_url
get_body_text
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST CASE PASSED
Response Time = 1 sec
Verification Time = 0 sec
Screenshot Time = 2 sec
-------------------------------------------------------
Test:  tests\test_jobs.xml - 20
Click Search
Verify Positive: "Found sought text"
Verify Positive: "Test jobs in London \+ 20 miles"
GET_BODY_TEXT:get_body_text
SELRESP:Focused and clicked tag INPUT WITH[Search] OK (exact match) id[search-button]
VISIBLE SEARCH TEXT:Explore results
TIMEOUT:25
SELRESP:Found sought text visible after 1 seconds
get_current_url
get_body_text
get_page_source
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST CASE PASSED
Response Time = 2 sec
Verification Time = 0 sec
Screenshot Time = 1 sec
-------------------------------------------------------
Test:  tests\test_jobs.xml - 30
Click on heading for first job ad on search results to see job details
Verify Positive: "Found sought text"
Verify Positive: "Next job"
GET_BODY_TEXT:get_body_text
SELRESP:Focused and clicked tag A WITH[See details for] OK (text index 0)
VISIBLE SEARCH TEXT:Back to search results
TIMEOUT:25
SELRESP:Found sought text visible after 1 seconds
get_current_url
get_body_text
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST CASE PASSED
Response Time = 1 sec
Verification Time = 0 sec
Screenshot Time = 0 sec
-------------------------------------------------------
Start Time: Sun 05 Mar 2017, 11:37:06
Total Run Time: 11.677 seconds

Total Response Time: 4.000 seconds

Test Cases Run: 3
Test Cases Passed: 3
Test Cases Failed: 0
Verifications Passed: 12
Verifications Failed: 0

Results at: output\results.html
```

### Examining the results

If your WebInject/output folder was empty before running the test, you'll now see 10 files there:
* 10.png, 20.png, 30.png - automatic screen shots taken after each test step was executed
* 10.html, 20.html, 30.html - a html file showing the individual results for each test step (including the screen shot)
* results.html - a html version of the output to the console, it links to each individual test step
* results.xml - an xml version of the results, needed by WebInject-Framework
* http.txt - verbose log of raw WebInject test output
* chromedriver.log

Generally the best way to view the results is to open `output\results.xml` in a browser and click on the links to the
individual resuls.

### Using the Selenium Server

In my experience, running tests using Selenium Server is more robust than running through Chrome directly.

You can excute the tests using Selenium Server as in the following example:

```
webinject.pl examples/selenium.xml --driver chrome --chromedriver-binary C:\selenium\chromedriver.exe --selenium-binary C:\selenium\selenium-server-standalone-2.53.1.jar
```

Or more simply, because the locations of the chromedriver and selenium binaries are specified in config.xml:

```
webinject.pl examples/selenium.xml --driver chrome
```

### Resources for creating your own tests

You can see the many Selenium commands you can use by checking the documentation for the Perl bindings:
http://search.cpan.org/perldoc/Selenium::Remote::Driver

There are further examples in the `examples` and `selftest\substeps` folders of this project.

The [WebInject-Selenium Manual - MANUAL.md](MANUAL.md) has full details on the helper (start with underscore _) functions available.

### Linux

1. First obtain ChromeDriver and put it in a folder called ~/selenium by running these commands
    ```
    mkdir ~/selenium
    wget -N http://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip -P ~/selenium
    sudo apt install unzip
    unzip ~/selenium/chromedriver_linux64.zip -d ~/selenium
    chmod +x ~/selenium/chromedriver
    ```

2. Now obtain the Selenium Standalone Server and put it in ~/selenium with this command
    ```
    wget -N http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar -P ~/selenium
    ```

3. A few extra commands are needed to ensure the dependencies are covered
    ```
    sudo apt-get update
    sudo apt install gnome-terminal
    sudo apt install default-jre
    sudo cpan Selenium::Remote::Driver
    ```

4. Now you should install Chrome, on Ubuntu / Debian / Linux Mint you can do it with these commands
    ```
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable
    ```

5. Important - Run Chrome at least once and choose whether you want it to be the default browser or not. You can then close it or leave it open. If you don't do this, then it will hang when you try to run a test with ChromeDriver.

6. You can check that it works by running an example:
    ```
    perl webinject.pl examples/selenium.xml
    ```    

    or using Selenium Server

    ```
    perl webinject.pl examples/selenium.xml --driver chrome
    ```    

### Mac - (currently only supports driving Chrome directly without Selenium Server)

1. Install Chrome, run it and decide whether you want it to be the default browser or not.

2. Install Homebrew
    ```
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

3. Install wget
    ```
    brew install wget
    ```

4. Obtain ChromeDriver and put it in a folder called ~/selenium by running these commands
    ```
    mkdir ~/selenium
    wget -N http://chromedriver.storage.googleapis.com/2.27/chromedriver_mac64.zip -P ~/selenium
    unzip ~/selenium/chromedriver_mac64.zip -d ~/selenium
    chmod +x ~/selenium/chromedriver
    ```

5. Now obtain the Selenium Standalone Server and put it in ~/selenium with this command
    ```
    wget -N http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar -P ~/selenium
    ```

6. Install JRE from http://www.oracle.com/technetwork/java/javase/downloads/index.html
    * click on the JRE link
    * download the .dmg file for Mac OS X
    * double click on the downloaded dmg file
    * double click on the Java icon to start the installer
    * export it
    ```
    export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"
    ```
    * put JAVA_HOME in your bash profile
    ```
    touch ~/.bash_profile; open ~/.bash_profile
    ```
    copy paste `export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"` into the file and save it (otherwise you have to export every time)
    * check everything ok
    ```
    java -version
    ```

7. Install perlbrew and switch shell to latest stable perl version
    ```
    sudo cpan App::perlbrew
    sudo perlbrew init
    sudo perlbrew install --switch stable
    ```

8. Reinstall the packages needed for WebInject in the perlbrew sub system
    ```
    sudo cpan File::Slurp
    sudo cpan XML::Simple
    sudo cpan Math::Random::ISAAC
    sudo cpan IO::Socket::SSL
    sudo cpan LWP::Protocol::https
    ```

8. Install Selenium::Remote::Driver from cpan
    ```
    sudo cpan Selenium::Remote::Driver
    ```

9. Check that it works
    ```
    sudo perl webinject.pl examples/selenium.xml --driver chrome
    ```    

Later, when you need to start perlbrew again:
```
perlbrew list
```

Check the output, e.g. if it is `* perl-5.24.1` then just:
```
sudo perlbrew use perl-5.24.1
```


Plugins
-------

### search-image.py (Windows Only)

To use the searchimage parameter (see manual), you need to install the dependencies for the search-image.py plugin. (The plugin itself is already installed in the plugins folder of the WebInject project at https://github.com/Qarj/WebInject)

See https://github.com/Qarj/search-image for full installation instructions.

To test that it works, run the following. If all test steps pass, then everything is setup ok.

```
webinject.pl ./../WebInject-Selenium/examples/searchimage.xml
```

You can also check the result by looking at `output\100.png' and also `output\200.png`. You'll see that
search-image.py has marked the locations of the result screenshot where it found the images.
