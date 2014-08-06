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
}
