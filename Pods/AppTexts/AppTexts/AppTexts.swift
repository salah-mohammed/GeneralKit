//
//  AppTexts.swift
//  AppTexts
//
//  Created by Salah on 11/30/21.
//  Copyright © 2021 Salah. All rights reserved.
//

import UIKit

public extension UIUserInterfaceStyle {
    var bs_title:String?{
        switch self {
        case .unspecified:
            return "UIUserInterfaceStyle.unspecified.bs_title".internalLocalize_;
        case .light:
            return "UIUserInterfaceStyle.light.bs_title".internalLocalize_;
        case .dark:
            return "UIUserInterfaceStyle.dark.bs_title".internalLocalize_;
        default:
            break;
        }
        return nil
    }
}
public enum FireBaseError:String{
 case tooMany="TooManyFirebaseRequests"
 case required="PhoneNumberIsRequired"
 case notValid="PhoneNumberIsNotValid"
 case connectionError="ConnectionError"
 case verificationCodeError="VerificationCodeError"
    public func string(_ value:String)->String{
    return self.rawValue.internalLocalize_
    }
}
public enum QuestionMessage:String{
case delete="General.QuestionYesNo.Delete"
case add="General.QuestionYesNo.Add"
case edit="General.QuestionYesNo.Edit"
case save="General.QuestionYesNo.Save"
case send="General.QuestionYesNo.Send"
case change="General.QuestionYesNo.Change"
case cutome="General.QuestionYesNo"
    public func string(_ value:String)->String{
    return String.init(format:self.rawValue.internalLocalize_, arguments:[value])
}
}
public enum DoneSuccessfully:String{
case deleted="General.Deleted.Successfully"
case Added="General.Added.Successfully"
case Edited="General.Edited.Successfully"
case Saved="General.Saved.Successfully"
case Sent="General.Sent.Successfully"
case Change="General.Change.Successfully"
case uploaded="General.Uploaded.Successfully"
func string(_ value:String?)->String{
    if let value:String=value{
        return String.init(format:self.rawValue.internalLocalize_, arguments:[value])
    }else{
        return "\(self.rawValue.internalLocalize_).New".internalLocalize_
    }
}
}
public class AppTexts: NSObject {
    // Constants
    public class var PasswordMustHave6:String{
        return "PasswordMustHave6".internalLocalize_
    }
    public class var NewPassword:String{
        return "NewPassword".internalLocalize_
    }
    public class var PasswordNotMatch:String{
        return "PasswordNotMatch".internalLocalize_
    }
    public class var CantNotOpenLink:String{
        return "CantNotOpenLink".internalLocalize_
    }
    public class var Choose:String{
        return "Choose".internalLocalize_
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
    public class var Send:String{
        return "Send".internalLocalize_
    }
    public class var Year:String{
        return "Year".internalLocalize_
    }
    public class var Clear:String{
        return "Clear".internalLocalize_
    }
    public class var Sort:String{
        return "Sort".internalLocalize_
    }
    public class var SortBy:String{
        return "SortBy".internalLocalize_
    }
    public class var Home:String{
        return "Home".internalLocalize_
    }
    public class var SeeAll:String{
        return "SeeAll".internalLocalize_
    }
    public class var Favorite:String{
        return "Favorite".internalLocalize_
    }
    public class var Signin:String{
        return "Signin".internalLocalize_
    }
    public class var Change:String{
        return "Change".internalLocalize_
    }
    public class var Edit:String{
        return "Edit".internalLocalize_
    }
    func KM(value:String)->String{
    return String.init(format: "KM".internalLocalize_, arguments:[value])
    }
    public class var ShowMore:String{
        return "ShowMore".internalLocalize_
    }
    public class var ShowLess:String{
        return "ShowLess".internalLocalize_
    }
    public class var Filter:String{
        return "Filter".internalLocalize_
    }
    public class var SearchResult:String{
        return "SearchResult".internalLocalize_
    }
    public class var Add:String{
        return "Add".internalLocalize_
    }
    public class var Back:String{
        return "Back".internalLocalize_
    }
    public class var Activate:String{
        return "Activate".internalLocalize_
    }
    public class var Next:String{
        return "Next".internalLocalize_
    }
    public class var Previous:String{
        return "Previous".internalLocalize_
    }
    public class var WriteAComment:String{
        return "WriteAComment".internalLocalize_
    }
    public class var Attachments:String{
        return "Attachments".internalLocalize_
    }
    public class var Continue:String{
        return "Continue".internalLocalize_
    }
    public class var ClearAll:String{
        return "ClearAll".internalLocalize_
    }
    public class var File:String{
        return "File".internalLocalize_
    }
    public class var Photo:String{
        return "Photo".internalLocalize_
    }
    public class var ProfilePicture:String{
        return "ProfilePicture".internalLocalize_
    }
    // Alerts
    public class var LogoutConfirmation:String{
        return "AlertMessageLogoutConfirmation".internalLocalize_
    }
    public class var Unauthorized:String{
        return "Unauthorized".internalLocalize_
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
    public class var Login:String{
        return "Login".internalLocalize_
    }
    public class var Register:String{
        return "Register".internalLocalize_
    }
    public class var Profile:String{
        return "Profile".internalLocalize_
    }
    public class var EditProfile:String{
        return "EditProfile".internalLocalize_
    }
    public class var Search:String{
        return "Search".internalLocalize_
    }
    public class var Language:String{
        return "Language".internalLocalize_
    }
    public class var From:String{
        return "From".internalLocalize_
    }
    public class var To:String{
        return "To".internalLocalize_
    }
    public class var Registration:String{
        return "Registration".internalLocalize_
    }
    public class var Chat:String{
        return "Chat".internalLocalize_
    }
    public class var AccountInformation:String{
        return "AccountInformation".internalLocalize_
    }
    public class var Skip:String{
        return "Skip".internalLocalize_
    }
    public class var Join:String{
        return "Join".internalLocalize_
    }
    public class var Delete:String{
        return "Delete".internalLocalize_
    }
    public class var PaymentSuccessful:String{
        return "PaymentSuccessful".internalLocalize_
    }
    public class var MyAccount:String{
        return "MyAccount".internalLocalize_
    }
    public class var Pending:String{
        return "Pending".internalLocalize_
    }
    public class var Confirmed:String{
        return "Confirmed".internalLocalize_
    }
    public class var Cancelled:String{
        return "Cancelled".internalLocalize_
    }
    public class var Unconfirmed:String{
        return "Unconfirmed".internalLocalize_
    }
    public class var Confirm:String{
        return "Confirm".internalLocalize_
    }
    public class var Version:String{
        return "Version".internalLocalize_
    }
    public class var ForgotPassword:String{
        return "ForgotPassword".internalLocalize_
    }
    public class var Male:String{
        return "Male".internalLocalize_
    }
    public class var Female:String{
        return "Female".internalLocalize_
    }
    public class var Other:String{
        return "Other".internalLocalize_
    }
    public class var Verfiy:String{
        return "Verfiy".internalLocalize_
    }
    public class var AppLanguage:String{
        return "AppLanguage".internalLocalize_
    }
    public class var ShareApp:String{
        return "ShareApp".internalLocalize_
    }
    public class var ChangePassword:String{
        return "ChangePassword".internalLocalize_
    }
    public class var ResendVerificationCode:String{
        return "ResendVerificationCode".internalLocalize_
    }
    public class var CompleteProfile:String{
        return "CompleteProfile".internalLocalize_
    }
    public class var Instructions:String{
        return "Instructions".internalLocalize_
    }
    public class var RateUs:String{
        return "RateUs".internalLocalize_
    }
    public class var Price:String{
        return "Price".internalLocalize_
    }
    public class var ExpiryDate:String{
        return "ExpiryDate".internalLocalize_
    }
    public class var UsagePolicy:String{
        return "UsagePolicy".internalLocalize_
    }
    public class var Verification:String{
        return "Verification".internalLocalize_
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
    public class var ConfirmPassword:String{
        return "ConfirmPassword".internalLocalize_
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
    public class var Location:String{
        return "Location".internalLocalize_
    }
    public class var Requirements:String{
        return "Requirements".internalLocalize_
    }
    public class var MessageTitle:String{
        return "MessageTitle".internalLocalize_
    }
    public class var MessageBody:String{
        return "MessageBody".internalLocalize_
    }
    public class var VerificationCode:String{
        return "VerificationCode".internalLocalize_
    }
    public class var Country:String{
        return "Country".internalLocalize_
    }
    public class var ChatTextMessagePlaceholder:String{
        return "ChatTextMessagePlaceholder".internalLocalize_
    }
    public class var GeneralMessage:String{
        return "General.Message".internalLocalize_
    }
    public class var AddressOnMap:String{
        return "AddressOnMap".internalLocalize_
    }
    public class var CurrentLocation:String{
        return "CurrentLocation".internalLocalize_
    }
    public class var SearchHere:String{
        return "SearchHere".internalLocalize_
    }
    public class var Nationality:String{
        return "Nationality".internalLocalize_
    }
    public class var DrivingLicense:String{
        return "DrivingLicense".internalLocalize_
    }
    public class var BirthCertificate:String{
        return "BirthCertificate".internalLocalize_
    }
    public class var UniversityCertificate:String{
        return "UniversityCertificate".internalLocalize_
    }
    public class var Governorate:String{
        return "Governorate".internalLocalize_
    }
    public class var Street:String{
        return "Street".internalLocalize_
    }
    public class var Neighborhood:String{
        return "Neighborhood".internalLocalize_
    }
    public class var ApartmentNo:String{
        return "ApartmentNo".internalLocalize_
    }
    public class var BuildingNo:String{
        return "BuildingNo".internalLocalize_
    }
    public class var FloorNo:String{
        return "FloorNo".internalLocalize_
    }
}
