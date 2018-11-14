# WebImblaze-Selenium 0.6.0
WebImblaze, the project found at [https://github.com/Qarj/WebImblaze](https://github.com/Qarj/WebImblaze), can also drive Selenium using the Chrome browser.

You have the choice of using the Selenium Server (which I find to be more robust), or you can drive ChromeDriver directly (Java not required!).

### Windows (instructions for Linux and Mac below)

1. After installing WebImblaze to `C:\git`, clone this plugin project
    ```
    cd C:/git
    git clone https://github.com/Qarj/WebImblaze-Selenium.git
    ```

2. Copy `WebImblaze-Selenium.pm` and `blocker` folder into `WebImblaze/plugins`
    ```
    perl WebImblaze-Selenium/plugins/update.pl
    ```

3. Open a command prompt as an administrator and issue the following command:
    ```
    cpan Selenium::Remote::Driver
    ```
    This will install the latest version of Selenium::Remote::Driver - 1.30 at the time of writing.
    
4. Obtain chromedriver.exe from https://sites.google.com/a/chromium.org/chromedriver/ and place it in `C:/selenium/`
    ```
    mkdir c:\selenium
    cd /D c:/selenium
    curl -O  http://chromedriver.storage.googleapis.com/LATEST_RELEASE
    set /p latest=<LATEST_RELEASE
    curl -O https://chromedriver.storage.googleapis.com/%latest%/chromedriver_win32.zip
    "C:\Program Files\7-Zip\7z.exe" x chromedriver_win32.zip -o"C:\selenium" -r -y
    chromedriver.exe --version
    ```

5. Optional - download latest selenium-server-standalone-3.*.*.jar from 
https://www.seleniumhq.org/download/
and place it in `C:/selenium`, give it the generic name `selenium-server-3-standalone.jar`
    ```
    curl --location --output c:/selenium/selenium-server-3-standalone.jar https://bit.ly/2yPGjmM
    java -jar selenium-server-3-standalone.jar --version
    ```
    Be sure to also install the Java runtime as well - https://ninite.com/ makes this easy.

#### Windows installation workaround
Note as at 25/10/2018, dependant package `Test::Time` is at version v0.07, but last working version on Windows is v0.05.
Workaround seems to be to:
1. Download `Test-Time-0.05.zip` from https://github.com/manwar/Test-Time/releases
2. Extract it
3. CD to the folder with Makefile.pl, then run it
4. `cpan .`
5. `cpan Selenium::Remote::Driver` should now work
```
curl --location --output %temp%/test-time-0.05.zip https://github.com/manwar/Test-Time/archive/0.05.zip
"C:\Program Files\7-Zip\7z.exe" x %temp%/test-time-0.05.zip -o"%temp%" -r
cd %temp%/Test-Time-0.05
perl Makefile.PL
cpan .
cpan Selenium::Remote::Driver
```

### Create your first WebImblaze-Selenium test

In the `tests` folder, create a file called `test_jobs.test`.
```
cd /D c:/git/WebImblaze
start notepad++ tests/test_jobs.test
```

Copy and paste the following into the file and save it.

```
step:                   Get CWJobs home page and fill out search form
selenium1:              $driver->get("https://www.cwjobs.co.uk/")
selenium2:              _keys_to_element_after('What','test')
selenium3:              _keys_to_element('Town, city or postcode','London')
selenium4:              _keys_to_element_after('Where','20 miles','SELECT')
verifytext:             get_current_url,get_body_text
verifypositive1:        home for tech jobs
verifypositive2:        Companies hiring

step:                   Click Search
selenium1:              _click('Search')
selenium2:              _wait_for_text_visible('Explore results',25)
verifytext:             get_current_url,get_body_text,get_page_source
verifypositive1:        Found sought text
verifypositive2:        Test jobs in London \+ 20 miles

step:                   Click on heading for first job ad on search results to see job details
selenium1:              _click('See details for')
selenium2:              _wait_for_text_visible('Back to search results',25)
verifytext:             get_current_url,get_body_text
verifypositive1:        Found sought text
verifypositive2:        Next job
```

### Run your first WebImblaze-Selenium test

1. From a command prompt, `cd /D C:/git/WebImblaze`

2. Run the tests with `perl wi.pl tests/test_jobs.test`

If all is ok, you'll see Chrome open and run the test steps. You'll also see output like the following
at the command prompt:

```
c:\git\WebImblaze>perl wi.pl tests/test_jobs.test

Starting WebImblaze Engine...

-------------------------------------------------------
Test:  tests\test_jobs.test - 10
Get CWJobs home page and fill out search form
Verify Positive: "home for tech jobs"
Verify Positive: "Companies hiring"
GET_BODY_TEXT:get_body_text
    [Starting ChromeDriver on port 9585]
SELRESP:1
SELRESP:Focused and clicked tag INPUT AFTER[What] OK (exact match) id[keywords] then sent keys OK
SELRESP:Focused and clicked tag INPUT WITH[Town, city or postcode] OK (exact match) id[location] then sent keys OK
SELRESP:Focused and clicked tag SELECT AFTER[Where] OK (exact match) id[Radius] then selected dropdown value OK
get_current_url
get_body_text
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST STEP PASSED
Response Time = 6.354 sec
Verification Time = 0.435 sec
Screenshot Time = 0.816 sec
-------------------------------------------------------
Test:  tests\test_jobs.test - 20
Click Search
Verify Positive: "Found sought text"
Verify Positive: "Test jobs in London \+ 20 miles"
GET_BODY_TEXT:get_body_text
SELRESP:Focused and clicked tag INPUT WITH[Search] OK (exact match) id[search-button]
VISIBLE SEARCH TEXT:Explore results
TIMEOUT:25
SELRESP:Found sought text visible after 2 seconds
get_current_url
get_body_text
get_page_source
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST STEP PASSED
Response Time = 7.208 sec
Verification Time = 2.015 sec
Screenshot Time = 0.305 sec
-------------------------------------------------------
Test:  tests\test_jobs.test - 30
Click on heading for first job ad on search results to see job details
Verify Positive: "Found sought text"
Verify Positive: "Next job"
GET_BODY_TEXT:get_body_text
SELRESP:Focused and clicked tag A WITH[See details for] OK (text index 0)
VISIBLE SEARCH TEXT:Back to search results
TIMEOUT:25
SELRESP:Found sought text visible after 0.9 seconds
get_current_url
get_body_text
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST STEP PASSED
Response Time = 3.557 sec
Verification Time = 1.32 sec
Screenshot Time = 0.311 sec
-------------------------------------------------------
Start Time: Wed 14 Nov 2018, 14:52:36
Total Run Time: 28.028 seconds

Total Response Time: 17.119 seconds

Test Steps Run: 3
Test Steps Passed: 3
Test Steps Failed: 0
Verifications Passed: 12
Verifications Failed: 0

Results at: output\Results.html
```

### Examining the results

If your WebImblaze/output folder was empty before running the test, you'll now see 10 files there:
- 10.png, 20.png, 30.png - automatic screen shots taken after each test step was executed
- 10.html, 20.html, 30.html - a html file showing the individual results for each test step (including the screen shot)
- Results.html - a html version of the output to the console, it links to each individual test step
- results.xml - an xml version of the results, needed by the optional WebImblaze-Framework
- http.txt - verbose log of raw WebImblaze http test output
- chromedriver.log

If not using WebInject-Framework, then double click on `output/Results.html` to view
the test results in a browser. Click on a step number hyperlink to see the individual
test step result.

### Using the Selenium Server

In my experience, running tests using Selenium Server is more robust than running through Chrome directly.

You can execute the tests using Selenium Server as in the following example:

```
perl wi.pl examples/misc/selenium.test --driver chrome --chromedriver-binary C:\selenium\chromedriver.exe --selenium-binary C:\selenium\selenium-server-3-standalone.jar
```

Or more simply, because the locations of the chromedriver and selenium binaries are specified in config.xml:

```
perl wi.pl examples/misc/selenium.test --driver chrome
```

### Resources for creating your own tests

You can see the many Selenium commands you can use by checking the documentation for the Perl bindings:
http://search.cpan.org/perldoc/Selenium::Remote::Driver

There are further examples in the `examples` and `selftest/substeps` folders of this project.

The [WebImblaze-Selenium Manual - MANUAL.md](MANUAL.md) has full details on the helper (start with underscore `_`) functions available.

### Linux

After installing WebImblaze to `/usr/local/bin`, clone this plugin project
```
cd /usr/local/bin
sudo git clone https://github.com/Qarj/WebImblaze-Selenium.git
```

Fix permissions
```
cd WebImblaze-Selenium
sudo find . -type d -exec chmod a+rwx {} \;
sudo find . -type f -exec chmod a+rw {} \;
```

Copy `WebImblaze-Selenium.pm` into `WebImblaze\plugins` by running `update.pl`
```
perl plugins/update.pl
```

Now obtain latest version of ChromeDriver and put it in a folder called ~/selenium by running these commands (double check version number)
```
cd /usr/local/bin
sudo mkdir selenium
sudo chmod 777 selenium

wget http://chromedriver.storage.googleapis.com/LATEST_RELEASE -P selenium
latest=$(cat selenium/LATEST_RELEASE)
wget -N https://chromedriver.storage.googleapis.com/$latest/chromedriver_linux64.zip -P selenium
sudo apt install unzip
unzip selenium/chromedriver_linux64.zip -d selenium
```

Obtain latest Selenium Standalone 3 Server and put it in `/usr/local/bin/selenium` with this command
```
wget -N https://bit.ly/2yPGjmM -O selenium/selenium-server-3-standalone.jar
```

A few extra commands are needed to ensure the dependencies are covered
```
sudo apt-get update
sudo apt --yes install gnome-terminal
sudo apt --yes install default-jre
sudo cpan Selenium::Remote::Driver
```
This will install the latest version of Selenium::Remote::Driver.

Now you should install Chrome, on Ubuntu / Debian / Linux Mint you can do it with these commands (assuming 64-bit)
```
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get --yes install google-chrome-stable
```

**_Important_** - Run Chrome at least once and choose whether you want it to be the default browser or not.
You can then close it or leave it open. If you don't do this, then it will hang when you try to run a test with ChromeDriver.

You can check that it works by running an example:
```
cd /usr/local/bin/WebImblaze
perl wi.pl examples/misc/selenium.test
```    

or using Selenium Server

```
perl wi.pl examples/misc/selenium.test --driver chrome
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
    - check everything OK
    ```
    java -version
    ```

7. Install perlbrew and switch shell to latest stable perl version
    ```
    sudo cpan App::perlbrew
    sudo perlbrew init
    sudo perlbrew install --switch stable
    ```

8. Reinstall the packages needed for WebImblaze in the perlbrew sub system
    ```
    sudo cpan File::Slurp
    sudo cpan XML::Simple
    sudo cpan Math::Random::ISAAC
    sudo cpan IO::Socket::SSL
    sudo cpan LWP::Protocol::https
    ```

8. Install Selenium::Remote::Driver
    ```
    sudo cpan Selenium::Remote::Driver
    ```

9. Check that it works
    ```
    sudo perl wi.pl examples/misc/selenium.test --driver chrome
    ```    

Later, when you need to start perlbrew again:
```
perlbrew list
```

Check the output, e.g. if it is `perl-5.24.1` then just:
```
sudo perlbrew use perl-5.24.1
```

## Self Tests
```
perl wi.pl ../WebImblaze-Selenium/selftest/all_selenium.test
```

## Plugins

### search-image.py (Windows Only)

To use the searchimage parameter (see manual), you need to install the dependencies for the search-image.py plugin. (The plugin itself is already installed in the plugins folder of the WebImblaze project at https://github.com/Qarj/WebImblaze)

See https://github.com/Qarj/search-image for full installation instructions.

To test that it works, run the following. If all test steps pass, then everything is setup OK.

```
perl wi.pl ./../WebImblaze-Selenium/examples/searchimage.test
```

You can also check the result by looking at `output\100.png' and also `output\200.png`. You'll see that
search-image.py has marked the locations of the result screenshot where it found the images.
