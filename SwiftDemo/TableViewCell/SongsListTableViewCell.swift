//
//  SongsListTableViewCell.swift
//  SwiftDemo
//
//  Created by Shivam on 26/01/21.
//

import UIKit

class SongsListTableViewCell: UITableViewCell {
    
    //MARK:- IBOUTLET
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var imgView_preview: UIImageView!
    @IBOutlet weak var lbl_trackName: UILabel!
    @IBOutlet weak var btn_viewDetails: UIButton!
    var callbackOnViewDetailsPressed : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set UI
        setUI()
    }
    
    //MARK:- SETUI
    func setUI(){
        view_container.layer.cornerRadius = 10.0
        imgView_preview.layer.cornerRadius = 5.0
        btn_viewDetails.layer.cornerRadius = 5.0
    }

    //SetData
    func populateData(obj:SongsListModel){
        obj.trackName == "" ? (self.lbl_trackName.text = "No Track Name") : (self.lbl_trackName.text = obj.trackName)
        self.imgView_preview.downloaded(from: obj.artworkUrl100)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- IBACTION
    @IBAction func btn_viewDetails(_ sender: UIButton) {
        self.callbackOnViewDetailsPressed?()
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
