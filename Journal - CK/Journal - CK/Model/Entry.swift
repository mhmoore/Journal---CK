//
//  Entry.swift
//  Journal - CK
//
//  Created by Michael Moore on 8/26/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    
    static let recordTypeKey = "Entry"
    static let recordTitleKey = "Title"
    static let recordTextKey = "Text"
    static let recordTimestampKey = "Timestamp"
}

class Entry {
    
    let title: String
    let text: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, text: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.text = text
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[Constants.recordTitleKey] as? String,
            let text = ckRecord[Constants.recordTextKey] as? String,
            let timestamp = ckRecord[Constants.recordTimestampKey] as? Date else { return nil }
        
        self.init(title: title, text: text, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    
    convenience init(entry: Entry) {
        self.init(recordType: Constants.recordTypeKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: Constants.recordTitleKey)
        self.setValue(entry.text, forKey: Constants.recordTextKey)
        self.setValue(entry.timestamp, forKey: Constants.recordTimestampKey)
    }
}
