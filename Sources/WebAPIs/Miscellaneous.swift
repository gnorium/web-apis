#if CLIENT
  @discardableResult
  public func setTimeout(_ ms: Int, _ callback: @escaping @Sendable () -> Void) -> Int32 {
    window.setTimeout(Double(ms), callback)
  }

  public func clearTimeout(_ timerID: Int32) {
    window.clearTimeout(timerID)
  }

  /// `encodeURIComponent`: every byte of the UTF-8 escaped as `%XX` except
  /// the characters the standard leaves alone — letters, digits and
  /// `- _ . ! ~ * ' ( )`. Pure Swift: the answer is fixed by the standard, so
  /// there is nothing to ask the browser.
  public func encodeURIComponent(_ string: String) -> String {
    var bytes: [UInt8] = []
    for byte in Array(string.utf8) {
      let unreserved =
        (byte >= 65 && byte <= 90) || (byte >= 97 && byte <= 122) || (byte >= 48 && byte <= 57)
        || byte == 45 || byte == 95 || byte == 46 || byte == 33 || byte == 126 || byte == 42
        || byte == 39 || byte == 40 || byte == 41
      if unreserved {
        bytes.append(byte)
      } else {
        let hex: [UInt8] = Array("0123456789ABCDEF".utf8)
        bytes.append(37)
        bytes.append(hex[Int(byte >> 4)])
        bytes.append(hex[Int(byte & 0xF)])
      }
    }
    return String(decoding: bytes, as: UTF8.self)
  }
  /// Format an ISO 8601 date string to the user's local timezone and locale.
  /// Uses the browser's `Intl.DateTimeFormat` via JSContent bridge.
  /// Returns nil if the ISO string is invalid.
  public func formatLocalDate(_ isoString: String) -> String? {
    var isoBuffer = Array(isoString.utf8)
    isoBuffer.append(0)

    var resultBuffer = [UInt8](repeating: 0, count: 256)
    let resultLen = isoBuffer.withUnsafeBufferPointer { isoPtr in
      resultBuffer.withUnsafeMutableBufferPointer { resultPtr in
        isoPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: isoBuffer.count) {
          cCharPtr in
          date_formatLocal(
            cCharPtr, Int32(isoBuffer.count - 1),
            resultPtr.baseAddress!, Int32(resultPtr.count)
          )
        }
      }
    }

    guard resultLen > 0 else { return nil }
    return String(decoding: resultBuffer[0..<Int(resultLen)], as: UTF8.self)
  }

  @_extern(wasm, module: "env", name: "timing_setTimeout")
  private func timing_setTimeout(_ ms: Int32, _ callbackID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "timing_clearTimeout")
  private func timing_clearTimeout(_ timerID: Int32)

  @_extern(wasm, module: "env", name: "date_formatLocal")
  private func date_formatLocal(
    _ isoPointer: UnsafePointer<CChar>, _ isoLen: Int32,
    _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32
#endif
