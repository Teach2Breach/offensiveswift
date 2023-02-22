2 methods to perform checks for common EDRs installed on a MacOS system. 

edrcheck.swift uses NSWORKSPACE to avoid launching a new process and using command_exec. 

edrcheckcmdline.swift uses the same methods as my command_exec to launch a process and run command line commands to perform the check.

compile with swiftc edrcheck.swift -o edrcheck

run with ./edrcheck

or test with swift:

![image](https://user-images.githubusercontent.com/105792760/220697340-365d33ec-e738-4ce6-b7c0-6123d516ce9f.png)




