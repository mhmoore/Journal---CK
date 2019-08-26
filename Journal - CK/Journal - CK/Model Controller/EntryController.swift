//
//  EntryController.swift
//  Journal - CK
//
//  Created by Michael Moore on 8/26/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    var entries: [Entry] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase

    func save(entry: Entry, completion: @escaping (Bool) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        
        privateDB.save(entryRecord) { (_, error) in
            if let error = error {
                print("There was an error saving. \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        entries.append(entry)
        completion(true)
    }
    
    // Create
    func addEntryWith(title: String, text: String, completion: @escaping (Bool) -> Void) {
        let newEntry = Entry(title: title, text: text)
        save(entry: newEntry) { (success) in
            if !success {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Read
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching. \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let entries = records.compactMap( {Entry(ckRecord: $0)} )
            self.entries = entries
            completion(true)
        }
    }
    
    
}
