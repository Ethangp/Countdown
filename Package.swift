// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Countdown",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .iOSApplication(
            name: "Countdown",
            targets: ["Countdown"],
            bundleIdentifier: "com.example.countdown",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(iconName: "AppIcon"),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .phone,
                .pad
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeLeft,
                .landscapeRight,
                .portraitUpsideDown
            ],
            additionalTargets: ["CountdownWidget"]
        ),
        .library(name: "CountdownKit", targets: ["CountdownKit"])
    ],
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "Countdown",
            dependencies: ["CountdownKit"],
            path: "Sources/Countdown"
        ),
        .executableTarget(
            name: "CountdownWidget",
            dependencies: ["CountdownKit"],
            path: "Sources/CountdownWidget"
        ),
        .target(
            name: "CountdownKit",
            path: "Sources/CountdownKit"
        )
    ]
)
