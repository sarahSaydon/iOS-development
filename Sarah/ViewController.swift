//
//  ViewController.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 26/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit
import CoreData

var nameArray = [Album]()
var deletedArray = [Album]()
var searchAlbum = [Album]()
var searching = false
var myIndex = 0
var deleteSelected = false
var indexToDelete = 0
var mediaSelected = false
var isOrientationPortrait = true
 var searchDeletedIndex = 0
var termSearch = "Jack Johnson"

class ViewController: UIViewController,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {
  @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBAction func btnDeleteRecord(_ sender: UIButton) {
     let point = sender.convert(CGPoint.zero,to: albumTableView)
        guard let indexPath = albumTableView.indexPathForRow(at: point) else {
        return
        }
      
        //storing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
 
         let newDeleteRecord = NSEntityDescription.insertNewObject(forEntityName:"RecordsDeleted", into: context)
         newDeleteRecord.setValue(nameArray[indexPath.row].artist, forKey: "artistName")
         newDeleteRecord.setValue(nameArray[indexPath.row].trackId, forKey: "trackName")
       
        deletedArray.append(nameArray[indexPath.row])
        nameArray.remove(at: indexPath.row)
        if indexPath.row == 0
        {
            albumTableView.deleteRows(at: [indexPath], with: .left)
        }
        else
        {
        albumTableView.deleteRows(at: [indexPath], with: .left)
        }
        deleteSelected = false

         
         do{
         try context.save()
         print("saved")
            print("Deleted + " , DeletedTrackName)
            print("Deleted + " , DeletedArtistName)
         }
         catch{
         //
         }
    }

    @IBAction func btnDelete(_ sender: Any) {
    }
    
    @IBAction func btnShowPopUp(_ sender: Any) {
        
        let popOverVc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "sbPopUpId") as! PopUpViewController
        
        self.addChildViewController(popOverVc)
        popOverVc.view.frame = self.view.frame
        self.view.addSubview(popOverVc.view)
        popOverVc.didMove(toParentViewController: self)
    }
    
    //A string array to save all the names


    func setUpNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        
        //check if record was deleted
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var alreadyDeleted = false
        var alreadyDeletedArtist = false
        var alreadyDeletedTrack = false
        
        //check if already stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsDeleted")
        
        let escapedStringTerm = termSearch.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        //creating a NSURL
        let url = URL(string:"https://itunes.apple.com/search?term=\(escapedStringTerm!)&media=all&limit=100")
            //https://itunes.apple.com/search?term=JackJohnson&media=music&limit=100")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
              //  print(jsonObj!.value(forKey: "results")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let resultArray = jsonObj!.value(forKey: "results") as? NSArray {
                    //looping through all the elements
                    for result in resultArray{
                        
                        //converting the element to a dictionary
                        if let resultDict = result as? NSDictionary {
                            
                            //getting the name from the dictionary
                            if let name = resultDict.value(forKey: "trackName") {
                                 let trackNameMain = resultDict["trackName"] as! String
                                let artist = resultDict["artistName"] as! String
                                let artworkURL = resultDict["artworkUrl60"] as! String
                                let artworkURLLarge = resultDict["artworkUrl100"] as! String
                                let albumTitle = resultDict["trackCensoredName"] as! String
                                let genre = resultDict["primaryGenreName"] as! String
                                let trackName = resultDict["trackName"] as! String
                                alreadyDeleted = false
                                request.returnsObjectsAsFaults = false
                                do{
                                    let results = try context.fetch(request)
                                    if results.count > 0
                                    {
                                        for result in results as! [NSManagedObject]{
                                            if let trackName = result.value(forKey: "trackName") as? String
                                            {
                                                if trackName == trackNameMain
                                                {
                                                    alreadyDeletedTrack = true
                                                    
                                                }
                                                
                                            }
                                            
                                            if let artistName = result.value(forKey: "artistName") as? String
                                            {
                                                
                                                if artistName ==  artist
                                                {
                                                    alreadyDeletedArtist = true
                                                }
                                                
                                                if ((alreadyDeletedArtist == true) && (alreadyDeletedTrack == true))
                                                {
                                                    
                                                    alreadyDeletedArtist = false
                                                    alreadyDeletedTrack = false
                                                    alreadyDeleted = true
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                catch{
                                    //
                                }
                                
                                if alreadyDeleted == false{
                                let album = Album(title:albumTitle,artist:artist,genre:genre,artworkURL:artworkURL,trackId:trackName,artworkURLLarge: artworkURLLarge,selected:false)
                                
                                //adding the name to the array
                                nameArray.append(album)
                                }
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                  //  self.showNames()
                    self.albumTableView.reloadData()
                    print(nameArray.count)
                })
            }
        }).resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searching
        {
            //get number of records
            return(searchAlbum.count)
        }
        else
        {
            //get number of records
            return(nameArray.count)
        }
       
        
    }
    
    var DeletedTrackName:[String] = []
    var DeletedArtistName:[String] = []
    
    
    var SelectedTrackName:[String] = []
    var SelectedArtistName:[String] = []
    
    
    private let cellReuseIdentifier: String = "cell"
var searchingIndex = 0
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape1")
            isOrientationPortrait = false
            //  albumTableView.reloadData()
        } else {
            print("Portrait1")
            isOrientationPortrait = true
            //albumTableView.reloadData()
            
        }
        
        var albumArray: [Album] = []
        var cell = albumTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! ViewControllerTableViewCell
        
        do{
      
        //var cell:UITableViewCell? = albumTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            if (cell == nil) {
                cell = UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier:cellReuseIdentifier) as! ViewControllerTableViewCell
            }
       
        
        if searching
        {
            if(deleteSelected == true)
            {
                searchDeletedIndex = searchingIndex
                if(cell.btnDeleteStatus != nil)
                {
                    cell.btnDeleteStatus?.isHidden = false
                }
                else
                {
                    
                }
            }
            else
            {
                searchDeletedIndex = indexPath.row
            }
           // searchingIndex = indexPath.row
            cell.lblAlbum.text = searchAlbum[searchDeletedIndex].title
            cell.lblArtist.text = searchAlbum[searchDeletedIndex].trackId
            cell.btnDeleteStatus.isHidden = false
    
            let url = URL(string: searchAlbum[searchDeletedIndex].artworkURL)
            let data = try? Data(contentsOf: url!)
    
            if data==nil
            {}
            else{
                cell.imgAlbum.image = UIImage(data: data!)}
            if ((deleteSelected == true) && (indexPath.row == indexToDelete))
            {
                if(cell.btnDeleteStatus != nil)
                {
                    cell.btnDeleteStatus?.isHidden = false
                }
             
            }
            else
            {
                cell.btnDeleteStatus?.isHidden = true
            }
  
        }
        else
        {
         
            if(nameArray.count > 0)
            {
                //add try
            cell.lblAlbum.text = nameArray[indexPath.row].title
            cell.lblArtist.text = nameArray[indexPath.row].trackId
                if deleteSelected == true && indexPath.row == indexToDelete{
                    if(cell.btnDeleteStatus != nil)
                    {
                    cell.btnDeleteStatus.isHidden = false
                    }
                }
                let url = URL(string: nameArray[indexPath.row].artworkURL)
                let data = try? Data(contentsOf: url!)
                
                if data==nil
                {}
                else{
                    cell.imgAlbum.image = UIImage(data: data!)
                    
                    }
            if isOrientationPortrait == false
            {
                cell.lblAlbum.text = ""
            }
               
            //check if record was selected in the past
      
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            var alreadySaved = false
            var alreadySavedArtist = false
            var alreadySavedTrack = false
            
            //check if already stored
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsSelected")
            
            request.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(request)
                if results.count > 0
                {
                    for result in results as! [NSManagedObject]{
                        if let trackNameSelected = result.value(forKey: "trackName") as? String
                        {
                            if trackNameSelected == nameArray[indexPath.row].trackId
                            {
                                alreadySavedTrack = true
                                SelectedTrackName.append(trackNameSelected)
                            }
                            
                        }
                        
                        if let artistNameSelected = result.value(forKey: "artistName") as? String
                        {
                            
                            if artistNameSelected ==  nameArray[indexPath.row].artist
                            {
                                alreadySavedArtist = true
                                SelectedArtistName.append(artistNameSelected)
                            }
                            
                            
                            
                        }
        
                        if ((alreadySavedArtist == true) && (alreadySavedTrack == true))
                        {
                             cell.backgroundColor = UIColor.gray
                            cell.btnDeleteStatus?.isHidden = true
                    
                        } else {
                            cell.backgroundColor = UIColor.white
                            cell.btnDeleteStatus?.isHidden = true
                           
                        }
                        if (deleteSelected == true && indexPath.row == indexToDelete)
                        {
                            if(cell.btnDeleteStatus != nil)
                            {
                            cell.btnDeleteStatus?.isHidden = false
                            }
                            else
                            {
                                
                            }
                        }
                        
                    }
                }
          
                
            }
            catch{
                //
            }
                
            
        }
            }
            
        }
        catch
        {
            print("error while updating cells")
        }
   
        
        return(cell)
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching == true
        {
             myIndex = searchingIndex
        }
        else
        {
        myIndex = indexPath.row
        }
        nameArray[myIndex].selected = true
        
        //storing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var alreadySaved = false
        var alreadySavedArtist = false
         var alreadySavedTrack = false
        
        //check if already stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsSelected")
        
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]{
                    if let trackName = result.value(forKey: "trackName") as? String
                    {
                        if trackName != nameArray[myIndex].trackId
                        {
                        SelectedTrackName.append(trackName)
                        }
                        else
                        {
                            alreadySavedTrack = true
                        }
                    }
                    
                    if let artistName = result.value(forKey: "artistName") as? String
                    {
                        
                        if artistName !=  nameArray[myIndex].artist
                        {
                        SelectedArtistName.append(artistName)
                        }
                        else
                        {
                            alreadySavedArtist = true
                        }
                        
                        if ((alreadySavedArtist == true) && (alreadySavedTrack == true))
                        {
                            alreadySaved = true
                            alreadySavedArtist = false
                            alreadySavedTrack = false
                        }
                    }
                   
                }
            }
            
        }
        catch{
            //
            print("error while selecting cell")
        }
        //if already save, do not store again
        if alreadySaved == false
        {
            let newSelectedRecord = NSEntityDescription.insertNewObject(forEntityName:"RecordsSelected", into: context)
            newSelectedRecord.setValue(nameArray[myIndex].artist, forKey: "artistName")
            newSelectedRecord.setValue(nameArray[myIndex].trackId, forKey: "trackName")
           
            do{
                try context.save()
                print("saved")
            }
            catch{
                //
                print("error while saving core data selected records")
            }
        }
        
        performSegue(withIdentifier: "segue", sender: self)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            nameArray.remove(at: indexPath.row)
            albumTableView.reloadData()
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var ResultScrollView: UIScrollView!
    
    var numberOfItems = 0
    var albumName = ""
    var artistName = ""
     var trackName = ""
    
    var data : Data?
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            isOrientationPortrait = false
        albumTableView.reloadData()
        } else {
            print("Portrait")
            isOrientationPortrait = true
            albumTableView.reloadData()
     
        }
    }
    func getDeletedRecords()
    {
        //get stored data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requestDeleted = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsDeleted")
        
        requestDeleted.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(requestDeleted)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]{
                    if let trackName = result.value(forKey: "trackName") as? String
                    {
                        DeletedTrackName.append(trackName)
                        // print (trackName)
                    }
                    
                    if let artistName = result.value(forKey: "artistName") as? String
                    {
                        DeletedArtistName.append(artistName)
                    }
                    
                  
                }
                print("Deleted + " , DeletedTrackName)
                print("Deleted + " , DeletedArtistName)
               
            }
            
        }
        catch{
            //
            print("error while retrieving core data for deleted records")
        }
    }
    
    func getSelectedRecords()
    {
        //get stored data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requestDeleted = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsSelected")
        
        requestDeleted.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(requestDeleted)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]{
                    if let trackName = result.value(forKey: "trackName") as? String
                    {
                        SelectedTrackName.append(trackName)
                        // print (trackName)
                    }
                    
                    if let artistName = result.value(forKey: "artistName") as? String
                    {
                        SelectedArtistName.append(artistName)
                    }
                    
                   
                }
                print(SelectedTrackName)
                print(SelectedArtistName)
               
            }
            
        }
        catch{
            //
            print("error while retreiving selected records")
        }
    }
    
    
    var searchBarText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSelectedRecords()
        getDeletedRecords()
      if(termSearch == "")
      {
            termSearch = "Jack Johnson"
        }
        searchBar.text = termSearch
     //  pageIndicator.numberOfPages = 0
         navBar.topItem?.title = "Main page"
      //  ResultScrollView.delegate = self
    
        self.albumTableView.estimatedRowHeight = 100
        self.albumTableView.rowHeight = UITableViewAutomaticDimension
        
        if mediaSelected == false && nameArray.count == 0
        {
            getJsonFromUrl()
           //ItunesConnection().getJsonFromUrl()
            albumTableView.reloadData()
        }
     
        
        
        albumTableView.delegate = self
        albumTableView.dataSource = self
 
     //   NotificationCenter.default.addObserver(self.albumTableView, selector: #selector(UITableView.reloadData), name: .UIContentSizeCategoryDidChange, object: nil)
  
    }

    @IBAction func searchMusic(_ sender: UIButton) {
    
      
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      //  let page = Int(ResultScrollView.contentOffset.x / ResultScrollView.frame.size.width)
       // pageIndicator.currentPage = page
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
 var i = 0
 var rIndex = 0
fileprivate let syncQueue = DispatchQueue(label: "Downloader.syncQueue")
    extension ViewController: UISearchBarDelegate{
        func searchBar(_ searchBar:UISearchBar,textDidChange searchText: String)
        {
            termSearch = searchText
            syncQueue.sync {
                 ItunesConnection().getJsonFromUrlSearch(searchString: searchText)
                searchAlbum = nameArray.filter{$0.trackId.description.lowercased().prefix(searchText.count) == searchText.lowercased()}
                //  searching = true
                sleep(2)
                albumTableView.reloadData()
                
                print("done")
            }
 
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searching = false
            searchBar.text = ""
            albumTableView.reloadData()
        
        }
    }



