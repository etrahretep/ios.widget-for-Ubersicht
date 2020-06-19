defaults read -g AppleInterfaceStyle 2> /dev/null
osascript ~/Documents/Widgets/ios.widget/IOSEvent.applescript
/usr/local/bin/icalbuddy -n -po title,datetime,location -iep title,datetime,location eventsToday+2