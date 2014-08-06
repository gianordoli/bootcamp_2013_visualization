/* ---------------------------------------------------------------------------
 Bootcamp 2013 Visualization
 MFADT, Parsons The New School for Design
 August, 2014
 Gabriel Gianordoli
 http://gianordoli.com
 
 Visualizing all posts from http://bootcamp.parsons.edu/2013/
 Data Scraped with https://www.kimonolabs.com/
 
 * Parsing data and storing as objects
 * Drawing each post as a square
   //Experiment with different values for spacing and square size
 * Assigning colors to the categories (classes and teams)
 * Adding rollover effect to squares
 * Storing positions in an ArrayList 
--------------------------------------------------------------------------- */

//Classes and teams will be stored in HashMaps ("name", index)
HashMap classes = new HashMap();
HashMap teams = new HashMap();

//Each post will be a Post object
//They will all be stored in an ArrayList called allPosts
ArrayList<Post> allPosts = new ArrayList<Post>();

//Determines whether we'll use classes or teams to display color
//Setting "classes" as the default
String mode = "classes";

int sqSize = 20;

void setup(){
  size(1333, 768);
  colorMode(HSB);
  
  //Filling out the classes HashMap
  classes.put("Code", 0);
  classes.put("Design", 0);
  classes.put("Web", 0);
  classes.put("Uncategorized", 0);  
  
  //This function will:
  //1 - Load the "teams x students" tsv
  //2 - Use it to:
  //    a) Fill out the teams HashMap
  //    b) Assign a team to each student in the posts data
  //       (and also assign "faculty" as a team)
  //3 - Load all posts from the bootcamp_2013_posts.tsv
  //4 - Filter the data's original tags and leave only Code, Design or Web
  //5 - Store each post as a Post object (reversing the order: older to recent)
  parseData();
  
  assignColors(classes);
  assignColors(teams);

  setPosByOrder();
}

void draw(){
  background(0);
  
  for(int i = 0; i < allPosts.size(); i++){
    Post thisPost = allPosts.get(i);
    thisPost.display();
  }  
}

void keyPressed() {
  //By hitting space, we can switch between the two color modes
  if (key == ' ') {
    mode = (mode.equals("classes")) ? ("teams"):("classes");
  }   
}
