import Foundation

func launch(tool: URL, arguments: [String] = [], input: Data = Data(), completionHandler: @escaping CompletionHandler) {

    dispatchPrecondition(condition: .onQueue(.main))

    let group = DispatchGroup()
    let inputPipe = Pipe()
    let outputPipe = Pipe()

    var errorQ: Error? = nil
    var output = Data()

    let proc = Process()
    proc.executableURL = tool
    proc.arguments = arguments
    proc.standardInput = inputPipe
    proc.standardOutput = outputPipe
    group.enter()
    proc.terminationHandler = { _ in

        DispatchQueue.main.async {
            group.leave()
        }
    }

    group.notify(queue: .main) {
        if let error = errorQ {
            completionHandler(.failure(error), output)
        } else {
            completionHandler(.success(proc.terminationStatus), output)
        }
    }
    
    do {
        func posixErr(_ error: Int32) -> Error { NSError(domain: NSPOSIXErrorDomain, code: Int(error), userInfo: nil) }
        
        let fcntlResult = fcntl(inputPipe.fileHandleForWriting.fileDescriptor, F_SETNOSIGPIPE, 1)
        guard fcntlResult >= 0 else { throw posixErr(errno) }

        // Actually run the process.
        
        try proc.run()

        group.enter()
        let writeIO = DispatchIO(type: .stream, fileDescriptor: inputPipe.fileHandleForWriting.fileDescriptor, queue: .main) { _ in

            try! inputPipe.fileHandleForWriting.close()
        }
        let inputDD = input.withUnsafeBytes { DispatchData(bytes: $0) }
        writeIO.write(offset: 0, data: inputDD, queue: .main) { isDone, _, error in
            if isDone || error != 0 {
                writeIO.close()
                if errorQ == nil && error != 0 { errorQ = posixErr(error) }
                group.leave()
            }
        }

        group.enter()
        let readIO = DispatchIO(type: .stream, fileDescriptor: outputPipe.fileHandleForReading.fileDescriptor, queue: .main) { _ in
            try! outputPipe.fileHandleForReading.close()
        }
        readIO.read(offset: 0, length: .max, queue: .main) { isDone, chunkQ, error in
            output.append(contentsOf: chunkQ ?? .empty)
            if isDone || error != 0 {
                readIO.close()
                if errorQ == nil && error != 0 { errorQ = posixErr(error) }
                group.leave()
            }
        }
    } catch {

        errorQ = error
        proc.terminationHandler!(proc)
    }
}

typealias CompletionHandler = (_ result: Result<Int32, Error>, _ output: Data) -> Void

func launchWrapper() {
    print("Enter path to tool:")
    guard let path = readLine() else {
        print("Invalid path")
        return
    }
    let toolURL = URL(fileURLWithPath: path)
    print("Enter arguments (comma-separated):")
    guard let argsString = readLine() else {
        print("No arguments provided")
        launch(tool: toolURL, completionHandler: handleCompletion)
        return
    }
    let args = argsString.split(separator: ",").map { String($0) }
    launch(tool: toolURL, arguments: args, completionHandler: handleCompletion)
}

func handleCompletion(result: Result<Int32, Error>, output: Data) {
    switch result {
    case .success(let status):
        if let outputString = String(data: output, encoding: .utf8) {
            print("Tool finished with status: \(status)\nOutput:\n\(outputString)")
        } else {
            print("Tool finished with status: \(status)\nNo output")
        }
    case .failure(let error):
        print("Tool failed with error: \(error)")
    }
}

//launchWrapper()

//define an array to hold all the possible native shell binary paths

let shellPaths = ["/bin/bash", "/bin/sh", "/bin/zsh", "/bin/csh", "/bin/tcsh"]

//define a variable to hold the path to the shell we want to use
var shellPath = #""#

// randomly select a shell path from the array
if let randomPath = shellPaths.randomElement() {
    // append the path to the shell to the variable
    shellPath += randomPath
}

// append the closing quote
shellPath += #""#

// create the tool URL
let tool = URL(fileURLWithPath: shellPath)

var command = #""# // the quotes are escaped so the shell doesn't interpret them

// get input from the user to use as the command
print("Enter the command to run:")
if let input = readLine() {
    // append the user's input to the command
    command += input
}

// append the closing quote
command += #""#

// create the arguments array
let arguments = ["-c", command]

launch(tool: tool, arguments: arguments) { result, output in
    switch result {
    case .success(let status):
        print("Process exited with status: \(status)")
        print("Output: \(String(data: output, encoding: .utf8) ?? "")")
    case .failure(let error):
        print("Error: \(error)")
    }
    CFRunLoopStop(CFRunLoopGetMain())
}

CFRunLoopRun()
