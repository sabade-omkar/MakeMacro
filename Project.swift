import ProjectDescription

/*
                +-------------+
                |             |
                |     App     | Contains Makemacro App target and Makemacro unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project Config

let platform: Platform = .iOS
let project = Project(
    name: "Makemacro",
    organizationName: "tuist.io",
    targets: [
        Targets.makeDefaultFrameworkTarget(with: .makeMacroKit),
        Target(
            name: Targets.makeMacroUI.name,
            platform: platform,
            product: .framework,
            bundleId: "io.tuist.\(Targets.makeMacroUI.name)",
            infoPlist: .default,
            sources: ["Targets/\(Targets.makeMacroUI.name)/Sources/**"],
            resources: ["Targets/\(Targets.makeMacroUI.name)/Resources/**"],
            dependencies: [.external(name: "SnapKit"), .target(name: Targets.makeMacroKit.name)]
        ),
        Targets.makeAppTarget(
            name: "Makemacro",
            platform: platform,
            dependencies: [.target(name: Targets.makeMacroUI.name)]
        )
    ]
)


// MARK: - Helpers
enum Targets {
    case makeMacroKit
    case makeMacroUI
    
    var name: String {
        switch self {
        case .makeMacroKit:
            return "MakeMacroKit"
        case .makeMacroUI:
            return "MakemacroUI"
        }
    }
}

extension Targets {
    static func makeDefaultFrameworkTarget(with targetType: Targets) -> Target {
        Target(
            name: targetType.name,
            platform: platform,
            product: .framework,
            bundleId: "io.tuist.\(targetType.name)",
            infoPlist: .default,
            sources: ["Targets/\(targetType.name)/Sources/**"],
            resources: [],
            dependencies: []
        )
    }
    
    static func makeAppTarget(name: String, platform: Platform, dependencies: [TargetDependency]) -> Target {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "NSPhotoLibraryUsageDescription": "Add Images to your macros from your Photos",
            "NSPhotoLibraryAddUsageDescription": "Export created macros to your Photos"
        ]

        return Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )
    }
}
