//
//  RestaurantTableViewController.swift
//  Restaurants
//
//  Created by Alejocram on 9/09/16.
//  Copyright © 2016 EAFIT. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    var model = RestaurantModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurants()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.restaurants.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RowTableViewCell

        // Configure the cell...
        let restaurant:Restaurant = model.restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.detailsLabel.text = restaurant.details
        cell.iconImageView.image = UIImage(named: restaurant.image)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurant = model.restaurantsMocks()[indexPath.row]
        performSegueWithIdentifier("detail", sender: restaurant)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destinationViewController as! DetailViewController
        destination.restaurant = (sender as! Restaurant)
    }
    
    
    func getRestaurants() {
        model.getRestaurantsFromServer { (success, response) in
            if success {
                /*
                self.tableView.reloadData()
            } else {
                //Como no hubo conexion, mostramos una alerta
                let alertController = UIAlertController(title: "Conexion", message: "No se pudo recuperar los datos desde el servidor", preferredStyle: .Alert)
                // Se adicionan los botones en la alerta
                let defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                
                //Adicionamos la accion creada en el alertController
                alertController.addAction(defaultAction)
                
                //Adicionamos el alert a la vista actual
                self.presentViewController(alertController, animated: true, completion: nil)
                */
                do {
                    try self.model.fetchRestaurants()
                    //try self.model.saveRestaurant(self.model.restaurantsMocks()[0])
                    self.tableView.reloadData()
                } catch let error as NSError {
                    //Como hubo error guardando, mostramos una alerta
                    let alertController = UIAlertController(title: "CoreData", message: "No se pudo almacenar el dato en coreData", preferredStyle: .Alert)
                    // Se adicionan los botones en la alerta
                    let defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    
                    //Adicionamos la accion creada en el alertController
                    alertController.addAction(defaultAction)
                    
                    //Adicionamos el alert a la vista actual
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }
        }
    }

}
