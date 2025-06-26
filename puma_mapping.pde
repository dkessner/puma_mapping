//
// puma_mapping.pde
//


Map map;


void setup()
{
    size(800, 800);

    map = new Map();
}


void draw()
{
    background(100);

    fill(200);
    map.display(100, 100, width-200, height-200);
}


