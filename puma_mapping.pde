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

    //pumaPopulationMap.get(3733); // returns 110720
}


// TODO:
// To read in data_population.csv:
//    1) loadStrings("data_population.csv")  ->  String[]
//    2) for each line:
//          split into fields  (String split() function)
//          put data into pumaPopulationMap
//


void draw()
{
    background(100);

    // display the map

    fill(200);
    map.displayBackground();

    fill(255);
    stroke(0);
    map.displayShapes();

    // display the selected ShapeRecord in a different color

    ShapeRecord selected = map.selected();
    fill(0, 255, 0);
    selected.display();

    // display information related to selected ShapeRecord

    int puma_selected = selected.getPuma();

    textSize(20);
    textAlign(CENTER);

    text(selected.getName(), width/2, height-75);
    text(puma_selected, width/2, height-50);

    Integer population_selected = pumaPopulationMap.get(puma_selected);
    if (population_selected != null)
        text("population: " + population_selected, width/2, height-25);


    // display overlay

    for (ShapeRecord shapeRecord : map.shapeRecords) // iterate through all shapes
    {
        // get the puma, and the population
        int puma = shapeRecord.getPuma();
        Integer population = pumaPopulationMap.get(puma);
        if (population == null)
            continue;

        // compute a grey value based on the population
        int value = int(map(population, 100000, 200000, 128, 0));
        fill(value);
        stroke(255);
        shapeRecord.display();
    }
}


