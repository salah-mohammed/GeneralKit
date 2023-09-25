//
//  Validate.swift
//  SalahUtility
//
//  Created by SalahMohamed on 18/10/2022.
//  Copyright © 2022 Salah. All rights reserved.
//
#if os(iOS)
import UIKit
#endif

public class Validate: NSObject {
    public class func fieldRequired(_ value:String)->String?{
      return  String.init(format: "FieldRequired".internalLocalize_, arguments:[value])
    }
    public class func required(_ value:String)->String?{
      return  String.init(format: "Required".internalLocalize_, arguments:[value])
    }
    public class func fieldNotValid(_ value:String)->String?{
      return  String.init(format: "NotValid".internalLocalize_, arguments:[value])
    }
    public class func pleaseEnter(_ value:String)->String?{
      return  String.init(format: "PleaseEnter".internalLocalize_, arguments:[value])
    }
    public class func pleaseChoose(_ value:String)->String?{
      return  String.init(format: "PleaseChoose".internalLocalize_, arguments:[value])
    }
    public class func fileSizeLessThanMB(_ value:String)->String?{
      return  String.init(format: "FileSizeLessThanMB".internalLocalize_, arguments:[value])
    }
    public class func EnterAllFields(_ fields:[Any?])->String?{
        for fieldItem in fields{
            if fieldItem == nil || (fieldItem as? String)?.isEmpty ?? false == true{
                return Validate.EnterAllFields()
            }
        }
        return nil;
    }
    public class func EnterAllFields()->String{
    return "EnterAllFields".internalLocalize_
    }
    func newPassword(_ newPassword:String?)->String?{
        if newPassword?.isEmpty ?? true{
            return Validate.fieldRequired(AppTexts.NewPassword);
        }else
        if (newPassword?.count ?? 0) < 6 {
            return AppTexts.PasswordMustHave6
        }
        return nil
    }
    public class func confirmPaswword(_ password:String?,_ confirmPassword:String?)->String?{
        if password?.isEmpty ?? true{
            return Validate.fieldRequired(AppTexts.ConfirmPassword);
        }else
        if confirmPassword != password {
            return AppTexts.PasswordNotMatch
        }
        return nil
    }
    public class func email(_ email:String?)->String?{
       if  RegularExpression.email.regex.matches(input:email ?? "")==false {
           return Validate.fieldNotValid(AppTexts.Email)
       }
        return nil
    }
}
