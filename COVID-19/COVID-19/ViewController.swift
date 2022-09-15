//
//  ViewController.swift
//  COVID-19
//
//  Created by Rookedsysc on 2022. 9. 15..
//

import UIKit

import Charts
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 코로나 API 호출
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result) :
                debugPrint("success \(result)")
            case let .failure(error) :
                debugPrint("error \(error)")
            }

        })
    }

    func fetchCovidOverview (
        // API를 요청하고 서버에서 Json 데이터 응답받거나 요청에 실패 했을 때 호출되는 클로저
        completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void // 요청에 성공하면 전달받을 열거형, 요청에 실패하면 전달받을 객체
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "q76Fmc2uzsY3BXZdpCQvKJPNt1OnlboD5"
        ]
        
        /* alamofire를 이용해서 해당 API 호출해줌
        여기서 정의된 completionHandler는 fetchCovidOverview 함수가 반환 된 후에 호출이 됨 (서버에서 데이터를 언제 반환해줄지 모르기 때문)
         escaping colsure로 competionHandler를 정의하지 않으면 서버에서 비동기로 데이터를 전달받기 전에 함수가 종료되어 버려서 completionHandler가 호출되지 않음 */
        AF.request(url, method: .get, parameters: param)// 요청할 쿼리 파라미터, 딕셔너리 형태로 파라미터에 전달을 하면 알아서 url 뒤에 쿼리 파라미터를
            .responseData(completionHandler: { response in //  응답 데이터를 받아서 클로저 파라미터로 전달됨
                switch response.result {
                case let .success(data) : // 성공한 응답 값을 CityCovidOverview 객체에 맵핑 되도록 해줌
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result)) // 서버에서 응답받은 JSON data를 넘겨줌
                    } catch { // JSON 데이터가 매칭하는데 실패하면 실행되는 구문
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                    
                default :
                    break
                }
                
            })
            
    }

}

