//
//  SceneDelegate.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 03/10/23.
//

import UIKit
import SwiftUI
import CloudKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("scene connected")
    }
    
    func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {

        // Create an operation to accept the share, running in the app's CKContainer.
        let container = CloudKitConfiguration.shared.container
        let operation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])

        debugPrint("Accepting CloudKit Share with metadata: \(cloudKitShareMetadata)")

        operation.perShareResultBlock = { metadata, result in
            let rootRecordID = metadata.rootRecordID

            switch result {
            case .failure(let error):
                debugPrint("Error accepting share with root record ID: \(rootRecordID), \(error)")

            case .success:
                debugPrint("Accepted CloudKit share for root record ID: \(rootRecordID)")
            }
        }

        operation.acceptSharesResultBlock = { result in
            if case .failure(let error) = result {
                debugPrint("Error accepting CloudKit Share: \(error)")
            }
        }

        operation.qualityOfService = .utility
        container.add(operation)
    }
}
