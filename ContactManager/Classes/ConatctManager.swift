//
//  ConatctManager.swift
//  Pods
//
//  Created by MacMini-2 on 23/08/17.
//
//

import Foundation
import Contacts
import CoreTelephony


// PRAGMA MARK: - Contacts Authorization -
public func requestAccess(_ requestGranted: @escaping (Bool) -> Void) {
    CNContactStore().requestAccess(for: .contacts) { (grandted, error) in
        requestGranted(grandted)
    }
}


public func authorizationStatus(_ requestStatus: @escaping (CNAuthorizationStatus) -> Void) {
    requestStatus(CNContactStore.authorizationStatus(for: .contacts))
}



// PRAGMA MARK: - Fetch Contacts -

public enum ContactsFetchResult {
    case Success(response : [CNContact])
    case Error(error : Error)
}


public func fetchContacts( completionHandler : @escaping (_ result : ContactsFetchResult) -> ()){
    
    let contactStore : CNContactStore = CNContactStore()
    var contacts : [CNContact] = [CNContact]()
    let fetchRequest : CNContactFetchRequest = CNContactFetchRequest(keysToFetch:[CNContactVCardSerialization.descriptorForRequiredKeys()])
    do{
        try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
            contact, cursor in
            contacts.append(contact)})
        completionHandler(ContactsFetchResult.Success(response: contacts))
    } catch {
        completionHandler(ContactsFetchResult.Error(error: error))
    }
}

public func fetchContactsOnBackgroundThread( completionHandler : @escaping (_ result : ContactsFetchResult) -> ()){
    
    DispatchQueue.global(qos: .userInitiated).async(execute: { () -> Void in
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as [Any]
        let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var contacts = [CNContact]()
        CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
        if #available(iOS 10.0, *) {
            fetchRequest.mutableObjects = false
        } else {
            // Fallback on earlier versions
        }
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        do {
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                contacts.append(contact)
            }
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(ContactsFetchResult.Success(response: contacts))
            })
        } catch let error as NSError {
            completionHandler(ContactsFetchResult.Error(error: error))
        }
        
    })
    
}

// PRAGMA MARK: - Search Contacts -
public func searchContact(SearchString string : String , completionHandler : @escaping (_ result : ContactsFetchResult) -> ()){
    
    let contactStore : CNContactStore = CNContactStore()
    var contacts : [CNContact] = [CNContact]()
    let predicate : NSPredicate = CNContact.predicateForContacts(matchingName: string)
    do {
        contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        completionHandler(ContactsFetchResult.Success(response: contacts))
    }
    catch {
        completionHandler(ContactsFetchResult.Error(error: error))
    }
}

public enum ContactFetchResult {
    case Success(response : CNContact)
    case Error(error : Error)
}

// Get CNContact From Identifier
public func getContactFromID(Identifire identifier : String , completionHandler : @escaping (_ result : ContactFetchResult) -> ()){
    
    fetchContacts { (result) in
        switch result{
        case .Success(response: let contacts):
            for item in contacts{
                if item.identifier == identifier{
                    completionHandler(ContactFetchResult.Success(response: item))
                }
            }
            break
        case .Error(error: let error):
            completionHandler(ContactFetchResult.Error(error: error))
        }
    }
}

// PRAGMA MARK: - Contact Operations
public enum ContactOperationResult {
    case Success(response : Bool)
    case Error(error : Error)
}

// Add Contact
public func addContact(Contact mutContact : CNMutableContact , completionHandler : @escaping (_ result : ContactOperationResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    request.add(mutContact, toContainerWithIdentifier: nil)
    do{
        try store.execute(request)
        completionHandler(ContactOperationResult.Success(response: true))
    } catch {
        completionHandler(ContactOperationResult.Error(error: error))
    }
}

public func addContactInContainer(Contact mutContact : CNMutableContact ,Container_Identifier identifier : String, completionHandler : @escaping (_ result : ContactOperationResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    request.add(mutContact, toContainerWithIdentifier: identifier)
    do{
        try store.execute(request)
        completionHandler(ContactOperationResult.Success(response: true))
    } catch {
        completionHandler(ContactOperationResult.Error(error: error))
    }
}


// Update Contact
public func updateContact(Contact mutContact : CNMutableContact , completionHandler : @escaping (_ result : ContactOperationResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    request.update(mutContact)
    do{
        try store.execute(request)
        completionHandler(ContactOperationResult.Success(response: true))
    } catch {
        completionHandler(ContactOperationResult.Error(error: error))
    }
}

// Delete Contact
public func deleteContact(Contact mutContact : CNMutableContact , completionHandler : @escaping (_ result : ContactOperationResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    request.delete(mutContact)
    do{
        try store.execute(request)
        completionHandler(ContactOperationResult.Success(response: true))
    } catch {
        completionHandler(ContactOperationResult.Error(error: error))
    }
}

// PRAGMA MARK: - Groups Methods -

public enum GroupsFetchResult {
    case Success(response : [CNGroup])
    case Error(error : Error)
}

public func fetchGroups( completionHandler : @escaping (_ result : GroupsFetchResult) -> ()){
    let store : CNContactStore = CNContactStore()
    do {
        let groups : [CNGroup] = try store.groups(matching: nil)
        completionHandler(GroupsFetchResult.Success(response: groups))
    } catch  {
        completionHandler(GroupsFetchResult.Error(error: error))
    }
}

public enum GroupsOperationsResult {
    case Success(response : Bool)
    case Error(error : Error)
}

public func createGroup(Group_Name name : String , completionHandler : @escaping (_ result : GroupsOperationsResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    let group: CNMutableGroup = CNMutableGroup()
    group.name = name
    request.add(group, toContainerWithIdentifier: nil)
    do{
        try store.execute(request)
        completionHandler(GroupsOperationsResult.Success(response: true))
    } catch {
        completionHandler(GroupsOperationsResult.Error(error: error))
    }
}

public func createGroupInContainer(Group_Name name : String , ContainerIdentifire identifire : String , completionHandler : @escaping (_ result : GroupsOperationsResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    let group: CNMutableGroup = CNMutableGroup()
    group.name = name
    request.add(group, toContainerWithIdentifier: identifire)
    do{
        try store.execute(request)
        completionHandler(GroupsOperationsResult.Success(response: true))
    } catch {
        completionHandler(GroupsOperationsResult.Error(error: error))
    }
}

public func removeGroup(Group group : CNGroup , completionHandler : @escaping (_ result : GroupsOperationsResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    if let mutableGroup : CNMutableGroup = group.mutableCopy() as? CNMutableGroup{
        request.delete(mutableGroup)
    }
    do{
        try store.execute(request)
        completionHandler(GroupsOperationsResult.Success(response: true))
    } catch {
        completionHandler(GroupsOperationsResult.Error(error: error))
    }
}

public func updateGroup(Group group : CNGroup , New_Group_Name name : String , completionHandler : @escaping (_ result : GroupsOperationsResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    if let mutableGroup : CNMutableGroup = group.mutableCopy() as? CNMutableGroup{
        mutableGroup.name = name
        request.update(mutableGroup)
    }
    do{
        try store.execute(request)
        completionHandler(GroupsOperationsResult.Success(response: true))
    } catch {
        completionHandler(GroupsOperationsResult.Error(error: error))
    }
}



public func addContactToGroup(Group group : CNGroup , Contact contact : CNContact , completionHandler : @escaping (_ result : GroupsOperationsResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    request.addMember(contact, to: group)
    do{
        try store.execute(request)
        completionHandler(GroupsOperationsResult.Success(response: true))
    } catch {
        completionHandler(GroupsOperationsResult.Error(error: error))
    }
}

public func removeContactFromGroup(Group group : CNGroup , Contact contact : CNContact , completionHandler : @escaping (_ result : GroupsOperationsResult) -> ()){
    let store : CNContactStore = CNContactStore()
    let request : CNSaveRequest = CNSaveRequest()
    request.removeMember(contact, from: group)
    do{
        try store.execute(request)
        completionHandler(GroupsOperationsResult.Success(response: true))
    } catch {
        completionHandler(GroupsOperationsResult.Error(error: error))
    }
}


public func fetchContactsInGorup(Group group : CNGroup , completionHandler : @escaping (_ result : ContactsFetchResult) -> ()){
    
    let contactStore : CNContactStore = CNContactStore()
    var contacts : [CNContact] = [CNContact]()
    do{
        let predicate : NSPredicate = CNContact.predicateForContactsInGroup(withIdentifier: group.name)
        let keysToFetch : [String] = [CNContactGivenNameKey]
        contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
        completionHandler(ContactsFetchResult.Success(response: contacts))
    } catch {
        completionHandler(ContactsFetchResult.Error(error: error))
    }
}

public func fetchContactsInGorup2(Group group : CNGroup , completionHandler : @escaping (_ result : ContactsFetchResult) -> ()){
    
    let contactStore : CNContactStore = CNContactStore()
    let contacts : [CNContact] = [CNContact]()
    do{
        var predicate : NSPredicate!
        let allGroups : [CNGroup] = try contactStore.groups(matching: nil)
        for item in allGroups {
            if (item.name == group.name) {
                predicate = CNContact.predicateForContactsInGroup(withIdentifier: group.identifier)
            }
        }
        let keysToFetch : [String] = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactNoteKey, CNContactImageDataKey]
        if predicate != nil {
            var contacts : [CNContact] = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            for contact in contacts {
                contacts.append(contact)
            }
        }
        completionHandler(ContactsFetchResult.Success(response: contacts))
    } catch {
        completionHandler(ContactsFetchResult.Error(error: error))
    }
}



// PRAGMA MARK: - Converter Methods -
// CSV Converter
public enum ContactsToVCardResult{
    case Success(response : Data)
    case Error(error : Error)
}

// Convert [CNContacts] TO CSV
public func contactsToVCardConverter(contacts : [CNContact], completionHandler : @escaping (_ result : ContactsToVCardResult) -> ()){
    
    var vcardFromContacts : Data = Data()
    do {
        try vcardFromContacts = CNContactVCardSerialization.data(with: contacts)
        completionHandler(ContactsToVCardResult.Success(response: vcardFromContacts))
    } catch {
        completionHandler(ContactsToVCardResult.Error(error: error))
    }
    
}

public enum VCardToContactResult{
    case Success(response : [CNContact])
    case Error(error : Error)
}

// Convert CSV TO [CNContact]
public func VCardToContactConverter(data : Data , completionHandler : @escaping (_ result : VCardToContactResult) -> ()){
    var contacts : [CNContact] = [CNContact]()
    do {
        try contacts = CNContactVCardSerialization.contacts(with: data) as [CNContact]
        completionHandler(VCardToContactResult.Success(response: contacts))
    } catch {
        completionHandler(VCardToContactResult.Error(error: error))
    }
}

// Archive Unarchive Contacts
public func archiveContacts(contacts : [CNContact], completionHandler : @escaping (_ result : Data) -> ()){
    
    let encodedData : Data = NSKeyedArchiver.archivedData(withRootObject: contacts)
    completionHandler(encodedData)
    
}


public func unarchiveConverter(data : Data , completionHandler : @escaping (_ result : [CNContact]) -> ()){
    let decodedData : Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
    if let contacts : [CNContact] = decodedData as? [CNContact] {
        completionHandler(contacts)
    }
}

// PRAGMA MARK: - Duplicates Contacts Methods
public func findDuplicateContacts(Contacts contacts : [CNContact], completionHandler : @escaping (_ result : [Array<CNContact>]) -> ()){
    
    let arrfullNames : [String?] = contacts.map{CNContactFormatter.string(from: $0, style: .fullName)}
    var contactGroupedByDuplicated : [Array<CNContact>] = [Array<CNContact>]()
    if let fullNames : [String] = arrfullNames as? [String]{
        let uniqueArray = Array(Set(fullNames))
        var contactGroupedByUnique = [Array<CNContact>]()
        for fullName in uniqueArray {
            let group = contacts.filter {
                CNContactFormatter.string(from: $0, style: .fullName) == fullName
            }
            contactGroupedByUnique.append(group)
        }
        for items in contactGroupedByUnique{
            if items.count > 1 {
                contactGroupedByDuplicated.append(items)
            }
        }
    }
    completionHandler(contactGroupedByDuplicated)
    
}


// PRAGMA MARK: - CoreTelephonyCheck
public func isCapableToCall(completionHandler: @escaping (_ result: Bool) -> ()) {
    if UIApplication.shared.canOpenURL(NSURL(string: "tel://")! as URL) {
        // Check if iOS Device supports phone calls
        // User will get an alert error when they will try to make a phone call in airplane mode
        if let mnc : String = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode, !mnc.isEmpty {
            // iOS Device is capable for making calls
            completionHandler(true)
        } else {
            // Device cannot place a call at this time. SIM might be removed
            completionHandler(false)
        }
    } else {
        // iOS Device is not capable for making calls
        completionHandler(false)
    }
    
}

public func isCapableToSMS(completionHandler: @escaping (_ result: Bool?) -> ()) {
    if UIApplication.shared.canOpenURL(NSURL(string: "sms:")! as URL) {
        completionHandler(true)
    } else {
        completionHandler(false)
    }
    
}

public func CNPhoneNumberToString(CNPhoneNumber : CNPhoneNumber) -> String{
    if let result: String = CNPhoneNumber.value(forKey: "digits") as? String{
        return result
    }
    return ""
}



public func makeCall(CNPhoneNumber : CNPhoneNumber){
    if let phoneNumber: String = CNPhoneNumber.value(forKey: "digits") as? String {
        guard let url: URL = URL(string: "tel://" + "\(phoneNumber)") else {
            print("Error in Making Call")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
    }
    
}
