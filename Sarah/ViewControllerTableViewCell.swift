//
//  ViewControllerTableViewCell.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 27/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit


class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var btnDeleteStatus: UIButton!
    
    @IBAction func btnDelete(_ sender: Any) {
       
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblAlbum.text = "";
        self.lblArtist.text = "";
        self.imgAlbum.image = nil
    //    self.btnDeleteStatus = nil
           //set cell to initial state here, reset or set values, etc.
    }
    

    func setAlbum(album:Album)
    {
        //imgAlbum.image = album.artworkURL
        lblArtist.text = album.trackId
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
