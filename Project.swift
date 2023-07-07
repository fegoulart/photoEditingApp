import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

let project = Project(
    name: Project.projectName,
    organizationName: "Leapi",
    options: Project.projectOptions,
    packages: [],
    settings: Settings.appSettings,
    targets: [.mainTarget, .testTarget],
    schemes: [.mainScheme],
    fileHeaderTemplate: .file("Tuist/IDEHeaderTemplate.txt"),
    additionalFiles: [],
    resourceSynthesizers: .default
)
