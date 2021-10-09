//
//  EntryViewController.swift
//  TableView_practice2
//
//  Created by 정지윤 on 2021/10/04.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    
    var update: (() -> Void)?

    override func viewDidLoad() { // 뷰의 로딩이 완료 됐을 때 시스템에 의해 자동으로 호출 -> 처음 한 번만 실행해야 하는 초기화 코드 작성(리소스 초기화, 초기화면 구성)
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // return 키 누르면 자동실행,,?
        
        saveTask()
        
        return true
    }
    
    @objc func saveTask(){
         
        guard let text = field.text, !text.isEmpty else{
            return
        }
        
        // UserDefaults -> 데이터 저장소 ex) 환경설정의 on/off 값 저장(따로 바꾸지 않는 한 저장돼 있음)
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }
    
}

