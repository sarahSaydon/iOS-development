//
//  PopUpViewController.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 29/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit
import CoreData

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Do any additional setup after loading the view.
    }
     
    @IBOutlet weak var btnMovie: UIButton!
    @IBOutlet weak var btnMusic: UIButton!
    
    @IBOutlet weak var btnPodcast: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    fileprivate let syncQueue = DispatchQueue(label: "Downloader.syncQueue")
    @IBAction func btnMediaSelected(_ sender: Any) {
     
        
        syncQueue.sync {
            
            ItunesConnection().getJsonFromUrlMedia(searchString: termSearch,mediaString:mediaSelected)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "sbMain") as! ViewController
            
            self.view.removeFromSuperview()
          //  let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //let newViewController = storyBoard.instantiateViewController(withIdentifier: "sbMain") as! ViewController
            //newViewController.albumTableView.reloadData()
            sleep(2)
            self.present(newViewController, animated: true, completion: nil)
            
        }
        
      
      
    }
    enum MediaTypes: String{
        case movie = "Movie"
        case podcast = "Podcast"
        case music = "Music"
         case all = "All"
    }
    var mediaSelected = ""
    @IBAction func mediaTypeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle , let mediaType = MediaTypes(rawValue: title) else {
            return
        }
        
        switch mediaType {
        case .movie:
            mediaSelected = "movie"
            btnAll.isSelected = false
            btnMovie.isSelected = true
            btnPodcast.isSelected = false
            btnMusic.isSelected = false
        case .podcast:
            mediaSelected = "podcast"
            btnAll.isSelected = false
            btnMovie.isSelected = false
            btnPodcast.isSelected = true
            btnMusic.isSelected = false
        case .music:
            mediaSelected = "music"
            btnAll.isSelected = false
            btnMovie.isSelected = false
            btnPodcast.isSelected = false
            btnMusic.isSelected = true
        case .all:
            mediaSelected = "all"
            btnAll.isSelected = true
            btnMovie.isSelected = false
            btnPodcast.isSelected = false
            btnMusic.isSelected = false
        default:
           mediaSelected = "all"
           btnAll.isSelected = true
           btnMovie.isSelected = false
           btnPodcast.isSelected = false
           btnMusic.isSelected = false
        }
    }
    @IBAction func handleSelection(_ sender: UIButton) {
        mediaTypeButtons.forEach{(button)in
            UIView.animate(withDuration: 0.3, animations: {
                 button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
           }
    }
    @IBOutlet var mediaTypeButtons: [UIButton]!
    @IBAction func btnClosePopUp(_ sender: Any) {
    self.view.removeFromSuperview()
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
