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
//    println(team);
  }
  
  boolean isHovering(float _posX, float _posY, float _sqSize){
    if(_posX < mouseX && mouseX < _posX + _sqSize &&
       _posY < mouseY && mouseY < _posY + _sqSize){
      return true;
    }else{
      return false;
    }
  }
  
  void display(float _posX, float _posY, float _sqSize){
    //Color
    int h = 0;
    int s = 255;
    int b = 255;
    if(mode.equals("classes")){
      h = classes.get(tags[0]);
      if(tags[0].equals("Uncategorized")){
        s = 30;
      }       
    }else if(mode.equals("teams")){
      h = teams.get(team);
      if(team.equals("faculty")){
        s = 30;
      }
    }
    
    //Interaction
    if(isHovering(_posX, _posY, _sqSize)){
      s -= 155;
      fill(255);
      String myText = title + ", " + author + " (" + team + "). " + tags[0];
      text(myText, 20, height - 20);
    }
    
    fill(h, s, b);
    rect(_posX, _posY, _sqSize, _sqSize);
  }
}
