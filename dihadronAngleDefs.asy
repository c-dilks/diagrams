//settings.outformat="png";
settings.render=16;

import three;
//size(4cm,0);
size(100);

// pens
pen penSupport = black + linetype(new real[] {2,3}) + linewidth(0.25);
pen penPlane = black + linewidth(0.15);

// coordinate system
//draw(O--2X ^^ O--2Y ^^ O--2Z);
draw(O--2X,penSupport);

// virtual photon
triple q = X;

// electron
triple b = X-Y; // beam electron
triple l = -X-Y; // scattered electron

// hadron momenta
//triple P1 = X + 0.3Y + 0.4Z; // orig
//triple P2 = 0.8X + 0.5Y + 0.2Z; // orig
triple P1 = X - 0.3Y + 0.4Z;
triple P2 = 0.8X + 0.5Y + 0.2Z;

// dihadron momenta
triple Ph = P1 + P2;
triple R = P1 - P2;

// draw momenta
draw(shift(-q)*(O--l), orange, Arrow3(size=3)); // l
draw(shift(-q-X+Y)*(O--b), orange, Arrow3(size=3)); // b
draw(-q--O, purple, Arrow3(size=3)); // q
draw(O--P1, black, Arrow3(size=3)); // P1
draw(O--P2, black, Arrow3(size=3)); // P2
draw(O--Ph, black, Arrow3(size=3)); // Ph
draw(shift(P2)*(O--R), black, Arrow3(size=3)); // R

// draw planes
draw(surface(plane(4X,4Y,-2*(X+Y))),opacity(0.5)+grey,penPlane,light=nolight); // reaction
draw(surface(plane(3Y,3Z,-1.5*(Y+Z))),opacity(0.5)+magenta,penPlane,light=nolight); // perp
draw(surface(plane(2q,2Ph,-Ph)),opacity(0.5)+green,penPlane,light=nolight); // Ph x q
draw(surface(plane(4P1,4P2,-Ph)),opacity(0.5)+cyan,penPlane,light=nolight); // P1 x P2
// - intersections
draw(-1.5Y--1.5Y,penPlane); // perp & reaction
draw(O--(-Ph+q*dot(Ph,q)/dot(q,q)),penPlane); // perp & Ph x q

// phiH
triple cross_ql = cross(q,l); // q x l
triple cross_qPh = cross(q,Ph); // q x Ph
//draw(O--cross_ql, magenta, Arrow3(size=3)); // q x l
//draw(O--cross_qPh,  magenta, Arrow3(size=3)); // q x Ph
real arcHpos = 0.5; // x position of arcH, w.r.t. Ph x-component
path3 arcH = shift(X*Ph.x*arcHpos) * 
             rotate(-90,X) *
             arc(O,cross_ql*arcHpos,cross_qPh*arcHpos); // arcH
draw(arcH,green); // arcH
// - supports
draw(X*Ph.x*arcHpos--arcpoint(arcH,0),penSupport); // arcH horizontal radius

// R projected to T frame (and perp frame)
triple RT = R - Ph * dot(R,Ph)/dot(Ph,Ph); // RT
draw((O--RT), blue, Arrow3(size=3)); // RT
//triple RPerp = R - q * dot(R,q)/dot(q,q); // RPerp
//draw((O--RPerp), red, Arrow3(size=3)); // RPerp

// phiR
triple cross_qRT = cross(q,RT);
//draw(O--cross_ql, magenta, Arrow3(size=3)); // q x l
//draw(O--cross_qRT, magenta, Arrow3(size=3)); // q x RT
real arcRpos = 1;
path3 arcR = /*shift(X*Ph.x*arcRpos) * */
             rotate(-90,X) *
             arc(O,cross_qRT*arcRpos,cross_ql*arcRpos); // arcH
draw(arcR,blue); // arcH
// - supports
draw(O--arcpoint(arcR,length(arcR)),penSupport); // arcR horizontal radius
draw(RT--arcpoint(arcR,0)); // RT to RT_perp line
draw(O--arcpoint(arcR,0),penSupport); // arcR RT_perp radius
