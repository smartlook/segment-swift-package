# SmartlookSegmentPlugin


This plugin allows you to easily add Smartlook support to your applications through  [Analytics-Swift](https://github.com/segmentio/analytics-swift)


## Adding the dependency

To add this plugin to your project, you'll need to install the Smartlook library as an additional dependency. There are two ways to add the dependency:

### Via Xcode
1. Open Xcode and go to the File menu.
2. Click Add Packages.
3. In the search field, enter the URL to this repo: https://github.com/smartlook/segment-swift-package
4. You'll then have the option to pin to a version, or specific branch, as well as which project in your workspace to add it to.
5. Once you've made your selections, click the Add Package button.

### via Package.swift

Add the following to your `Package.swift` file under the `dependencies` section:

```
.package(
            name: "SmartlookSegmentPlugin",
            url: "https://github.com/smartlook/segment-swift-package",
            from: "1.0"
        ),
```


*Note the Smartlook library itself will be installed as an additional dependency.*


## Using the Plugin in your App

1. Open the file where you setup and configure the Analytics-Swift library.
2. Import the plugin by adding this line at the top of the file:

```
import Segment
import SmartlookSegmentPlugin
```


3. Beneath your Analytics-Swift library setup, add the plugin to the Analytics timeline by invoking `analytics.add(plugin: ...)`, like this:



```
let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(1)
                    .trackApplicationLifecycleEvents(true))
analytics.add(plugin: SmartlookSegmentPlugin(projectKey: "<YOUR SMARTLOOK PROJECT KEY >"))
```

Once you've added the plugin, your events will begin streaming to Smartlook.
    