// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartlookSegmentPlugin",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmartlookSegmentPlugin",
            targets: ["SmartlookSegmentPlugin"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "Segment",
            url: "https://github.com/segmentio/analytics-swift.git",
            from: "1.1.2"
        ),
        .package(
            name: "SmartlookAnalytics",
            url: "https://github.com/smartlook/analytics-swift-package",
            from: "2.1.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmartlookSegmentPlugin",
            dependencies: [
                "Segment",
                "SmartlookAnalytics"
            ])
    ]
)
