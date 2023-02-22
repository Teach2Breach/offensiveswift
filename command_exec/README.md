#command_exec

Contains 2 tools written in Swift, targeting MacOS, which each will execute user provided command. Command_exec is a classic command runner, spawning a new process with the provided commands. command_advanced.swift is a bit different, and performs some operations to avoid spawning a new process in order to execute the commands, and additionally identifies all shells installed on the system and then randomly chooses the one to use for launching provided commands. The 2nd one is probably slightly more opsec safe, but these are just POCs really.

will add compile instructions and screenshots here...
