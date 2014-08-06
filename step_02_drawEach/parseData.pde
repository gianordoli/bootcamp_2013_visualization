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
  println(allPosts.size());
}
