//
//  MusicView.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 27/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit

class MusicView: UIView {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func addDataToMusicView(album:Album){
        
        let url = URL(string: album.artworkURL)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        artworkImageView.image = UIImage(data: data!)
        
       // artworkImageView.image = UIImage(named: album.artworkURL)
        titleLabel.text = album.title
        artistLabel.text = album.artist
        genreLabel.text = album.genre
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
