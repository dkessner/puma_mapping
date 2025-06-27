//
// puma_mapping.pde
//


Map map;

HashMap<Integer,Integer> pumaPopulationMap;


void setup()
{
    size(800, 800);
    map = new Map(100, 100, width-200, height-250); // Map(x, y, w, h)

    initializeData();
}


void initializeData()
{
    pumaPopulationMap = new HashMap<Integer,Integer>();

    // TODO: initialize this HashMap by reading in data_population.csv
    pumaPopulationMap.put(3733,110720);
    pumaPopulationMap.put(3732,171797);
    pumaPopulationMap.put(3734,195666);
}


void draw()
{
    background(100);

    // display the map

    fill(200);
    map.displayBackground();

    fill(255);
    map.displayShapes();

    // display the selected ShapeRecord in a different color

    ShapeRecord selected = map.selected();
    fill(0, 255, 0);
    selected.display();

    // display information related to selected ShapeRecord

    int puma = selected.getPuma();

    textSize(20);
    textAlign(CENTER);

    text(selected.getName(), width/2, height-75);
    text(puma, width/2, height-50);

    Integer population = pumaPopulationMap.get(puma);
    if (population != null)
        text("population: " + population, width/2, height-25);
}


