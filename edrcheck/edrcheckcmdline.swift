import Foundation

func checkEDRs() {
    let edrList = [
        "com.crowdstrike.falcon.UserAgent",
        "com.carbonblack.defense.uiagent",
        "com.symantec.SymLUHelper",
        "com.mcafee.ssm.Eupdate",
        "com.tanium.taniumclient",
        "com.microsoft.seattleglacier",
        "com.traps.agent",
        "com.paloaltonetworks.traps",
        "com.sophos.intercheck",
        "com.sophos.xcs",
        "com.sophos.festoon",
        "com.eset.remoteadministrator.agent",
        "com.eset.nod32av",
        "com.kaspersky.kav.16.0.0",
        "com.kaspersky.kav.17.0.0",
        "com.kaspersky.kav.18.0.0",
        "com.kaspersky.kav.19.0.0",
        "com.kaspersky.kav.20.0.0",
        "com.symantec.sep",
        "com.symantec.sesc"
    ]

    for edr in edrList {
        let output = executeCommand("/bin/launchctl", args: 
["list"]).lowercased()

        if output.contains(edr.lowercased()) {
            print("\u{001B}[0;32m" + "\(edr) found" + "\u{001B}[0;0m")
        } else {
            print("\u{001B}[0;31m" + "\(edr) not found" + "\u{001B}[0;0m")
        }
    }
}

func executeCommand(_ launchPath: String, args: [String]) -> String {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = args

    let pipe = Pipe()
    task.standardOutput = pipe

    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: 
.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

    return output ?? ""
}

func main() {
    checkEDRs()
}

main()
