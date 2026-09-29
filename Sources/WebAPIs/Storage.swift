#if CLIENT
  import EmbeddedSwiftUtilities

  /// The Web Storage API: `localStorage` (kept across sessions) and
  /// `sessionStorage` (kept for the browser session, per tab). Where the
  /// browser refuses storage (a private window, blocked site data), a read
  /// finds nothing and a write does nothing.
  public struct Storage: Sendable {
    /// Whether this is `sessionStorage` rather than `localStorage`.
    let session: Bool

    init(session: Bool) {
      self.session = session
    }

    private func get(_ key: UnsafePointer<CChar>, _ keyLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32)
      -> Int32
    {
      session
        ? sessionStorage_getItem(key, keyLen, buffer, bufferLen) : localStorage_getItem(key, keyLen, buffer, bufferLen)
    }

    private func set(_ key: UnsafePointer<CChar>, _ keyLen: Int32, _ value: UnsafePointer<CChar>, _ valueLen: Int32) {
      if session {
        sessionStorage_setItem(key, keyLen, value, valueLen)
      } else {
        localStorage_setItem(key, keyLen, value, valueLen)
      }
    }

    private func remove(_ key: UnsafePointer<CChar>, _ keyLen: Int32) {
      if session {
        sessionStorage_removeItem(key, keyLen)
      } else {
        localStorage_removeItem(key, keyLen)
      }
    }

    public func getItem(_ key: String) -> String? {
      var buffer = [UInt8](repeating: 0, count: 1024)
      var keyBuffer = Array(key.utf8)
      keyBuffer.append(0)
      return keyBuffer.withUnsafeBufferPointer { keyPtr in
        keyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) {
          keyPointer in
          let len = get(keyPointer, Int32(keyBuffer.count - 1), &buffer, 1024)
          return len >= 0 ? String(decoding: buffer[0..<Int(len)], as: UTF8.self) : nil
        }
      }
    }

    public func getItem(_ key: StaticString) -> String? {
      var buffer = [UInt8](repeating: 0, count: 1024)
      return key.withUTF8Buffer { keyBuffer in
        keyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) {
          keyPointer in
          let len = get(keyPointer, Int32(keyBuffer.count), &buffer, 1024)
          return len >= 0 ? String(decoding: buffer[0..<Int(len)], as: UTF8.self) : nil
        }
      }
    }

    public func setItem(_ key: String, _ value: String) {
      var keyBuffer = Array(key.utf8)
      keyBuffer.append(0)
      var valueBuffer = Array(value.utf8)
      valueBuffer.append(0)

      keyBuffer.withUnsafeBufferPointer { keyPtr in
        keyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) {
          keyPointer in
          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePointer in
              set(
                keyPointer, Int32(keyBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
            }
          }
        }
      }
    }

    public func setItem(_ key: StaticString, _ value: String) {
      var valueBuffer = Array(value.utf8)
      valueBuffer.append(0)

      key.withUTF8Buffer { keyBuf in
        keyBuf.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuf.count) {
          keyPointer in
          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePointer in
              set(
                keyPointer, Int32(keyBuf.count), valuePointer, Int32(valueBuffer.count - 1))
            }
          }
        }
      }
    }

    public func setItem(_ key: StaticString, _ value: StaticString) {
      key.withUTF8Buffer { keyBuffer in
        value.withUTF8Buffer { valueBuffer in
          keyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) {
            keyPointer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePointer in
              set(
                keyPointer, Int32(keyBuffer.count), valuePointer, Int32(valueBuffer.count))
            }
          }
        }
      }
    }

    public func removeItem(_ key: String) {
      var keyBuffer = Array(key.utf8)
      keyBuffer.append(0)

      keyBuffer.withUnsafeBufferPointer { keyPtr in
        keyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) {
          keyPointer in
          remove(keyPointer, Int32(keyBuffer.count - 1))
        }
      }
    }

    public func removeItem(_ key: StaticString) {
      key.withUTF8Buffer { keyBuffer in
        keyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) {
          keyPointer in
          remove(keyPointer, Int32(keyBuffer.count))
        }
      }
    }
  }

  public let localStorage = Storage(session: false)
  public let sessionStorage = Storage(session: true)

  @_extern(wasm, module: "env", name: "localStorage_getItem")
  func localStorage_getItem(
    _ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "localStorage_setItem")
  func localStorage_setItem(
    _ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32, _ valuePointer: UnsafePointer<CChar>,
    _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "localStorage_removeItem")
  func localStorage_removeItem(_ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32)

  @_extern(wasm, module: "env", name: "sessionStorage_getItem")
  func sessionStorage_getItem(
    _ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "sessionStorage_setItem")
  func sessionStorage_setItem(
    _ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32, _ valuePointer: UnsafePointer<CChar>,
    _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "sessionStorage_removeItem")
  func sessionStorage_removeItem(_ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32)
#endif
