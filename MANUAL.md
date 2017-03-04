# Manual for WebInject-Selenium version 0.1.0

## Table of Contents


#### [3.3.8 - Parameters to control Selenium WebDriver Test Execution](#webdriver)

[searchimage searchimage1 ... searchimage5](#searchimage)

[verifytext](#verifytext)


#### [3.3.10 - Selenium WebDriver](#selenium)

[helper functions](#helper)



<a name="webdriver"></a>
### 3.3.8 - Parameters to control Selenium WebDriver Test Execution

<br />


<a name="searchimage"></a>
#### searchimage searchimage1 ... searchimage5

Searches the WebDriver pagegrab or screenshot for a specified subimage. A small tolerance is allowed in case
the image cannot be found exactly. This is useful if the baseline image is captured in one browser version /
operating system, but tested on another.

```
    searchimage="RunningMan_Company_Logo.png"`
```

The subimages are stored in a folder named baseline under the testcases folder. The specific imagie is in an addtional
subfolder that has the same name as the testcase you are running.

For example, refering to the example above, RunningMan_Company_Logo.png can be found at
```
    mywebinjectestsfolder\baseline\mytestname\RunningMan_Company_Logo.png
```

<br />


<a name="verifytext"></a>
#### verifytext
Fetches from WebDriver / Selenium the details you specify. Used in conjuction with a verifypostive or verifynegative.
Or perhaps you just want those details to appear in the http.txt.

Separate additional items with commas. Example:

```
    verifytext="get_active_element,get_all_cookies,get_current_url,get_window_position,get_body_text,get_page_source"
```

<br />


<a name="selenium"></a>
### 3.3.10 - Selenium WebDriver

A minimal Selenium example looks like the following:

```
<case
    id="10"
    description1="Get Totaljobs Home Page"
    method="selenium"
    command='$selresp = $driver->get("http://www.totaljobs.com");'
/>
```

The method is specified as `selenium` and this is used in conjunction with `command` to drive Selenium.

The example gets a web page, and automatically takes a screenshot which will be saved in the output folder.

Many different commands are supported, to see them all refer to Selenium::Remote::Driver on cpan which
can be found here: http://search.cpan.org/~gempesaw/Selenium-Remote-Driver/lib/Selenium/Remote/Driver.pm

The first example given does not include an assertion. Here is a more complete example:

```
<case
    id="10"
    description1="Get Totaljobs Home Page"
    method="selenium"
    command='$selresp = $driver->get("http://www.totaljobs.com");'
    verifytext="get_current_url,get_page_source"
    verifypositive="Find your perfect job"
/>
```

Here you can see that we also get the page source. WebInject then can use this to perform a standard
assertion within its existing framework.

<a name="helper"></a>
#### Helper functions for Selenium WebDriver based tests

There are a number of helper functions built into WebInject to make it easier to create
Selenium test suites.

The following example shows how you can get WebInject to wait up to a maximum of 25 seconds
for the text `Sign in` to appear.

```
<case
    id="10"
    description1="Get Totaljobs Home Page"
    method="selenium"
    command1='$selresp = $driver->get("http://www.totaljobs.com");'
	command2="$selresp = helper_wait_for_text_visible('Sign in',25,'body','tag_name');"
    verifytext="get_current_url,get_page_source"
    verifypositive="Find your perfect job"
    verifypositive1="Found sought text"
/>
```

Here is a full list of the helper functions.

##### helper_clear_and_send_keys

helper_clear_and_send_keys(`target`, `locator`, `keys`);

```
command="$selresp = helper_clear_and_send_keys('candidateProfileDetails_txtPostCode','id','WC1X 8TG');"
```

##### helper_switch_to_window

helper_switch_to_window(`window number`);

```
command="$selresp = helper_switch_to_window(0);"
```

##### helper_keys_to_element

helper_keys_to_element(`anchor[|||instance]`,`keys`);

Will look for some text in the page source, and enter a value to found element. In this example
the element is found using the placeholder text.
```
command="$selresp = helper_keys_to_element('Job title, skill or company','WebDriver Jobs');"
```

Select "Contract" in the drop down with attribute "optJobType".
```
command="$selresp = helper_keys_to_element('optJobType','Contract','SELECT');"
```

##### helper_keys_to_element_after

helper_keys_to_element_after(`anchor[|||instance]`,`keys`,[`tag[|||instance]`]);

Will look for some text in the page source, and enter a value to the following INPUT tag.
```
command="$selresp = helper_keys_to_element_after('What','WebDriver Jobs');"
```

Select "Contract" in the 2nd drop down after the element targeted by "Job Type".
```
command="$selresp = helper_keys_to_element_after('Job Type','Contract','SELECT|||2');"
```

##### helper_keys_to_element_before

Works just like `helper_keys_to_element_after` but will search for a matching element before the anchor text.

##### helper_click

helper_click(`anchor[|||instance]`);

Clicks the first element on the page with Yes in it somewhere. Exact matches are priortised over partial matches.
Element text is prioritised over attribute values.
```
command="$selresp = helper_click('Yes');"
```

Clicks the second instance that matches `Yes`.
```
command="$selresp = helper_click('Yes',2);"
```

##### helper_click_after

helper_click_after(`anchor[|||instance]`,[`tag[|||instance]`]);

Will click the first element it finds after the text anchor, so long as it is one of INPUT, BUTTON, SELECT or A (i.e. link).

Clicks the first button after the second instance that matches `Yes`.
```
command="$selresp = helper_click_after('Yes|||2','BUTTON');"
```

Due to the heuristics, if there are two exact matches for `Yes` then only those will be counted. The other `Yes` matches will
be ignored if they are considered to be of poorer quality.

##### helper_click_before

Works just like helper_click_after, except that it looks before the matching anchor text.

##### helper_check_element_within_pixels

helper_check_element_within_pixels(`target`, `id`, `x baseline`, `y baseline`, `pixel threshold`);

```
command="$selresp = helper_check_element_within_pixels('txtEmail','id',193,325,30);"
```

##### helper_wait_for_text_present

helper_wait_for_text_present(`search text`, `timeout`);

```
command="$selresp = helper_wait_for_text_present('Job title',10);"
```

##### helper_wait_for_text_visible

helper_wait_for_text_visible(`search text`,`timeout`,`target`,`locator`);

```
command="$selresp = helper_wait_for_text_visible('Job title', 10, 'body', 'tag_name');"
```

##### helper_wait_visible

helper_wait_visible(`anchor[|||instance]`[,timeout]);

Waits for the element designated by the anchor to be visible in the current viewport. Default timeout is 5 seconds.

Will wait up to 10 seconds for element with attribute `txtJobTitle` to become visible in the viewport.
```
command="$selresp = helper_wait_visible('txtJobTitle', 10);"
```

##### helper_wait_not_visible

Works like helper_wait_visible except that it waits until the element targeted by the anchor to be not visible in the current viewport.

##### helper_scroll_to

helper_scroll_to(`anchor[|||instance]`);

Uses the JavaScript element.scrollIntoView method to scroll the element targeted by the anchor into view.

##### helper_move_to

helper_move_to(`anchor[|||instance]`,`x offset`,`y offset`);

Moves the mouse to the element targeted by the anchor. 

Moves to an x offset of 320 and a y offset of 200 from the 2nd element with anchor `Yes`.
```
command="$selresp = helper_move_to('Yes|||2',320,200);"
```

##### helper_get_element

helper_get_element(`anchor[|||instance]`);

Gets various information about the element targeted by the anchor.

The information includes the element attributes, the text, and if the element is in the current viewport.

If applicable the currently selected drop down option is returned.

