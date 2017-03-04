# WebInject-Selenium
WebInject, the project found at [https://github.com/Qarj/WebInject](https://github.com/Qarj/WebInject), can also drive Selenium using the Chrome browser.

You have the choice of using the Selenium Server (which I find to be more robust), or you can drive ChromeDriver directly (Java not required!).

Selenium WebDriver using ChromeDriver
-------------------------------------

Download this project and copy `WebInjectSelenium.pm` from the plugins folder to the plugins folder of the WebInject project.

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
1. Open a command prompt as an administrator, change directory to where webinject.pl is located, then issue the following command:

    ```
    perl webinject.pl examples\selenium.xml --driver chromedriver --chromedriver-binary C:\selenium\chromedriver.exe
    ```

    You should see Chrome open along with a process chromedriver.exe in the taskbar.

    After the tests run, you will see in the `output` folder that screenshots for each step
    are automatically taken.

2. Optional - Run the same example through Selenium Server (in my experience this is more robust)

    ```
    perl webinject.pl --driver chrome --chromedriver-binary C:\selenium\chromedriver.exe --selenium-binary C:\selenium\selenium-server-standalone-2.53.1.jar examples/selenium.xml
    ```

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

6. You can check that it all works by running the Selenium self test. You should see Chrome open twice and run a quick test. The first time will be using Selenium Server Standalone. The second time will be using ChromeDriver directly without Selenium Server Standalone.
    ```
    perl webinject.pl selftest/selenium.xml
    ```    

### Mac - (only supports driving Chrome directly without Selenium Server)

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
    cpan File::Slurp
    cpan XML::Simple
    cpan Math::Random::ISAAC
    cpan IO::Socket::SSL
    ```

8. Install Selenium::Remote::Driver from cpan
    ```
    sudo cpan Selenium::Remote::Driver
    ```

9. Check that it works
    ```
    perl webinject.pl -d chromedriver --chromedriver-binary ~/selenium/chromedriver examples/selenium.xml
    ```    

#### Run the Selenium WebDriver example

1. You can run the example through ChromeDriver directly as follows:

    ```
    perl webinject.pl -d chromedriver --chromedriver-binary ~/selenium/chromedriver examples/selenium.xml
    ```

2. In my experience, the Selenium Standalone Server is more reliable. You can run the same example test through Selenium Server.
   
    ```
    perl webinject.pl --driver chrome --chromedriver-binary $HOME/selenium/chromedriver --selenium-binary $HOME/selenium/selenium-server-standalone-2.53.1.jar examples/selenium.xml
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
