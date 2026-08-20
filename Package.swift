// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "URKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "URKit",
            targets: ["URKit"]),
    ],
    dependencies: [
        // 2.0.0 is the first release where DCBOR declares the `SortedCollections` it imports
        // in Sources/DCBOR/Map.swift (upstream moved it into its own SwiftSortedCollections
        // package). Below that, DCBOR only links when it is statically absorbed into a final
        // binary — building it as a framework fails on SortedDictionary symbols.
        .package(url: "https://github.com/BlockchainCommons/BCSwiftDCBOR", from: "2.0.0"),
        // `Tag` is used by Registry/CryptoKeyPath.swift and Registry/TonSignRequest.swift.
        // It reaches them through DCBOR's `@_exported import BCTags`, which is enough to
        // compile but not to link: when URKit is built as a dynamic framework rather than
        // statically absorbed into the final binary, it has to link BCTags itself.
        .package(url: "https://github.com/BlockchainCommons/BCSwiftTags", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "URKit",
            dependencies: [
                .product(name: "DCBOR", package: "BCSwiftDCBOR"),
                .product(name: "BCTags", package: "BCSwiftTags"),
            ]
        ),
        .testTarget(
            name: "URKitTests",
            dependencies: [
                "URKit",
            ]
        ),
    ]
)
