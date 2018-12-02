//
//  ItunesConnection.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 27/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit
import CoreData

class ItunesConnection: NSObject {

   
    class func getAlbumForString(searchString:String,completionHandler:@escaping (Album)->())
    {
        //https://itunes.apple.com/search?term=frozen&media=music
        let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        let url = URL(string:"https://itunes.apple.com/search?term=\(escapedString!)&media=music&limit=100")
        
        let task = URLSession.shared.dataTask(with: url! , completionHandler:{ (data:Data!,response:URLResponse! , error:Error!)-> Void in
             if error == nil{
             
                let itunesDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                
                let resultsArray = itunesDict?.object(forKey: "results") as! [Dictionary<String,AnyObject>]
        
                if resultsArray.count > 0
                {
                 //   for itemResult in resultsArray{
                    if let resultDict = resultsArray.first
                    {
                        let artist = resultDict["artistName"] as! String
                        let artworkURL = resultDict["artworkUrl30"] as! String
                         let artworkURLLarge = resultDict["artworkUrl30"] as! String
                        let albumTitle = resultDict["collectionName"] as! String
                        let genre = resultDict["primaryGenreName"] as! String
                        let album = Album(title:albumTitle,artist:artist,genre:genre,artworkURL:artworkURL,trackId:"123",artworkURLLarge:artworkURLLarge, selected: false)
                        completionHandler(album)
                    
                    }
                       //    }
                }
               
            print(itunesDict)
            }
        })
        task.resume()
    
    }
  //   var nameArray = [Album]()
    func getJsonFromUrlMedia(searchString:String){
        mediaSelected = true
        //check if record was deleted
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var alreadyDeleted = false
        var alreadyDeletedArtist = false
        var alreadyDeletedTrack = false
        
        //check if already stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsDeleted")
        
        
        //creating a NSURL
        let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        let url = URL(string:"https://itunes.apple.com/search?term=frozen&media=\(escapedString!)")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "results")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let resultArray = jsonObj!.value(forKey: "results") as? NSArray {
                     nameArray = [Album]()
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
                                let albumTitle = resultDict["country"] as! String
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
                                let album = Album(title:albumTitle,artist:artist,genre:genre,artworkURL:artworkURL,trackId:trackName,artworkURLLarge:artworkURLLarge, selected: false)
                            
                                //adding the name to the array
                                nameArray.append(album)
                                }
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                  
                  //  self.albumTableView.reloadData()
                    print(nameArray.count)
                })
            }
        }).resume()
    }
    func getJsonFromUrlSearch(searchString:String){
     //   mediaSelected = true
        //check if record was deleted
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var alreadyDeleted = false
        var alreadyDeletedArtist = false
        var alreadyDeletedTrack = false
        
        //check if already stored
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordsDeleted")
        
        
        //creating a NSURL
        let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        let url = URL(string:"https://itunes.apple.com/search?term=\(escapedString!)&media=all&limit=100")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "results")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let resultArray = jsonObj!.value(forKey: "results") as? NSArray {
                    nameArray = [Album]()
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
                                let albumTitle = resultDict["country"] as! String
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
                                    let album = Album(title:albumTitle,artist:artist,genre:genre,artworkURL:artworkURL,trackId:trackName,artworkURLLarge:artworkURLLarge, selected: false)
                                    
                                    //adding the name to the array
                                    nameArray.append(album)
                                }
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    
                    //  self.albumTableView.reloadData()
                    print(nameArray.count)
                })
            }
        }).resume()
    }
    
    class func getAlbums(searchString:String,completionHandler:@escaping ( [Album]) -> [Album] )
    {
        var albumArray: [Album] = []
        //https://itunes.apple.com/search?term=frozen&media=music
        let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        let url = URL(string:"https://itunes.apple.com/search?term=\(escapedString!)&media=music&limit=10")
        
        let task = URLSession.shared.dataTask(with: url! , completionHandler:{ (data:Data!,response:URLResponse! , error:Error!)-> Void in
            if error == nil{
                
                let itunesDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                
                let resultsArray = itunesDict?.object(forKey: "results") as! [Dictionary<String,AnyObject>]
                
                if resultsArray.count > 0
                {
                       for itemResult in resultsArray{
                
                        let artist = itemResult["artistName"] as! String
                        let artworkURL = itemResult["artworkUrl30"] as! String
                         let artworkURLLarge = itemResult["artworkUrl30"] as! String
                        let albumTitle = itemResult["collectionName"] as! String
                        let genre = itemResult["primaryGenreName"] as! String
                        let trackName = itemResult["trackName"] as! String
                        let album = Album(title:albumTitle,artist:artist,genre:genre,artworkURL:artworkURL,trackId:trackName,artworkURLLarge:artworkURLLarge,selected: false)
                        albumArray.append(album)
                        completionHandler(albumArray)
                        
                    
                       }
                }
                
                print(itunesDict)
            }
        })
        task.resume()
        
    }
    
}
