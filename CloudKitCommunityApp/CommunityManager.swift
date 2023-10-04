//
//  CommunityManager.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 19/09/23.
//

import Foundation
import CloudKit


class CommunityManager: ObservableObject{
    
    @Published public var communities: [Community] = []
    @Published public var sharedCommunities: [Community] = []
    @Published var errorMessage = ""
    @Published var selectedSharedRecordCommunity: CKShare?
    
    //Use main Actor to make
    @MainActor
    public func fetchAllCommunity() async {
        self.communities = await Community.getAllMyCommunity()
        self.sharedCommunities = await Community.getAllShareCommunity()
    }
    
    public func checkForAuth(){
        
    }
    
    public func addNewCommunity(with name: String) async -> Community?{
        var newCommunity = Community(name: name)
        do{
            let _ = try await newCommunity.saveToCloudKit()
            communities.append(newCommunity)
            return newCommunity
        }catch let err as AppError{
            errorMessage = err.localizedDescription
            return nil
        }catch{
            return nil
        }
    }
    
    @MainActor
    public func share(_ community: Community) async throws{
        selectedSharedRecordCommunity = try await community.createShareRecord()
        
    }
    
    
    
}

