import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .upToNextMinor("14.3"),
    cloud: nil,
    cache: nil,
    swiftVersion: "5.8.0",
    plugins: [],
    generationOptions: .options(
        resolveDependenciesWithSystemScm: false,
        disablePackageVersionLocking: false
    )
)
