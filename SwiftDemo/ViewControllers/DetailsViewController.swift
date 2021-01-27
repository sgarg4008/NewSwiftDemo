//
//  DetailsViewController.swift
//  SwiftDemo
//
//  Created by Shivam on 27/01/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var imgView_preview: UIImageView!
    @IBOutlet weak var lbl_collectionName: UILabel!
    @IBOutlet weak var lbl_trackName: UILabel!
    @IBOutlet weak var lbl_artistName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var btn_done: UIButton!
    @IBOutlet weak var stackView_details: UIStackView!
    
    var songDetailsObj : SongsListModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setData()
    }
    
    //Set UI
    func setUI(){
        self.imgView_preview.layer.cornerRadius = 8.0
        self.stackView_details.layer.cornerRadius = 10.0
        self.stackView_details.layer.borderWidth = 1.0
        self.stackView_details.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.btn_done.layer.cornerRadius = 5.0
    }
    
    //Details of Song
    func setData(){
        self.songDetailsObj?.trackName == "" ? (self.lbl_trackName.text = "No Track Name") : (self.lbl_trackName.text = self.songDetailsObj?.trackName)
        self.imgView_preview.downloaded(from: songDetailsObj?.artworkUrl100 ?? "")
        self.lbl_collectionName.text = self.songDetailsObj?.collectionName
        self.lbl_price.text = "$ " + String(self.songDetailsObj?.collectionPrice ?? 0.0)
        self.lbl_artistName.text = self.songDetailsObj?.artistName
    }
    
    //MARK: IBACTIONS
    @IBAction func btn_done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
