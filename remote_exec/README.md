# remote_exec

Uses NSAPPLESCRIPT to inject commands into a remote process on MacOS. Tested on latest Ventura. Nothing fancy, but it works and avoids some of the issues around process injection on Mac, such as requiring user interaction to grant permissions to the target application. In this case we inject into Calculator.app and run hardcoded 'whoami' command. Modify for your own use case.

![image](https://user-images.githubusercontent.com/105792760/220698925-6d4b6a18-7580-464c-8951-6aceeae4393e.png)

