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

public class EmoRecord : Codable
{
    public var title : String = ""
    public var type : String = ""
    public var start : Date = Date()
    public var end : Date = Date()
    public var body : String = ""
    
    public init(_ json: JSON)  {
        
        if let title = json["title"].string
        {
            self.title = title
        }
        
        if let type = json["type"].string
        {
            self.type = type
        }
        
        if let start = json["start"].string
        {
            self.start = Date(dateString: start, format: Date.emoFormat)
        }
        
        if let end = json["end"].string
        {
            self.end = Date(dateString: end, format: Date.emoFormat)
        }
        
        if let body = json["body"].string
        {
            self.body = body
        }
        
    }
    
    public init(_ title : String, _ type : String, _ body : String, _ start : Date, _ end : Date)
    {
        self.title = title
        self.type = type
        self.body = body
        self.end = end
        self.start = start
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
            let file = Self.containerUrl!.appendingPathComponent("\(self.start.emoDate)" + ".emo")
            
            let json = JSON(self.toJSON())
            
            try json.rawString()!.write(to: file, atomically: true, encoding: .utf8)
        
        } catch {
            
        }

    }
    
    func toJSON() -> JSON
    {
        var json = JSON(parseJSON: "{}")
        json["title"].string = self.title
        json["type"].string = self.type
        json["start"].string = self.start.emoDate
        json["end"].string = self.end.emoDate
        json["body"].string = self.body

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
                        print("something went wrong")
                    }
                }
            }
        }
        
        return records
    }
    
}
