//
//  Community.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 19/09/23.
//

import Foundation
import CloudKit

enum AppError: Error{
    case cloudKitError(String)
}

struct Community: Identifiable{
    var id = UUID()
    var name: String
    var image: URL?
    
    //CloudKit Properties
    var record: CKRecord?
    var share: CKShare?
    
    
    static func getAllMyCommunity() async -> [Community]{
        let database = CloudKitConfiguration.shared.container.privateCloudDatabase
        let query = CKQuery(recordType: "community", predicate: NSPredicate(value: true))
        
        do{
            let records = try await database.records(matching: query,inZoneWith: CloudKitConfiguration.shared.recordZone.zoneID)
            
            let communities = try records.map { result in
                let record =  result
                var community = Community(name: record["name"] as! String)
                community.record = record
                
                return community
            }
            return communities
        }catch let error{
            return []
        }
    }
    
    static func getAllShareCommunity() async -> [Community]{
        let database = CloudKitConfiguration.shared.container.sharedCloudDatabase
        let query = CKQuery(recordType: "community", predicate: NSPredicate(value: true))
        do{
            let records = try await database.records(matching: query,inZoneWith: CloudKitConfiguration.shared.recordZone.zoneID)
            let communities = try records.map { result in
                
                var community = Community(name: result["name"] as! String)
                community.record = result
                
                return community
            }
            return communities
        }catch let error{
            return []
        }
    }
    
    mutating public func saveToCloudKit() async throws -> Community{
        let database = CloudKitConfiguration.shared.container.privateCloudDatabase
        
        let communityRecord = CKRecord(recordType: "community",zoneID: CloudKitConfiguration.shared.recordZone.zoneID)
        
        communityRecord.setValuesForKeys([
            "name": self.name
        ])
        self.record = communityRecord
        
        do{
            try await database.save(communityRecord)
            return self
        }catch let err{
            throw AppError.cloudKitError(err.localizedDescription)
        }
    }
    
    public func createShareRecord() async throws -> CKShare{
        
        let share = CKShare(rootRecord: record!)
        
        share[CKShare.SystemFieldKey.title] = "Community \(name) Invite" as CKRecordValue
        share.publicPermission = .readWrite
        
        do {
            let modifyResult = try await CloudKitConfiguration.shared.container.privateCloudDatabase.modifyRecords(saving: [record!, share], deleting: [])
            return share
        }catch let error{
            print(error)
            throw error
        }

        
        


    }
}

