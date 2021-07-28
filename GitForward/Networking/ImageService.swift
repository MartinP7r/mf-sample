//
//  ImageService.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import UIKit

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}

protocol ImageServiceProtocol {
    func get(for url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable
}

struct ImageService: ImageServiceProtocol {

    func get(for url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            var image: UIImage?

            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }

            if let data = data {
                image = UIImage(data: data)
            }
        }

        dataTask.resume()

        return dataTask
    }

}
