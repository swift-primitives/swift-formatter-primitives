// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-formatter-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // MARK: - Namespace

        .library(
            name: "Formatter Primitive",
            targets: ["Formatter Primitive"]
        ),
        .library(
            name: "Formatter Protocol",
            targets: ["Formatter Protocol"]
        ),
        .library(
            name: "Formattable",
            targets: ["Formattable"]
        ),

        // MARK: - Witness

        .library(
            name: "Format",
            targets: ["Format"]
        ),

        // MARK: - Shape-Primitive Integration

        .library(
            name: "Formatter Pair Primitives",
            targets: ["Formatter Pair Primitives"]
        ),

        // MARK: - Umbrella

        .library(
            name: "Formatter Primitives",
            targets: ["Formatter Primitives"]
        ),

        // MARK: - Test Support

        .library(
            name: "Formatter Primitives Test Support",
            targets: ["Formatter Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-either-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-pair-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Namespace

        .target(
            name: "Formatter Primitive",
            dependencies: []
        ),
        .target(
            name: "Formatter Protocol",
            dependencies: [
                "Formatter Primitive",
            ]
        ),
        .target(
            name: "Formattable",
            dependencies: [
                "Formatter Protocol",
            ]
        ),

        // MARK: - Witness

        .target(
            name: "Format",
            dependencies: [
                "Formatter Protocol",
            ]
        ),

        // MARK: - Shape-Primitive Integration

        .target(
            name: "Formatter Pair Primitives",
            dependencies: [
                "Formattable",
                "Formatter Protocol",
                .product(name: "Either Primitives", package: "swift-either-primitives"),
                .product(name: "Pair Primitives", package: "swift-pair-primitives"),
            ]
        ),

        // MARK: - Umbrella

        .target(
            name: "Formatter Primitives",
            dependencies: [
                "Format",
                "Formattable",
                "Formatter Pair Primitives",
                "Formatter Primitive",
                "Formatter Protocol",
            ]
        ),

        // MARK: - Test Support

        .target(
            name: "Formatter Primitives Test Support",
            dependencies: [
                "Formatter Primitives",
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests

        .testTarget(
            name: "Formatter Pair Primitives Tests",
            dependencies: [
                "Formatter Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
