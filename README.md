# MooncascadeProject

iOS Sample project where you fetch employees from an API and match them with your phone's contacts.

## GIF
![](https://gfycat.com/shygentleadamsstaghornedbeetle)

## HOW TO USE IT
  - Download and build.
  - If you fetch once, you can use it offline.
  - If you have a contact matching on of the employees, you can open it from the app.
  - Pull up to refreash.
  - Search employees from name, position, email and projects.
  - Touch the row and go to detail view.
  - If any error occurs, an alert will appear.

## HOW IT WAS MADE
  - The View model handles the employees. It fetches twice from the urls, fetches contacts<br/>
    from phones and stores the last fetch on the phone's disk.
  - The model has extensions to be comparable, and other types also uses extensions for<br/>
    separation of concern and encapsulation
  - Each of these features has it's on class.
  - The DataSource filters the employee so it doesn't display repeatedly on The TableView.
  - It uses storyboard and segues.
  - It uses URLSession for networking.
  - It uses UserDefautls for persistency.

## ARCHITECTURAL PATTERN USED
  - MVVM for better distribution of responsability and to avoid Massive View Controllers.
