//
//  UIImageView+Network.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit

extension UIImageView {
    @discardableResult
    func loadImage(from urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        task.resume()
        return task
    }
}
