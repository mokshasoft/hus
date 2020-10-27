// Written in 2015 by Marius Kintel <marius@kintel.net>
// Additions 2020 by Mokshasoft AB
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

// Area of a triangle with the 3rd vertex in the origin
function triarea(v0, v1) = cross(v0, v1) / 2;

// Area of a polygon using the Shoelace formula
function area(vertices) =
  let (areas = [let (num=len(vertices))
                  for (i=[0:num-1]) 
                    triarea(vertices[i], vertices[(i+1)%num])
               ])
      sum(areas);

// Recursive helper function: Sums all values in a list.
// In this case, sum all partial areas into the final area.
function sum(values,s=0) =
  s == len(values) - 1 ? values[s] : values[s] + sum(values,s+1);

function length(p1, p2) =
    sqrt(pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2));

function vlength(p) =
  let (num  = len(p),
       lens = [ for (i=[0:num-2]) length(p[i], p[i + 1]) ])
    sum(lens);

function angle(p1, pc, p2) =
  let ( v1 = p1 - pc
      , v2 = p2 - pc
      , n1 = v1/norm(v1)
      , n2 = v2/norm(v2)
      )
    acos(n1*n2);
