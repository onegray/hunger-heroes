//
//  TapeArchive.swift
//  HungerHeroes
//
//  Created by onegray on 24.08.22.
//

import Foundation

class TapeArchive {

    enum DecodingError: Error {
        case invalidLength(Int)
        case invalidFilename(chunkStart: Int)
    }

    func parseFiles(data: Data) throws -> [String : Data] {

        guard data.count % 512 == 0 else {
            throw DecodingError.invalidLength(data.count)
        }

        var files = [String : Data]()
        var chunkStart = 0

        while chunkStart < data.count {
            assert(chunkStart + 512 <= data.count, "Unexpected chunk length")

            let chunkType = data[chunkStart + 156]
            if chunkType == 0x30 {
                let nameData = data[chunkStart..<(chunkStart + 100)]
                let endIndex = nameData.firstIndex(of: 0) ?? nameData.endIndex
                let name = String(data: nameData.prefix(upTo: endIndex), encoding: .utf8)
                guard let name = name, !name.isEmpty else {
                    throw DecodingError.invalidFilename(chunkStart: chunkStart)
                }

                let sizeData = data[(chunkStart + 124)..<(chunkStart + 136)]
                let size = sizeData.withUnsafeBytes { ptr in
                    strtol(ptr.baseAddress!, nil, 8)
                }

                chunkStart += 512
                let fileData = data[chunkStart..<(chunkStart + size)]
                chunkStart += (size / 512) * 512
                files[name] = fileData
            }

            chunkStart += 512
        }
        return files
    }
}
