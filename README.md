# WebImblaze-Selenium 0.7.1

WebImblaze, the project found at [https://github.com/Qarj/WebImblaze](https://github.com/Qarj/WebImblaze), can also drive Selenium using the Chrome browser.

You have the choice of using the Selenium Server (which I find to be more robust), or you can drive ChromeDriver directly (Java not required!).

### Linux

After installing WebImblaze to `$HOME/git/WebImblaze`, clone this plugin project

```sh
cd $HOME/git
git clone https://github.com/Qarj/WebImblaze-Selenium.git
```

Copy `WebImblaze-Selenium.pm` into `WebImblaze\plugins` by running `update.pl`

```sh
perl $HOME/git/WebImblaze-Selenium/plugins/update.pl
```

Now obtain latest version of ChromeDriver and place in `$HOME/selenium`

```sh
mkdir $HOME/selenium
cd $HOME/selenium
wget http://chromedriver.storage.googleapis.com/LATEST_RELEASE -O LATEST_RELEASE
latest=$(cat LATEST_RELEASE)
wget -N https://chromedriver.storage.googleapis.com/$latest/chromedriver_linux64.zip -O chromedriver_linux64.zip
sudo apt install unzip
unzip -o chromedriver_linux64.zip -d .
./chromedriver --version
```

Obtain latest Selenium Standalone 3 Server and put it in `$HOME/selenium`

```sh
cd $HOME/selenium
wget -N https://bit.ly/2TlkRyu -O selenium-server-3-standalone.jar
```

Ensure you have `gnome-terminal` and a Java runtime

```sh
sudo apt update
sudo apt --yes install gnome-terminal
sudo apt --yes install default-jre
```

Install the latest version of `Selenium::Remote::Driver`

```sh
cpan Selenium::Remote::Driver
```

Check Java and Selenium Standalone versions

```sh
java -version
java -jar $HOME/selenium/selenium-server-3-standalone.jar --version
.
Selenium server version: 3.141.59, revision: e82be7d358
```

Now you should install Google Chrome if you haven't already.

```sh
cd $HOME/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

**_Important_** - Run Chrome at least once and choose whether you want it to be the default browser or not.
You can then close it or leave it open. If you don't do this, then it will hang when you try to run a test with ChromeDriver.

```
google-chrome
```

You can check that it works by running an example:

```sh
cd $HOME/git/WebImblaze
perl wi.pl examples/misc/selenium.test
```

or using Selenium Server

```sh
perl wi.pl examples/misc/selenium.test --driver chrome
```

Keep in mind that the major version number of ChromeDriver must match the version of Chrome you have installed.

### Create your first WebImblaze-Selenium test

In the `tests` folder, create a file called `test_jobs.test`.

```sh
cd $HOME/git/WebImblaze
code tests/test_jobs.test
```

Copy and paste the following into the file and save it.

```yml
step:                   Get CWJobs home and accept all cookies
selenium1:              $driver->get("https://www.cwjobs.co.uk/")
selenium2:              _click('Accept All')

step:                   Fill out search form
selenium1:              $driver->get("https://www.cwjobs.co.uk/")
selenium2:              _keys_to_element_after('What','test')
selenium3:              _keys_to_element('Town, city or postcode','London')
selenium4:              _keys_to_element_after('Where','20 miles','SELECT')
verifytext:             get_current_url,get_body_text
verifypositive1:        home for tech jobs
verifypositive2:        Companies hiring

step:                   Click Search
selenium1:              _click('Search')
selenium2:              _wait_for_text_visible('Test jobs',25)
verifytext:             get_current_url,get_body_text,get_page_source
verifypositive1:        Found sought text
verifypositive2:        Test jobs in London \+ 20 miles

step:                   Click on heading for first job ad on search results to see job details
selenium1:              _click('job-item-title')
selenium2:              _wait_for_text_visible('Back to search results',25)
verifytext:             get_current_url,get_body_text
verifypositive1:        Found sought text
```

### Run your first WebImblaze-Selenium test

1. From a command prompt, `cd $HOME/git/WebImblaze`

2. Run the tests with `perl wi.pl tests/test_jobs.test`

If all is OK, you'll see Chrome open and run the test steps. You'll also see output like the following
at the command prompt:

```txt
Starting WebImblaze Engine...

-------------------------------------------------------
Test:  tests/test_jobs.test - 10
Get CWJobs home and accept all cookies
 Try 1 of 10 failed [Accept All]:[*] ...
    [Starting ChromeDriver without Selenium Server on port 9585]
SELRESP:1
SELRESP:Focused and clicked tag SPAN WITH[Accept All] OK (exact match)
Passed HTTP Response Code Verification
TEST STEP PASSED
Response Time = 3.214 sec
Verification Time = 0.022 sec
Screenshot Time = 0.306 sec
-------------------------------------------------------
Test:  tests/test_jobs.test - 20
Fill out search form
Verify Positive: "home for tech jobs"
Verify Positive: "Companies hiring"
GET_BODY_TEXT:get_body_text
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
Response Time = 1.629 sec
Verification Time = 0.157 sec
Screenshot Time = 0.25 sec
-------------------------------------------------------
Test:  tests/test_jobs.test - 30
Click Search
Verify Positive: "Found sought text"
Verify Positive: "Test jobs in London \+ 20 miles"
GET_BODY_TEXT:get_body_text
SELRESP:Focused and clicked tag INPUT WITH[Search] OK (exact match) id[search-button]
VISIBLE SEARCH TEXT:Test jobs
TIMEOUT:25
SELRESP:Found sought text visible after 0.4 seconds
get_current_url
get_body_text
get_page_source
Passed Positive Verification
Passed Positive Verification
Passed HTTP Response Code Verification
TEST STEP PASSED
Response Time = 2.221 sec
Verification Time = 0.435 sec
Screenshot Time = 0.15 sec
-------------------------------------------------------
Test:  tests/test_jobs.test - 40
Click on heading for first job ad on search results to see job details
Verify Positive: "Found sought text"
GET_BODY_TEXT:get_body_text
SELRESP:Focused and clicked tag A WITH[job-item-title] OK (exact match)
VISIBLE SEARCH TEXT:Back to search results
TIMEOUT:25
SELRESP:Found sought text visible after 0.1 seconds
get_current_url
get_body_text
Passed Positive Verification
Passed HTTP Response Code Verification
TEST STEP PASSED
Response Time = 1.198 sec
Verification Time = 0.131 sec
Screenshot Time = 0.144 sec
-------------------------------------------------------
Start Time: Sun 27 Feb 2022, 21:37:24
Total Run Time: 11.411 seconds

Total Response Time: 8.262 seconds

Test Steps Run: 4
Test Steps Passed: 4
Test Steps Failed: 0
Verifications Passed: 13
Verifications Failed: 0

Results at: output/Results.html
```

### Examining the results

If your WebImblaze/output folder was empty before running the test, you'll now see 10 files there:

-   `10.png`, `20.png`, `30.png` - automatic screen shots taken after each test step was executed
-   `10.html`, `20.html`, `30.html` - a html file showing the individual results for each test step (including the screen shot)
-   `Results.html` - a html version of the output to the console, it links to each individual test step
-   `results.xml` - an xml version of the results, needed by the optional WebImblaze-Framework
-   `http.txt` - verbose log of raw WebImblaze http test output
-   `_chromedriver.log`

If not using WebImblaze-Framework, then double click on `output/Results.html` to view
the test results in a browser. Click on a step number hyperlink to see the individual
test step result.

### Using the Selenium Server

In my experience, running tests using Selenium Server is more robust than running through Chrome directly.

You can execute the tests using Selenium Server as in the following example:

```sh
perl wi.pl examples/misc/selenium.test --driver chrome --chromedriver-binary C:\selenium\chromedriver.exe --selenium-binary C:\selenium\selenium-server-3-standalone.jar
```

Or more simply, because the locations of the chromedriver and selenium binaries are specified in `config.xml`:

```sh
perl wi.pl examples/misc/selenium.test --driver chrome
```

### Resources for creating your own tests

You can see the many Selenium commands you can use by checking the documentation for the Perl bindings:
http://search.cpan.org/perldoc/Selenium::Remote::Driver

There are further examples in the `examples` and `selftest/substeps` folders of this project.

The [WebImblaze-Selenium Manual - MANUAL.md](MANUAL.md) has full details on the helper (start with underscore `_`) functions available.

### Windows installation

1. After installing WebImblaze to `C:\git`, clone this plugin project

    ```bat
    cd C:/git
    git clone https://github.com/Qarj/WebImblaze-Selenium.git
    ```

2. Copy `WebImblaze-Selenium.pm` and `blocker` folder into `WebImblaze/plugins`

    ```bat
    perl WebImblaze-Selenium/plugins/update.pl
    ```

3. Open a command prompt as an administrator and issue the following command:

    ```bat
    cpan Selenium::Remote::Driver
    ```

    This will install the latest version of Selenium::Remote::Driver - 1.37 at the time of writing.

4. Obtain chromedriver.exe from https://sites.google.com/a/chromium.org/chromedriver/ and place it in `C:/selenium/`

    ```bat
    mkdir c:\selenium
    cd /D c:/selenium
    curl -O  http://chromedriver.storage.googleapis.com/LATEST_RELEASE
    set /p latest=<LATEST_RELEASE
    curl -O https://chromedriver.storage.googleapis.com/%latest%/chromedriver_win32.zip
    "C:\Program Files\7-Zip\7z.exe" x chromedriver_win32.zip -o"C:\selenium" -r -y
    chromedriver.exe --version
    ```

    7-Zip is easy to install with https://ninite.com/.

5. Optional - download latest Selenium Server from https://selenium.dev/downloads/
   and place it in `C:/selenium`, give it the generic name `selenium-server-3-standalone.jar`

    ```bat
    curl --location --output c:/selenium/selenium-server-3-standalone.jar https://bit.ly/2TlkRyu
    java -jar c:/selenium/selenium-server-3-standalone.jar --version
    ```

    Be sure to also install the Java 8 runtime as well - https://ninite.com/ makes this easy.

### Mac

First install WebImblaze https://github.com/Qarj/WebImblaze

Install Chrome, run it and decide whether you want it to be the default browser or not.

Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

Install wget

```sh
brew install wget
```

Now obtain latest version of ChromeDriver and place in `/usr/local/bin/selenium`

Remember that the major version of Chrome and ChromeDriver must be an exact match.

```sh
cd /usr/local/bin
sudo mkdir selenium
sudo chmod 777 selenium

wget http://chromedriver.storage.googleapis.com/LATEST_RELEASE -P selenium
latest=$(cat selenium/LATEST_RELEASE)
wget -N https://chromedriver.storage.googleapis.com/$latest/chromedriver_mac64.zip -P selenium
unzip -o selenium/chromedriver_mac64.zip -d selenium
selenium/chromedriver --version
```

Obtain latest Selenium Standalone 3 Server and put it in `/usr/local/bin/selenium`

```sh
wget -N https://bit.ly/2TlkRyu -O /usr/local/bin/selenium/selenium-server-3-standalone.jar
```

Install `OpenJDK 8 (LTS)` from https://adoptopenjdk.net/

After opening and installing the `.pkg` file, check Java is working

```sh
java -version
.
openjdk version "1.8.0_265"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_265-b01)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.265-b01, mixed mode)
```

Open / create the `.bash_profile` with a text editor

```sh
code ~/.bash_profile
```

Add this line, save

```sh
export JAVA_HOME=$(/usr/libexec/java_home)
```

Source the updated bash profile and check JAVA_HOME is now set correctly

```sh
source ~/.bash_profile
echo $JAVA_HOME
.
/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
```

Check version of Selenium Server

```sh
java -jar /usr/local/bin/selenium/selenium-server-3-standalone.jar --version
.
Selenium server version: 3.141.59, revision: e82be7d358
```

Install perlbrew

```sh
curl -L https://install.perlbrew.pl | bash
```

Append `source ~/perl5/perlbrew/etc/bashrc` to bash profile and run it now also

```sh
code ~/.bash_profile
source ~/perl5/perlbrew/etc/bashrc
```

Init perlbrew and switch shell to latest stable perl

```sh
sudo perlbrew init
sudo perlbrew install --switch stable
```

Install the packages needed for WebImblaze in the perlbrew sub system

```sh
sudo cpan XML::Simple
sudo cpan Math::Random::ISAAC
sudo cpan IO::Socket::SSL
sudo cpan LWP::Protocol::https
```

Install Selenium::Remote::Driver

```sh
sudo cpan Selenium::Remote::Driver
```

Clone this plugin project

```sh
cd /usr/local/bin
sudo git clone https://github.com/Qarj/WebImblaze-Selenium.git
```

Fix permissions

```sh
cd WebImblaze-Selenium
sudo find . -type d -exec chmod a+rwx {} \;
sudo find . -type f -exec chmod a+rw {} \;
```

Copy `WebImblaze-Selenium.pm` into `WebImblaze\plugins` by running `update.pl`

```sh
perl plugins/update.pl
```

Check that it all works - with Selenium Server

```sh
cd /usr/local/bin/WebImblaze
sudo perl wi.pl examples/misc/selenium.test --driver chrome
```

Using ChromeDriver directly without Selenium Server

```sh
sudo perl wi.pl examples/misc/selenium.test
```

Later, when you need to start perlbrew again:

```sh
perlbrew list
```

Check the output, e.g. if it is `perl-5.32.0` then just:

```sh
sudo perlbrew use perl-5.32.0
```

## Self Tests

```sh
perl wi.pl ../WebImblaze-Selenium/selftest/all_selenium.test
```

## Plugins

### search-image.py (Windows Only)

To use the searchimage parameter (see manual), you need to install the dependencies for the search-image.py plugin. (The plugin itself is already installed in the plugins folder of the WebImblaze project at https://github.com/Qarj/WebImblaze)

See https://github.com/Qarj/search-image for full installation instructions.

To test that it works, run the following. If all test steps pass, then everything is setup OK.

```sh
perl wi.pl ./../WebImblaze-Selenium/examples/searchimage.test
```

You can also check the result by looking at `output\100.png' and also`output\200.png`. You'll see that
search-image.py has marked the locations of the result screenshot where it found the images.
