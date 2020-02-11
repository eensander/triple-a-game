


int max_velocity = 0;
int max_particles = 1500;

ArrayList<Particle> particles;
MainFrame mainFrame;

ShipSelf shipSelf;
ArrayList<Bullet> selfBullets;

int max_violent_ships = 3;
ArrayList<Ship> violentShips;



boolean keyLeft, keyRight, keyUp, keyDown, keySpace;

int background_r = 255;
int background_b = 0;
int background_g = 0;
int background_i = 0;

int lastShot = 0;

int gamestate = 0;

int score = 0;

void setup() {
	
	size(1000,600);
	colorMode(RGB, 255);

	//background(180, 60, 50);
	background(5, 5, 5);
	//stroke(255);
	frameRate(60);
	
		
	mainFrame = new MainFrame(width/2, height/2, Color(240,200,190,255));
	
	particles = new ArrayList<Particle>();
	selfBullets = new ArrayList<Bullet>();
	violentShips = new ArrayList<Ship>();
	
	shipSelf = new ShipSelf(width/2, height/2, 2, color(16,128,32));
	
	score = 0;
	
}

void draw() {
	if(background_r > 0 && background_b <= 0){
		background_r--;
		background_g++;
	}
	if(background_g > 0 && background_r <= 0){
		background_g--;
		background_b++;
	}
	if(background_b > 0 && background_g <= 0){
		background_r++;
		background_b--;
	}
	//background(sin(0.1*background_i+0)*20, sin(0.1*background_i+2)*20, sin(0.1*background_i+4)*20);
	background(background_r/255*20, background_g/255*20, background_b/255*20);
	
	
	switch (gamestate)
	{
		
		case 0:
		
			gamestate_main();
			break;
		
		
		case 1:
			
			gamestate_playing();
			break;
		
		case 2:
		
			gamestate_gameover();
			break;
		
	}
	
}

void gamestate_main() {
	
	//background(2,5,2);

	btn_start = new Button("Start", width/2-26, 150, 25, color(244));
	btn_opt = new Button("Options", width/2-43, 180, 25, color(204));
	
	
	btn_start.display();
	btn_opt.display();
	
	btn_start.update();
	btn_opt.update();

	

	/*
	 * 37 - links
	 * 38 - boven
	 * 39 - rechts
	 */
	
	if(btn_opt.pressed()) {
		background(128,255,200);
		
	}
	
	if(btn_start.pressed()) {
		//setup();
		gamestate = 1;
		////shipMeLoc = {width/2, height-50};
	}
	
}

void gamestate_gameover() {


	font = loadFont("FFScala.ttf");
	textFont(font);
	textSize(40);
	fill(200,30,30);
	text("GAME OVER", width/2-112, height/2); 
	
	textFont(font);
	textSize(25);
	fill(90,90,90);
	text("Score: ", width/2-62, height/2+40); 
	fill(255, 255, 255);
	text(score, width/2+40, height/2+40);
	
	btn_start = new Button("Start", width/2-26, 150, 25, color(244));
	btn_opt = new Button("Options", width/2-43, 180, 25, color(204));
	
	
	btn_start.display();
	btn_opt.display();
	
	btn_start.update();
	btn_opt.update();

	

	/*
	 * 37 - links
	 * 38 - boven
	 * 39 - rechts
	 */
	
	if(btn_opt.pressed()) {
		background(128,255,200);
		
	}
	
	if(btn_start.pressed()) {
		setup();
		gamestate = 1;
		////shipMeLoc = {width/2, height-50};
	}
	
}


void gamestate_playing() {
	

	
	//for (Particle part : particles) {
	for (int i = particles.size() - 1; i >= 0; i--) {
		Particle part = particles.get(i);
		if (part.finished())
			particles.remove(i);
		part.update();
		part.display();
	}
	
	for (int i = selfBullets.size() - 1; i >= 0; i--) {
		Bullet bullet = selfBullets.get(i);
		for (int ii = violentShips.size() - 1; ii >= 0; ii--) {
			violentShip = violentShips.get(ii);
			selfLoc = shipSelf.getLoc();
			violentLoc = violentShip.getLoc();
			//if (selfLoc[2] >= violentLoc[2] && selfLoc[2] <= selfLoc[2]+selfLoc[0] || selfLoc[3] >= violentLoc[3] && selfLoc[3] <= selfLoc[3]+selfLoc[1])
			if (violentShip.checkCollide(bullet.getLoc()))
			{
				violentShip.damage(bullet.getDamage());
				score += violentShip.getDamageScore();
		
				mainFrame.setX(violentShip.getX());
				mainFrame.setY(violentShip.getY());
				for (int prt_i = 0; prt_i < random(3, 6); prt_i ++ )
				{
					if (particles.size() > max_particles-1)
						particles.remove(0);
					particles.add(new Particle(mainFrame));			
				}
				
				selfBullets.remove(i);
				//if (violentShip.finished())
					//violentShips.remove(ii);
				
			}
		}
		if (bullet.finished())
			selfBullets.remove(i);
		bullet.update();
		bullet.display();
	}
	
	for (int i = violentShips.size() - 1; i >= 0; i--) {
		Ship ship = violentShips.get(i);
		if (ship.finished())
		{
			score += ship.getKillScore();
			violentShips.remove(i);
			mainFrame.setX(ship.getX());
			mainFrame.setY(ship.getY());
			for (int prt_i = 0; prt_i < random(18, 26); prt_i ++ )
			{
				if (particles.size() > max_particles-1)
					particles.remove(0);
				particles.add(new Particle(mainFrame));			
			}
		}
		
		selfLoc = shipSelf.getLoc();
		violentLoc = ship.getLoc();

		if (selfLoc[2] >= violentLoc[2]-violentLoc[0]/2 && selfLoc[2] <= violentLoc[2]+violentLoc[0]/2 && selfLoc[3] >= violentLoc[3]-violentLoc[1]/2 && selfLoc[3] <= violentLoc[3]+violentLoc[1]/2)
		{
			
			shipSelf.damage(ship.getSuicideDamage());
			
			mainFrame.setX(ship.getX());
			mainFrame.setY(ship.getY());
			for (int prt_i = 0; prt_i < random(20, 30); prt_i ++ )
			{
				if (particles.size() > max_particles-1)
					particles.remove(0);
				particles.add(new Particle(mainFrame));			
			}

			violentShips.remove(i);

				
		}
		
		ship.update();
		ship.display();
	}
	
	/*
	if (mousePressed == true)
	{
		mainFrame.setX(mouseX);
		mainFrame.setY(mouseY);
		for (int i = 0; i < random(5, 18); i ++ )
		{
			if (particles.size() > max_particles-1)
				particles.remove(0);
			particles.add(new Particle(mainFrame));			
		}
	}
	*/
	
	if (violentShips.size() < max_violent_ships)
	{
		
		/* Side can be */		
		
		for (int i = 0; i < random(0, max_violent_ships); i ++ )
		{
			sx = -20;
			sy = -20;
			
			if (random(0,1) > 0.5)
			{ /* top, botom */
				sx = random(0, width);
				if (random(0,1) > 0.5) 
					sy = height + 20;
			}
			else
			{ /* left, right */
				sy = random(0, height);
				if (random(0,1) > 0.5) 
					sx = width + 20;
			}
			violentShips.add(new ShipViolent(sx, sy));	
		}
	}
	
	
	shipSelf.update();
	shipSelf.display();
	
	if (shipSelf.finished())
	{
		gamestate = 2;
	}
	
	
	popMatrix();
	
	font = loadFont("FFScala.ttf"); 

	textFont(font);
	fill(255);
	textSize(17);

	text(score, 15, 30);

	
}


void keyPressed() {
	setMove(keyCode, true);
}
 
void keyReleased() {
	setMove(keyCode, false);
}
 
boolean setMove(int k, boolean b) {
	//keys[k] = b;
	
	switch (k) {
		case UP:
			return keyUp = b;

		case 32:
			return keySpace = b;

		case LEFT:
			return keyLeft = b;

		case RIGHT:
			return keyRight = b;
			
		case DOWN:
			return keyDown = b;

		default:
			return b;
	}
	
}

class Bullet
{
	int x,y,size;
	float direction;
	int velocity;
	int damage;
	
	color col;

	
	Bullet(int ix, int iy, int isize, color icol, idir, int idamage)
	{
		size	= isize;
		direction = idir-PI/2;
		x		= ix;
		y		= iy;
		col		= icol;
		velocity = 25;
		damage = idamage;
	}
	
	void display()
	{
		pushMatrix();
		noFill();
		strokeWeight(2);
		stroke(255, 255, 255, 255);
		translate(x, y);
		//rotate(direction);
		line(0, 0, cos(direction)*5, sin(direction)*5);
		popMatrix();
	}
	void update()
	{

		y = y+sin(direction)*velocity;
		x = x+cos(direction)*velocity;
		
	}
	
	int[] getLoc()
	{
		int[] loc = {1,1,x,y};
		return loc;
	}
	
	boolean finished()
	{
		if (y < 0 || y > height || x < 0 || x > width)
			return true;
		else
			return false;
	}
	
	int getDamage()
	{
		return damage;
	}
	
}

class Ship
{
	int x, y, w, h, size, speed;
	int health;
	int max_health;
	float direction;
	
	color col;
	
	Ship (int ix, int iy, int isize, int ispeed, color icol, direction idir, int ihealth)
	{
		
		size	= isize;
		x		= ix;
		y		= iy;
		speed	= ispeed;
		col		= icol;
		
		w = 60;
		h = 60;
		
		max_health = ihealth;
		health = max_health;
		
		direction = idir;
			
	}
	
	void displayHealthBar()
	{
		pushMatrix();
		bar_maxwidth = 40;
		bar_width = (health * bar_maxwidth) / max_health;
		
		noFill();
		stroke(color(0, 0, 0));
		rect(x - bar_maxwidth/2, y + 40, bar_maxwidth, 10);
		noStroke();
		fill(color(128, 0, 0));
		rect(x - bar_maxwidth/2, y + 40, bar_width, 10);
		popMatrix();
	}
	
	void displayHitArea()
	{
		return;
		pushMatrix();
		
		fill(255, 0, 0);
		rect(x-w/2, y-h/2, w, h);
		
		popMatrix();
	}
	
	int getX()
	{
		return x;
	}
	
	int getY()
	{
		return y;
	}
	
	boolean checkCollide(int[] obj)
	{
		pushMatrix();
		int w1 = obj[0];
		int h1 = obj[1];
		int x1 = obj[2];
		int y1 = obj[3];
		
			//fill(0, 255, 0);
			//rect(x-w/2, y-h/2, h, w);

		if (x-w/2 <= (x1+w1) && x+w/2 >= x1-w1 && 
			y-h/2 <= y1+h1 && y+h/2 > y1-h1) {
			return true;
		
		}
		popMatrix();
	}
	
	int[] getLoc()
	{
		int[] loc = {w,h,x,y};
		return loc;
	}
	
	void damage(int damage)
	{
		health -= damage;
	}
	
}


class ShipViolent extends Ship {

	float rotate_vel = 0;
	float rotate_frict = 0.005;
	
	int suicideDamage = 50;
	int damageScore = 2;
	int killScore = 10;

	//ShipViolent (int ix, int iy, int isize, int ispeed, color icol)
	ShipViolent()
	{
		isize	= 5;
		ix		= random(0, width);
		iy		= random(0, height);
		ispeed	= random(1,2);
		icol	= color(200, 15, 15);
		idir    = random(0, TWO_PI);
		ihealth = 100;
		super(ix, iy, 20, ispeed, icol, idir, ihealth);
	}
	
	ShipViolent(int ix, int iy)
	{
		isize	= 5;
		ispeed	= random(1,2);
		icol	= color(200, 15, 15);
		idir    = random(0, TWO_PI);
		ihealth = 100;
		super(ix, iy, 20, ispeed, icol, idir, ihealth);
	}
	

	void display()
	{
		//println("x: " + x);
		
		displayHitArea();
		pushMatrix();
		noStroke();
		
		
		translate(x, y);
		rotate(direction);
		/*fill(128, 0, 0);
		rect(-15, -10, 30, 5);
		fill(col);
		rect(-15, -5, 30, 10);
		*/
		
		
		fill(32,32,180);
		rect(-3, -30, 6, 7);
		//fill(0, 0, 0);
		fill(44, 14, 237);
		rect(-5, 20, 10, 3);
		
		fill(255,255,255);
		
		rect(-3, -20, 6, 35);
		
		fill(255,255,255);
		rect(-6, -20, 12, 35);
		
		rect(-9, -5, 18, 20);
		rect(-16, 10, 32, 6);
		
		rect(-16, 5, 3, 14);
		rect(13, 5, 3, 14);
		popMatrix();
		
		displayHealthBar();
		
	}
	void update()
	{
		
		//x = x + xvel;
		//if (abs(xvel) > 45)
		//	xvel = xvel/2;
		pushMatrix();
		
		int dist_y = shipSelf.getY() - y;
		int dist_x = shipSelf.getX() - x;
		
		
		new_direction = atan(dist_y / dist_x);
		
		//if (new_direction - direction > PI/2)
		//{
			//direction += 0.1;
		//}
		
		
		//if (new_direction - direction < PI/2)
		//{
			//direction -= 0.1;
		//}
		
		
		//direction = PI + PI/2 + new_direction;
		if (shipSelf.getX() < x)
		{
			new_direction -= PI;
		}
		
		//direction = new_direction + PI/2;/*
		if (new_direction + PI/2 > direction)
			rotate_vel += rotate_frict;
		
		if (new_direction + PI/2 < direction)
			rotate_vel -= rotate_frict;
		//*/
	
		
		rotate_vel=rotate_vel*0.90;
		
		direction = direction+rotate_vel;
		
		//if (x > width+16)
			//x = -16;
		//if (x < -16)
			//x = width+16;
		//if (y > height + 32)
			//y = -32;
		//if (y < -32)
			//y = height + 32;
		
		x = x+sin(direction)*speed;
		y = y-cos(direction)*speed;
		
		
		
		//direction+=rotate_vel;
		
		fill(color(100,100,100));
		
		popMatrix();
		
	}
	
	
	boolean finished()
	{
		if(health <= 0)
		{
			return true;
		}
		else
		{
			return false;
		}

	}
	
	int getSuicideDamage()
	{
		return suicideDamage;
	}
	
	int getDamageScore()
	{
		return damageScore;
	}
	
	int getKillScore()
	{
		return killScore;
	}
	
}

class ShipSelf extends Ship {
	
	float rotate_vel = 0;
	float rotate_frict = 0.012;
	
	float normal_vel = 0;
	float normal_frict = 0.8;

	int cur_damage;


	ShipSelf (int ix, int iy, int ispeed, color icol)
	{
		super(ix, iy, 20, ispeed, icol, 0, 100);
		
		cur_damage = 34;
	}
	
	void display()
	{
		//println("x: " + x);
		noStroke();
		displayHitArea();
		pushMatrix();
		
		translate(x, y);
		rotate(direction);
		/*fill(128, 0, 0);
		rect(-15, -10, 30, 5);
		fill(col);
		rect(-15, -5, 30, 10);
		*/
		
		
		fill(180,32,32);
		rect(-3, -30, 6, 7);
		//fill(0, 0, 0);
		fill(237, 114, 14);
		rect(-5, 20, 10, 3);
		
		fill(255,255,255);
		
		rect(-3, -20, 6, 35);
		
		fill(255,255,255);
		rect(-6, -20, 12, 35);
		
		rect(-9, -5, 18, 20);
		rect(-16, 10, 32, 6);
		
		rect(-16, 5, 3, 14);
		rect(13, 5, 3, 14);
		popMatrix();
		
		
		displayHealthBar();
		
	}
	void update()
	{
		
		//x = x + xvel;
		//if (abs(xvel) > 45)
		//	xvel = xvel/2;
		
		pushMatrix();
			
		
		if (keyLeft)
		{
			rotate_vel = rotate_vel - rotate_frict;
		}
		if (keyRight)
		{
			rotate_vel = rotate_vel + rotate_frict;
		}
		if (keyUp)
		{
			normal_vel = normal_vel + normal_frict;
		}
		if (keyDown)
		{
			normal_vel = normal_vel - normal_frict;
		}
		if (keySpace)
		{
			if (lastShot < (frameCount - frameRate/6))
			{
				selfBullets.add(new Bullet(x, y, 1, color(255, 255, 255), direction, cur_damage));
				lastShot = frameCount;
			}
		}
		
		if (x > width+16)
			x = -16;
		if (x < -16)
			x = width+16;
		if (y > height + 32)
			y = -32;
		if (y < -32)
			y = height + 32;
		
		x = x+sin(direction)*normal_vel;
		y = y-cos(direction)*normal_vel;
		
		//normal_vel = 6;
		normal_vel=normal_vel*0.90;
		rotate_vel=rotate_vel*0.90;
		
		direction+=rotate_vel;
		
		fill(color(100,100,100));
		//rect(x-10, 20, y-10, 20);
		
		
		/*if (x < 10)
		{
			x = 10;
			xvel = (xvel*-1)/1;
			xvel = xvel / 2;
			if (abs(xvel) < 3)
				xvel = 0;
		}
		
		if (x > width - w - 10)
		{
			x = width - w - 10;
			xvel = (xvel*-1)/1;
			xvel = xvel / 2;
			if (abs(xvel) < 3)
				xvel = 0;
		}*/
		
		popMatrix();
		
	}
	
	
	boolean finished()
	{
		if(health <= 0)
		{
			return true;
		}
		else
		{
			return false;
		}

	}
	
}



class Color {
	
	int r;
	int g;
	int b;
	int t;
	
	Color (int red, int green, int blue, int transparent)
	{
		r = red;
		g = green;
		b = blue;
		t = transparent;		
	}
	Color (int red, int green, int blue)
	{
		r = red;
		g = green;
		b = blue;
		t = 255;
	}
	int getR()
	{
		return r;
	}
	int getG()
	{
		return r;
	}
	int getB()
	{
		return r;
	}
	int getT()
	{
		return t;
	}
	int setR(red)
	{
		r = red;
	}
	int setG(green)
	{
		g = green;
	}
	int setB(blue)
	{
		b = blue;
	}
	int setT(transparent)
	{
		t = transparent;
	}
	color get()
	{
		return color(r,g,b,t);
	}
	
}


class MainFrame {
	
	int pos_x;
	int pos_y;
	
	color maincolor;
	color particlecolor;
	
	MainFrame (int par_pos_x, int par_pos_y, color par_particlecolor) {
		pos_x = par_pos_x;
		pos_y = par_pos_y;
		//maincolor = par_maincolor;
		particlecolor = par_particlecolor;
	}
	
	int getX()
	{
		return pos_x;
	}
	
	int getY()
	{
		return pos_y;
	}
	
	void setX(x)
	{
		pos_x = x;
	}
	
	void setY(y)
	{
		pos_y = y;
	}
	
	color getColor()
	{
		return particlecolor;
	}
	
}


class Particle {
	
	//int near = 1;
	float direction = 0;
	int direction_x = 0;
	int direction_y = 0;
	
	
	float velocity = 5;
	float velocity_max = 5;
	float velocity_min = 0.5;
	
	int max_distance = 2500; // max_distance ^ 2
	float gravity = 0.9995;
	
	int pos_x;
	int pos_y;
	
	int color_r;
	int color_g;
	int color_b;
	
	Color pointcolor;
	
	
	MainFrame mainframe;
	
	//  
	Particle (MainFrame mf) {
		
		mainframe = mf;
		direction = random(0, TWO_PI);
		velocity = random(3, 9);
		velocity_max = velocity;
		//gravity = random(0.989, 0.9997);
		gravity = random(0.989, 0.9997);
		
		pointcolor = new Color(255,0,0,255);
		
		//direction = random(0, 360);
		
		pos_x = mainframe.getX();
		pos_y = mainframe.getY();
		
		
		direction_x = random(0,1);
		direction_y = random(0,1);
		
	}
	
	void update()
	{
		//direction = random(0, TWO_PI);
		
		
		
		if (pos_x > width || pos_x < 0)
		{
			direction_x = direction_x * -1;
		}
		
		if (pos_y > height || pos_y < 0)
		{
			direction_y = direction_y * -1;
		}
		
		
		velocity = velocity * gravity;
		
		
		pos_x = pos_x + cos(direction) * direction_x * velocity;
		pos_y = pos_y + sin(direction) * direction_y * velocity;
				
		//v = (velocity - velocity_min) / (velocity_max-velocity_min) * 255;
		
		inter_min = 10;
		inter_max = 0;
		
		//v = inter_min + (float(velocity - velocity_min) / float(velocity_max - velocity_min) * (inter_max-inter_min));
		v = frameCount/(frameRate)*0.1;
		shade = 0.3 + (float(velocity - velocity_min) / float(velocity_max - velocity_min) * (1-0));
    

		pointcolor.setR((sin(v + 0) * 127 + 128)*shade);
		pointcolor.setG((sin(v + 2) * 127 + 128)*shade);
		pointcolor.setB((sin(v + 4) * 127 + 128)*shade);
		         
		pointcolor.setR(background_r/255*127+128*shade);
		pointcolor.setG(background_g/255*127+128*shade);
		pointcolor.setB(background_b/255*127+128*shade);
	
	
	
	}
	
	void display()
	{
		stroke(pointcolor.get());
		
		swidth = 0.1 + (float(velocity - velocity_min) / float(velocity_max - velocity_min) * (3-0.1));

		strokeWeight(swidth);
		
		point(pos_x, pos_y);
	}
	
	boolean finished()
	{
		if (velocity <= velocity_min)
		{
			return true;
		}
		return false;
	}
	
}















class Button
{
	int x, y;
	int w, h;
	int size;
	char toprint;
	
	color currentcolor;
	
	
	Button(char itoprint, int ix, int iy, int isize, color icolor)
	{
		PFont font 		= loadFont("FFScala.ttf");
		size			= isize;
		
		toprint 		= itoprint;
		
		x 				= ix;
		y 				= iy;
		
		textFont(font, size);
		w 				= textWidth(toprint);
		h 				= textAscent(toprint);
		currentcolor	= icolor;
	}
	
		
	boolean pressed() 
	{
		if(over() && mousePressed) {
			pressed = true;
			return true;
		}
		else
		{
			pressed = false;
			return false;
		}
	}

	boolean overRect(int ax, int ay, int width, int height) 
	{
		if (mouseX >= ax && mouseX <= ax+width && 
			mouseY >= ay && mouseY <= ay+height) {
			return true;
		}
		else 
		{
			return false;
		}
	}

	boolean over()
	{
		if( overRect(x, y, w, h) ) {
			return true;
		}
		else 
		{
			return false;
		}
	}
  
	void display() 
	{
		PFont font = loadFont("FFScala.ttf"); 
		textFont(font, size); 
		fill(currentcolor);
		// rect(x,y,w,h);
		text(toprint, x, y+h);
	}
	
	void update()
	{
		if(over())
		{
			currentcolor = currentcolor + (100,100,100);
			display();
		}
	}
	
}
