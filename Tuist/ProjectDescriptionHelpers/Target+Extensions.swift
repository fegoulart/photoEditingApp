import ProjectDescription

extension Target {

    static let mainTargetName = ""

    public static let mainTarget = Self.init(
        name: "PhotoEditingApp",
        platform: .iOS,
        product: .app,
        productName: "PhotoEditingApp",
        bundleId: "com.leapi.photoEditingApp",
        deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
        infoPlist: .file(path: "PhotoEditingApp/Config/Info.plist"),
        sources: .paths(["PhotoEditingApp/**"]),
        resources: ["PhotoEditingApp/Resources/**"],
        copyFiles: nil,
        headers: nil,
        entitlements: nil,
        scripts: [],
        dependencies: [],
        settings: .mainTargetSettings,
        coreDataModels: [],
        environment: [:],
        launchArguments: [],
        additionalFiles: [],
        buildRules: []
    )

    public static let testTarget = Self.init(
        name: "PhotoEditingAppTests",
        platform: .iOS,
        product: .unitTests,
        productName: "PhotoEditingAppTests",
        bundleId: "com.leapi.photoEditingAppTests",
        deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
        infoPlist: .file(path: "PhotoEditingAppTests/Config/Info.plist"),
        sources: .paths(["PhotoEditingAppTests/**"]),
        resources: [],
        copyFiles: nil,
        headers: nil,
        entitlements: nil,
        scripts: [],
        dependencies: [.target(name: "PhotoEditingApp")],
        settings: .testTargetSettings,
        coreDataModels: [],
        environment: [:],
        launchArguments: [],
        additionalFiles: [],
        buildRules: []
    )
}
