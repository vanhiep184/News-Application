//
//  NewsViewController.swift
//  News App
//
//  Created by I Am Focused on 12/2/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import UIKit


class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        NewServiceAPI.shared.fetchNewsbyCountry(countryName: "us") {
            (result: Result<NewsResponse, NewServiceAPI.APIServiceError>) in
            switch result {
                case .success(let news):
            
                    for article in news.articles{
                        print(article.source.id ?? "No ID")
                    }
                    
                        
                case .failure(let error):
                    print(error.localizedDescription)
            }

        }

    }


<<<<<<< HEAD





=======
>>>>>>> 6e6780a69739bc874ffba323441d1661d7e4941c
}
extension URLSession {

    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            print(data)
            result(.success((response, data)))

        }
    }
}
