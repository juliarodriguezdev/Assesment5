//
//  CloudKitController.swift
//  ContactsApp
//
//  Created by Julia Rodriguez on 7/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    static let shared = CloudKitController()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func update(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        
        // Declare our operation
        let operation = CKModifyRecordsOperation()
        
        // override operation attributes
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
        }
        
        // edit, execute operation
        database.add(operation)
    }
    
}
