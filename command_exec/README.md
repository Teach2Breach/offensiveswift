# command_exec

Contains 2 tools written in Swift, targeting MacOS, which each will execute user provided command. Command_exec is a classic command runner, spawning a new process with the provided commands. command_advanced.swift is a bit different, and performs some operations to avoid spawning a new process in order to execute the commands, and additionally identifies all shells installed on the system and then randomly chooses the one to use for launching provided commands. The 2nd one is probably slightly more opsec safe, but these are just POCs really.

command_advanced.swift:
![image](https://user-images.githubusercontent.com/105792760/220694132-e0d0588d-6698-48ef-bc63-dd399b3cf9c0.png)


command_exec.swift:

![image](https://user-images.githubusercontent.com/105792760/220695550-833c4ef9-2aa8-4d47-a21e-c4525948f626.png)
