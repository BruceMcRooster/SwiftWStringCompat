// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import WCharUtils
import CxxStdlib

// MARK: - wchar_t Encoding Detection

extension CWideChar {
    /// Returns the appropriate String.Encoding for wchar_t based on its size and endianness.
    /// - Returns: One of `.utf16LittleEndian`, `.utf16BigEndian`, `.utf32LittleEndian`, or `.utf32BigEndian`
    public static var stringEncoding: String.Encoding {
        let isLittleEndian = isWCharLittleEndian()
        let size = MemoryLayout<CWideChar>.size
        
        switch size {
        case 2:
            return isLittleEndian ? .utf16LittleEndian : .utf16BigEndian
        case 4:
            return isLittleEndian ? .utf32LittleEndian : .utf32BigEndian
        default:
            preconditionFailure("Unsupported wchar_t size: \(size). Only 2-byte and 4-byte wchar_t are supported.")
        }
    }
}

// MARK: - String Extension for wstring Conversion

extension String {
    /// Creates a Swift String from a C++ std::wstring.
    /// - Parameter wstring: The C++ wstring to convert from.
    /// - Returns: A Swift String, or nil if conversion fails.
    public init?(_ wstring: std.wstring) {
        let length = wstring.size()
        
        if length == 0 {
            self = ""
            return
        }
        
        // Calculate the byte size of the wstring data
        let byteCount = length * MemoryLayout<CWideChar>.size
        
        // Copy the wstring data into a Data buffer
        var data = Data(count: byteCount)
        data.withUnsafeMutableBytes { buffer in
            let destPtr = buffer.baseAddress!.assumingMemoryBound(to: CWideChar.self)
            for i in 0..<length {
                destPtr[i] = wstring[i]
            }
        }
        
        // Convert using the appropriate encoding
        guard let result = String(data: data, encoding: CWideChar.stringEncoding) else {
            return nil
        }
        self = result
    }
}

// MARK: - std::wstring Extension for String Conversion

extension std.wstring {
    /// Creates a C++ std::wstring from a Swift String.
    /// - Parameter string: The Swift String to convert from.
    /// - Returns: A C++ wstring, or nil if conversion fails.
    public init?(_ string: String) {
        self.init()
        
        guard !string.isEmpty else {
            return
        }
        
        // Convert the Swift String to Data using the appropriate encoding
        guard let data = string.data(using: CWideChar.stringEncoding) else {
            return nil
        }
        
        // Calculate the number of wchar_t elements
        let wcharCount = data.count / MemoryLayout<CWideChar>.size
        
        // Initialize the wstring from the data buffer
        data.withUnsafeBytes { buffer in
            let wcharPtr = buffer.baseAddress!.assumingMemoryBound(to: CWideChar.self)
            for i in 0..<wcharCount {
                self.push_back(wcharPtr[i])
            }
        }
    }
}