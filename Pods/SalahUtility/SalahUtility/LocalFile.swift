//
//  LocalFile.swift
//  SalahUtility
//
//  Created by SalahMohamed on 22/02/2023.
//  Copyright © 2023 Salah. All rights reserved.
//

import UIKit


public enum LocalFile{
 case url(URL)
 case bundle(forResource:String,ofType:String)
 case file(searchPathDirectory:FileManager.SearchPathDirectory? = .documentDirectory,
                folderName:String?,
                localeFileName:String,
                fileType:String)
    public var url:URL?{
        switch self{
        case .url(let url):
            return url
        case .file(searchPathDirectory:let searchPathDirectory,
                        folderName: let folderName,
                        localeFileName: let localeFileName,
                        fileType: let fileType):
            return URL.bs_genrateLocalFile(searchPathDirectory ?? .documentDirectory,
                                        folderName,
                                        fileType,
                                        localeFileName,true);
        case .bundle(forResource: let forResource, ofType: let ofType):
            if let  path:String = Bundle.main.path(forResource:forResource, ofType:ofType){
             return URL.init(fileURLWithPath:path)
            }
            return nil
        }
    }
    public var stringUrl:String?{
        switch self{
        case .url(let url):
            return url.path
        case .file(searchPathDirectory:let searchPathDirectory,
                        folderName: let folderName,
                        localeFileName: let localeFileName,
                        fileType: let fileType):
            return URL.bs_genrateLocalFile(searchPathDirectory ?? .documentDirectory,
                                        folderName,
                                        fileType,
                                           localeFileName,true)?.path;
        case .bundle(forResource: let forResource,ofType:let ofType):
            if let  path:String = Bundle.main.path(forResource:forResource, ofType:ofType){
             return path
            }
            return nil
        }
    }
}
open class FileBuilder{
    open func copy()->FileBuilder{
        let copyFileBuilder = FileBuilder.init(self.operationType);
        copyFileBuilder.operationType=self.operationType
        copyFileBuilder.folders=self.folders
        copyFileBuilder.searchPathDirectory=self.searchPathDirectory
        copyFileBuilder.fileType=self.fileType
        copyFileBuilder.fileName=self.fileName
        copyFileBuilder.create=self.create
        return copyFileBuilder
    }
    public enum OperationType{
    case write(deleteIfExist:Bool,writtenType:WrittenType)
    case get(finish:((Data?)->Void)?=nil)
    case copy(deleteIfExist:Bool,from:URL)
    case remove
    }
    public enum WrittenType{
    case data(Data)
    case string(String)
    }
    var operationType:OperationType = .get()
    private var folders:[String]=[String]();
    private var searchPathDirectory:FileManager.SearchPathDirectory = .documentDirectory
    private var fileType:String?
    private var fileName:String?
    private var create:Bool=false;
    var genratedUrl:URL?
    private var folderPath:String?{
        if folders.count > 0{
            return folders.joined(separator:"/")
        }
        return nil
    }
    public init(_ operationType: OperationType) {
        self.operationType=operationType
        // open url
    }
    public init(_ genratedUrl:URL?,_ operationType: OperationType) {
     self.operationType=operationType
     self.genratedUrl=genratedUrl;
    }
    @discardableResult open func build()->Self{
    self.genratedUrl=URL.bs_genrateLocalFile(searchPathDirectory, self.folderPath,self.fileName,self.fileType, self.create)
    return self;
    }
    open func operationType(_ operationType:OperationType)->Self{
    self.operationType=operationType
    return self
    }
    open func searchPathDirectory(_ searchPathDirectory:FileManager.SearchPathDirectory)->Self{
    self.searchPathDirectory=searchPathDirectory
    return self
    }
    open func folders(_ folders:[String])->Self{
    self.folders.append(contentsOf:folders)
    return self
    }
    open func folder(_ folder:String)->Self{
    self.folders.append(folder)
    return self
    }
    open func fileType(_ fileType:String)->Self{
    self.fileType=fileType
    return self
    }
    open func fileName(_ fileName:String)->Self{
    self.fileName=fileName
    return self
    }
    open func create(_ create:Bool)->Self{
    self.create=create
    return self
    }
    @discardableResult open func execute()->URL?{
    self.genrate();
    return self.genratedUrl
    }
    private func genrate(){
        switch self.operationType{
        case .get(let handler):
            if let genratedUrl:URL = self.genratedUrl{
                handler?(try? Data.init(contentsOf: genratedUrl));
            }
            break;
        case .copy(let deleteIfExist,let fromUrl):
            if let genratedUrl:URL = self.genratedUrl{
               let _ = FileManager.default.bs_copyItem(deleteIfExist:deleteIfExist, at:fromUrl, to:genratedUrl)
            }
            break;
        case .write(let deleteIfExist,let writtenType):
          #if DEBUG
            if self.fileName == nil || self.fileType == nil {
                fatalError("you should enter file name and file type to write file")
            }
          #endif
            if let localUrl:URL = self.genratedUrl,
               let localPath:String=self.genratedUrl?.localPath{
            switch writtenType{
            case .data(let data):
                if deleteIfExist,FileManager.default.fileExists(atPath:localPath) {
                    try? FileManager.default.removeItem(at:localUrl)
                }
                try? data.write(to:localUrl)
                break;
            case .string(let string):
                try? string.write(toFile: localPath, atomically:deleteIfExist, encoding: .utf8)
                break;
            }
            }
            break;
        case .remove:
            if let localUrl:URL = self.genratedUrl{
            try? FileManager.default.removeItem(at:localUrl)
            }
            break;
        }
    }
}

extension URL{
    var localPath:String?{
        if #available(iOS 16.0, *) {
            return self.path()
        } else {
            return self.path
        }
    }
}



