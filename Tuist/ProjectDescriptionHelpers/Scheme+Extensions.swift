import ProjectDescription

extension Scheme {

    public static let mainScheme: Scheme = .init(
        name: "PhotoEditingApp",
        shared: true,
        hidden: false,
        buildAction: mainBuildAction,
        testAction: mainTestAction,
        runAction: mainRunAction,
        archiveAction: mainArchiveAction,
        profileAction: mainProfileAction,
        analyzeAction: mainAnalyzeAction
    )

    static let mainBuildAction: BuildAction = .init(
        targets: [
            .project(path: "", target: "PhotoEditingApp")
        ],
        preActions: [],
        postActions: [],
        runPostActionsOnFailure: false
    )

    static let mainTestAction: TestAction = .targets(
        [.init(
            target: .project(path: "", target: "PhotoEditingAppTests"),
            skipped: false,
            parallelizable: false,
            randomExecutionOrdering: true
        )],
        arguments: nil,
        configuration: .debug,
        attachDebugger: true,
        expandVariableFromTarget: nil,
        preActions: [],
        postActions: [],
        options: .options(
            language: nil,
            region: "pt-BR",
            coverage: true,
            codeCoverageTargets: [.project(path: "", target: "PhotoEditingApp")]
        ),
        diagnosticsOptions: [.mainThreadChecker]
    )

    static let mainRunAction: RunAction = .runAction(
        configuration: .debug,
        attachDebugger: true,
        customLLDBInitFile: nil,
        preActions: [],
        postActions: [],
        executable: nil,
        arguments: nil,
        options: .options(
            language: nil,
            storeKitConfigurationPath: nil,
            simulatedLocation: nil,
            enableGPUFrameCaptureMode: RunActionOptions.GPUFrameCaptureMode.default
        ),
        diagnosticsOptions: [.mainThreadChecker]
    )

    static let mainArchiveAction: ArchiveAction = .archiveAction(
        configuration: .release,
        revealArchiveInOrganizer: true,
        customArchiveName: nil,
        preActions: [],
        postActions: []
    )

    static let mainProfileAction: ProfileAction = .profileAction(
        configuration: .release,
        preActions: [],
        postActions: [],
        executable: .project(path: "", target: "PhotoEditingApp"),
        arguments: nil
        )

    static let mainAnalyzeAction: AnalyzeAction = .analyzeAction(
        configuration: .debug
    )
}
