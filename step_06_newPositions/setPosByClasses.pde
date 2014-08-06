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
