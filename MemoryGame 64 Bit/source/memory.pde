//Author:Allan Joshua Luke
//Date: 21/03/2013
//Purpose: An implementation of the classis memory game/concentration game. 
//Input: The user interacts with the program using the mouse or keyboard. The game supports upto 3 players.
//Output: The game.


//0 is clubs,1 is spades, 2 is hearts, 3 is diamond, 4 is jokers.
Card [][] cards = new Card [5][13]; //contains card objects
int [] [] click = new int [2][2]; //tracks which cards are clicked
PImage [] srules = new PImage [4]; //images for rules screen
int [] [] up = new int [2][2];
Player [] players; //array of players
int [] [] tagged; //tagged cards for hints
//MISC IMAGES
PImage back; 
PImage cback;
PImage restart;
PImage match;
PImage cback2;
PImage turn;
PImage arrow;
PImage rule;
PImage hint;
PImage cheat;
PImage scoreImg;
PImage playerImg;
PImage input;
////END
PFont score; // font for score
int currentPlayer = 0; //tracks the current player
boolean showcback2 = false; //if the red back should be shown or not.
boolean rules = true; // if the rules should be displayed
int count = 0; //keeps track of clicks in rules state.
boolean cheatOn = false;
float splitx; // misc display
boolean hints = false; // show hints?
boolean showMatch = false;
int gap = 5; //misc display
int gapy; //misc display
int maxhint;
int clicks = -1; //clicks in game state.
int numPlayers = -1; // how many players are in the game
int inputPlayer = 0; //keeps track of for which player the info is being entered for
/////////////////////////////////SETUP///////////////////////////////////SETUP//////////////////////////////////////////////SETUP///////////////////
void setup()
{
  cards = new Card [5][13]; //contains card objects
  click = new int [2][2]; //tracks which cards are clicked
  srules = new PImage [5]; //images for rules screen
  clicks = -1;
  numPlayers = -1;
  inputPlayer = 0;
  gap = 5;
  showMatch = false;
  hints = false;
  count = 0;
  rules = true;
  showcback2 = false;
  currentPlayer = 0;
  back = loadImage ("back.jpg");
  scoreImg = loadImage ("board.png");
  cback = loadImage ("cback.png");
  input = loadImage ("inputs.png");
  cback2 = loadImage ("cback2.png");
  hint = loadImage ("hint.png");
  arrow = loadImage ("arrow.png");
  score = loadFont ("score.vlw");
  cheat = loadImage ("cheat.png");
  match = loadImage ("match.png");
  playerImg = loadImage ("playerlog.png");
  int sizex = 1000; //MODIFY THIS FOR WINDOW SIZE!
  size(sizex, sizex/2+cback.height + gap);
  for (int i = 0; i < 5;i++)
  {
    srules[i] = loadImage("r"+i+".png");
    if (i!=2 && i!=3 && i!=4)
      srules[i].resize(width, height);
  } 
  restart = loadImage("restart.png");
  turn = loadImage ("turn.png");
  rule = loadImage ("rule.png");
  load();

  splitx = width/13;
  gapy = height /(cards[0][0].card.height);
  if (splitx < (cards[0][0].card.width+gap))
  {
    float temp = (cards[0][0].card.width+gap) - splitx;
    int dx = cards[0][0].card.width - (int)temp;
    int dy = cards[0][0].card.height - (int)temp;
    cback.resize(dx, dy);
    cback2.resize (dx, dy);

    for (int i = 0; i < 5; i++)
      for (int j = 0; j < 13 ;j++)
      {
        cards[i][j].card.resize(dx, dy);
        if (i == 4 && j == 1)
          break;
      }
  }  
  scoreImg.resize(scoreImg.width, height-(cards[0][0].card.height * 4 + 6*gapy));
  shuffle();
}

/////////////////////////////////////////MOUSECLICKED////////////////////////////////////////////////MOUSECLICKED///////////////////////
void mouseClicked ()
{
  if (mouseX > 1.5*splitx+gap+width/30-150 && mouseX < (1.5*splitx+gap+width/30-150) + (width - 2*splitx+gap)/7+25)
    if (mouseY > cards[0][0].card.height * 5.5 + 6*gapy-20 && mouseY < (cards[0][0].card.height * 5.5 + 6*gapy-20) + (height - cards[0][0].card.height * 4 + 6*gapy)/5)
      cheat();
  int col = ((int)((mouseX/splitx)-((float)gap/cards[0][0].card.width))); //intense calculations..
  int row =((int) ((mouseY/((cards[0][0].card.height+gapy))))); 

  if (rules &&( count !=4 &&  count != 3))
  {

    if (mouseX > (width-arrow.width-splitx) && mouseX < width-splitx && mouseY > height/2 - gap && mouseY < height/2 - gap + arrow.height)
    {
      count++;
      if (count > 4)
      {
        count = 0;
        rules = false;
      }
    }
  }
  else
  {  
    if ((row < 4 && col < 13 || row == 4 && col < 2 ) && clicks < 1 && !cheatOn)
    {
      if (!cards[row][col].up && cards[row][col].show)
      {
        clicks++;
        showMatch = true;
        click [clicks][0] = row;
        click [clicks][1] = col;
        cards [row][col].up = !cards[row][col].up;
      }
    }
    else guiCheck(mouseX, mouseY);
  }
}

//////////////////////////////////////////////////DRAW////////////////////////////////////////DRAW//////////////////////////////DRAW//////////////////
void draw()
{
  if (gameOver())
  {
    PImage done = loadImage ("done.jpg");
    done.resize(width, height);
    image (done, 0, 0);
    noLoop();
  }
  else if (!rules)
  {
    image(back, 0, 0);
    image (cheat, 1.5*splitx+gap+width/30-150, cards[0][0].card.height * 5.5 + 6*gapy-20, (width - 2*splitx+gap)/7+25, (height - cards[0][0].card.height * 4 + 6*gapy)/5);

    back.resize(width, height);
    for (int i = 0; i < 5; i++)
      for (int j = 0; j < 13 ;j++)
      { 
        if (cards[i][j].show)
        {
          if (cards[i][j].up)
            image (cards[i][j].card, gap+ (j*(gap + cards[0][0].card.width)), gapy +(cards[0][0].card.height+gapy)*i);
          else
            if (!showcback2)
              image (cback, gap+ (j*(gap + cards[0][0].card.width)), gapy +(cards[0][0].card.height+gapy)*i);
            else
              image (cback2, gap+ (j*(gap + cards[0][0].card.width)), gapy +(cards[0][0].card.height+gapy)*i);
          if (cards[i][j].tagged)
          {
            if (showcback2)
              fill(0, 0, 255, 100);
            else
              fill(255, 0, 0, 100);
            rect (gap+ (j*(gap + cards[0][0].card.width)), gapy +(cards[0][0].card.height+gapy)*i, cards[0][0].card.width, cards[0][0].card.height);
          }
        }
        if (i ==4 && j == 1)
          break;
      }
    gui();
    scoreBoard(numPlayers, 1.5*splitx+gap + width/30+ ((width - 2*splitx+gap)/5), cards[0][0].card.height * 4 + 6*gapy);
  }
  if (rules)
  {
    background(0);
    rules(count);
  }
}


/////////////////////////////////////////RULES////////////////////////////////////////RULES//////////////////////////////////////////RULES////////////////////////////////RULES
void rules (int screen)
{
  float x = 0;
  float y = 0;
  background (0);
  if (screen == 3 || screen == 2)
    x = width/3;
  image(srules[screen], x, y);
  if (screen !=3 && screen !=4)
    image (arrow, width-arrow.width-splitx, height/2 - gap);

  if (screen == 4)
  {
    image(playerImg, 50, height/2);
    image(input, 50, height/2 + playerImg.height);
    textFont(score, 48);
    fill(124, 0, 0);
    text((inputPlayer+1), playerImg.width+5, height/2+85);
    String displayh = "";
    String displayv ="";
    if (players[inputPlayer].hints > 0 && players[inputPlayer].hints < 10)
      displayh = players[inputPlayer].hints +"";
    if (players[inputPlayer].maxhint > 0 && players[inputPlayer].maxhint < 10)
      displayv = players[inputPlayer].maxhint + "";
    text(displayh, width/2-53, height/2+187);
    text(displayv, width/2-53, height/2+237);
  }
}

/////////////////////////////////////GUI////////////////////////////////////////GUI//////////////////////////////////////////////////GUI////////////////////////////////////////GUI
void gui ()
{
  fill(124, 0, 0);
  stroke(0);
  rect (2*splitx+gap, cards[0][0].card.height * 4 + 6*gapy, width, height);
  image (restart, 1.5*splitx+gap + width/30, cards[0][0].card.height * 4 + 5*gapy, (width - 2*splitx+gap)/5, (height - cards[0][0].card.height * 4 + 6*gapy)/4); //restart
  image (turn, 1.5*splitx+gap + width/30, cards[0][0].card.height * 4.5 + 4*gapy, (width - 2*splitx+gap)/7, (height - cards[0][0].card.height * 4 + 6*gapy)/5); // turn
  image (rule, 1.5*splitx+gap + width/30, cards[0][0].card.height * 4.85 + 4*gapy, (width - 2*splitx+gap)/5, (height - cards[0][0].card.height * 4 + 6*gapy)/5); //shuffle
  if (clicks == 0 && players[currentPlayer].hints > 0)
    image (hint, 1.5*splitx+gap + width/30, cards[0][0].card.height * 5.15 + 6*gapy, (width - 2*splitx+gap)/7, (height - cards[0][0].card.height * 4 + 6*gapy)/5);//hint
  if ( matchNoFlip (click[0][0], click[0][1], click[1][0], click[1][1]) && showMatch)
    image (match, 1.5*splitx+gap+width/30+15, cards[0][0].card.height * 5.5 + 6*gapy-20, (width - 2*splitx+gap)/7+25, (height - cards[0][0].card.height * 4 + 6*gapy)/5); //match
}

////////////////////////////////////////////GUICHECK////////////////////////////////////////////////GUICHECK///////////////////////////////////////GUICHECK////////////////////////GUICHECK
void guiCheck(int x, int y)
{
  if ((x > 1.5*splitx+gap + width/30) && (x <( 1.5*splitx+gap + width/30) +(width - 2*splitx+gap)/5 -10 ) && !cheatOn)
  {
    if (y >  cards[0][0].card.height * 4 + 5*gapy && y <  cards[0][0].card.height * 4.5 + 4*gapy) //restart
      setup();
    if (y >  cards[0][0].card.height * 4.5 + 4*gapy && y <  cards[0][0].card.height * 4.5 + 4*gapy + (height - cards[0][0].card.height * 4 + 6*gapy)/5 && clicks > 0)//turn
      if (x < ( 1.5*splitx+gap + width/30) +(width - 2*splitx+gap)/5 -60 && !matchNoFlip (click[0][0], click[0][1], click[1][0], click[1][1]))
      {
        turn();
        updateGame();
      }
    if (y > cards[0][0].card.height * 4.85 + 4*gapy && y < cards[0][0].card.height * 4.85 + 4*gapy+ (height - cards[0][0].card.height * 4 + 6*gapy)/5)//shuffle
      shuffle();
    if (y > cards[0][0].card.height * 5.3 + 6*gapy && y <( cards[0][0].card.height * 5.15 + 6*gapy) + ((height - cards[0][0].card.height * 4 + 6*gapy)/5) && clicks == 0 && !hints &&  players[currentPlayer].hints > 0)
    {
      if (!hints)
        hint(players[currentPlayer].maxhint);
    }
    if (y > cards[0][0].card.height * 5.5 + 6*gapy-20 && y < (cards[0][0].card.height * 5.5 + 6*gapy-20) + ( (height - cards[0][0].card.height * 4 + 6*gapy)/5) && matchNoFlip (click[0][0], click[0][1], click[1][0], click[1][1]))
    {
      players[currentPlayer].matched();
      updateGame();
      match (click[0][0], click[0][1], click[1][0], click[1][1]);
      showMatch = false;
    }
  }
}

/////////////////////////////////LOAD////////////////////////////////////////////////////LOAD///////////////////////////////////////////LOAD//////////////////////////LOAD////
void load ()
{
  int suit = 0;
  int card = 1;
  for (int i = 0;suit < 4;card+=4,i++)
  {
    cards [suit] [i] = new Card (loadImage (card+".png"), i, suit);
    if (card > 54 || i == 12)
    {
      card = suit - 2;
      suit++;
      i = -1;
    }
  }
  cards [4][0] = new Card (loadImage ("53.png"), 0, 4);
  cards [4][1] = new Card (loadImage ("54.png"), 0, 4);
} 

void turn ()
{
  cards [click[0][0]][click[0][1]].up = false;
  cards [click[1][0]][click[1][1]].up = false;
}

//////////////////////////////////HINT/////////////////////////////////////////HINT//////////////////////////////////////////////HINT//////////////////////HINT///////
void hint (int val)
{
  players[currentPlayer].hintUse();
  hints = true;
  int row;
  int col;
  for (int i = 0; i < 5;i++)
    for (int j = 0;j < 13;j++)
    {
      if (matchNoFlip(click [0][0], click[0][1], i, j))
      {
        cards [i][j].tagged = true;
        tagged [0][0] = i;
        tagged [0][1] = j;
      }
      if (i == 4 && j > 0)
        break;
    }
  for (int i = 0; i < players[currentPlayer].maxhint-1;i++)
  {
    row = (int) random (0, 5);
    if (row == 4)
      col = (int) random (0, 2);
    else
      col = (int) random (0, 13);
    cards[row] [col].tagged = true;
    tagged [i+1][0] = row;
    tagged [i+1][1] = col;
  }
}

///////////////////////////////////////////SHUFFLE///////////////////////////////////////SHUFFLE///////////////////////////////////////SHUFFLE//////////////////////SHUFFLE////
void shuffle()
{
  int row;
  int col;
  clicks = -1;
  for (int i = 0; i < 5; i++)
    for (int j = 0; j < 13 ;j++)
    {
      Card temp =  cards[i][j];
      temp.up = false;
      temp.show = true;
      row = (int) random (0, 5);
      if (row == 4)
        col = (int) random (0, 2);
      else
        col = (int) random (0, 13);
      cards[row][col].up = false;
      cards[row][col].show = true;
      cards[i][j] = cards [row][col];
      cards [row][col] = temp;
      if (i == 4 && j == 1)
        break;
    }
  for (int i = 0; i < numPlayers;i++)
  {
    players[i].score = 0;
    players[i].hints = players[i].startHints;
  }
  noTags();
  click = new int [2][2];
}

///////////////////////////////////////////////////MATCH//////////////////////////////////MATCH///////////////////////////////MATCH////////////////////////////MATCH
boolean match (int r, int c, int r2, int c2)
{
  boolean matched = false;
  if (r == r2 && c == c2)
    return matched;
  if (cards [r][c].suit == cards [r2][c2].suit && cards[r][c].rank == cards [r2][c2].rank)
  {

    cards [click[0][0]][click[0][1]].show = false;
    cards [click[1][0]][click[1][1]].show = false;
    matched = true;
  }
  turn();
  noTags();
  clicks = -1;
  hints = false;
  return matched;
}

/////////////////////////////////////////////////////////////MatchNoFlip//////////////////////////////////////////////////////////////////
boolean matchNoFlip (int r, int c, int r2, int c2)
{
  if (r == r2 && c == c2)
    return false;
  else
    return (cards [r][c].suit == cards [r2][c2].suit && cards[r][c].rank == cards [r2][c2].rank);
}
///////////////////////////////////////////////KEYPRESSED////////////////////////////KEYPRESSED///////////////////////////////KEYPRESSED//////////////////////KEYPRESSED
void keyPressed ()
{
  if (rules)
  {
    if (count == 4)
    {
      if (players [inputPlayer].hints > 9 || players[inputPlayer].hints <= 0)
      {
        players[inputPlayer].hints =  Character.getNumericValue(key);
        players[inputPlayer].startHints =  Character.getNumericValue(key);
      }
      else if (players [inputPlayer].maxhint > 9 || players[inputPlayer].maxhint <= 0)
        players [inputPlayer].maxhint = Character.getNumericValue(key);
      else 
        inputPlayer++;
      if (inputPlayer == numPlayers)
      {
        int max = 0;
        for (int i = 0; i < numPlayers;i++)
        {
          if (players[i].maxhint > max)
            max = players[i].maxhint;
        }
        tagged = new int [max][2];  
        maxhint = max;
        rules = false;
      }
    }
    if (count == 3)
    {
      numPlayers = Character.getNumericValue(key); //parse key press to int
      if (numPlayers > 0 && numPlayers < 4)
      {
        count++;
        players = new Player [numPlayers];
        for (int i = 0;i < numPlayers;i++)
          players [i] = new Player(-1, -1);
      }
    }
  }
  else if (!cheatOn)
  {
    if (key == 'b')
      showcback2 = !showcback2;
    if (key == 't' && clicks > 0)
    {
      if ( !matchNoFlip (click[0][0], click[0][1], click[1][0], click[1][1]))
      {
        turn();
        updateGame();
      }
    }
    if (key == 'r')
      setup();
    if (key == 'h' && clicks == 0 && !hints && players[currentPlayer].hints > 0)
      hint(players[currentPlayer].maxhint);
    if (key == 'm' && matchNoFlip (click[0][0], click[0][1], click[1][0], click[1][1]) && showMatch)
    {
      players[currentPlayer].matched();
      updateGame();
      match (click[0][0], click[0][1], click[1][0], click[1][1]);
      showMatch = false;
    }
  }
}
/////////////////////////////////////////////NOTAGS/////////////////////////////////////////////////NOTAGS////////////////////////////NOTAGS/////
void noTags()
{
  if (hints)
  {
    for (int i = 0; i < maxhint; i++)
      cards [tagged[i][0]] [tagged[i][1]].tagged = false;
  }
}

/////////////////////////////////////////SCOREBOARD////////////////////////////////////SCOREBOARD////////////////SCOREBOARD
void scoreBoard(int numPlayers, float startx, float starty)
{
  float split = (width-startx) /numPlayers;
  for (int i = 0; i < numPlayers;i++)
  {
    line(startx +(split*i), starty, startx + (split*i), height);
    image(scoreImg, startx +(split*i), starty);
    textFont (score, 20);
    fill(0);
    if (numPlayers == 1)
    {
      text (players[i].score, startx+(split*(i+1))-((split/2)+170), starty+47); //score
      text (players[i].hints, startx+(split*(i+1)) -( (split/2)+170), starty + 47*2);
      text (players[i].maxhint, startx+(split*(i+1)) - ((split/2)+170), starty + 47 *3);
    }
    else if (numPlayers == 2)
    {
      text (players[i].score, startx+(split*(i+1))-(split/2)+12, starty+48); //score
      text (players[i].hints, startx+(split*(i+1)) - (split/2)+12, starty + 48*2);
      text (players[i].maxhint, startx+(split*(i+1)) - (split/2)+12, starty + 48 *3);
    }
    else
    {
      text (players[i].score, startx+(split*(i+1))-(split/3)+20, starty+46); //score
      text (players[i].hints, startx+(split*(i+1))-(split/3)+20, starty + 46*2);
      text (players[i].maxhint, startx+(split*(i+1))-(split/3)+20, starty + 46 *3);
    }
  }
  line(startx +(split*numPlayers+1), starty, startx + (split*numPlayers+1), height);
}

///////////////////////////////////////////gameOver////////////////////////////////////////???????????????????????
boolean gameOver()
{
  int score = 0;
  for (int i = 0; i < numPlayers;i++)
    score+= players[i].score;
  return (score == 27);
}

/////////////////////////////////////////////updateGame////////////////////////////updateGame/////////////////////
void updateGame()
{
  noTags();
  currentPlayer++;
  clicks = -1;
  if (currentPlayer == numPlayers)
    currentPlayer = 0;
} 
///////////////////////////////////////////////////////////////////CHEAT////////////////////////////////CHEAT//////////////////CHEAT////////////
void cheat ()
{
  cheatOn = !cheatOn;
  if (cheatOn)
  {
    int lcount = 0;
    for (int i = 0; i < 5;i++)
      for (int j = 0;j < 13;j++)
      {
        if (lcount < clicks +1)
        if (cards[i][j].up)
        {
          up[lcount][0] = i;
          up [lcount] [1] = j;
          lcount++;
        }
          cards[i][j].up = true;
        if (i == 4 && j > 0)
          break;
    
      }
  }
  else 
  {
    int lcount = 0 ;

    for (int i = 0; i < 5;i++)
      for (int j = 0;j < 13;j++)
      {
        if (lcount < clicks+1)
        {
        if (up[lcount][0] == i && up[lcount][1] == j)
        {
          lcount++;
        }
        else
          cards[i][j].up = false;
        }
         else  cards[i][j].up = false;
        if (i == 4 && j > 0)
          break;
      }
  }
}

  //////////////////////////CARD CLASS/////////////////////////////CARD CLASS////////////////////////CARD CLASS////////////////////////////////CARD CLASS///////
  class Card 
  {
    boolean up = false;
    boolean show = true;
    PImage card;
    boolean tagged = false; 
    int rank;
    int suit;
    public Card(PImage face, int num, int col)
    {
      card = face;
      image (card, 0, 0);
      rank = num;
      if (col == 1 || col == 0)
        suit = 1;
      else if (col == 2 || col ==3)
        suit = 2;
      else 
        suit = col;
    }
  }

  ///////////////////////////PLAYER CLASS//////////////////////PLAYER CLASS///////////////PLAYER CLASS
  class Player
  {
    int hints = -1;
    int maxhint = -1;
    int score;
    int startHints = 0;
    Player (int hintval, int numHints )
    {
      maxhint = hintval;
      score = 0;
      hints = numHints;
    }

    void matched()
    {
      score++;
    }

    void hintUse()
    {
      hints--;
    }
  }

