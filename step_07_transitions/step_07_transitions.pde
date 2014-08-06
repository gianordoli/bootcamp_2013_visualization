/* ---------------------------------------------------------------------------
 Bootcamp 2013 Visualization
 MFADT, Parsons The New School for Design
 August, 2014
 Gabriel Gianordoli
 http://gianordoli.com
 
 Visualizing all posts from http://bootcamp.parsons.edu/2013/
 Data Scraped with https://www.kimonolabs.com/
 
 **IMPORTANT**
 Because the HashMap functions are a bit different in JavaScript and Java,
 this sketch only works in JavaScript mode. 
 
 * Parsing data and storing as objects
 * Drawing each post as a square
   //Experiment with different values for spacing and square size
 * Assigning colors to the categories (classes and teams)
 * Adding rollover effect to squares
 * Storing positions in an ArrayList 
 
 Next:
 - create buttons (colors: teams/classes; sort by: date/teams/classes)
 - create rollover description
 - finish html 
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

int sqSize = 22;

float value = 0;
float prevValue = 0;
float targetValue = 0;

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
  setPosByTeams();
  setPosByClasses();
}

void draw(){
  background(255);
  
  //Easing
  value += (targetValue - value) * 0.1;
  
  for(int i = 0; i < allPosts.size(); i++){
    Post thisPost = allPosts.get(i);
    PVector pos = new PVector(0, 0);
    if(abs(targetValue - value) > 0.01){
      pos.x = map(value, prevValue, targetValue, thisPost.positions.get(prevValue).x, thisPost.positions.get(targetValue).x);
      pos.y = map(value, prevValue, targetValue, thisPost.positions.get(prevValue).y, thisPost.positions.get(targetValue).y);
    }else{
      pos.x = thisPost.positions.get(targetValue).x;
      pos.y = thisPost.positions.get(targetValue).y;      
    }
    thisPost.display(pos);
  }  
}

void keyPressed() {
  //By hitting space, we can switch between the two color modes
  if (key == ' ') {
    mode = (mode.equals("classes")) ? ("teams"):("classes");
  }else if(key == '0'){
    prevValue = targetValue;
    targetValue = 0;
  }else if(key == '1'){
    prevValue = targetValue;
    targetValue = 1;
  }else if(key == '2'){
    prevValue = targetValue;
    targetValue = 2;
  }
}

void mousePressed(){
  for(int i = 0; i < allPosts.size(); i++){
    Post thisPost = allPosts.get(i);
    PVector pos = thisPost.positions.get(targetValue);
    if(thisPost.isHovering(pos.x, pos.y, sqSize)){
      link(thisPost.titleHref, "_new");
    }
  }
}
