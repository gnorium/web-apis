#if CLIENT
  import DOMBuilder
  import WebTypes

  extension DOM.Text {
    /// `CharacterData.length`: its text's length in UTF-16 code units.
    public var length: Int {
      Int(characterData_length(id))
    }

    /// `CharacterData.replaceData(offset, count, data)`: `count` UTF-16
    /// code units from `offset` replaced with `data`. A selection in the
    /// node keeps its place as the DOM moves it; nothing enters an
    /// editor's undo history.
    public func replaceData(_ offset: Int, _ count: Int, _ data: String) {
      let bytes = Array(data.utf8)
      bytes.withUnsafeBufferPointer { buffer in
        characterData_replaceData(id, Int32(offset), Int32(count), buffer.baseAddress, Int32(buffer.count))
      }
    }
  }

  extension DOM.Text {
    /// `CharacterData.substringData(offset, count)`: `count` UTF-16 code
    /// units of its text from `offset`—what was added to a text that grows
    /// read alone, never the whole again.
    public func substringData(_ offset: Int, _ count: Int) -> String {
      // UTF-8 spends at most three bytes on a UTF-16 unit.
      var capacity = count * 3
      while true {
        var buffer = [UInt8](repeating: 0, count: capacity + 1)
        let length = characterData_substringData(id, Int32(offset), Int32(count), &buffer, Int32(capacity + 1))
        if length >= 0 { return String(decoding: buffer[0..<Int(length)], as: UTF8.self) }
        // Too small: the bridge answers -(bytes + 1).
        let needed = Int(-length) - 1
        if needed <= capacity { return "" }
        capacity = needed
      }
    }
  }

  extension Document {
    /// `document.execCommand(command, false, value)`: an editing command on
    /// the focused editing host's selection, entered in its undo history as
    /// typing would be (`insertText` replaces the selection with `value`).
    /// Whether the browser ran it.
    @discardableResult
    public func execCommand(_ command: String, value: String = "") -> Bool {
      let commandBytes = Array(command.utf8)
      let valueBytes = Array(value.utf8)
      return commandBytes.withUnsafeBufferPointer { commandBuffer in
        valueBytes.withUnsafeBufferPointer { valueBuffer in
          document_execCommand(
            commandBuffer.baseAddress, Int32(commandBuffer.count), valueBuffer.baseAddress, Int32(valueBuffer.count))
            != 0
        }
      }
    }
  }

  @_extern(wasm, module: "env", name: "characterData_length")
  func characterData_length(_ nodeID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "characterData_replaceData")
  func characterData_replaceData(
    _ nodeID: Int32, _ offset: Int32, _ count: Int32, _ data: UnsafePointer<UInt8>?, _ length: Int32)

  @_extern(wasm, module: "env", name: "characterData_substringData")
  func characterData_substringData(
    _ nodeID: Int32, _ offset: Int32, _ count: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLength: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "document_execCommand")
  func document_execCommand(
    _ command: UnsafePointer<UInt8>?, _ commandLength: Int32, _ value: UnsafePointer<UInt8>?, _ valueLength: Int32
  ) -> Int32
#endif
