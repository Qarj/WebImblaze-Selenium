# Manual for WebInject-Selenium version 0.2.0

## [1 - Overview](#overview)

## [2 - Parameters to control Selenium WebDriver Test Execution](#parameters)
### [ searchimage searchimage1 ... searchimage5](#searchimage)
### [ verifytext](#verifytext)

## [3 - Helper Functions - Locators for Testers](#locators)
### [`target` and `element` parameters described](#target_element)
### [`Locators for Testers` helper functions full details](#full_details)
### [ _keys_to_element](#_keys_to_element)
### [ _keys_to_element_after](#_keys_to_element_after)
### [ _keys_to_element_before](#_keys_to_element_before)
### [ _click](#_click)
### [ _click_after](#_click_after)
### [ _click_before](#_click_before)
### [ _get_element](#_get_element)
### [ _wait_visible](#_wait_visible)
### [ _wait_not_visible](#_wait_not_visible)
### [ _scroll_to](#_scroll_to)
### [ _move_to](#_move_to)
### [ Locators for Testers - Heuristics full details](#heuristics)

## [4 - Helper Functions - Other](#helper)
### [ _clear_and_send_keys](#_clear_and_send_keys)
### [ _switch_to_window](#_switch_to_window)
### [ _wait_for_text_present](#_wait_for_text_present)
### [ _wait_for_text_visible](#_wait_for_text_visible)
### [ _check_element_within_pixels](#_check_element_within_pixels)

## [5 - Hints and tips](#tips)
### [ Single quote vs Double quote](#tips)
### [ Need more quotes!](#more_quotes)
### [ Page load timeout](#page_load_timeout)
### [ Switch to iframe example](#switch_iframe)
### [ Set window size to emulate Mobile view port](#set_window_size)
### [ Execute a JavaScript snippet](#javascript_snippet)


<a name="overview"></a>
## 1 - Overview

A minimal Selenium example looks like the following:

```xml
<case
    id="10"
    description1="Get Totaljobs Home Page"
    method="selenium"
    command='$driver->get("https://www.totaljobs.com")'
/>
```

The method is specified as `selenium` and this is used in conjunction with `command` to drive Selenium.

`$selresp` refers to the Selenium Response. This will be stored in the http.txt file for each step.
Typically Selenium just responds with `1` for a command to do something - e.g. click on an element.

The example gets a web page, and automatically takes a screenshot which will be saved in the output folder.

Many different commands are supported, to see them all refer to Selenium::Remote::Driver on cpan which
can be found here: http://search.cpan.org/~gempesaw/Selenium-Remote-Driver/lib/Selenium/Remote/Driver.pm

In addition, there are many helper (start with underscore _) functions built into this plugin that make working with Selenium very easy. See the
[Helper Functions](#helper) section.

Here is an example that includes an assertion:

```xml
<case
    id="10"
    description1="Get Totaljobs Home Page"
    method="selenium"
    command='$driver->get("https://www.totaljobs.com")'
    verifytext="get_current_url,get_body_text,get_page_source"
    verifypositive="a job you love"
/>
```

Here you can see that we also get the body text and page source. WebInject then can use this to perform a standard
assertion within its existing framework.

<a name="parameters"></a>
## 2 - Parameters to control Selenium WebDriver Test Execution

<br />


<a name="searchimage"></a>
### searchimage searchimage1 ... searchimage5

Requires search-image plugin. The plugin itself is already installed, however there are dependencies on Python and other libraries. Setup
instructions can be found here: https://github.com/Qarj/search-image

Searches the WebDriver Selenium screenshot for a specified subimage. A small tolerance is allowed in case
the image cannot be found exactly. This is useful if the baseline image is captured in one browser version /
operating system, but tested on another.

```
    searchimage="examples\search_images\menu_hamburger.png"`
```

Specify the file path relative to the WebInject root folder.

<br />


<a name="verifytext"></a>
### verifytext
Fetches from WebDriver / Selenium the details you specify. Used in conjuction with a verifypostive or verifynegative.
If you want to parseresponse, then you will need to use this feature to get something to parse.

Multiple items can be separated with commas. Example:

```
    verifytext="get_active_element,get_all_cookies,get_current_url,get_window_position,get_body_text,get_page_source"
```

Typically you might just get the current URL, the body text and the page source:

```
    verifytext="get_current_url,get_body_text,get_page_source"
```


<br />


<a name="locators"></a>
## 3 - Helper Functions - Locators for Testers

### Overview

If you have ever found locating elements using XPATH or CSS cumbersome, especially when there are no neatly named id attributes,
then these helper functions are for you.

If you were to write a script for a manual tester to conduct a test, you would do it in terms of what you see on the web page.

There is no good reason not to do the same for an automated test.

The helper functions described in this section allow you write automated tests simply by looking at the web page and describing
what to do based on the visible text.

Look at this example:
```xml
<case
    id="10"
    description1="Get CWJobs home page and fill out search form"
    method="selenium"
    command1='$driver->get("https://www.cwjobs.co.uk/")'
    command2="_keys_to_element_after('What','Automated Testing')"
    command3="_keys_to_element_after('Where','London')"
/>
```

The search form on this website looks like this:
![Alt text](images/basic_search_form.png?raw=true "Basic Search Form")

So we can see the labels `What` and `Where`. We see input fields after the labels.

`_keys_to_element_after` will send keys to the INPUT element after the target text, in this case `What` and `Where`.
The target text is referred to as the `target` parameter in these 'Locators for Testers' helper functions.

In fact this is the most common scenario, the label will be immediately before corresponding INPUT element.

After we fill out the search form, we will want to submit it. We can do this as follows:
```xml
<case
    id="20"
    description1="Click Search"
    method="selenium"
    command1="_click('Search')"
/>
```

`_click` found an element with the text `Search` and clicked it. The Search button.

These locators use heuristics to determine the correct elements to interact with. These heuristics are described in
detail at the end of this section. For now just understand that high probability matches will be chosen ahead of a low
probability match.

Imagine if the text `Search for what job you want where you want it` appeared at the top of the page. This would
have the potential to cause an incorrect result. However the exact match `Search` (on the button) is a better match
than the `Search` in this sentence, so the button takes priority. `what` and `where` will not even match - the capitalisation
is different!

And if there were two `What` input fields fields for some reason? You could target the second one as follows:
```
    command2="_keys_to_element_after('What|||2','Automated Testing')"
```

This simply says to use the second match. Most of the time you will not need to do this.

So how can we select a radius in the drop down combo box (refer back to the search form example above)?

This can be done as follows:
```
    command4="_keys_to_element_after('Where','20 miles','SELECT')"
```

Here an additional parameter is introduced, called the `element`. By default we send keys to `INPUT` elements. (Think
of it as an element with tag name `INPUT`). Drop downs are designated by the `SELECT` tag. So to send
keys to a drop down, we need to specify the target tag `SELECT` explicitly.

One final concept we need to cover is what to do if there is no text nearby the element we want to
interact with. In this case, as a last resort, the heuristics will look at the element attribute contents.

So lets say you had a hamburger icon for the menu (often the case for mobile websites) and in the page source you
discovered it had a name="hamburger_icon", you could target it as follows:
```
    command1="_click('hamburger_icon')"
```

<br />


<a name="target_element"></a>
### `target` and `element` parameters described

#### target - `anchor[|||instance]`

The target is made up of the text to search for (the `anchor`) and an optional instance number. The instance defaults
to 1 - i.e. the 1st text that matches the target according to the heuristics.

`_keys_to_element('Town, city or postcode|||2','London')`
In this example, `Job title, skill or company` is the target text (refer to the example search form in the Overview).
`2` says to match the second instance of the target text.

<br />


#### element - `tag[|||instance]`

Only used with the helper functions that end in _after or _before.

Once the target has been found, if we are interacting with an element *after* or *before* the target
we need to know what type of element to interact with.

For the helpers that send keys, we don't want to send keys to literally the next element in the DOM after the
field label. We want to send the keys to the next INPUT element. This is the default.

`_keys_to_element_after('Where|||2','London')`
In this example, it is implied that we send the keys to the next `INPUT` element after `Where` in the DOM. That is the default.

`_keys_to_element_after('Where|||2','London','INPUT')`
This example is functionally identical.

`_keys_to_element_after('Where|||2','London','INPUT|||1')`
This example is also functionally identical.

`_keys_to_element_after('Where|||2','London','INPUT|||2')`
In this example, the keys are sent to the second `INPUT` element found in the DOM *after* the best
match of `Where` according to the heuristics.

Note that the tag is always specified in *UPPERCASE*. This is how it is done in JavaScript. These helper
functions heavily rely on JavaScript for parsing the DOM.

<br />


<a name="full_details"></a>
### `Locators for Testers` helper functions full details

<a name="_keys_to_element"></a>
#### _keys_to_element

_keys_to_element(`target`,`keys`)

Will look for some text in the page source, and enter a value to found element. In this example
the element is found using the placeholder text.
```
    command="_keys_to_element('Job title, skill or company','WebDriver Jobs')"
```

Select "Contract" in the drop down with attribute "optJobType".
```
    command="_keys_to_element('optJobType','Contract','SELECT')"
```

<br />


<a name="_keys_to_element_after"></a>
#### _keys_to_element_after

_keys_to_element_after(`target`,`keys`,[`element`])

Will look for some text in the page source, and enter a value to the following INPUT tag.
```
    command="_keys_to_element_after('What','WebDriver Jobs')"
```

Select "Contract" in the 2nd drop down after the element targeted by "Job Type".
```
    command="_keys_to_element_after('Job Type','Contract','SELECT|||2')"
```

<br />


<a name="_keys_to_element_before"></a>
#### _keys_to_element_before

Works just like `_keys_to_element_after` but will search for a matching element before the anchor text.

<br />


<a name="_click"></a>
#### _click

_click(`target`)

Clicks the first element on the page with Yes in it somewhere. Exact matches are priortised over partial matches.
Element text is prioritised over attribute values.
```
    command="_click('Yes')"
```

Clicks the second instance that matches `Yes`.
```
    command="_click('Yes',2)"
```

<br />


<a name="_click_after"></a>
#### _click_after

_click_after(`target`,[`element`])

Will click the matching element it finds after the target.

If `element` is not specified, it defaults to `INPUT|BUTTON|SELECT|A||||1`.

This means any tag named `INPUT`, `BUTTON`, `SELECT` or `A` (link) is a match.

`1` means first match.

```
    command="_click_after('Yes|||2','BUTTON')"
```
Clicks the first button after the second instance that matches `Yes`.

Due to the heuristics, if there are two exact matches for `Yes` then only those will be counted. The other `Yes` matches will
be ignored if they are considered to be of poorer quality.

<br />


<a name="_click_before"></a>
#### _click_before

Works just like _click_after, except that it looks before the matching target.

<br />


<a name="_get_element"></a>
#### _get_element

_get_element(`target`)

Gets various information about the element targeted by the anchor.

The information includes the element attributes, the text, and if the element is in the current viewport.

If applicable the currently selected drop down option is returned.

```
    command="_get_element('Company Billing Cycle|||2')"
```

This example might return something like:
```
Located tag SELECT WITH[Company Billing Cycle] OK (exact match)
 name="cmp_billing_cycle" class="form-control input-lg" 
 Element Text [_NULL_]
 Element Value [MONTHLY]
 Element Selection [[MONTHLY] Monthly] isChecked[false]
 scrollTop[0] offsetWidth[455] offsetHeight[45] inViewport[1]
 allText[Please enter the company billing cycle details]
```

`inViewport[1]` means that the element is visible in the current view port (on the screen).

`inViewport[0]` means the element is not visible in the current view port. It could be further
down the page (out of the currently scrolled to area). Or it might be completely hidden.

<br />


<a name="_wait_visible"></a>
#### _wait_visible

_wait_visible(`target`,`[timeout]`)

Waits for the element designated by the anchor to be visible in the current viewport. Default timeout is 5 seconds.

```
    command="_wait_visible('txtJobTitle', 10)"
```
Will wait up to 10 seconds for element with attribute `txtJobTitle` to become visible in the viewport.

The determination of whether an element is visible in the view port is something of a black art. It is done
using this function found on stack overflow:
```JavaScript
function isElementInViewport (el) {

    var rect = el.getBoundingClientRect();

    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && /*or $(window).height() */
        rect.right <= (window.innerWidth || document.documentElement.clientWidth) /*or $(window).width() */
    );
}
```
See the `Recommended by John Resig` solution here: http://stackoverflow.com/questions/123999/how-to-tell-if-a-dom-element-is-visible-in-the-current-viewport

It works pretty well but not in all cases. If it does work for your scenario, then it should work consistently.

<br />


<a name="_wait_not_visible"></a>
#### _wait_not_visible

Works like _wait_visible except that it waits until the element targeted by the anchor to be not visible in the current viewport.

<br />


<a name="_scroll_to"></a>
#### _scroll_to

_scroll_to(`target`)

Uses the JavaScript element.scrollIntoView method to scroll the element targeted by the anchor into view.

<br />


<a name="_move_to"></a>
#### _move_to

_move_to(`target`,`x offset`,`y offset`)

Moves the mouse to the element targeted by the anchor. Uses the Selenium command of the same name once the
target has been found.

```
    command="_move_to('Yes|||2',320,200)"
```
Moves to an x offset of 320 and a y offset of 200 from the 2nd element with anchor `Yes`.

<br />


<a name="heuristics"></a>
### Locators for Testers - Heuristics full details

Three classes of text are searched for the `target`.

The first class is the text contained *between* the element tags.

The second class is what is collectively called the *priority attributes*.

The third class are *all other attributes*.

<br />


#### Class one - Text *between* the element tags

Consider the following fragment the DOM for a web page:
```
<label for="location">Where</label>
```

In this case the text between the tags is `Where`.

Consider this more complex example:
```
<h2><span class="brand-highlight">10,545</span> job ads for <span class="brand-highlight">766</span> companies</h2>
```

The `h2` example has two sub elements. Only the text directly in the `h2` element, i.e. the root level is assessed for the heuristics.

So the text for the `h2` element is ` job ads for  companies`.

The text for the first `span` element is `10,545`.

The text for the second `span` element is `766`.

##### Exclusions from class one

Elements marked as hidden are ignored.

```
<div type="hidden" class="password" id="confirm_password">Please confirm your password</div>
```

Hidden elements should be ignored since we don't want to target elements we can't see.

Unfortunately this doesn't always work as well as we would hope. Sometimes elements are hidden by virtue that there
is another element on top of them. In other cases content is hidden by a combination of CSS and JavaScript. In these
situations you can end up targeting elements you do not expect.

<br />


#### Class two - *priority attributes*

Certain attributes have a high chance of having their text content displayed directly on the web page.

These attributes are `value`, `placeholder` and `title`.

Consider this DOM fragment:
```
<input class="search-location" type="search" name="LTxt" placeholder="Town, city or postcode" id="txt_location">
```

The `placeholder` text is highly likely to be displayed on the web page. So this attribute is searched by the heuristics in preference
to the other attributes.

<br />


#### Class three - *all other attributes*

The final place to search is the other attribute values. The attribute text is typically for internal use only
and is not displayed on the web page. However we need a way of locating elements by other means.

Consider this DOM fragment:
```
<input class="search-location" type="search" name="LTxt" placeholder="Town, city or postcode" id="txt_location">
```

The attribute values are `search-location`, `search`, `LTxt`, `Town, city or postcode`, and `txt_location`.

<br />

#### Algorithm

##### Phase 1

1. Search class one - full exact match only
2. Search class one - target text must start from position 1
3. Search class one - target text must start from no later than position 3
4. Search class one - target text must start from no later than position 15
5. Search class one - target text must start from no later than position 50

For each step, the entire DOM is searched from top to bottom before proceeding onto the next step.

This means in this phase the DOM is scanned 5 times before giving up and moving on to phase 2.

##### Phase 2

As per `Phase 1`, however `class two` text is searched.

##### Phase 3

As per `Phase 1`, however `class three` text is searched.

<br />


<a name="helper"></a>
## 4 Helper Functions - Other


<a name="_clear_and_send_keys"></a>
#### _clear_and_send_keys

_clear_and_send_keys(`target`, `locator`, `keys`)

Commonly when we send keys to an element we want to blank out any existing text first. This helper does that.

Refer to the Selenium::Remote:::Driver documentation on cpan for descriptions on `target` and `locator`.

```
    command="_clear_and_send_keys('candidateProfileDetails_txtPostCode','id','WC1X 8TG')"
```

<br />


<a name="_switch_to_window"></a>
#### _switch_to_window

_switch_to_window(`window number`)

For working with multiple tabs / windows. Refer to the Selenium::Remote:::Driver documentation on cpan.

```
    command="_switch_to_window(0)"
```

Note that if you know the window's name, you don't need to use this helper, you can use the Selenium
command directly:
```
    command="$driver->switch_to_window('Homepage')"
```

<br />


<a name="_wait_for_text_present"></a>
#### _wait_for_text_present

_wait_for_text_present(`search text`, `timeout`)

Waits for the `search text` to be found in the page source. Waits until the `timeout` has been reached.

When the search text is found, a message will be writen to the response log `Found sought text present`.

```
    command="_wait_for_text_present('Job title',10)"
```
Wait up to 10 seconds for `Job title` to appear in the page source.

Full example:
```xml
<case
    id="520"
    description1="Click 'Connect to Dropbox' button"
    method="selenium"
    command1='$driver->find_element("lnkDropBox","id")->click()'
    command2="_wait_for_text_present('Sign in to Dropbox',15)"
    verifytext="get_current_url,get_body_text"
    verifypositive="Found sought text"
/>
```

When this is run, you might get a response like this:
```
Found sought text in page source after 1.6 seconds
```

<br />


<a name="_wait_for_text_visible"></a>
#### _wait_for_text_visible

_wait_for_text_visible(`search text`,[`timeout`,`target`,`locator`])

`timeout` defaults to 5 seconds
`target` defaults to 'body'
`locator` defaults to 'tag_name'

```
    command="_wait_for_text_visible('Job title')"
```
Waits up to 5 seconds for `Job title` to be found in the body text.

```
    command="_wait_for_text_visible(q|my profile and CV|,25,q|label[for='candidateProfile']|,q|css|)"
```
Waits up to 25 seconds for `my profile and CV` to be found using the given css locator.

The following example shows how you can get WebInject to wait up to a maximum of 25 seconds
for the text `Sign in` to appear.
```xml
<case
    id="10"
    description1="Get Totaljobs Home Page"
    method="selenium"
    command1='$driver->get("https://www.totaljobs.com")'
	command2="_wait_for_text_visible('Sign in',25)"
    verifytext="get_current_url,get_body_text"
    verifypositive="a job you love"
    verifypositive1="Found sought text"
/>
```

In the response log you will see a message like the following that you can assert against:
```
Found sought text visible after 3.8 seconds
```

<br />


<a name="_check_element_within_pixels"></a>
#### _check_element_within_pixels

_check_element_within_pixels(`target`, `id`, `x baseline`, `y baseline`, `pixel threshold`)

If you know an element you appear at a particular location on the page, you can assert that it does
appear there. A threshold can be specified.

```
    command="_check_element_within_pixels('Edit profile','link_text',860,549,40)"
```
Check that the element identified by the link text 'Edit profile' appears at 860,549 - or within 40 pixels of that location.

The response log will contain a message like the following that you can assert against:
```
Pixel threshold check passed - Edit profile is 0,0 (x,y) pixels removed from baseline of 860,549; actual was 860,549
```

<br />


<a name="tips"></a>
## 5 - Hints and tips

### Single quote vs Double quote

The test steps are processed by Perl. Perl treats single quotes differently to double quotes.
The content of single quotes is interpreted literally, whereas double quotes are `interpolated`. This
includes giving special meaning to certain characters that denote variables. `$` and `@` are examples.

So it is generally better to write the commands as follows:
```
    command1="_keys_to_element_after('E-mail','john@example.com')"
```
In this example WebInject will not get tripped up by the `@` symbol in the email address.

If you had written
```
    command1='_keys_to_element_after("E-mail","john@example.com")'
```
Perl would expect a variable `@example` to exist and would throw an error when it couldn't find it.

There is always the option of escaping the special characters with a backslash:
```
    command1='_keys_to_element_after("E-mail","john\@example.com")'
```

<br />


<a name="more_quotes"></a>
### Need more quotes!

In some cases due to complex CSS locators, you might find yourself running out of quotes.

Fortunately with Perl you can make up your own quotes as in this example:
```
    command="_wait_for_text_visible(q|my profile and CV|,25,q|label[for='candidateProfile']|,q|css|)"
```

Just use a `q` then immediately following the character you want to act as a quote.

<br />


<a name="page_load_timeout"></a>
### Page load timeout

By default WebInject sets the Selenium page load timeout to 30 seconds. You can change it
to a different value as follows.

```
    command="$driver->set_timeout('page load', 5_000)"
```
Changes page load timeout to 5 seconds.

Setting the page load timeout to a low value can help with pages that have a lot of third party content.
Sometimes this content can be slow to load, or in fact may never load. Often your test will not
depend on it at all - for example, banner ads and tracking tags.

<br />


<a name="switch_iframe"></a>
### Switch to iframe example

```
    command="$driver->switch_to_frame($driver->find_element(q|iframe[title='Third party frame']|,'css'))"
```

<br />


<a name="set_window_size"></a>
### Set window size to emulate Mobile view port

```
    command1="$driver->set_window_size(960, 340)"
```
The pixels down is given first, then across.

<br />


<a name="javascript_snippet"></a>
### Execute a JavaScript snippet

You can execute some JavaScript to interact with the page.

```
	command="$driver->execute_script(q|return analytics.Campaign;|)"
```
Will return the value of the variable `analytics.Campaign`.

The JavaScript can be many lines long if required.

