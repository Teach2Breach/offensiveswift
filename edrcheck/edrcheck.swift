import Cocoa

func isAppRunning(bundleIdentifier: String) -> Bool {
    let runningApplications = NSWorkspace.shared.runningApplications
    for app in runningApplications {
        if app.bundleIdentifier == bundleIdentifier {
            return true
        }
    }
    return false
}

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
    if isAppRunning(bundleIdentifier: edr) {
        print("\u{001B}[0;32m" + "\(edr) found" + "\u{001B}[0;0m")
    }
}
