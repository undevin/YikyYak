//
//  YakController.swift
//  YikyYak
//
//  Created by Devin Flora on 2/4/21.
//

import CloudKit

class YakController {
    
    //MARK: - Properties
    static let shared = YakController()
    var yaks: [Yak] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD Methods
    func createYakWith(text: String, author: String, completion: @escaping (Result<String,YakError>) -> Void) {
        
        let newYak = Yak(text: text, author: author)
        let record = CKRecord(yak: newYak)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let savedYak = Yak(ckRecord: record) else {return completion(.failure(.couldNotUnwrap)) }
            
            self.yaks.append(savedYak)
            return completion(.success("Saved Yak to CloudKit"))
        }
    }
    
    func fetchAllYaks(completion: @escaping (Result<String,YakError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: YakStrings.referenceTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            let fetchedYaks = records.compactMap({ Yak(ckRecord: $0)})
            
            let sortedYaks = fetchedYaks.sorted(by: { $0.score > $1.score })
            self.yaks = sortedYaks
            return completion(.success("Successfully fetched all yaks!"))
        }
    }
    
    func updateYak(yak: Yak, completion: @escaping (Result<Yak,YakError>) -> Void) {
        
        let record = CKRecord(yak: yak)
        let opertaion = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        opertaion.savePolicy = .changedKeys
        opertaion.qualityOfService = .userInteractive
        opertaion.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.ckError(error)))
            }
            guard let record = records?.first,
                  let updatedYak = Yak(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            return completion(.success(updatedYak))
        }
        publicDB.add(opertaion)
    }
    
    func deleteYak(yak: Yak, completion: @escaping (Result<String,YakError>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [yak.recordID])
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print(error)
                return completion(.failure(.ckError(error)))
            }
            guard let recordID = recordIDs else {return completion(.failure(.couldNotUnwrap))}
            return completion(.success("Successfully deleted Yak with recordID;: \(recordID)"))
        }
        publicDB.add(operation)
    }
}//End of Class
