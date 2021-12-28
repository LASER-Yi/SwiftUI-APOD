//
//  Loadable.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum Loadable<T> {
    
    case notRequested
    case isLoading(last: T?, AnyCancellable?)
    case loaded(T)
    case failed(last: T?, Error)
    
    var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last, _): return last
        default: return nil
        }
    }
    var error: Error? {
        switch self {
        case let .failed(_, error): return error
        default: return nil
        }
    }
}

protocol LoadableObject: ObservableObject {
    associatedtype Output
    typealias Result = Loadable<Output>
    
    var state: Result { get set }
    
    func load()
}

extension LoadableObject {
    func cancel() {
        switch state {
        case .isLoading(last: let last, let cancelable):
            cancelable?.cancel()
        default:
            break
        }
    }
}
