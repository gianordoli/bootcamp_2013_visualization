void assignColors(HashMap hm){
  int i = 0;
  for (Map.Entry me : hm.entrySet()) {
    int tempColor = int(map(i, 0, hm.size(), 0, 255));
    me.setValue(tempColor);
    i++;
  }
}
