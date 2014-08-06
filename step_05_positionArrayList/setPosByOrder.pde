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
