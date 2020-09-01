//settings.outformat="png";
settings.render=16;

import three;
size(4cm,0);
//size(100);

// coordinate system
draw(O--2X ^^ O--2Y ^^ O--2Z);

// virtual photon
triple q = X;

// hadron momenta
triple p1 = X + 0.3Y + 0.4Z;
triple p2 = 0.8X + 0.5Y + 0.2Z;

// dihadron momenta
triple ph = p1 + p2;
triple rh = p1 - p2;

// draw momenta
draw(-q--O, purple, Arrow3(size=3)); // q
draw(O--p1, black, Arrow3(size=3)); // p1
draw(O--p2, black, Arrow3(size=3)); // p2
draw(O--ph, black, Arrow3(size=3)); // ph
draw(shift(p2)*(O--rh), black, Arrow3(size=3)); // rh

// draw planes
draw(surface(plane(4X,4Y,-2*(X+Y))),opacity(0.5)+cyan,black,light=nolight); // reaction
draw(surface(plane(3Y,3Z,-1.5*(Y+Z))),opacity(0.5)+magenta,black,light=nolight); // perp
draw(surface(plane(2q,2ph,-ph)),opacity(0.5)+green,black,light=nolight); // ph x q
draw(surface(plane(4p1,4p2,-ph)),opacity(0.5)+yellow,black,light=nolight); // p1 x p2

// arcs
real phiH = 180-degrees(atan2(ph.z,ph.y));
triple phH = rotate(phiH,X)*ph; // ph, rotated to be on reaction plane
//draw(O--phH, black, Arrow3(size=3));
path3 arcH = arc(ph.x*X/2,ph/2,phH/2);
draw(arcH,green);
