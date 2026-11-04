#if CLIENT
  /// The Web Crypto API's `crypto` global, the part the client uses.
  public struct Crypto: Sendable {
    public init() {}

    /// `crypto.randomUUID()`: a version 4 UUID, 36 characters in lowercase
    /// hexadecimal with hyphens, from a cryptographically secure random
    /// source.
    public func randomUUID() -> String {
      var buffer = [UInt8](repeating: 0, count: 37)
      let length = crypto_randomUUID(&buffer, Int32(buffer.count))
      guard length > 0 else { return "" }
      return String(decoding: buffer[0..<Int(length)], as: UTF8.self)
    }
  }

  /// The global `crypto`.
  public let crypto = Crypto()

  @_extern(wasm, module: "env", name: "crypto_randomUUID")
  func crypto_randomUUID(_ buffer: UnsafeMutablePointer<UInt8>, _ capacity: Int32) -> Int32
#endif
