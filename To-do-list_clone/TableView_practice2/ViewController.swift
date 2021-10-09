//
//  ViewController.swift
//  TableView_practice2
//
//  Created by 정지윤 on 2021/10/04.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [String]()
    
    func updateTasks() {
        
        tasks.removeAll() // 굳이 초기화를 해야하는 이유,,?
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        
        for x in 0..<count {
            
            if let task = UserDefaults().value(forKey: "task\(x+1)") as? String {
                tasks.append(task)
            }
            
        }
        
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async { //어떨 땐 쓰고 어떨 땐 안쓰는지
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true) // EntryViewController 화면 띄우기
        
    }
    
    // 셀 개수 -> UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // 셀 내용 -> UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }

    // 버튼 눌렀을 때 -> UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true) // EntryViewController 화면 띄우기
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Setup
        
        if !UserDefaults().bool(forKey: "setup") { // 아무런 task도 저장되지 않았을 때
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count") // count 초기값 0으로 설정!
        }
        
        updateTasks()
        // Get all current saved tasks
    }
}


