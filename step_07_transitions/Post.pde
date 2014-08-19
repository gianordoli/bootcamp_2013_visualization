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
