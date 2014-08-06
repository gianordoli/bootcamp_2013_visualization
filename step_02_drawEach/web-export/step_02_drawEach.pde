/* ---------------------------------------------------------------------------
 Dorkshop: Data Visualization
 MFADT, Parsons The New School for Design
 August 9th, 2014
 Gabriel Gianordoli
 http://gianordoli.com
 
 * Parsing data and storing as objects
 * Drawing each post as a square
   //Experiment with different values for spacing and square size
--------------------------------------------------------------------------- */

//Classes and teams will be stored in HashMaps ("name", index)
HashMap classes = new HashMap();
HashMap teams = new HashMap();

//Each post will be a Post object
//They will all be stored in an ArrayList called allPosts
ArrayList<Post> allPosts = new ArrayList<Post>();

void setup(){
  size(1333, 768);
  //Filling out the classes HashMap
  classes.put("Code", 0);
  classes.put("Design", 0);
  classes.put("Web", 0);
  
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
}

void draw(){
  background(0);
  
  int sqSize = 30;
  int spacing = 0;
  float posX = 0;
  float posY = 0;
  
  for(int i = 0; i < allPosts.size(); i++){
    Post thisPost = allPosts.get(i);
    thisPost.display(posX, posY, sqSize);
    posX += sqSize + spacing;
    if(posX + sqSize > width){
      posX = 0;
      posY += sqSize + spacing;
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
  
  Post(String _title, String _titleHref, String _author, String _authorHref, String _team, String[] _tags, String _date){
    title = _title;
    titleHref =  _titleHref;
    author = _author;
    authorHref =  _authorHref;
    team = _team;
    tags = _tags;
    date = _date;  
  }
  
  void display(float _posX, float _posY, float _sqSize){
    rect(_posX, _posY, _sqSize, _sqSize);
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
//  for(int i = 0; i < students.length; i++){
//    println(students[i][0] + "\t" + students[i][1]);
//  }
    
  tableString = loadStrings("bootcamp_2013_posts.tsv");
  for(int i = tableString.length - 1; i >= 0; i--){
    String[] myLine = split(tableString[i], "\t");
    
    //TITLE
    String title = trim(myLine[0]);
    
    //TITLE HREF
    String titleHref = "";    
    
    //AUTHOR
    String author = trim(myLine[1]);
    
    //AUTHOR HREF
    String authorHref = trim(myLine[2]);
    
    //TEAM
    String team = "";
    //Is the author a student or a teacher?
    for(int j = 0; j < students.length; j++){
      if(author.equals(students[j][1])){ //Student!
        team = students[j][0];
      }else{
        team = "faculty";
      }   
    }
    
    //TAGS
    //I want to store only code/design/web in tags. So...
    String[] originalTags = split(trim(myLine[3]), ",");
//    printArray(originalTags);
    String[] tags = new String[0];
    for(int j = 0; j < originalTags.length; j++){
      String thisTag = trim(originalTags[j]);
//      println(thisTag);

        if(classes.containsKey(thisTag)){
          tags = append(tags, thisTag);
        }
    }
//    printArray(tags);

    //DATE
    String date = trim(myLine[4]);
    
    //Creating the object
    Post thisPost = new Post(title, titleHref, author, authorHref, team, tags, date);
  
    //Pushing it to the ArrayList
    allPosts.add(thisPost);
  }
//  println(allPosts.size());
}

