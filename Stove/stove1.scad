include <compose.scad>

*layer(0) full_layer(4, 2);
*layer(1) full_layer(4, 2);
*layer(2) full_layer(4, 2);

layer(0) ash_layer_odd();
layer(1) ash_layer_even();

*join()
{
    brick();
    join()
    {
       brick();
       brick();
    }
}
