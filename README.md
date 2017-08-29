# ContactManager
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=59a59ae5e0a69d0001eb87dc&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/59a59ae5e0a69d0001eb87dc/build/latest?branch=master)
[![CI Status](http://img.shields.io/travis/mspvirajpatel/ContactManager.svg?style=flat)](https://travis-ci.org/mspvirajpatel/ConatctManager)
[![Version](https://img.shields.io/cocoapods/v/ContactManager.svg?style=flat)](http://cocoapods.org/pods/ContactManager)
[![License](https://img.shields.io/cocoapods/l/ContactManager.svg?style=flat)](http://cocoapods.org/pods/ContactManager)
[![Platform](https://img.shields.io/cocoapods/p/ContactManager.svg?style=flat)](http://cocoapods.org/pods/ContactManager)

A Swift library for Contacts framework.

## Requirements

- iOS 9.0+ 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ContactManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ContactManager"
```
## Get started

Import SwiftyContacts into your porject

```swift
import SwiftyContacts
```


For requesting an access for getting contacts.
The user will only be prompted the first time access is requested.

```swift
requestAccess { (responce) in
if responce{
print("Contacts Acess Granted")
} else {
print("Contacts Acess Denied")
}
}
```


Determine Status of Acess Permission

```swift
authorizationStatus { (status) in
switch status {
case .authorized:
print("authorized")
break
case .denied:
print("denied")
break
default:
break
}
}
```

Fetch Contacts 
-- Result will be Array of CNContacts

```swift
fetchContacts(completionHandler: { (result) in
switch result{
case .Success(response: let contacts):
// Do your thing here with [CNContacts] array	 
break
case .Error(error: let error):
print(error)
break
}
})
```

Fetch Contacts on Background Thread

```swift
fetchContactsOnBackgroundThread(completionHandler: { (result) in
switch result{
case .Success(response: let contacts):
// Do your thing here with [CNContacts] array	 
break
case .Error(error: let error):
print(error)
break
}
})
```

Search Contact

```swift

searchContact(SearchString: "john") { (result) in
switch result{
case .Success(response: let contacts):
// Contacts Array includes Search Result Contacts
break
case .Error(error: let error):
print(error)
break
}
}

```

Get CNContact From Identifire

```swift

getContactFromID(Identifire: "XXXXXXXXX", completionHandler: { (result) in  
switch result{
case .Success(response: let contact):
// CNContact
break
case .Error(error: let error):
print(error)
break
}
})

```

Add Contact

```swift

let contact : CNMutableContact = CNMutableContact()
contact.givenName = "Satish"
// OR Use contact.mutableCopy() For Any CNContact

addContact(Contact: contact) { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Contact Sucessfully Added")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}

```

Add Contact in Container

```swift

addContactInContainer(Contact: CNMutableContact, Container_Identifier: String) { (result) in
//Same As Add Contact
}

```

Update Contact

```swift

updateContact(Contact: contact) { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Contact Sucessfully Updated")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}

```

Delete Contact

```swift
// Use contact.mutableCopy() To convert CNContact to CNMutableContact
deleteContact(Contact: contact) { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Contact Sucessfully Deleted")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}
```

Fetch List Of Groups

```swift
fetchGroups { (result) in
switch result{
case .Success(response: let groups):
// List Of Groups in groups array
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}
```

Create Group

```swift
createGroup(Group_Name: "Satish") { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Group Sucessfully Created")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}
```

Create Group in Container

```swift
createGroup(Group_Name: "Satish" , ContainerIdentifire: "ID") { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Group Sucessfully Created")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}
```

Update Group

```swift
updateGroup(Group: group, New_Group_Name: "New Name") { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Group Sucessfully Updated")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}

```

Remove Group

```swift
removeGroup(Group: group) { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Group Sucessfully Removed")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}

```

Fetch Contacts In Group

```swift

fetchContactsInGorup(Group: group) { (result) in
switch result{
case .Success(response: let contacts):
// Do your thing here with [CNContacts] array	 
break
case .Error(error: let error):
print(error)
break
}
}

// OR Use

fetchContactsInGorup2(Group: group) { (result) in
switch result{
case .Success(response: let contacts):
// Do your thing here with [CNContacts] array	 
break
case .Error(error: let error):
print(error)
break
}
}

```

Add Contact To Group

```swift
addContactToGroup(Group: group, Contact: contact) { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Contact Sucessfully Added To Group")         
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}
```

Remove Contact From Group

```swift
removeContactFromGroup(Group: group, Contact: contact) { (result) in
switch result{
case .Success(response: let bool):
if bool{
print("Contact Sucessfully Added To Group")
}
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}
```

Convert [CNContacts] TO CSV

```swift

contactsToVCardConverter(contacts: ContactsArray) { (result) in
switch result {
case .Success(response: data):
// Use file extension will be .vcf
break
case .Error(error: let error):
print(error.localizedDescription)
break

}
}

```

Convert CSV TO [CNContact]

```swift

VCardToContactConverter(data: data) { (result) in
switch result{
case .Success(response: let contacts):
// Use Contacts array as you like   
break
case .Error(error: let error):
print(error.localizedDescription)
break
}
}

```

Find Duplicates Contacts

```swift

findDuplicateContacts(Contacts: contactsArray) { (duplicatesContacts) in
//Duplicates Contacts Array 
//Array type [Array<CNContact>]
}


```

## Author

Viraj Patel, mspviraj@hotmail.com

## License

ContactManager is available under the MIT license. See the LICENSE file for more info.
