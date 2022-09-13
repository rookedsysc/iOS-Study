//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rookedsysc on 2022. 9. 13..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    // 날씨 가져왔을 때 isHidden 속성 변경해주기 위해서 
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func tapFetchWeatherButton(_ sender: Any) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true) // 버튼 누르면 키보드 사라짐
        }
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first { // weather 배열의 첫 번째 변수가 weather에 대입되게 함
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15)) °C" // 현지 온도 표시
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15)) °C"
        self.maxTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15)) °C"
    }
    
    
    
    func getCurrentWeather(cityName: String) {
        // URL 호출
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=ef5f3573e78f892cd3eb3059b366221a") else { return }
        let session = URLSession(configuration: .default) // 기본 세션
        session.dataTask(with: url) { [weak self] data, response, error in // 서버에서 응답이 오면 Handler가 호출되고 data에 응답 저장
            // 에러 처리 위한 상수
            let successRange = (200..<300) // 200 ~ 299
            
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder() // codable을 준수하는 사용자 정의 타입으로 json 데이터를 변환 시켜줌
        
            if let response = response as? HTTPURLResponse,successRange.contains(response.statusCode) {// 응답받은 status가 200번대인지 확인
                // Json Data를 WeatherInformation 객체로 Decoding 해줌
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                debugPrint(weatherInformation)
                        
                // 네트워크 작업은 자동으로 메인 스레드로 돌아오지 않기 때문에 메인 스레드에서 작업 할 수 있도록 만들어줘야 함
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                // 서버에서 응답받은 Error Json 데이터를 ErrorMessage 객체로 Decoding 시켜줌
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume() // 작업 실행 시켜줌
    }
    
    func showAlert (message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
