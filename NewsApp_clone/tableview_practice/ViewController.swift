//
//  ViewController.swift
//  tableview_practice
//
//  Created by 정지윤 on 2021/09/19.
//


//tableview 테이블로 된 뷰 - 여러개의 행이 모여있는 목록(화면)
//정갈하게 보여줄려고

//1. 데이터 무엇?
//2. 테이블 몇 개?
//3. (옵션) 데이터 눌렀다!

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsdata: Array<Dictionary<String, Any>>?
    
    //1. http 통신 방법 - 2진수 - urlsession
    //2. JSON 데이터 형태 -> {"돈":"10000"} {["1","2","as"]} - 뉴스정보
    //3. tableview의 데이터 매칭! <- 통보! 그리기!
    //!!!!! background : network / ui : Main
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=8b016c626d0e440f86301b0ebfb7079c")!) { data, response, error in
            if let dataJson = data{
                print(dataJson)
                // json parsing
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    print(json)
                    //Dictionary
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    self.newsdata = articles
                    
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData() // 아직까진 bakcground에서 네트워크 통신 작업을 하고있음 -> Main에서 화면을 그리게 바꿔줘야 함
                    }

                }
                catch {}
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //데이터 몇 개? -> 숫자
        
        if let news = newsdata {
            return news.count
        }else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //데이터 무엇? 반복 10번?
        // 2가지!
        // 1번 방법 -> 임의의 셀 만들기
        // 2번 방법 -> 스토리보드 + identifier
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        // 친자 확인 as?: 나 맞아?  as!: 나 맞아! ->
//        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1") //reuseIdentifier -> 이름을 정해주는 것
        
        let idx = indexPath.row
        if let news = newsdata {
            
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                print("Title :: \(r)")
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                    
                }
            }
    
        }
        return cell
    }
    
    //1. 클릭했을 때 -> option
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "newsDetailController") as! newsDetailController
        
        if let news = newsdata {
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any> {
                
                if let desc = r["description"] as? String {
                    controller.desc = desc
                }
                if let ImageUrl = r["urlToImage"] as? String {
                    controller.ImageUrl = ImageUrl
                    
                }
            }
            
        }
        
        // 이동! - 수동!
//        showDetailViewController(controller, sender: nil)
    }
    
    
    //2. 세그웨이 / override -> 부모인 viewcontroller에 prepare라는 함수가 있었다는 뜻
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "newsDetail" == id {
            if let controller = segue.destination as? newsDetailController {

                if let news = newsdata {
                    if let indexPath = TableViewMain.indexPathForSelectedRow {
                        let row = news[indexPath.row]
                        if let r = row as? Dictionary<String, Any> {
                            if let desc = r["description"] as? String {
                                controller.desc = desc
                            }
                            if let ImageUrl = r["urlToImage"] as? String {
                                controller.ImageUrl = ImageUrl

                            }
                        }

                    }

                }
            }
        }
        // 이동! - 자동!
    }
    
    
    
    //1. 디테일 화면 만들기
    //2. 값을 보내기 2가지 방법
    //      - tableview delegate / stodyboard (segue)
    //3. 화면 이동 (이동하기 전에 값을 미리 세팅하기)!!!!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewMain.delegate = self // self -> viewconroller 클래스 내에 있는 함수들
        TableViewMain.dataSource = self
        
        getNews()
    }
}
