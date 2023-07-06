import ProjectDescription

extension Target {

    static let mainTargetName = ""

    public static let mainTarget = Self.init(
        name: "PhotoEditingApp",
        platform: .iOS,
        product: .app,
        bundleId: "com.acme.photoEditingApp",
        // sources: .paths(["PhotoEditingApp/**"]),
        resources: [],
        dependencies: []
    )

//    public static let unitTestTarget = Self.init(
//        name: <#T##String#>,
//        platform: <#T##Platform#>,
//        product: <#T##Product#>,
//        bundleId: <#T##String#>,
//        sources:,
//        resources: [],
//        dependencies: []
//    )
}
