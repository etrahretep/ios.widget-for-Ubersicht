defaults read -g AppleInterfaceStyle 2> /dev/null
/usr/local/bin/icalbuddy -n -po title,datetime,location -iep datetime,title,location eventsToday+2
LC_TIME='nl_NL.UTF-8' date +'    %A ^ %e'