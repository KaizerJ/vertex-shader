import geomerative.*;

RFont f;
RShape grp;
RExtrudedMesh em;
 
PImage earthTexture, gold;
PShape earth;
 
PShader sh;

void setup() {
  size(600, 400, P3D);

  // VERY IMPORTANT: Allways initialize the library in the setup
  RG.init(this);

  //  Load the font file we want to use
  grp = RG.getText("UNIVERSAL", "theboldfont.ttf", 20, CENTER);
  
  // Set the polygonizer detail (lower = more details)
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(1);
  
  // Create an extruded mesh
  em = new RExtrudedMesh(grp, 5);
  
  earthTexture = loadImage("earth.jpg");
  gold = loadImage("gold.jpg");
  
  beginShape();
  earth = createShape(SPHERE, 50);
  earth.setStroke(255);
  earth.setTexture(earthTexture);
  endShape(CLOSE);

  // Enable smoothing
  smooth();
  sh = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {

  shader(sh);
  background(0);

  spotLight(51, 102, 126, mouseX, mouseY, 300, -1, 0, 0, PI/2, 2);

  translate(width/2, height/2, 200);
  rotateY(-millis()/3000.0);

  shape(earth);

  noStroke();
  
  translate(0,0, 70);
  
  // Draw mesh
  em.draw();
  
}  

class RExtrudedMesh
{
  float depth = 10;
  RPoint[][] points;
  RMesh m;
  
  RExtrudedMesh(RShape grp, float d)
  {
    depth = d;
    m = grp.toMesh();
    points = grp.getPointsInPaths();
  }
  
  void draw()
  {
    // Draw front
    for (int i=0; i<m.countStrips(); i++) {
      beginShape(TRIANGLE_STRIP);
      for (int j=0;j<m.strips[i].vertices.length;j++) {
        vertex(m.strips[i].vertices[j].x, m.strips[i].vertices[j].y, 0);
      }
      texture(gold);
      endShape(CLOSE);
    }

    // Draw back
    for (int i=0; i<m.countStrips(); i++) {
      beginShape(TRIANGLE_STRIP);
      for (int j=0;j<m.strips[i].vertices.length;j++) {
        vertex(m.strips[i].vertices[j].x, m.strips[i].vertices[j].y, -depth);
      }
      texture(gold);
      endShape(CLOSE);
    }
  
    // Draw side (from outline points)
    for (int i=0; i<points.length; i++) {
      beginShape(TRIANGLE_STRIP);
      for (int j=0; j<points[i].length-1; j++)
      {
        vertex(points[i][j].x, points[i][j].y, 0);
        vertex(points[i][j].x, points[i][j].y, -depth);
        vertex(points[i][j+1].x, points[i][j+1].y, -depth);
        vertex(points[i][j].x, points[i][j].y, 0);
        vertex(points[i][j+1].x, points[i][j+1].y, 0);
      }
      vertex(points[i][0].x, points[i][0].y, 0);
      texture(gold);
      endShape(CLOSE);
    }
  }
}
