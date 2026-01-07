# SwiftWStringCompat

A Swift library providing seamless conversion between Swift `String` and C++ `std::wstring`, with automatic handling of platform-dependent `wchar_t` size and endianness.

## Overview

Converting between Swift strings and C++ wide strings is tricky because `wchar_t` has platform-dependent characteristics:
- **Size**: 2 bytes on Windows, 4 bytes on Unix-like systems (macOS, Linux)
- **Encoding**: UTF-16 on Windows, UTF-32 on Unix-like systems
- **Endianness**: Varies by platform architecture

SwiftWStringCompat handles all of this automatically by detecting the platform's `wchar_t` configuration at runtime and using the appropriate encoding for conversions.

## Requirements

- Swift 5.9+ (when C++ interoperability was introduced)
- C++ interoperability enabled

> **Note**: Running the test suite seems to require Swift 6.0+ due to some limitations in how Swift's test discovery interacts with C++ interoperability. The library itself builds and works correctly on Swift 5.9+.

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/BruceMcRooster/SwiftWStringCompat.git", from: "1.0.0")
]
```

Then add `WStringCompat` as a dependency to your target and enable C++ interoperability:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        ...
        .product(name: "WStringCompat", package: "SwiftWStringCompat")
    ],
    swiftSettings: [
        .interoperabilityMode(.Cxx)
    ]
)
```

## Usage

### Converting from `std::wstring` to Swift `String`

```swift
import WStringCompat
import CxxStdlib

let wstring: std.wstring = ... // from C++ code
if let swiftString = String(wstring) {
    print(swiftString)
}
```

### Converting from Swift `String` to `std::wstring`

```swift
import WStringCompat
import CxxStdlib

let swiftString = "Hello, 世界! 🌍"
if let wstring = std.wstring(swiftString) {
    // Pass wstring to C++ code
}
```

### Checking the Platform Encoding

```swift
import WStringCompat

let encoding = CWideChar.stringEncoding
// Returns one of:
// - .utf16LittleEndian
// - .utf16BigEndian
// - .utf32LittleEndian
// - .utf32BigEndian
```

`String.data(using: encoding)` will get you raw bytes that are equivalent to an array of `wchar_t` values, based on the platform's `wchar_t` type.

## How It Works

1. **Endianness Detection**: A C++ utility function examines the byte representation of a known `wchar_t` literal to determine if the platform uses little-endian or big-endian byte order.

2. **Size Detection**: Swift's `MemoryLayout<CWideChar>.size` determines whether `wchar_t` is 2 bytes (UTF-16) or 4 bytes (UTF-32).

3. **Encoding Selection**: Based on size and endianness, the library selects the appropriate `String.Encoding` for conversion.

4. **Data Conversion**: String data is converted through a `Data` buffer using the detected encoding.

## License

MIT License

Copyright (c) 2026 Evan Foster

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
