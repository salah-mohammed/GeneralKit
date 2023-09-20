# AppTexts

AppTexts used for make deal with business app more easier.

# Advantages of usage AppTexts:
* Constants Texts(Ok,Cancel,No,Yes,usernam,password,cond..&rules,Firebase, errors,..).
* Validation Messages(Error Messages).
* Success Messages.
* Quesstion Meesages.



# Requirements
* IOS 13+ 
* Swift 5+

# How used (configuration): 

# Pod install
```ruby
pod 'AppTexts',:git => "https://github.com/salah-mohammed/AppTexts.git"
 
```
- Constants Texts Example

```swift
    AppTexts.UserName   //result ->  //EN: UserName      //AR:اسم المستخدم
    AppTexts.FullName   //result ->  //EN:Fullname       //AR: الإسم الكامل
    AppTexts.Cancel     //result ->  //EN:Cancel       //AR: إلغاء
    AppTexts.Error      //result ->  //EN:Error       //AR: خطأ
    AppTexts.Ok         //result ->  //EN:Ok       //AR: تم
    AppTexts.Search     //result ->  //EN:Search       //AR: ابحث هنا
    AppTexts.SearchHere //result ->  //EN:Search here       //AR: 
    AppTexts.SeeAll     //result ->  //EN:See All       //AR:عرض المزيد
    AppTexts.Done       //result ->  //EN:Done       //AR:تم
    AppTexts.Skip       //result ->  //EN:skip       //AR: تخطي

```
- Validation Messages(Error Messages).
```swift
    Validate.fieldNotValid(AppTexts.UserName)  //result ->  //EN:Sorry, Invalid Username    //AR:عذراً، اسم المستخدم غير صحيح
    Validate.fieldRequired(AppTexts.UserName)  //result ->  //EN:Sorry, The Username Field is required    //AR:عذراً، حقل اسم المستخدم مطلوب
    Validate.EnterAllFields()                  //result ->  //EN:EnterAllFields     //AR:الرجاء إدخال جميع الحقول
    Validate.pleaseEnter(AppTexts.UserName)    //result ->  //EN:Sorry, please enter UserName    //AR:عذرا ,الرجاء إدخال اسم المستخدم
    Validate.pleaseChoose(AppTexts.City)       //result ->  //EN:Sorry, choose City please         //AR:عذراً، الرجاء اختيار المدينة
    Validate.EnterAllFields(["Palestine",nil,"Gaza"])  //result ->  //EN:EnterAllFields     //AR:الرجاء إدخال جميع الحقول
    Validate.fileSizeLessThanMB("5")      //result ->  //EN:File size must be less than %@ MB   //AR:حجم الملف يجب أن يكون أقل من 5 ميجا بايت
```
 
 Success Messages.
 
 ```swift
    DoneSuccessfully.added.string(AppTexts.Product) //result ->  //EN:This Product has been Added Successfully  //AR:تم إضافة المنتج بنجاح
    DoneSuccessfully.deleted.string(AppTexts.Product) //result ->  //EN:This Product has been Added Successfully  //AR:تم إضافة المنتج بنجاح
    DoneSuccessfully.change.string(AppTexts.Product) //result ->  //EN:This Product has been Changed Successfully  //AR:تم تغير المنتج بنجاح
    DoneSuccessfully.edited.string(AppTexts.Product) //result ->  //EN:This Product has been Edited Successfully  //AR:تم تعديل المنتج بنجاح
    DoneSuccessfully.saved.string(AppTexts.Product) //result ->  //EN:This Product has been Saved Successfully  //AR:تم حفظ المنتج بنجاح
    DoneSuccessfully.sent.string(AppTexts.Product) //result ->  //EN:This Product has been Sent Successfully  //AR:تم إرسال المنتج بنجاح
    DoneSuccessfully.uploaded.string(AppTexts.Product) //result ->  //EN:This Product has been Uploaded Successfully  //AR:تم رفع المنتج بنجاح

    DoneSuccessfully.added.string(nil) //result ->  //EN:This has been Added Successfully  //AR:تمت الإضافة بنجاح
    DoneSuccessfully.deleted.string(nil) //result ->  //EN:This has been deleted successfully  //AR:تم الحذف بنجاح
    DoneSuccessfully.change.string(nil) //result ->  //EN:This has been Changed Successfully  //AR:تم التغير بنجاح
    DoneSuccessfully.edited.string(nil) //result ->  //EN:This has been Edited Successfully  //AR:تم التعديل  بنجاح
    DoneSuccessfully.saved.string(nil) //result ->  //EN:This has been Saved Successfully  //AR:تم الحفظ بنجاح
    DoneSuccessfully.sent.string(nil) //result ->  //EN:This has been Sent Successfully  //AR:تم الإرسال بنجاح
    DoneSuccessfully.uploaded.string(nil) //result ->  //EN:This has been Uploaded Successfully  //AR:تم الرفع بنجاح

```
Quesstion Meesages.

 ```swift
    QuestionMessage.delete.string(AppTexts.Product) //result ->  //EN: Are you sure you want to delete this Product?  //AR:هل تريد بالتأكيد حذف المنتج؟
    QuestionMessage.add.string(AppTexts.Product) //result ->  //EN:Are you sure you want to add this Product?  //AR:هل تريد بالتأكيد إضافة المنتج؟
    QuestionMessage.edit.string(AppTexts.Product) //result ->  //EN:Are you sure you want to edit this Product?  //AR:هل تريد بالتأكيد تعديل المنتج؟
    QuestionMessage.save.string(AppTexts.Product) //result ->  //EN:Are you sure you want to save this Product?  //AR:هل تريد بالتأكيد حفظ المنتج؟
    QuestionMessage.send.string(AppTexts.Product) //result ->  //EN:Are you sure you want to send this Product?  //AR:هل تريد بالتأكيد إرسال المنتج؟
    QuestionMessage.change.string(AppTexts.Product) //result ->  //EN:Are you sure you want to change this Product?  //AR:هل تريد بالتأكيد تغير المنتج؟
    QuestionMessage.cutome.string("حذف هذا العنصر") //result ->  //EN:"Are you sure you want to حذف هذا العنصر?" //AR:"هل تريد بالتأكيد حذف هذا العنصر؟"
 ```

# Configure Successfully

## License

AppTexts is released under the MIT license. [See LICENSE](https://github.com/salah-mohammed/AppTexts/blob/master/LICENSE) for details.

# Developer's information to communicate

- salah.mohamed_1995@hotmail.com
- https://www.facebook.com/salah.shaker.7
- +972597105861 (whatsApp And PhoneNumber)

