//
//  Yak.swift
//  YikyYak
//
//  Created by Devin Flora on 2/4/21.
//

import CloudKit

struct YakStrings {
    static let referenceTypeKey = "Yak"
    fileprivate static let textKey = "text"
    fileprivate static let authorKey = "author"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let scoreKey = "score"
}//End of Struct

class Yak {
    let text: String
    let author: String
    let timestamp: Date
    var score: Int
    var recordID: CKRecord.ID
    
    init(text: String, author: String, timestamp: Date = Date(), score: Int = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.score = score
        self.recordID = recordID
    }
}//End of Class

//MARK: - Extensions
extension CKRecord {
    //making a CKRecord and passing in a YAK
    convenience init(yak: Yak) {
        self.init(recordType: YakStrings.referenceTypeKey, recordID: yak.recordID)
        self.setValuesForKeys([
            YakStrings.textKey : yak.text,
            YakStrings.authorKey : yak.author,
            YakStrings.timestampKey : yak.timestamp,
            YakStrings.scoreKey : yak.score
        ])
    }
}//End of Extension

extension Yak {
    convenience init?(ckRecord: CKRecord) {
        guard let text = ckRecord[YakStrings.textKey] as? String,
              let author = ckRecord[YakStrings.authorKey] as? String,
              let timestamp = ckRecord[YakStrings.timestampKey] as? Date,
              let score = ckRecord[YakStrings.scoreKey] as? Int else {return nil}
        self.init(text: text, author: author, timestamp: timestamp, score: score, recordID: ckRecord.recordID)
    }
}//End of Extension

extension Yak: Equatable {
    static func == (lhs: Yak, rhs: Yak) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//End of Extension
