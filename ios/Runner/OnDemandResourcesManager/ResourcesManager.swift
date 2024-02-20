//
//  ResourcesManager.swift
//  Runner
//
//  Created by Anatolii Shumov on 24/01/2024.
//
//

import Foundation
import UIKit
import Flutter

final class ResourcesManager {
    private let keyGroup = DispatchGroup()
    private let tags = ["ApiKey"]
    
    private func loadResources(completion: @escaping (NSBundleResourceRequest?, Error?) -> Void) {
        let tags = NSSet(array: tags)
        let resourcesRequest: NSBundleResourceRequest = NSBundleResourceRequest(tags: tags as! Set<String>)
        
        resourcesRequest.conditionallyBeginAccessingResources { resourcesAvailable in
            if resourcesAvailable {
                completion(resourcesRequest, nil)
            } else {
                resourcesRequest.beginAccessingResources { error in
                    if let error {
                        completion(nil, error)
                        print("Could not read on-Demand Resources: \(error.localizedDescription)")
                              } else {
                                  completion(resourcesRequest, nil)
                        }
                }
            }
        }
    }
    
    func getKey(result: FlutterResult) {
        var key: String?
        var errorMessage: String?
        
        keyGroup.enter()
        loadResources { [weak self] odr, error in
            guard let self else { return }
            if error == nil, odr != nil {
                guard let resources = NSDataAsset(name: "secret") else { return }
                let data = resources.data
                let nsKey = NSString(data: data, encoding: NSUTF8StringEncoding)
                key = nsKey as? String
                self.keyGroup.leave()
            } else {
                errorMessage = error?.localizedDescription
                self.keyGroup.leave()
            }
        }
        
        keyGroup.wait()
        if key != nil && errorMessage == nil {
            result(key!)
        } else {
            result(FlutterError(code: "unavailable",
                                message: errorMessage!,
                                details: nil))
        }
    }
}
