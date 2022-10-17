//
//  Localize.swift
//  SalahUtility
//
//  Created by Salah on 11/30/21.
//  Copyright © 2021 Salah. All rights reserved.
//

import UIKit

public class Localize: NSObject {
    // Constants
    public class var CantNotOpenLink:String{
        return "CantNotOpenLink".internalLocalize_
    }
    public class var Choose:String{
        return "Choose".internalLocalize_
    }
    public class func FieldRequired(_ value:String)->String{
      return  String.init(format: "FieldRequired".internalLocalize_, arguments:[value])
    }
    public class var Ok:String{
        return "Ok".internalLocalize_
    }
    public class var Cancel:String{
        return "Cancel".internalLocalize_
    }
    public class var Done:String{
        return "Done".internalLocalize_
    }
    public class var Yes:String{
        return "Yes".internalLocalize_
    }
    public class var No:String{
        return "No".internalLocalize_
    }
    public class var Update:String{
        return "Update".internalLocalize_
    }
    public class var Save:String{
        return "Save".internalLocalize_
    }
    public class var Complete:String{
        return "Complete".internalLocalize_
    }
    public class var Verify:String{
        return "Verify".internalLocalize_
    }
    public class var Settings:String{
        return "Settings".internalLocalize_
    }
    public class var Appearance:String{
        return "Appearance".internalLocalize_
    }
    public class var DoneSuccessfully:String{
        return "DoneSuccessfully".internalLocalize_
    }
    public class var Attention:String{
        return "Attention".internalLocalize_
    }
    public class var Error:String{
        return "Error".internalLocalize_
    }
    public class var AnErrorOccurred:String{
        return "AnErrorOccurred".internalLocalize_
    }
    
    // Alerts
    public class var LogoutConfirmation:String{
        return "AlertMessageLogoutConfirmation".internalLocalize_
    }
    // Titles
    public class var ContactUs:String{
        return "ContactUs".internalLocalize_
    }
    public class var TermsAndConditions:String{
        return "TermsAndConditions".internalLocalize_
    }
    public class var Notifications:String{
        return "Notifications".internalLocalize_
    }
    public class var RateApp:String{
        return "RateApp".internalLocalize_
    }
    public class var AboutApp:String{
        return "AboutApp".internalLocalize_
    }
    public class var PrivacyPolicy:String{
        return "PrivacyPolicy".internalLocalize_
    }
    // Fields
    public class var FirstName:String{
        return "FirstName".internalLocalize_
    }
    public class var LastName:String{
        return "LastName".internalLocalize_
    }
    public class var FullName:String{
        return "FullName".internalLocalize_
    }
    public class var UserName:String{
        return "UserName".internalLocalize_
    }
    public class var Password:String{
        return "Password".internalLocalize_
    }
    public class var Address:String{
        return "Address".internalLocalize_
    }
    public class var AddressDetails:String{
        return "AddressDetails".internalLocalize_
    }
    public class var City:String{
        return "City".internalLocalize_
    }
    public class var Region:String{
        return "Region".internalLocalize_
    }
    public class var PhoneNumber:String{
        return "PhoneNumber".internalLocalize_
    }
    public class var Title:String{
        return "Title".internalLocalize_
    }
    public class var Description:String{
        return "Description".internalLocalize_
    }
    public class var Details:String{
        return "Details".internalLocalize_
    }
    public class var NoData:String{
        return "NoData".internalLocalize_
    }
    public class var Email:String{
        return "Email".internalLocalize_
    }
    public class var Gender:String{
        return "Gender".internalLocalize_
    }
    public class var DateOfBirth:String{
        return "DateOfBirth".internalLocalize_
    }
    public class var Version:String{
        return "Version".internalLocalize_
    }
    
}
