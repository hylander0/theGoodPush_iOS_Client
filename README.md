#the Good Push
##the iOS Client
---

###the Introduction

This project demonstrates different practices and implementations when adding push notifications to your application. This application employs the use of [Urban Airship's](http://urbanairship.com) SDK for interacting with their provider services.


> **Note:** This project code is related to a presentation performed during a [CocoaHeads Meetup](http://www.meetup.com/Cleveland-CocoaHeads/events/135931172/) in Cleveland, Ohio. This demo is used in conjunction with the backend API service called [theGoodPush_API_Service](https://github.com/hylander0/theGoodPush_API_Service) but it is not required to run this iOS client.  For the push notification functionality a iOS Developer membership is required.


###the Setup

By default, this **Xcode 5** project should run without any changes to the code or configuration files. However, if you would like to enable the full setup of the demo projects then please use the instructions below:

####Urban Airship and iOS provisioning 

1. Sign up for a Urban Airship account and setting up the [application for push notifications with Apple](http://docs.urbanairship.com/build/ios.html#set-up-your-application-with-apple) (of course, changing the projects bundle in the process)
2. If you want to use Urban Airship's SDK that is installed with this project ensure [this](https://github.com/hylander0/theGoodPush_iOS_Client/blob/master/theGoodPush/theGoodPush/Common/Constants.m#L21) constant flag is set to **YES** and both your development [App Key](https://github.com/hylander0/theGoodPush_iOS_Client/blob/master/theGoodPush/theGoodPush/AirshipConfig.plist#L8) and [App Secret](https://github.com/hylander0/theGoodPush_iOS_Client/blob/master/theGoodPush/theGoodPush/AirshipConfig.plist#L8) are set.
3. During the app's first run and after successfully registering for push notifications you will recieve a `NSData` object containing the **DeviceToken** from the `didRegisterForRemoteNotificationsWithDeviceToken` AppDelete Method.
4. Logging into your **Urban Airship** application dashboard will allow you to send test push notifications to your device using the **DeviceToken** you have received.


####Service Endpoint Setup

After setting up and hosting the [Good Push API](https://github.com/hylander0/theGoodPush_API_Service) set the HTTP url location in the `GoodPushApi` class located [**here**](https://github.com/hylander0/theGoodPush_iOS_Client/blob/master/theGoodPush/theGoodPush/Services/GoodPushApi.m#L27)

The API will allow the device to query notifications recorded when they are submitted thought the service's HTML home page forms (the **Message Me** form and **Example Survey** form).


###the Author

* Justin Hyland - Email: justin.hyland@live.com

## MIT License

Copyright (c) 2012, 2013 Heapsource.com and Contributors - http://www.heapsource.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/hylander0/thegoodpush_ios_client/trend.png)](https://bitdeli.com/free "Bitdeli Badge")