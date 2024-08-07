--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module provides various hashing algorithms for use within Hammerspoon.
--
-- The currently supported hash types can be viewed by examining the [hs.hash.types](#types) constant.
--
-- In keeping with common hash library conventions to simplify the future addition of additional hash types, hash calculations in this module are handled in a three step manner, which is reflected in the constructor and methods defined for this module:
--
--  * First, the hash context is initialized. For this module, this occurs when you create a new hash object with [hs.hash.new(name, [secret])](#new).
--  * Second, data is "input" or appended to the hash with the [hs.hash:append(data)](#append) method. This may be invoked one or more times for the hash object before finalizing it, and order *is* important: `hashObject:append(data1):append(data2)` is different than `hashObject:append(data2):append(data1)`.
--  * Finally, you finalize or finish the hash with [hs.hash:finish()](#finish), which generates the final hash value. You can then retrieve the hash value with [hs.hash:value()](#value).
--
-- Most of the time, we only want to generate a hash value for a single data object; for this reason, meta-methods for this module allow you to use the following shortcut when computing a hash value:
--
--  * `hs.hash.<name>(data)` will return the hexadecimal version of the hash for the hash type `<name>` where `<name>` is one of the entries in [hs.hash.types](#types). This is syntacticly identical to `hs.hash.new(<name>):append(data):finish():value()`.
--  * `hs.hash.b<name>(data)` will return the binary version of the hash for the hash type '<name>'. This is syntacticly identical to `hs.hash.new(<name>):append(data):finish():value(true)`.
--  * In both cases above, if the hash name begins with `hmac`, the arguments should be `(secret, data)`, but otherwise act as described above. If additional shared key hash algorithms are added, this will be adjusted to continue to allow the shortcuts for the most common usage patterns.
--
-- The SHA3 code is based on code from the https://github.com/rhash/RHash project.
-- https://github.com/krzyzanowskim/CryptoSwift may also prove useful for future additions.
---@class hs.hash
local M = {}
hs.hash = M

-- Adds the provided data to the input of the hash function currently in progress for the hashObject.
--
-- Parameters:
--  * `data` - a string containing the data to add to the hash functions input.
--
-- Returns:
--  * the hash object, or if the hash has already been calculated (finished), nil and an error string
function M:append(data, ...) end

-- Adds the contents of the file at the specified path to the input of the hash function currently in progress for the hashObject.
--
-- Parameters:
--  * `path` - a string containing the path of the file to add to the hash functions input.
--
-- Returns:
--  * the hash object
function M:appendFile(path, ...) end

-- Calculates a binary MD5 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the binary hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("MD5"):append(data):finish():value(true)`
function M.bMD5(data, ...) end

-- Calculates a binary SHA1 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the binary hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("SHA1"):append(data):finish():value(true)`
function M.bSHA1(data, ...) end

-- Calculates a binary SHA256 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the binary hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("SHA256"):append(data):finish():value(true)`
function M.bSHA256(data, ...) end

-- Calculates a binary SHA512 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the binary hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("SHA512"):append(data):finish():value(true)`
function M.bSHA512(data, ...) end

-- Converts a string containing a binary hash value to its equivalent hexadecimal digits.
--
-- Parameters:
--  * input - a string containing the binary hash value you wish to convert into its equivalent hexadecimal digits.
--
-- Returns:
--  * a string containing the equivalent hash as a string of hexadecimal digits
--
-- Notes:
--  * this is a convenience function for use when you already have a binary hash value that you wish to convert to its hexadecimal equivalent -- the value is not actually validated as the actual hash value for anything specific.
---@return string
function M.convertBinaryHashToHex(input, ...) end

-- Converts a string containing a hash value as a string of hexadecimal digits into its binary equivalent.
--
-- Parameters:
--  * input - a string containing the hash value you wish to convert into its binary equivalent. The string must be a sequence of hexadecimal digits with an even number of characters.
--
-- Returns:
--  * a string containing the equivalent binary hash
--
-- Notes:
--  * this is a convenience function for use when you already have a hash value that you wish to convert to its binary equivalent. Beyond checking that the input string contains only hexadecimal digits and is an even length, the value is not actually validated as the actual hash value for anything specific.
---@return string
function M.convertHexHashToBinary(input, ...) end

-- Finalizes the hash and computes the resulting value.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the hash object
--
-- Notes:
--  * a hash that has been finished can no longer have data appended to it.
function M:finish() end

-- Calculates the specified hash value for the file at the given path.
--
-- Parameters:
--  * `hash`   - the name of the type of hash to calculate. This must be one of the string values found in the [hs.hash.types](#types) constant.
--  * `secret` - an optional string specifying the shared secret to prepare the hmac hash function with. For all other hash types this field is ignored. Leaving this parameter off when specifying an hmac hash function is equivalent to specifying an empty secret or a secret composed solely of null values.
--  * `path`   - the path to the file to calculate the hash value for.
--
-- Returns:
--  * a string containing the hexadecimal version of the calculated hash for the specified file.
--
-- Notes:
--  * this is a convenience function that performs the equivalent of `hs.new.hash(hash, [secret]):appendFile(path):finish():value()`.
---@return string
function M.forFile(hash, secret, path, ...) end

-- Calculates an HMAC using a key and an MD5 hash
--
-- Parameters:
--  * key - A string containing a secret key to use
--  * data - A string containing the data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("hmacMD5", key):append(data):finish():value()`
---@return string
function M.hmacMD5(key, data, ...) end

-- Calculates an HMAC using a key and a SHA1 hash
--
-- Parameters:
--  * key - A string containing a secret key to use
--  * data - A string containing the data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("hmacSHA1", key):append(data):finish():value()`
---@return string
function M.hmacSHA1(key, data, ...) end

-- Calculates an HMAC using a key and a SHA256 hash
--
-- Parameters:
--  * key - A string containing a secret key to use
--  * data - A string containing the data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("hmacSHA256", key):append(data):finish():value()`
---@return string
function M.hmacSHA256(key, data, ...) end

-- Calculates an HMAC using a key and a SHA512 hash
--
-- Parameters:
--  * key - A string containing a secret key to use
--  * data - A string containing the data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("hmacSHA512", key):append(data):finish():value()`
---@return string
function M.hmacSHA512(key, data, ...) end

-- Calculates an MD5 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data, encoded as hexadecimal
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("MD5"):append(data):finish():value()`
---@return string
function M.MD5(data, ...) end

-- Creates a new context for the specified hash function.
--
-- Parameters:
--  * `hash`    - a string specifying the name of the hash function to use. This must be one of the string values found in the [hs.hash.types](#types) constant.
--  * `secret`  - an optional string specifying the shared secret to prepare the hmac hash function with. For all other hash types this field is ignored. Leaving this parameter off when specifying an hmac hash function is equivalent to specifying an empty secret or a secret composed solely of null values.
--
-- Returns:
--  * the new hash object
function M.new(hash, secret, ...) end

-- Calculates an SHA1 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data, encoded as hexadecimal
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("SHA1"):append(data):finish():value()`
---@return string
function M.SHA1(data, ...) end

-- Calculates an SHA256 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data, encoded as hexadecimal
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("SHA256"):append(data):finish():value()`
---@return string
function M.SHA256(data, ...) end

-- Calculates an SHA512 hash
--
-- Parameters:
--  * data - A string containing some data to hash
--
-- Returns:
--  * A string containing the hash of the supplied data, encoded as hexadecimal
--
-- Notes:
--  * this function is provided for backwards compatibility with a previous version of this module and is functionally equivalent to: `hs.hash.new("SHA512"):append(data):finish():value()`
---@return string
function M.SHA512(data, ...) end

-- Returns the name of the hash type the object refers to
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string containing the hash type name.
---@return string
function M:type() end

-- A tale containing the names of the hashing algorithms supported by this module.
--
-- Notes:
--  At present, this module supports the following hash functions:
--  * `CRC32`      - Technically a checksum, not a hash, but often used for similar purposes, like verifying file integrity. Produces a 32bit value.
--  * `MD5`        - A message digest algorithm producing a 128bit hash value. MD5 is no longer consider secure for cryptographic purposes, but is still widely used to verify file integrity and other non cryptographic uses.
--  * `SHA1`       - A message digest algorithm producing a 160bit hash value. SHA-1 is no longer consider secure for cryptographic purposes, but is still widely used to verify file integrity and other non cryptographic uses.
--  * `SHA256`     - A cryptographic hash function that produces a 256bit hash value. While there has been some research into attack vectors on the SHA-2 family of algorithms, this is still considered sufficiently secure for many cryptographic purposes and for data validation and verification.
--  * `SHA512`     - A cryptographic hash function that produces a 512bit hash value. While there has been some research into attack vectors on the SHA-2 family of algorithms, this is still considered sufficiently secure for many cryptographic purposes and for data validation and verification.
--  * `hmacMD5`    - Combines the MD5 hash algorithm with a hash-based message authentication code, or pre-shared secret.
--  * `hmacSHA1`   - Combines the SHA1 hash algorithm with a hash-based message authentication code, or pre-shared secret.
--  * `hmacSHA256` - Combines the SHA-2 256bit hash algorithm with a hash-based message authentication code, or pre-shared secret.
--  * `hmacSHA512` - Combines the SHA-2 512bit hash algorithm with a hash-based message authentication code, or pre-shared secret.
--  * `SHA3_224`   - A SHA3 based cryptographic hash function that produces a 224bit hash value. The SHA3 family of algorithms use a different process than that which is used in the MD5, SHA1 and SHA2 families of algorithms and is considered the most cryptographically secure at present, though at the cost of additional computational complexity.
--  * `SHA3_256`   - A SHA3 based cryptographic hash function that produces a 256bit hash value. The SHA3 family of algorithms use a different process than that which is used in the MD5, SHA1 and SHA2 families of algorithms and is considered the most cryptographically secure at present, though at the cost of additional computational complexity.
--  * `SHA3_384`   - A SHA3 based cryptographic hash function that produces a 384bit hash value. The SHA3 family of algorithms use a different process than that which is used in the MD5, SHA1 and SHA2 families of algorithms and is considered the most cryptographically secure at present, though at the cost of additional computational complexity.
--  * `SHA3_512`   - A SHA3 based cryptographic hash function that produces a 512bit hash value. The SHA3 family of algorithms use a different process than that which is used in the MD5, SHA1 and SHA2 families of algorithms and is considered the most cryptographically secure at present, though at the cost of additional computational complexity.
M.types = nil

-- Returns the value of a completed hash, or nil if it is still in progress.
--
-- Parameters:
--  * `binary` - an optional boolean, default false, specifying whether or not the value should be provided as raw binary bytes (true) or as a string of hexadecimal numbers (false).
--
-- Returns:
--  * a string containing the hash value or nil if the hash has not been finished.
function M:value(binary, ...) end

