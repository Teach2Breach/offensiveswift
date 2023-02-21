import Foundation

print("Enter a command:")
let command = readLine(strippingNewline: true)!
let task = Process()
task.launchPath = "/usr/bin/env"
task.arguments = ["bash", "-c", command]
let pipe = Pipe()
task.standardOutput = pipe
task.launch()
let data = pipe.fileHandleForReading.readDataToEndOfFile()
let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
print(output ?? "No output")
