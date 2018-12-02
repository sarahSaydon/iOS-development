//
//  DetailViewController.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 30/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblName.text = nameArray[myIndex].artist
        lblDesc.text = nameArray[myIndex].trackId
        
        let url = URL(string: nameArray[myIndex].artworkURLLarge)
        let data = try? Data(contentsOf: url!)
        
        if data==nil
        {}
        else{
             imgAlbum.image = UIImage(data: data!)}
        
    }

    @IBAction func btnDelete(_ sender: Any) {
        let popOverVc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "sbDeletePopUpId") as! DeletePopUpViewController
        
        self.addChildViewController(popOverVc)
        popOverVc.view.frame = self.view.frame
        self.view.addSubview(popOverVc.view)
        popOverVc.didMove(toParentViewController: self)
        
            deleteSelected = true
    }
    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    
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
