//
//  Notes.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 04/10/23.
//

import Foundation
import CloudKit

struct Notes{
    var text: String
    var title: String
    
    public func saveNewNote() async throws {
        //1. Get the container
        let container = CloudKitConfiguration.shared.container
        
        // 2. Choose the database
        let database = container.privateCloudDatabase
        
        let record = CKRecord(recordType: "Notes")
        record.setValuesForKeys([
            "text": text,
            "title": title
        ])
        
        
        
        
        
    }
}
