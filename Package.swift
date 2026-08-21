// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-formatter-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

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

        .library(
            name: "Format",
            targets: ["Format"]
        ),

        .library(
            name: "Formatter Pair Primitives",
            targets: ["Formatter Pair Primitives"]
        ),

        .library(
            name: "Formatter Primitives",
            targets: ["Formatter Primitives"]
        ),

        .library(
            name: "Formatter Primitives Test Support",
            targets: ["Formatter Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-either-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-pair-primitives.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Formatter Primitive",
            dependencies: []
        ),
        .target(
            name: "Formatter Protocol",
            dependencies: [
                "Formatter Primitive"
            ]
        ),
        .target(
            name: "Formattable",
            dependencies: [
                "Formatter Protocol"
            ]
        ),

        .target(
            name: "Format",
            dependencies: [
                "Formatter Protocol"
            ]
        ),

        .target(
            name: "Formatter Pair Primitives",
            dependencies: [
                "Formattable",
                "Formatter Protocol",
                .product(name: "Either Primitives", package: "swift-either-primitives"),
                .product(name: "Pair Primitives", package: "swift-pair-primitives"),
            ]
        ),

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

        .target(
            name: "Formatter Primitives Test Support",
            dependencies: [
                "Formatter Primitives"
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Formatter Pair Primitives Tests",
            dependencies: [
                "Formatter Primitives Test Support"
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
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
