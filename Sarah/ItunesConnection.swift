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
                  //albumTableView.reloadData()
                    print(nameArray.count)
                })
            }
        }).resume()
    }
    
    func getJsonFromUrlMedia(searchString:String,mediaString:String){
       
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
        let escapedStringMedia = mediaString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
         do{
        let url = URL(string:"https://itunes.apple.com/search?term=\(escapedString!)&media=\(escapedStringMedia!)&limit=100")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if (data != nil)
            {
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
            }
            else
            {
                print("kindly check your connection")
            }
        }).resume()
        }
        
        catch
        {
            print("error while retreving media selected ")
        }
    
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
}

