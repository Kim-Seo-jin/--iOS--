//
//  ViewController.swift
//  iOS-Challenge-Concurrency
//
//  Created by 김서진 on 2023/03/01.
//  author 변경 테스트

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    var imageViews: [UIImageView] = []
    let imageUrls = [
        "https://pbs.twimg.com/media/Fk5-BOaaAAEZYBe?format=jpg&name=large",
        "https://pbs.twimg.com/media/FlJplSaagAU4OPQ?format=jpg&name=4096x4096",
        "https://pbs.twimg.com/media/FlJm5RxaYAE230F?format=jpg&name=medium",
        "https://pbs.twimg.com/media/FlIgUOraUAEOJYB?format=jpg&name=medium",
        "https://pbs.twimg.com/media/FlJrLH3agAI2di3?format=jpg&name=medium"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViews = [
            image1,
            image2,
            image3,
            image4,
            image5
        ]

    }

    // MARK: IBAction
    // 개별 이미지 로드
    @IBAction func loadImage(_ sender: UIButton) {
        let imageNum = sender.tag
        
        self.imageViews[imageNum].image = UIImage(systemName: "photo")
        
        guard let imageUrl = URL(string: imageUrls[imageNum]) else { return }
        
        download(url: imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageViews[imageNum].image = image
            }
        }
    }
    
    // 전체 이미지 로드
    @IBAction func loadAllImages(_ sender: Any) {
        
        initImage()
        
        for i in 0..<5 {
            guard let imageUrl = URL(string: imageUrls[i]) else { return }
            download(url: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageViews[i].image = image
                }
                
            }
        }
    }
    
    // MARK: Func
    // URLSession 을 활용한 비동기 다운로드 함수
    func download(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let imageData = UIImage(data: data)
            completion(imageData) // 작업이 다 끝나면 UIImage 콜백
        }.resume()
    }
    
    // 기본 이미지 설정
    func initImage() {
        for i in 0..<5 {
            imageViews[i].image = UIImage(systemName: "photo")
        }
    }
    
}

