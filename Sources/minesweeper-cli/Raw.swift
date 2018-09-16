// via https://stackoverflow.com/questions/49748507/listening-to-stdin-in-swift
import Foundation

func initStruct<S>() -> S {
    let structPointer = UnsafeMutablePointer<S>.allocate(capacity: 1)
    let structMemory = structPointer.pointee
    structPointer.deallocate()
    return structMemory
}

func enableRawMode(fileHandle: FileHandle) -> termios {
    var raw: termios = initStruct()
    tcgetattr(fileHandle.fileDescriptor, &raw)

    let original = raw

    raw.c_lflag &= ~(UInt(ECHO | ICANON))
    tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &raw)

    return original
}

func restoreRawMode(fileHandle: FileHandle, originalTerm: termios) {
    var term = originalTerm
    tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &term)
}
