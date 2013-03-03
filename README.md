LEAP OSX Gesture Controller
=========================

A Simple OSX application that lets you do basic tasks like switching spaces, opening mission control and expose using the LeapMotion Sensor

Why?
-----
When i first recieved the LEAP Motion i wanted to develop an application that was not just cool, but actually practical for every day usage. i wanted to develop something that you could use every day. I think people have already found that mouse control apps are cool but generally impractical to use with the current state of the leap motion, accidental clicking is a common problem. Thats when i turned to a more common problem i have experienced when using a mac: Window management and switching spaces without a decent mouse. 
if you have a magic mouse or trackpad, switching spaces is a very simple 3-fingered swipe left or right, but what if you just have a simple two-button mouse? you have to use the keyboard shortcuts to switch spaces and open mission-control which i have always found a very inconvenient way to navigate a computer. Thus the OSX Gesture Controller (i know, its a stupid name, feel free to come up with a better name)

the idea is to eventually do everything you can do on a trackpad or magic mouse using only the leap motion. complete control of a computer with the leap is NOT the goal. this application lets the leap be an addition to a mouse and keyboard instead of a replacement.

How?
-----
After you have opened the application in xcode and started the app (there might be some referance errors, if there are, drag libLeap.dylib from the Leap SDK into Frameworks) you may use the following gestures:

* swipe up: open mission control
* swipe down: open expose
* swipe left: switch to space left of current space
* swipe right: switch to space right of current space
* make a fist: put all displays to sleep
Also...
-------
Please feel free to contribute! i honestly have never made an OSX app before so i'm sure i'm making planty of noob mistakes so if you see anything that can be fixed, go ahead and clone it and fix it, and don't forget to put in a pull request.
