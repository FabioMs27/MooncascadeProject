# MooncascadeProject

iOS sample project where you fetch employees contact from an API and match them with your phone's contacts.

## GIF
![](https://media.giphy.com/media/rRrkSOU6Ixgqw0U721/giphy.gif)

## HOW TO USE IT
  - If you fetch once, you can use it offline.
  - If you have a contact matching one of the employees, you can open it from the app.
  - Pull up to refreash.
  - Search employees by the name, position, email or projects he made.
  - Touch the row and go to detail view.
  - If any error occurs, an alert will appear.

## HOW IT WAS MADE
  - The view model handles the employees. It fetches from two different urls and combine the results using reactive programming for safe threading, fetches contacts<br/>
    from the phone and stores the last fetch on the phone's disk using future and promises.
  - The model has extensions to be comparable, and other types also uses extensions for<br/>
    separation of concern and encapsulation
  - Each of these features has it's on class and protocol following some of the software design principles (Single responsability, Interface segregation and Dependency inversion).
  - The DataSource filters the employee so it doesn't display repeatedly on The TableView using functional programming.
  - It uses storyboard and segues to it's full capacity. It uses contraints, size classes (supports all devices + dark mode), stack views, scroll views, table view, layout guides and IBDesignables.
  - It uses URLSession for networking. It follows the protocol + generic constraints approach and combine.
  - It uses UserDefautls for persistency. It was chosen for the simplicity of the project but can easily be changed since it uses protocols.

## ARCHITECTURAL PATTERN USED
  - MVVM (Combine for binding).
