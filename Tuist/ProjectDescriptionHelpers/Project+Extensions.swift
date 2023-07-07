import ProjectDescription

extension Project {

    public static let projectName = "PhotoEditingApp"

    public static let projectOptions: Project.Options = .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["en-US", "Base"],
        developmentRegion: "pt-BR",
        disableBundleAccessors: false,
        disableShowEnvironmentVarsInScriptPhases: false,
        disableSynthesizedResourceAccessors: false,
        textSettings: textSettings,
        xcodeProjectName: projectName
    )

    public static let textSettings: Project.Options.TextSettings = .textSettings(
        usesTabs: false,
        indentWidth: 4,
        tabWidth: 4,
        wrapsLines: true
    )
}
