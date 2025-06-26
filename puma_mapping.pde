//
// puma_mapping.pde
//


Map map;


void setup()
{
    size(800, 800);
    map = new Map(100, 100, width-200, height-200); // Map(x, y, w, h)
}


void draw()
{
    background(100);

    fill(200);
    map.displayBackground();

    fill(255);
    map.displayShapes();

    ShapeRecord selected = map.selected();
    fill(0, 255, 0);
    selected.display();

    textSize(20);
    textAlign(CENTER);
    text(selected.getName(), width/2, height-50);
    text(selected.getPuma(), width/2, height-25);
}


