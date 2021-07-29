//
//  ImageServiceMock.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-28.
//

import UIKit
@testable import GitForward

final class ImageServiceMock: ImageServiceProtocol {

    final class FakeCancellable: GitForward.Cancellable {
        func cancel() {}
    }

    var callCount = 0
    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) -> GitForward.Cancellable {
        callCount += 1
        return FakeCancellable()
    }
}
