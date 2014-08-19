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
 - change color palletes
 - replace hashmaps with 2D array
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
float targetValue = 2;

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
//  println(value);
  
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
  }
  
  if((key == '0' || key == '1' || key == '2') &&  key - 48 != targetValue){
    if(key == '0'){
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
class Post{
  String title;
  String titleHref;
  String author;
  String authorHref;
  String team;
  String[] tags;
  String date;
  ArrayList<PVector> positions;
  
  Post(String _title, String _titleHref, String _author, String _authorHref, String _team, String[] _tags, String _date){
    title = _title;
    titleHref =  _titleHref;
    author = _author;
    authorHref =  _authorHref;
    team = _team;
    tags = _tags;
    date = _date;
    positions = new ArrayList<PVector>();
  }
  
  void setPosition(float _posX, float _posY){
    PVector pos = new PVector(_posX, _posY);
//    println(pos.y);
    positions.add(pos);
  }
  
  boolean isHovering(float _posX, float _posY, float _sqSize){
    if(_posX < mouseX && mouseX < _posX + _sqSize &&
       _posY < mouseY && mouseY < _posY + _sqSize){
      return true;
    }else{
      return false;
    }
  }
  
  void display(PVector pos){
    //Color
    int h = 0;
    int s = 255;
    int b = 255;
    if(mode.equals("classes")){
      h = classes.get(tags[0]);
      if(tags[0].equals("Uncategorized")){
        s = 30;
        b = 100;
      }      
    }else if(mode.equals("teams")){
      h = teams.get(team);
      if(team.equals("faculty")){
        s = 30;
        b = 100;
      }
    }
        
    //Interaction
    if(isHovering(pos.x, pos.y, sqSize)){
      s -= 155;
      fill(0);
      String myText = title + ", " + author + " (" + team + "). " + tags[0];
      text(myText, 20, height - 20);
    }
    
    fill(h, s, b, 240);
    stroke(255);
    rect(pos.x, pos.y, sqSize, sqSize);
  }
}
void assignColors(HashMap hm){
  int i = 0;
  for (Map.Entry me : hm.entrySet()) {
    int tempColor = int(map(i, 0, hm.size(), 0, 255));
    me.setValue(tempColor);
    i++;
  }
}
void parseData(){
  //To categorize posts by teams (and filter faculty), we can't rely on the tags,
  //because many posts are uncategorized.
  //So we'll load data from the "students x teams" file
  String[][] students = new String[0][2];
  String[] tableString = loadStrings("bootcamp_2013_students.tsv");
  for(String lineString : tableString){
    String[] myLine = split(lineString, "\t");
    String team = trim(myLine[0]);
    String student = trim(myLine[1]);
    students = (String[][])append(students, new String[]{team, student});
    if(!teams.containsKey(trim(myLine[0]))){
      teams.put(team, 0);
    }
  }
  teams.put("faculty", 0);
//  for(int i = 0; i < students.length; i++){
//    println(students[i][0] + "\t" + students[i][1]);
//  }
    
  tableString = loadStrings("bootcamp_2013_posts.tsv");
//  for(int i = tableString.length - 1; i >= 0; i--){
  for(int i = tableString.length - 1; i >= 0; i--){
    String[] myLine = split(tableString[i], "\t");
    
    //TITLE
    String title = trim(myLine[0]);
    
    //TITLE HREF
    String titleHref = trim(myLine[1]);    
    
    //AUTHOR
    String author = trim(myLine[2]);
    
    //AUTHOR HREF
    String authorHref = trim(myLine[3]);
    
    //TEAM
    String team = "faculty";
    //By default, team is assigned as "faculty"
    //If the author name is found in the students list,
    //then change it to the team name
    for(int j = 0; j < students.length; j++){
      if(author.equals(students[j][1])){ //Student!
        team = students[j][0];
        break;
      }
    }
//    println(i + " : " + team);
    
    //TAGS
    //I want to store only code/design/web in tags. So...
    String[] originalTags = split(trim(myLine[4]), ",");
//    printArray(originalTags);
    String[] tags = new String[0];
    for(int j = 0; j < originalTags.length; j++){
      String thisTag = trim(originalTags[j]);
//      println(thisTag);
        if(classes.containsKey(thisTag)){
          tags = append(tags, thisTag);
        }
    }
    if(tags.length == 0){
      tags = append(tags, "Uncategorized");
    }
//    printArray(tags);

    //DATE
    String date = trim(myLine[5]);
    
    //Creating the object
    Post thisPost = new Post(title, titleHref, author, authorHref, team, tags, date);
  
    //Pushing it to the ArrayList
    allPosts.add(thisPost);
  }
//  println(allPosts.size());
}
void setPosByClasses(){
  //Setting positions   
  int spacing = 0;
  float posX = 0;
  float posY = 0;
  
  Iterator i = classes.entrySet().iterator();  // Get an iterator
  while (i.hasNext()) {
  Map.Entry me = (Map.Entry)i.next();
//    print(me.getKey() + " is ");
//    println(me.getValue());

    for(int j = 0; j < allPosts.size(); j++){
      Post thisPost = allPosts.get(j);
      if(thisPost.tags[0].equals(me.getKey())){
//        println(me.getKey());
        thisPost.setPosition(posX, posY);
        posX += sqSize + spacing;
        if(posX + sqSize > width){
          posX = 0;
          posY += sqSize + spacing;
        }
      }
    }
  }  
}
void setPosByOrder(){
  //Setting positions   
  int spacing = 0;
  float posX = 0;
  float posY = 0;
  
  for(int i = 0; i < allPosts.size(); i++){
    Post thisPost = allPosts.get(i);
    thisPost.setPosition(posX, posY);
    posX += sqSize + spacing;
    if(posX + sqSize > width){
      posX = 0;
      posY += sqSize + spacing;
    }
  }
}
void setPosByTeams(){
  //Setting positions   
  int spacing = 0;
  float posX = 0;
  float posY = 0;
  
  Iterator i = teams.entrySet().iterator();  // Get an iterator
  while (i.hasNext()) {
  Map.Entry me = (Map.Entry)i.next();
//    print(me.getKey() + " is ");
//    println(me.getValue());

    for(int j = 0; j < allPosts.size(); j++){
      Post thisPost = allPosts.get(j);
      if(thisPost.team.equals(me.getKey())){
//        println(me.getKey());
        thisPost.setPosition(posX, posY);
        posX += sqSize + spacing;
        if(posX + sqSize > width){
          posX = 0;
          posY += sqSize + spacing;
        }
      }
    }
  }  
}

