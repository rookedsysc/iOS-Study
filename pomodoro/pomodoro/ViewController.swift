//
//  ViewController.swift
//  pomodoro
//
//  Created by Rookedsysc on 2022. 9. 13..
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Button
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정된 시간을 '초'단위로 저장함
    var duration = 60 // 앱이 실행되면 datePicker가 기본적으로 1로 시작을 해서 60으로 설정함
    // 타이머의 상태를 가지고 있는 프로퍼티
    var timerStatus: TimerStatus = .end
    
    // Timer관련 프로퍼티
    var timer: DispatchSourceTimer?
    var currnetSeconds = 0 // 현재 카운트다운되는 시간
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    
    
    // 취소 버튼 탭 : datePicker가 표시되고 lable과 progress view를 다시 숨기고 취소버튼을 비활성화 되고 toggleButtonTitle을 "시작"으로 변경
    @IBAction func tapCancelButton(_ sender: Any) {
        switch self.timerStatus {
        // 타이머가 시작 중이거나 일시정지일 때 진입
        case .start, .pause:
            self.stopTimer()
            
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: Any) {
        // countDownDuration: datePicker에서 선택한 시간이 몇 초인지 알려줌
        self.duration = Int(self.datePicker.countDownDuration)
        debugPrint(self.duration)
        
        /*
         시작 버튼 누르면: timerStatus를 start로 변경, Label과 progressView를 Hidden 해제, datePicker 숨김, toggleButton을 선택된 것으로 해서 configureToggleButton()에서 설정해둔대로 Tittledl "일시정지"로 바뀜, cancelButton 활성화
         */
        switch self.timerStatus {
        // 기본값인 end 상태로 초기 진입
        case .end:
            self.timerStatus = .start
            // timerLabel과 progress View를 보이게 해줌
            self.setTimerInfoViewVisble(isHidden: false)
            self.datePicker.isHidden = true
            
            // 선택된 상태가 되어서 Title이 "일시정지"가 됨
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true // 취소 버튼 활성화
            
            self.currnetSeconds = self.duration // datePicker에서 선택한 시간 설정
            self.startTimer() // Timer 시작
            
        case .start:
            self.timerStatus = .pause
            
            // 일시정지 버튼 누르면 toggleButton이 시작버튼으로 다시 바뀜
            self.toggleButton.isSelected = false
            self.timer?.suspend() // 일시정지
            
        // 일시정지 상태일 때 진입
        case .pause:
            // 재시작되어서 timerStatus Start로 변경
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume() // 재시작
            
        default:
            break
            
        }
    }
    
    // 타이머를 설정하고 타이머가 시작되게 함
    func startTimer() {
        if self.timer == nil {
            // main Thread는 iOS에서 한 개 뿐인 Thread, 코코아가 이 Thread를 사용함(인터페이스와 관련된 코드는 반드시 main 스레드에서 구현해야 함
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main) // Timer 설정
            // 타이머 실행 주기, 당장 시작되게 함(만약에 3초 뒤에 실행되게 해주려면 now() 뒤에 +3을 해주면 됨 / 1초마다 반복
            self.timer?.schedule(deadline: .now(), repeating: 1)
            // 타이머의 실행주기마다 실행될 코드를 closure로 설정함
            self.timer?.setEventHandler(handler: { [weak self] in
                /* 일시적으로 self가 strong reference가 되게 만들어줌
                 self 뒤에 ? 다 지워줌*/
                guard let self = self else { return }
                self.currnetSeconds -= 1 // 클로저 호출될 때마다 1씩 빼줌
                
                // 시, 분, 초 할당
                let hour = self.currnetSeconds / 3600
                let minutes = (self.currnetSeconds%3600) / 60
                let seconds = (self.currnetSeconds%3600) % 60
                // 시:분:초 형식으로 label에 표시
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                
                // Progress는 1~0까지, 0에 가까워질수록 게이지가 비워짐
                self.progressView.progress = Float(self.currnetSeconds) / Float(self.duration)
                debugPrint(self.progressView.progress)
                                
                // 현재 시간이 0보다 작거나 같을 때
                if self.currnetSeconds <= 0 {
                    self.stopTimer() // 타이머 멈춤
                    
                    // 알람 울림, ID값: https://iphonedev.wiki/index.php/AudioServices 에서 확인 가능
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume() // 타이머가 시작
        }
    }
    
    
    func stopTimer() {
        // 일시정지 상태에서 취소버튼 누르면 runtime error 발생, 이를 해결하기 위함임
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        
        /* 원래 tapCancelButton에 있던 Method들이지만 stopTimer() 호출될 때
        화면 초기화 해주기 위해서 stopTimer() 함수 안으로 가져옴 */
        self.timerStatus = .end // status상태 end로
        self.datePicker.isHidden = false // date Picker 다시 표시
        self.cancelButton.isEnabled = false // 취소 비활성화
        self.setTimerInfoViewVisble(isHidden: true) // label, progress 비활성화
        self.toggleButton.isSelected = false // toggleButton Title을 "시작"으로 변경
        
        self.timer?.cancel() // 타이머 멈춤
        self.timer = nil // nil을 할당 안해주면 화면 벗어났을 때 계속 타이머 동작함
        
        
    }
    
    // 버튼의 초기 상태면 "시작" 버튼이 선택된 상태면 "일시정지"로 변경됨
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    func setTimerInfoViewVisble(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
}

