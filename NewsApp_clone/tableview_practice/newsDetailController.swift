//
//  newsDetailController.swift
//  tableview_practice
//
//  Created by 정지윤 on 2021/10/03.
//

import UIKit

class newsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain : UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    //1. 이미지 주소
    //2. 본문
    
    var ImageUrl: String?
    var desc: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ok?
        if let img = ImageUrl {
            //이미지 가져와서 뿌린다.
            //data
            if let data = try? Data(contentsOf: URL(string: img)!) {
                //Main Thread
                DispatchQueue.main.async{
                    self.ImageMain.image = UIImage(data: data) // -> background에서 실행 중
                }
            }
            
        }
        
        if let d = desc {
            //뉴스 본문을 가져온다.
            self.LabelMain.text = d
        }
    }
}
