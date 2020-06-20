//
//  EmoRecord.swift
//  emoteen
//
//  Created by Douglas Purdy on 6/14/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import Foundation
import SwiftyJSON
import CalendarKit

extension Date
{
    var emoDate : String
    {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = Self.emoFormat
            return formatter.string(from: self)
        }
    }
    
    static var emoFormat : String
    {
        get {
            return "yyyy-MM-dd'T'HH:mm:ss"
        }
    }
}

public enum EmoType : String {
    case Journal = "journal"
    case Meditation = "meditation"
}

public class EmoRecord : Codable
{
    public var Title : String = ""
    public var EmoType : String = ""
    public var Body : String = ""
    public var Start : Date = Date()
    public var End : Date = Date()
    
    public init(type: EmoType, title: String, body: String)
    {
        self.EmoType = type.rawValue
        self.Title = title
        self.Body = body
    }
    
    public init(_ json: JSON)  {
        
        if let title = json["title"].string
        {
            self.Title = title
        }
        
        if let type = json["type"].string
        {
            self.EmoType = type
        }
        
        if let start = json["start"].string
        {
            self.Start = Date(dateString: start, format: Date.emoFormat)
        }
        
        if let end = json["end"].string
        {
            self.End = Date(dateString: end, format: Date.emoFormat)
        }
        
        if let body = json["body"].string
        {
            self.Body = body
        }
        
    }
    
    public init(_ title : String,
                _ type : String,
                _ body : String,
                _ start : Date,
                _ end : Date)
    {
        self.Title = title
        self.EmoType = type
        self.Body = body
        self.End = end
        self.Start = start
    }
        
    static var containerUrl: URL?
    {
          return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
      
    func save()
    {
        if let url = Self.containerUrl, !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
              do {
                  try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
              }
              catch {
                  print(error.localizedDescription)
              }
          }
        do
        {
            let file = Self.containerUrl!.appendingPathComponent("\(self.Start.emoDate)" + ".emo")
            
            let json = JSON(self.toJSON())
            
            try json.rawString()!.write(to: file, atomically: true, encoding: .utf8)
        
        }
        catch
        {
            print(error)
        }

    }
    
    func delete()
    {
        do
        {
            let file = Self.containerUrl!.appendingPathComponent("\(self.Start.emoDate)" + ".emo")
            
            try FileManager.default.removeItem(at: file)
        }
        catch
        {
            print(error)
        }
    }
    
    func toJSON() -> JSON
    {
        var json = JSON(parseJSON: "{}")
        json["title"].string = self.Title
        json["type"].string = self.EmoType
        json["start"].string = self.Start.emoDate
        json["end"].string = self.End.emoDate
        json["body"].string = self.Body

        return json
    }
        
    static func load() -> [EmoRecord]
    {
        var records = [EmoRecord]()
        
        if let url = Self.containerUrl
        {
            let files = try! FileManager.default.contentsOfDirectory(atPath: url.path)
            
            for file in files
            {
                if(file.contains(".emo") && !file.starts(with: "."))
                {
                    let fileUrl = Self.containerUrl!.appendingPathComponent(file)
                    
                    do {
                    
                        let data = try FileManager.default.contents(atPath: fileUrl.path)!
            
                        let record = EmoRecord(try JSON(data: data))
                        
                        records.append(record)
                        
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        return records
    }
    
}
