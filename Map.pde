//
// Map.java
//


import java.util.*;
import processing.core.*;


public class Map
{
    ArrayList<ShapeRecord> shape_records;

    float xMin = Float.MAX_VALUE;
    float xMax = -Float.MAX_VALUE;
    float yMin = Float.MAX_VALUE;
    float yMax = -Float.MAX_VALUE;

    public Map()
    {
        initialize_shape_records();
    }

    void initialize_shape_records()
    {
        // read in shape records from json file

        JSONArray json_shape_records = loadJSONArray("shape_records.json");
        println("shape records: " + json_shape_records.size());

        shape_records = new ArrayList<ShapeRecord>();

        for (int i=0; i<json_shape_records.size(); i++)
        {
            JSONObject json = json_shape_records.getJSONObject(i);
            shape_records.add(new ShapeRecord(json));
        }

        // calculate bounding box

        for (ShapeRecord shape_record : shape_records)
        {
            for (PVector p : shape_record.points)
            {
                if (p.x < xMin) xMin = p.x;
                if (p.x > xMax) xMax = p.x;
                if (p.y < yMin) yMin = p.y;
                if (p.y > yMax) yMax = p.y;
            }
        }

        println("x range: ", xMin, xMax);
        println("y range: ", yMin, yMax);
    }


    void display(float rectX, float rectY, float rectW, float rectH)
    {
        rect(rectX, rectY, rectW, rectH);

        // draw each ShapeRecord

        for (int i=0; i<shape_records.size(); i++)
        {
            ShapeRecord shape_record = shape_records.get(i);

            shape_record.display(rectX, rectY, rectW, rectH,
                                 xMin, yMin, xMax, yMax);
        }

        // display selected 

        ShapeRecord selected = selected(rectX, rectY, rectW, rectH);

        fill(0, 255, 0);
        selected.display(rectX, rectY, rectW, rectH,
                         xMin, yMin, xMax, yMax);

        textSize(20);
        text(selected.name, width*.2, height-50);
        text(selected.puma, width*.2, height-25);
    }

    ShapeRecord selected(float rectX, float rectY, float rectW, float rectH)
    {
        // calculate hover by smallest distance to center

        int hoverIndex = 0;
        float smallestDistance = Float.MAX_VALUE;

        for (int i=0; i<shape_records.size(); i++)
        {
            ShapeRecord shape_record = shape_records.get(i);

            float cx = map(shape_record.center.x, xMin, xMax, rectX, rectX+rectW);
            float cy = map(shape_record.center.y, yMin, yMax, rectY+rectH, rectY); // note: flip
            float d = dist(mouseX, mouseY, cx, cy);

            if (d < smallestDistance)
            {
                hoverIndex = i;
                smallestDistance = d;
            }
        }

        return shape_records.get(hoverIndex);
    }
}


class ShapeRecord
{
    String name;
    String puma;
    ArrayList<PVector> points;
    PVector center;

    public ShapeRecord(JSONObject json)
    {
        name = json.getString("name");
        puma = json.getString("puma");
        points = new ArrayList<PVector>();

        JSONArray json_points = json.getJSONArray("points");
        for (int i=0; i<json_points.size(); i++)
        {
            JSONArray point = json_points.getJSONArray(i);
            if (point.size() != 2) println("I am insane!");
            PVector p = new PVector(point.getFloat(0), point.getFloat(1));
            points.add(p);
        }

        center = new PVector();
        for (PVector p : points)
            center.add(p);
        center.div(points.size());
    }

    void display(float rectX, float rectY, float rectW, float rectH,
                 float xMin, float yMin, float xMax, float yMax)
    {
        beginShape();
        for (PVector p : points)
        {
            float x = map(p.x, xMin, xMax, rectX, rectX+rectW);
            float y = map(p.y, yMin, yMax, rectY+rectH, rectY); // note: flip
            vertex(x, y);
        }
        endShape();
    }
}


