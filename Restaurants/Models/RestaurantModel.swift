//
//  RestaurantModel.swift
//  Restaurants
//
//  Created by Alejocram on 9/09/16.
//  Copyright © 2016 EAFIT. All rights reserved.
//

import UIKit
import CoreData

typealias CompletionHandler = (success: Bool, response: [Restaurant]) ->()

class RestaurantModel: NSObject {
    var restaurants = [Restaurant]()
    var managedObjects = [NSManagedObject]()
    
    func deleteRestaurants() throws {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Restaurants", inManagedObjectContext: managedContext)
        let managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)

    }
    
    
    //MARK: CoreData
    func saveRestaurant(restaurant: Restaurant) throws {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Restaurants", inManagedObjectContext: managedContext)
        let managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        managedObject.setValue(restaurant.name, forKey: "name")
        managedObject.setValue(restaurant.details, forKey: "details")
        managedObject.setValue(restaurant.address, forKey: "address")
        managedObject.setValue(restaurant.telephone, forKey: "telephone")
        managedObject.setValue(restaurant.latitude, forKey: "latitude")
        managedObject.setValue(restaurant.longitude, forKey: "longitude")
        managedObject.setValue(restaurant.category, forKey: "category")
        managedObject.setValue(restaurant.wifi, forKey: "wifi")
        managedObject.setValue(restaurant.available, forKey: "available")
        managedObject.setValue(restaurant.ranking, forKey: "ranking")
        managedObject.setValue(restaurant.image, forKey: "image")
        
        
        do {
            try managedContext.save()
            managedObjects.append(managedObject)
            manageObjectToRestaurant()
        } catch let error as NSError{
            print("No se pude guardar los datos, Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Consulta todos los restaurantes
    func fetchRestaurants() throws {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Restaurants")
        
        //Con este fetch se hacen los filtros que se necesiten.
        //fetch.
        
        do {
            let result = try managedContext.executeFetchRequest(fetch)
            managedObjects = result as! [NSManagedObject]
            manageObjectToRestaurant()
        } catch let error as NSError {
            print("No pude recuperar datos, Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func manageObjectToRestaurant() {
        restaurants.removeAll()
        for managedObject in managedObjects {
            let restaurantTmp = Restaurant(name: managedObject.valueForKey("name") as! String,
                                           details: managedObject.valueForKey("details") as! String,
                                           address: managedObject.valueForKey("address") as! String,
                                           telephone: managedObject.valueForKey("telephone") as! String,
                                           latitude: managedObject.valueForKey("latitude") as! Double,
                                           longitude: managedObject.valueForKey("longitude") as! Double,
                                           category: managedObject.valueForKey("category") as! String,
                                           wifi: managedObject.valueForKey("wifi") as! Bool,
                                           available: managedObject.valueForKey("available") as! Bool,
                                           ranking: managedObject.valueForKey("ranking") as! Float,
                                           image: managedObject.valueForKey("image") as! String
            )
            
            restaurants.append(restaurantTmp)
        }
    }
    
    //MARK: Services 
    func getRestaurantsFromServer(completion: CompletionHandler) {
        let request = RestaurantService()
        request.getRestaurants { (success, response) in
            if success {
                self.restaurants.removeAll()
                
                for item in response {
                    let restaurantTmp = Restaurant(name: item["name"] as! String, details: item["details"] as! String, address: item["address"] as! String, telephone: item["telephone"] as! String, latitude: item["latitude"] as! Double, longitude: item["longitude"] as! Double, category: item["category"] as! String, wifi: item["wifi"] as! Bool, available: item["available"] as! Bool, ranking: item["ranking"] as! Float, image: item["image"] as! String)
                    
                    self.restaurants.append(restaurantTmp)
                }
                
                // En este caso, luego de recuperar todos los datos desde el server, estamos guardàndolos en el coreData.
                // La idea serìa sòlo guardar los nuevos registros
                // O borrar todos los existentes en el coreData y luego insertarlos todos.
                for restaurantTmp in self.restaurants {
                    do {
                        try self.saveRestaurant(restaurantTmp)
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                completion(success: true, response: self.restaurants)
            } else {
                completion(success: false, response: self.restaurants)
            }
        }
    }
    
    
    //MARK: Mocks
    func restaurantsMocks() -> [Restaurant] {
        let restaurants:[Restaurant] = [Restaurant(name: "Asados Doña Rosa", address: "Cr 80 #34-23", latitude: 6.342344, longitude: -75.12345, category: "Asados", image: "parrilla-restaurant"), Restaurant(name: "Rancherito", address: "Cr 80 #34-23", latitude: 6.342344, longitude: -75.12345, category: "Asados", image: "parrilla-restaurant"), Restaurant(name: "Il'Forno", address: "Cr 80 #34-23", latitude: 6.342344, longitude: -75.12345, category: "Asados", image: "mexican-restaurant")]
        
        return restaurants
    }

}
