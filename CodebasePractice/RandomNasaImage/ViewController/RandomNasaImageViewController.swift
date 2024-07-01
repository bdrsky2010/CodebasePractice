//
//  RandomNasaImageViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit

fileprivate enum Nasa: String, CaseIterable {
    
    static let baseURL = "https://apod.nasa.gov/apod/image/"
    
    case one = "2308/sombrero_spitzer_3000.jpg"
    case two = "2212/NGC1365-CDK24-CDK17.jpg"
    case three = "2307/M64Hubble.jpg"
    case four = "2306/BeyondEarth_Unknown_3000.jpg"
    case five = "2307/NGC6559_Block_1311.jpg"
    case six = "2304/OlympusMons_MarsExpress_6000.jpg"
    case seven = "2305/pia23122c-16.jpg"
    case eight = "2308/SunMonster_Wenz_960.jpg"
    case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
     
    static var photo: URL {
        return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
    }
}

final class RandomNasaImageViewController: BaseViewController {
    
    private let randomNasaImageView = RandomNasaImageView()
    
    private var urlSession: URLSession?
    private var totalImageSize: Double = 0
    private var buffer: Data? {
        didSet {
            let result = Double(buffer?.count ?? 0) / totalImageSize
            let doubleResult = round(result * 100)
            randomNasaImageView.configureContentLabel(doubleResult < 100 ? "\(doubleResult) / 100" : "complete")
        }
    }
    
    override func loadView() {
        view = randomNasaImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        urlSession?.invalidateAndCancel()
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
        navigationItem.title = "NASA"
    }
    
    private func configureButton() {
        randomNasaImageView.downloadButton.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func downloadButtonClicked() {
        buffer = Data()
        callRequest()
    }
    
    private func callRequest() {
        let request = URLRequest(url: Nasa.photo)
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        urlSession?.dataTask(with: request).resume()
    }
}

extension RandomNasaImageViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
            if let contentLength = response.value(forHTTPHeaderField: "Content-Length"), let size = Double(contentLength) {
                totalImageSize = size
            }
            return .allow
        } else {
            return .cancel
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(data)
        buffer?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let _ = error {
            presentNetworkErrorAlert(error: .noData)
            randomNasaImageView.configureContentImage()
        } else {
            guard let buffer else {
                presentNetworkErrorAlert(error: .invalidData)
                randomNasaImageView.configureContentImage()
                return
            }
            randomNasaImageView.configureContentImage(buffer)
        }
    }
}
