import Testing
import CxxStdlib
@testable import WStringCompat

@Test func testEncodingDetection() async throws {
    // Verify that the encoding is one of the expected values
    let encoding = CWideChar.stringEncoding
    let validEncodings: [String.Encoding] = [
        .utf16LittleEndian,
        .utf16BigEndian,
        .utf32LittleEndian,
        .utf32BigEndian
    ]
    #expect(validEncodings.contains(encoding))
}

@Test func testEmptyStringConversion() async throws {
    // Test empty Swift String to wstring
    let emptyString = ""
    let wstring = std.wstring(emptyString)
    #expect(wstring != nil)
    #expect(wstring!.size() == 0)
    
    // Test empty wstring to Swift String
    let emptyWstring = std.wstring()
    let string = String(emptyWstring)
    #expect(string != nil)
    #expect(string! == "")
}

@Test func testASCIIStringConversion() async throws {
    // Test ASCII Swift String to wstring and back
    let original = "Hello, World!"
    let wstring = try #require(std.wstring(original))
    let converted = try #require(String(wstring))
    #expect(converted == original)
}

@Test func testUnicodeStringConversion() async throws {
    // Test Unicode Swift String to wstring and back
    let original = "Hello, 世界! 🌍"
    let wstring = try #require(std.wstring(original))
    let converted = try #require(String(wstring))
    #expect(converted == original)
}

@Test func testSpecialCharacters() async throws {
    // Test various special characters
    let original = "Ñoño — \"quotes\" & <symbols>"
    let wstring = try #require(std.wstring(original))
    let converted = try #require(String(wstring))
    #expect(converted == original)
}

@Test func testEmoji() async throws {
    // Test emoji characters
    let original = "🎉🎊🎁🎄🎅"
    let wstring = try #require(std.wstring(original))
    let converted = try #require(String(wstring))
    #expect(converted == original)
}

@Test func testMultilingualText() async throws {
    // Test text in multiple languages
    let original = "English 日本語 한국어 العربية עברית"
    let wstring = try #require(std.wstring(original))
    let converted = try #require(String(wstring))
    #expect(converted == original)
}