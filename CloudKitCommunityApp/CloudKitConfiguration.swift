//
//  CloudKitConfiguration.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 03/10/23.
//

import Foundation
import CloudKit

struct CloudKitConfiguration{
    //Singleton
    static var shared = CloudKitConfiguration()
    private init (){}
    
    let container = CKContainer(identifier: "iCloud.cloudKitCommunityApp")
    let recordZone = CKRecordZone(zoneName: "Communities")
    
    public func checkForAuth() async throws{
        
        let status = try await container.accountStatus()
        
        switch status{
        case .available:
            print("")
        case .couldNotDetermine:
            print("")
        case .restricted:
            print("")
        case .noAccount:
            print("")
        case .temporarilyUnavailable:
            print("")
        @unknown default:
            print("")
        }
    }
    
    /// Creates the custom zone in use if needed.
    func createZoneIfNeeded() async throws {
        // Avoid the operation if this has already been done.
        guard !UserDefaults.standard.bool(forKey: "isZoneCreated") else {
            return
        }

        do {
            _ = try await container.privateCloudDatabase.modifyRecordZones(saving: [recordZone], deleting: [])
        } catch {
            print("ERROR: Failed to create custom zone: \(error.localizedDescription)")
            throw error
        }

        UserDefaults.standard.setValue(true, forKey: "isZoneCreated")
    }
}
