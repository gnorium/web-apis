#if CLIENT
  public struct Console: Sendable {
    public func log(_ message: LogMessage) {
      if let staticMsg = message.staticMessage {
        // Use StaticString - pointer is valid in static memory
        staticMsg.withUTF8Buffer { buffer in
          buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            console_log(pointer, Int32(buffer.count))
          }
        }
      } else if let runtimeMsg = message.runtimeMessage {
        // Copy runtime string to WASM memory
        let bytes: [UInt8] = Array(runtimeMsg.utf8)
        let len = Int32(bytes.count)

        // Write directly to WASM memory via JSContent
        bytes.withUnsafeBufferPointer { buffer in
          buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            console_log(pointer, len)
          }
        }
      }
    }

    public func error(_ message: LogMessage) {
      if let staticMsg = message.staticMessage {
        // Use StaticString - pointer is valid in static memory
        staticMsg.withUTF8Buffer { buffer in
          buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            console_error(pointer, Int32(buffer.count))
          }
        }
      } else if let runtimeMsg = message.runtimeMessage {
        // Copy runtime string to WASM memory
        let bytes: [UInt8] = Array(runtimeMsg.utf8)
        let len = Int32(bytes.count)

        // Write directly to WASM memory via JSContent
        bytes.withUnsafeBufferPointer { buffer in
          buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            console_error(pointer, len)
          }
        }
      }
    }
  }

  public let console = Console()

  @_extern(wasm, module: "env", name: "console_log")
  func console_log(_ messagePointer: UnsafePointer<CChar>, _ messageLen: Int32)

  @_extern(wasm, module: "env", name: "console_error")
  func console_error(_ messagePointer: UnsafePointer<CChar>, _ messageLen: Int32)
#endif
