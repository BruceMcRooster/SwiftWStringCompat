// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WStringCompat",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WStringCompat",
            targets: ["WStringCompat"]
        ),
    ],
    targets: [
        // C++ utility target for wchar_t endianness detection
        .target(
            name: "WCharUtils",
            path: "Sources/WCharUtils",
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("include")
            ]
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WStringCompat",
            dependencies: ["WCharUtils"],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .testTarget(
            name: "WStringCompatTests",
            dependencies: ["WStringCompat"],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
    ]
)