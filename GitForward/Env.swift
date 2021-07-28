//
//  Env.swift
//
//  Created by Martin Pfundmair on 2019-03-09.
//

import Foundation

struct Env {
    enum Variable: String { case
        apiKey = "API_KEY"
    }

    static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            preconditionFailure("info.plist unavailable")
        }
        return dict
    }()

    static func variable(_ envVar: Variable) -> String {
        guard let variable = infoDict[envVar.rawValue] as? String else {
            preconditionFailure("variable not available in info.plist")
        }
        return variable
    }
}
