//
//  ViewState.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-31.
//

import Foundation

enum ViewState: Equatable { case
    idle,
    loading,
    error(Error)

    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.error, .error): return true // status is considered equal even if the associated errors are not
        default: return false
        }
    }
}
