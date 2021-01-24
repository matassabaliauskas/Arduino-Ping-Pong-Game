import processing.serial.*;

Serial myPort;

/* some variables with specifications for program */
final int WIDTH = 800;
final int HEIGHT = 600;

final int PADDLE_HEIGHT = 100;
final int PADDLE_WIDTH = 20;

final int PADDLE_A_POSX = 30;
final int PADDLE_B_POSX = 740;

final int BALL_HEIGHT = 20;
final int BALL_WIDTH = 20;

final int SPEEDX_INIT = 10;
final int SPEEDY_INIT = 10;
final int POSX_INIT = WIDTH / 2;
final int POSY_INIT = HEIGHT / 2;

final int LF = 10; /* ASCII linefeed */

final int WIN_SCORE = 5;

int speedX = SPEEDX_INIT, speedY = SPEEDY_INIT;
int posX = POSX_INIT, posY = POSY_INIT;

int scoreA = 0;
int scoreB = 0;

int paddleAPos = 0;
int paddleBPos = 0;

int paddleASpeed = 0;
int paddleBSpeed = 0;

int time = 0; /* time keeping for drawing loop */

boolean pause = true; /* game is paused */
boolean scored = false; /* pause after player has scored */
boolean stop = true; /* game has not started */
String won = ""; /* which player has won */

PFont f;

void setup() {
  /* font for displaying text */
  f = createFont("ARCADECLASSIC", 200, true);
  textFont(f, 130);

  /* initialise Serial port */
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil(LF);

  /* set window size */
  size(800, 600);
}

void keyPressed() {
  won = "";
  pause = !pause;
  stop = false;
}

void serialEvent(Serial myPort) {
  /* this function is called whenever a line is received over the serial port */
  try {
    /* read string and parse into paddleAPos and paddleBPos */
    // enter code here
    String raw = myPort.readString();
    raw = raw.replace("\n", ""); // remove newline
    raw = raw.replace("\r", ""); // remove newline
    
    String[] parts = raw.split(","); // split array
    // parts[0] -> 1st value, parts[1] -> 2nd value

    int prevPosA = paddleAPos;
    int prevPosB = paddleBPos;

    paddleAPos = Integer.parseInt(parts[0]);
    paddleBPos = Integer.parseInt(parts[1]);
    
    paddleASpeed = (paddleAPos - prevPosA) / 3;
    paddleBSpeed = (paddleBPos - prevPosB) / 3;
    
    
  } catch (Exception ex) {
    ex.printStackTrace();
  }
  
}

void scoreA() {
  scoreA++; /* increment score */
  posX = POSX_INIT; /* reset ball postion */
  posY = POSY_INIT;
  speedX = -speedX; /* reverse x direction, ball moves towards scoring player */
  speedY = SPEEDY_INIT;
  scored = true; /* to pause game for 2 seconds (caught in draw loop) */
  if (scoreA >= WIN_SCORE) { /* player A won */
    won = "A"; /* set a flag for drawing loop */
    scoreA = 0; /* reset score for next game */
    scoreB = 0;
    stop = true; /* set another flag */
    speedX = SPEEDX_INIT; /* reset speed */
    speedY = SPEEDY_INIT;
  }
}

void scoreB() {
  scoreB++; /* increment score */
  posX = POSX_INIT; /* reset ball position */
  posY = POSY_INIT;
  speedX = -speedX; /* reverse x direction, ball moves towards scoring player */
  speedY = SPEEDY_INIT;
  scored = true; /* to pause game for 2 seconds (caught in draw loop) */
  if (scoreB >= WIN_SCORE) { /* player B won */
    won = "B"; /* set flag for drawing loop */
    scoreA = 0; /* reset score for next game */
    scoreB = 0;
    stop = true; /* set another flag */
    speedX = SPEEDX_INIT; /* reset speed */
    speedY = SPEEDY_INIT;
  }
}

void printScoreA(int score) {
  fill(255); /* white font */
  textFont(f, 130); /* font size 130 */
  if (score < 10) { /* place text on screen */
    text(" " + score, 230, 100);
  } else {
    text(score, 230, 100);
  }
}

void printScoreB(int score) {
  fill(255); /* white font */
  textFont(f, 130); /* font size 130 */
  if (score < 10) { /* place text on screen */
    text(" " + score, 470, 100);
  } else {
    text(score, 470, 100);
  }
}

void collisionDetection() {
  if (posX > WIDTH - BALL_WIDTH) {
    scoreA(); /* ball reached end of board at right side */
  }
  if (posY > HEIGHT - BALL_HEIGHT) {
    speedY = -speedY; /* ball reached bottom -> reverse y direction */
  }
  if (posX < 0) {
    scoreB(); /* ball reached end of board at left side */
  }
  if (posY < 0) {
    speedY = -speedY; /* ball reached top -> reverse y direction */
  }

  if (posX <= PADDLE_A_POSX + PADDLE_WIDTH && posX > PADDLE_A_POSX + PADDLE_WIDTH + speedX) {
    /* ball has reached paddle area -> check whether paddle is at correct position */
    if (posY + BALL_HEIGHT > paddleAPos / 2 && posY < paddleAPos / 2 + PADDLE_HEIGHT) {
      /* ball hit paddleA -> reverse x direction */
      speedX = -speedX;
      speedY += paddleASpeed;
    }
  }

  if (posX + BALL_WIDTH >= PADDLE_B_POSX && posX + BALL_WIDTH < PADDLE_B_POSX + speedX) {
    /* ball has reached paddle area -> check whether paddle is at correct position */
    if (posY + BALL_HEIGHT > paddleBPos / 2 && posY < paddleBPos / 2 + PADDLE_HEIGHT) {
      /* ball hit paddle B -> reverse x direction */
      speedX = -speedX;
      speedY += paddleBSpeed;
    }
  }
}

void printPaddleA() {
  /* draw rectangle for paddle in correct position */
  // enter code here
  //int paddleAPos = 100;
  
  rect(PADDLE_A_POSX, paddleAPos/2, PADDLE_WIDTH, PADDLE_HEIGHT);      // rectangle at x =PADDLE_A_POSX, y = paddleAPos (variable), width = PADDLE_WIDTH, height = PADDLE_HEIGHT
  // paddleAPos can have a max range of 512, while the serial input from the arduino is between 0 and 1024. So paddleAPos is divided by 2.
}

void printPaddleB() {
  /* draw rectangle for paddle in correct position */
  // enter code here
  //int paddleBPos = 300;
  
  rect(PADDLE_B_POSX, paddleBPos/2, PADDLE_WIDTH, PADDLE_HEIGHT);      // rectangle at x =PADDLE_B_POSX, y = paddleAPos (variable), width = PADDLE_WIDTH, height = PADDLE_HEIGHT
}

void moveBall() {
  /* move ball depending on speedX and speedY */
  // enter code here
  posX += speedX;
  posY += speedY;

}

void drawBall() {
  /* draw rectangle for ball at right position */
  // enter code here
  rect(posX, posY, BALL_WIDTH, BALL_HEIGHT);
  
}

void draw() {
  /* clear your window and set background to black */
  clear();
  int passed_time = millis() - time;

  /* pause game for 2 seconds after scoring */
  if (scored && !stop && passed_time > 2000) {
    scored = false;
  }

  /* display message if a player won */
  if (won.equals("A")) {
    fill(255);
    textFont(f, 90);
    text("Player  A  won", 150, 300);
    return;
  } else if (won.equals("B")) {
    fill(255);
    textFont(f, 90);
    text("Player  B  won", 150, 300);
    return;
  }

  /* Print text PAUSE when paused */
  if (pause) {
    fill(255);
    textFont(f, 90);
    text("PAUSE", 300, 450);
  }

  /* draw middle line */
  fill(255);
  for (int i = 0; i < 23; i++) {
    rect(398, i * 27 + 10, 4, 15);
  }

  /* draw scores */
  printScoreA(scoreA);
  printScoreB(scoreB);

  /* move ball every 20ms if game is not paused */
  if (passed_time > 20 && !stop && !pause && !scored) {
    moveBall();
    collisionDetection();
    time = millis();
  }

  /* print paddle and ball */
  printPaddleA();
  printPaddleB();
  drawBall();

}
