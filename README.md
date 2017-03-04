# WebInject-Selenium
Selenium plugin for WebInject

Selenium WebDriver using ChromeDriver
-------------------------------------

WebInject can also drive Chrome using using ChromeDriver. A bit of extra setup is needed.

### Windows

1. Open a command prompt as an administrator and issue the following command:
    ```
    cpan Selenium::Remote::Driver
    ```

2. Obtain ChromeDriver.exe from https://sites.google.com/a/chromium.org/chromedriver/ and save
it somewhere. For simplicity, ensure that there are no spaces in the path.

    For this example, we'll put it here: `C:\selenium\chromedriver.exe`

3. Optional - download selenium-server-standalone-2.53.1.jar from http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar
and place it in `C:\selenium`

#### Run the Selenium WebDriver example
1. Open a command prompt as an administrator and issue the following command:

    ```
    perl webinject.pl examples\selenium.xml --driver chromedriver --binary C:\selenium\chromedriver.exe
    ```

    You should see Chrome open along with a process chromedriver.exe in the taskbar.

    After the tests run, you will see in the `output` folder that screenshots for each step
    are automatically taken.

2. Optional - Run the same example through Selenium Server (in my experience this is more robust)

    First you need to start the server in a separate process, in this example we'll start it on port 9988
    ```    
    wmic process call create 'cmd /c java -Dwebdriver.chrome.driver="C:\selenium\chromedriver.exe" -jar C:\selenium\selenium-server-standalone-2.53.1.jar -port 9988 -trustAllSSLCertificates'
    ```

    Then you call WebInject telling it what port to find Selenium Server on
    ```
    perl webinject.pl examples\selenium.xml --port 9988 --driver chrome
    ```

### Linux

1. First obtain ChromeDriver and put it in a folder called ~/selenium by running these commands
    ```
    mkdir ~/selenium
    wget -N http://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip -P ~/selenium
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

6. You can check that it all works by running the Selenium self test. You should see Chrome open twice and run a quick test. The first time will be using Selenium Server Standalone. The second time will be using ChromeDriver directly without Selenium Server Standalone.
    ```
    perl webinject.pl selftest/selenium.xml
    ```    

#### Run the Selenium WebDriver example

1. You can run the example through ChromeDriver directly as follows:

    ```
    perl webinject.pl -d chromedriver --binary ~/selenium/chromedriver examples/selenium.xml
    ```

2. In my experience, the Selenium Standalone Server is more reliable. You can run the same example test through Selenium Server.
   
    First start the Selenium Standalone Server in a background terminal
    ```
    (gnome-terminal -e "java -Dwebdriver.chrome.driver=$HOME/selenium/chromedriver -jar $HOME/selenium/selenium-server-standalone-2.53.1.jar -port 9988 -trustAllSSLCertificates" &)
    ```

    Now run the example, selecting to use the Selenium Standalone Server running on port 9988
    ```
    perl webinject.pl --port 9988 --driver chrome examples/selenium.xml
    ```

    Once you are finished running all the Selenium tests, you can shut down the Selenium Standalone Server as follows
    ```
    curl http://localhost:9988/selenium-server/driver/?cmd=shutDownSeleniumServer
    ```

Plugins
-------

### search-image.py (Windows Only)

To use the searchimage parameter (see manual), you need to install the dependencies for the search-image.py plugin. (The plugin itself is already installed in the plugins folder of the WebInject project at https://github.com/Qarj/WebInject)

See https://github.com/Qarj/search-image for full installation instructions.

To test that it works, run the following. If all test steps pass, then everything is setup ok.

```
webinject.pl -d chromedriver --chromedriver-binary C:\selenium\chromedriver.exe ./../WebInject-Selenium/examples/searchimage.xml
```

You can also check the result by looking at `output\100.png' and also `output\200.png`. You'll see that
search-image.py has marked the locations of the result screenshot where it found the images.
