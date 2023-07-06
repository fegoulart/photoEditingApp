import ProjectDescription

let config = Config(
    compatibleXcodeVersions: ["14.3.1"],
    swiftVersion: "5.4.0",
    generationOptions: .options(
        xcodeProjectName: "SomePrefix-\(.projectName)-SomeSuffix",
        organizationName: "Tuist",
        developmentRegion: "pt"
    )
)
