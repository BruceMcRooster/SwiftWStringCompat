#ifndef WCHAR_UTILS_HPP
#define WCHAR_UTILS_HPP

#include <cstdint>

/// Determines if the system uses little-endian byte order for wchar_t
/// by examining the byte representation of a known wchar_t literal.
inline bool isWCharLittleEndian() {
    // Use a wchar_t value where we can distinguish endianness
    // 0x0041 is 'A' in Unicode - the bytes will be ordered differently
    // based on endianness
    const wchar_t testChar = L'A'; // Unicode code point 0x0041
    const uint8_t* bytes = reinterpret_cast<const uint8_t*>(&testChar);
    
    // In little-endian, the least significant byte comes first
    // 'A' (0x0041) would be stored as: 0x41, 0x00, ... (little-endian)
    // or: 0x00, ..., 0x41 (big-endian)
    return bytes[0] == 0x41;
}

#endif // WCHAR_UTILS_HPP