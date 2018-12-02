//
//  DeletePopUpViewController.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 30/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit

class DeletePopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Do any additional setup after loading the view.
    }

    @IBAction func btnDelete(_ sender: Any) {
          deleteSelected = true
          indexToDelete = myIndex
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "sbMain") as! ViewController
        self.present(newViewController, animated: true, completion: nil)
     //   newViewController.albumTableView.reloadData()
    }
    @IBOutlet weak var btnDelete: UIButton!
    @IBAction func btnClose(_ sender: Any) {
        self.view.removeFromSuperview()
        deleteSelected = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
