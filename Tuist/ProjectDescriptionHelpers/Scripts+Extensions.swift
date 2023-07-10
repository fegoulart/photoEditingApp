import ProjectDescription

extension TargetScript {

    public static let swiftLint = Self.post(
        script: swiftLintScript,
        name: "SwiftLint",
        inputPaths: [],
        inputFileListPaths: [],
        outputPaths: [],
        outputFileListPaths: [],
        basedOnDependencyAnalysis: false,
        runForInstallBuildsOnly: false,
        shellPath: "/bin/sh",
        dependencyFile: nil
    )

    static let swiftLintScript: String = """
    if [[ "$(uname -m)" == arm64 ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    if which swiftlint > /dev/null; then
      swiftlint
    else
      echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
    """

}
