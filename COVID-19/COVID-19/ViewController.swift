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
    
    // 서버에서 응답오기 전에 라벨은 표시 안되고 indicator가 표시되게 해줌
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetchCovidOverview 호출 이전에 Indicator View 동작
        self.indicatorView.startAnimating()
        
        // 코로나 API 호출
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            // completion 호출된 경우
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true // indicator Animation 멈추고 숨겨줌
            self.labelStackView.isHidden = false // stackView 표시
            self.pieChartView.isHidden = false // pieChart 표시
            
            switch result {
            case let .success(result) :
                // label에 전체 확진자 수와 국내 신규 확진자 수를 표시해줌
                self.configureStackView(koreaCovidOverview: result.korea)
                // Chart 생성
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverViewList: covidOverviewList)
            case let .failure(error) :
                debugPrint(error)

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
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text  = "\(koreaCovidOverview.totalCase) 명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase) 명"
        
    }
    
    func makeCovidOverviewList(
        cityCovidOverview: CityCovidOverView
    ) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.jeonnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    func configureChartView(covidOverViewList: [CovidOverview]) {
        self.pieChartView.delegate = self // pieChartView Delegate 할당
        
        // covidOverViewList 배열을 piChart의 Entry 객체로 맵핑시킴
        let entries  = covidOverViewList.compactMap{ [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: removeFormatString(string: overview.newCase),
                label: overview.countryName, // 항목 이름
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        
        /* Pie Chart UI 변경 */
        dataSet.sliceSpace = 1 // 항목간 간격
        dataSet.entryLabelColor = .black // 항목 이름 색상
        dataSet.xValuePosition = .outsideSlice // 항목 이름이 Pie 차트 바깥에 표시됨
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.valueTextColor = .black // 값 색상
        // Pie Chart의 항목이 다양한 색상으로 표현되게 해줌
        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.material()
        
        // Pie Chart 80도 회전 시킴 
        self.pieChartView.spin(
            duration: 0.3, // 0.3초간
            fromAngle: self.pieChartView.rotationAngle,
            toAngle: self.pieChartView.rotationAngle + 80 // 현재 Angle에서 80도 정도 회전
        )
    }
    
    // 세자리 마다 콤마를 찍어주는 포맷의 문자열을 숫자로 변경해주는 함수
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0 // nil이면 0
    }
}


extension ViewController: ChartViewDelegate {
    // 차트에서 항목을 선택했을 때 호출되는 메서드, 엔트리 메서드 파라미터를 통해 선택된 항목에 저장되있는 항목을 가져올 수 있음
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailTableViewController") as? CovidDetailTableViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
