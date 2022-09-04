//
//  ViewController.swift
//  ToDoList
//
//  Created by Rookedsysc on 2022. 8. 23..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    
    // Task Struct에 감시자 설정, 값이 바뀔 때마다 saveTakss() 호출
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // done button을 선택했을 때 doneButtonTap 메서드가 호출됨
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    // selector 타입으로 전달할 메서드를 작성할 때는 반드시 @objc atrribute를 붙여줘야 함, 이는 object-C와의 호환성을 위한 것
    // done button을 눌렀을 때 editing mode에서 빠져나오고 editbutton으로 다시 바뀌게 함
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    @IBAction func tapAddButton(_ sender:UIBarButtonItem) {
        // prefrerredStyle의 actionSheet는 밑에서 표시되는 창임
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        // handler는 버튼을 눌렸을 때 해줄 동작을 나타냄
        // closure 선언부에 대괄호로 waek self를 작성해서 캡쳐목록을 정의함 > 강한 순환참조로 메모리 누수를 방지
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self]_ in
            // 등록버튼을 눌렀을 때 텍스트에 입력한 값을 가져오도록 해줌, textField는 리스트형
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            // tasks 배열에 할 일이 추가될 때마다 테이블뷰를 갱신해서 테이블 뷰에 할 일이 표시되게끔 해줌
            self?.tableView.reloadData()
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        // alert에 텍스트 필드를 추가해줌, configurationHandler는 alert에 표시하는 텍스트 필드를 설정하는 클로저
        // textField 객체를 파라미터로 전달받으므로 textField라고 네이밍을 해주고 textField.placeholder를 통해서 값을 전달함
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        // Add 모드 사용시 Editing 모드 해제되게 해줌
        self.doneButtonTap()
        self.present(alert, animated: true, completion: nil)
    }
    // 값을 저장해줌
    func saveTasks() {
        // 배열의 요소들을 dictionary 형태로 mapping함
        let data = self.tasks.map {
            [
                // $0은 첫 번째 인자를 뜻함
                "title": $0.title,
                "done": $0.done
            ]
        }
        // 할 일들을 저장함
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        // object 메서드는 any 타입으로 return이 되므로 dictionaly
        guard let data =  userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 모든 할 일 만큼 표현할거니 배열의 개수를 리턴해줌
        return self.tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 스토리보드에서 정의한 셀을 dequeueReusableCell를 통해 가져오게 됨
        // 지정된 재사용 식별자(withIdentifier)에 대한 재사용 가능한 table view 객체를 반환을 하고 이를 table view에 추가하는 역할을 함
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    // editing mode에서 삭제 버튼을 눌렀을 때 삭제된 cell이 어떤 cell인지 알려줌
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // 모든 cell이 삭제되면 editing 모드를 빠져나오게 해줌
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    /*
     행이 다른 위치로 이동하면 sourceIndexPath 파라미터를 통해 원래 위치를 알려주고
     destinationIndexPath 파라미터를 통해 어디로 이동 했는지 알려줌
     */
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        // 원래 있던 위치의 할 일을 삭제함
        tasks.remove(at: sourceIndexPath.row)
        // 이동한 위치를 넘겨줌
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks         
    }
}

extension ViewController: UITableViewDelegate {
    // 셀 선택시 어떤 셀 선택했는지 알려줌
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

