public class Board extends GUI_component { //<>// //<>//
  Gear[] gears = new Gear[55];
  int distance = 70;
  int amount_of_gears = 0;
  int currentPlayer = 1;
  Gear selectedGear;
  Gear[] coreGears = new Gear[2];

  public Board() {
    x = 250;
    y = 25;
    w = 925;
    h = 750;

    int middleX = x + w/2;
    // creating all the gears
    for (int i = 0; i < 10; i++) {
      int y_level = y + 68 + distance*i;
      if (i % 2 == 0) {
        int lefts = (i+1) / 2;
        int x_level = middleX - distance*lefts;

        for (int j = 0; j <= i; j++) {
          gears[amount_of_gears++] = new Gear(amount_of_gears, x_level, y_level, j, i);
          x_level += distance;
        }
      } else {
        int amount = i + 1;
        int x_level = middleX - distance*amount/2 + distance/2;

        for (int j = 0; j <= i; j++) {
          gears[amount_of_gears++] = new Gear(amount_of_gears, x_level, y_level, j, i);
          x_level += distance;
        }
      }
    }

    // Coloring the cores and setting the variables
    gears[0].player = 3;
    gears[0].isCore = true;
    gears[45].player = 2;
    gears[45].isCore = true;
    gears[54].player = 1;
    gears[54].isCore = true;
    coreGears[0] = gears[45];
    coreGears[1] = gears[54];
    
  }


  public void Show() {
    // background
    strokeWeight(0.5);
    fill(150, 50, 150, 100);
    //rect(x, y, w, h, 25);

    // triangle background
    int middleX = x + w/2;
    fill(51);
    strokeWeight(5);


    beginShape();
    // TOP
    vertex(middleX - 20, y + 10);
    vertex(middleX + 20, y + 10);
    // RIGHT
    vertex(x+w - 80, y + h - 50);
    vertex(x+w - 80, y + h - 10);
    // LEFT
    vertex(x + 80, y + h - 10);
    vertex(x + 80, y + h - 50);

    vertex(middleX - 20, y + 10);
    endShape();


    // gears
    for (Gear g : gears)
      g.Show();
  }

  // Returns whether the game has to test for rotatable gears
  public boolean onClick(int mouseX, int mouseY) {
    for (Gear g : gears) {
      // Only do something when a gear is clicked
      if (dist(g.x, g.y, mouseX, mouseY) < g.size/2) {

        // if the gear is one of the corners stop the onclick
        if (g.isCore)
          return false;

        // if there was no previously selected gear place a new one
        if (selectedGear == null) {
          // if the clicked gear hasnt been claimed yet set it to currentPlayer
          if (g.player == 0) {
            g.player = currentPlayer;
            CheckGears(new int[1], g);
            NextPlayer();
          } else if (g.player == currentPlayer) {
            // if the gear is the same as this player. Select the gear to move it next click
            g.selected = true;
            selectedGear = g;
          }

          // If another gear has been selected before move the selected gear to the new spot or cancel the selection
        } else {
          if (g.player == 0) {
            selectedGear.player = 0;
            selectedGear.selected = false;
            selectedGear = null;
            g.player = currentPlayer;
            NextPlayer();
          } else if (g.selected) { // If the to be selected gear gets selected again
            g.selected = false;
            selectedGear = null;
            return false;
          }
        }
      }
    }

    // if everything went well return true
    return true;
  }

  public boolean CheckGears(int[] visitedGears, Gear currentGear) {

    // Check every neighbour of the current gear
    // same row
    Gear l = GetLeftGear(currentGear);
    Gear r = GetRightGear(currentGear);

    // upper row
    Gear tl = GetTopLeftGear(currentGear);
    Gear tr = GetTopRightGear(currentGear);

    // lower row
    Gear bl = GetBottomLeftGear(currentGear);
    Gear br = GetBottomRightGear(currentGear);
    
    // Check if left core is stuck
    coreGears[0].SetRotation("r");
    
    // Check if right core is stuck
    coreGears[1].SetRotation("l");
    
    

    return true;
  }

  public Gear GetRightGear(Gear g) {
    // Get potential gear's index
    int potentialIndex = g.id + 1;
    // Check if index is out of range
    if (potentialIndex < 0 || potentialIndex >= gears.length)
      return null;
    Gear potentialGear = gears[potentialIndex];
    // Check if it is not null
    if (g.row == potentialGear.row)
      return potentialGear;
    return null;
  }

  public Gear GetLeftGear(Gear g) {
    // Get potential gear's index
    int potentialIndex = g.id - 1;
    // Check if index is out of range
    // Check if index is out of range
    if (potentialIndex < 0 || potentialIndex >= gears.length)
      return null;
    Gear potentialGear = gears[potentialIndex];
    // Check if it is on the same row
    if (g.row == potentialGear.row)
      return potentialGear;
    return null;
  }

  public Gear GetTopRightGear(Gear g) {
    // Get potential gear's index
    int potentialIndex = g.id - g.row;
    // Check if index is out of range
    if (potentialIndex < 0 || potentialIndex >= gears.length)
      return null;
    Gear potentialGear = gears[potentialIndex];
    // Check if it is on the above row
    if (g.row == potentialGear.row + 1)
      return potentialGear;
    return null;
  }

  public Gear GetTopLeftGear(Gear g) {
    // Get potential gear's index
    int potentialIndex = g.id - g.row - 1;
    // Check if index is out of range
    if (potentialIndex < 0 || potentialIndex >= gears.length)
      return null;
    Gear potentialGear = gears[potentialIndex];
    // Check if it is on the above row
    if (g.row == potentialGear.row + 1)
      return potentialGear;
    return null;
  }
  public Gear GetBottomLeftGear(Gear g) {
    // Get potential gear's index
    int potentialIndex = g.id + g.row + 1;
    // Check if index is out of range
    if (potentialIndex < 0 || potentialIndex >= gears.length)
      return null;
    Gear potentialGear = gears[potentialIndex];
    // Check if it is on the below row
    if (g.row == potentialGear.row - 1)
      return potentialGear;
    return null;
  }
  public Gear GetBottomRightGear(Gear g) {
    // Get potential gear's index
    int potentialIndex = g.id + g.row + 2;
    // Check if index is out of range
    if (potentialIndex < 0 || potentialIndex >= gears.length)
      return null;
    Gear potentialGear = gears[potentialIndex];
    // Check if it is on the below row
    if (g.row == potentialGear.row - 1)
      return potentialGear;
    return null;
  }


  public int[] GetAmount() {
    int[] result = new int[2];
    for (Gear g : gears) {
      if (g.player == 1)
        result[0]++;
      else if (g.player == 2)
        result[1]++;
    }

    return result;
  }

  public void NextPlayer() {
    currentPlayer = currentPlayer != 1 ? 1 : 2;
  }
}
