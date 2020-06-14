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
            formatter.dateFormat = "yyyy.MM.dd'@'HH.mm"
            return formatter.string(from: self)
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
        
        if let title = json["title"].string {
            self.title = title
        }
        
    }
    
    static var containerUrl: URL?
      {
          return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
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
