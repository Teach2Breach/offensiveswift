import Foundation

func executeInApplescript(_ script: String) -> String? {
    let appleScript = NSAppleScript(source: script)!
    var error: NSDictionary?
    if let output = appleScript.executeAndReturnError(&error).stringValue {
        return output
    } else {
        print("Error executing script: \(error!)")
        return nil
    }
}

let script = """
    tell application "Calculator"
        activate
        set output to do shell script "ls -h"
    end tell
    return output
"""

if let output = executeInApplescript(script) {
    print(output)
} else {
    print("Error executing script.")
}
