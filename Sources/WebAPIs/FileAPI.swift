#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import HTMLBuilder
  import WebTypes

  /// The File API's `Blob`: raw data of a known size and media type, held by
  /// the page (a handle into the loader's element table).
  public class Blob: @unchecked Sendable {
    public let id: Int32

    public init(id: Int32) {
      self.id = id
    }

    /// Its size in bytes.
    public var size: Int {
      Int(blob_getSize(id))
    }

    /// Its media type ("image/png"), empty when unknown.
    public var type: String {
      blobString(id) { blob_getType($0, $1, $2) }
    }
  }

  /// The File API's `File`: a `Blob` with the name it had on the reader's
  /// device.
  public final class File: Blob {
    /// Its name, without a path.
    public var name: String {
      blobString(id) { file_getName($0, $1, $2) }
    }
  }

  /// The File API's `FileList`: the files a file input holds.
  public struct FileList: Sendable {
    let id: Int32

    /// How many files it holds.
    public var length: Int {
      Int(fileList_getLength(id))
    }

    /// The file at `index`, nil past the end.
    public func item(_ index: Int) -> File? {
      let fileID = fileList_item(id, Int32(index))
      return fileID < 0 ? nil : File(id: fileID)
    }
  }

  extension HTML.HTMLInputElement {
    /// The standard `files`: the files chosen in a file input, nil for any
    /// other type of input.
    public var files: FileList? {
      let listID = element_getFiles(id)
      return listID < 0 ? nil : FileList(id: listID)
    }
  }

  /// A string property of a blob, however long: the loader answers
  /// `-(bytes + 1)` when the buffer is too small.
  private func blobString(
    _ id: Int32, _ read: (Int32, UnsafeMutablePointer<UInt8>, Int32) -> Int32
  ) -> String {
    var capacity = 256
    while true {
      var buffer = [UInt8](repeating: 0, count: capacity)
      let length = read(id, &buffer, Int32(capacity))
      if length >= 0 { return String(decoding: buffer[0..<Int(length)], as: UTF8.self) }
      capacity = Int(-length) - 1 + 16
    }
  }

  @_extern(wasm, module: "env", name: "element_getFiles")
  func element_getFiles(_ elementID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "fileList_getLength")
  func fileList_getLength(_ listID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "fileList_item")
  func fileList_item(_ listID: Int32, _ index: Int32) -> Int32

  @_extern(wasm, module: "env", name: "blob_getSize")
  func blob_getSize(_ blobID: Int32) -> Double

  @_extern(wasm, module: "env", name: "blob_getType")
  func blob_getType(_ blobID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "file_getName")
  func file_getName(_ fileID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32) -> Int32
#endif
