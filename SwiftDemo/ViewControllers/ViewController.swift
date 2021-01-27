//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Shivam on 26/01/21.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {
    
    //MARK:- IBOUTLET
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var tableView_listOfSongs: UITableView!
    @IBOutlet weak var btn_refresh: UIButton!
    
    var songsListObj: [SongsListModel] = []
    var activityIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView_listOfSongs.delegate = self
        tableView_listOfSongs.dataSource = self
        
        //Hit Service
        self.serviceHitForSongsList()
        
        //Set UI
        self.setUI()
    }
    
    //MARK:- SETUI
    func setUI(){
        self.btn_refresh.layer.cornerRadius = 5.0
        
        // set up activity indicator
        self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        self.activityIndicator.color = UIColor.blue
        self.view.addSubview(activityIndicator)
    }
    
    //Check Internet Connection
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    //MARK:- IBACTIONS
    @IBAction func btn_refresh(_ sender: UIButton) {
        self.serviceHitForSongsList()
    }
    
}

//TableView Delegate & TableViewDataSource
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsListObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView_listOfSongs.dequeueReusableCell(withIdentifier: "SongsListTableViewCell") as! SongsListTableViewCell
        cell.selectionStyle = .none
        
        //Populate Data
        cell.populateData(obj: self.songsListObj[indexPath.row])
        
        //CallBack On Details Pressed
        cell.callbackOnViewDetailsPressed = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
                detailsViewController.songDetailsObj = self.songsListObj[indexPath.row]
                self.present(detailsViewController, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Fix Height
        return 135
        // Dynamic Height
        // return UITableView.automaticDimension
    }
}

//MARK:- SERVICE HIT
extension ViewController {
    //Get Songs List
    func serviceHitForSongsList(){
        
        if !isConnectedToNetwork(){
            print("No Internet Connection")
            return
        }
        
        //Activity Indicator
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
        }
        //URL
        guard let url = URL(string: "https://itunes.apple.com/search?term=Michael+jackson") else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async{
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
            }
            
            if error != nil || data == nil {
                print("Error")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
                
                if let data = json as? [String:Any]{
                    //ResultData
                    
                    if let resultData = data["results"] as? [[String: Any]] {
                        _ = resultData.map { self.songsListObj.append(SongsListModel(dic: $0)) }
                        DispatchQueue.main.async{
                            self.tableView_listOfSongs.reloadData()
                        }
                    }
                    
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
