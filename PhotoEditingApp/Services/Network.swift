//
//  Network.swift
//  PhotoEditingApp
//
//  Created by Fernando Goulart on 11/07/23.
//

import Foundation
import Alamofire

final class Network {

    func run() {
        AF.request("https://httpbin.org/get").response { response in
            debugPrint(response)
        }
    }
}
