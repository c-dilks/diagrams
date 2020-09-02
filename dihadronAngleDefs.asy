/*** webGL ***/
//settings.outformat="html";
// note: may need to change permission 'none' to 'read|write' in /etc/ImageMagick-6/policy.xml
//settings.offline=true;
/*************/
settings.render=16;

import three;
size(100);

// pens
pen penSupport = black + linetype(new real[] {2,3}) + linewidth(0.25);
pen penPlane = black + linewidth(0.3);

// coordinate system
//draw(O--2X ^^ O--2Y ^^ O--2Z);
draw(O--1.5X,penSupport);

// virtual photon
triple q = X;

// electron
triple b = X-Y; // beam electron
triple l = -X-Y; // scattered electron

// hadron momenta
//triple P1 = X + 0.3Y + 0.4Z; // orig
//triple P2 = 0.8X + 0.5Y + 0.2Z; // orig
triple P1 = X - 0.3Y + 0.6Z;
triple P2 = 0.8X + 0.8Y + 0.3Z;

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

// momentum projections to T frame and perp frame
triple RT = R - Ph * dot(R,Ph)/dot(Ph,Ph); // RT
triple RTPerp = RT - q * dot(RT,q)/dot(q,q); // RT, projected to perp plane
triple RPerp = R - q * dot(R,q)/dot(q,q); // RPerp
triple PhPerp = Ph-q*dot(Ph,q)/dot(q,q); // PhPerp
draw((O--RT), blue, Arrow3(size=3)); // RT
//draw((O--RPerp), red, Arrow3(size=3)); // RPerp

// draw planes
draw(surface(plane(3X,3Y,-1.5*(X+Y))),opacity(1.0)+lightgrey,penPlane,light=nolight); // reaction
//draw(surface(plane(2.5Y,2.5Z,-1.25*(Y+Z))),opacity(0.5)+magenta,penPlane,light=nolight); // perp
draw(surface(shift(-q)*plane(2q,2Ph,-Ph)),opacity(0.5)+green,penPlane,light=nolight); // Ph x q
draw(surface(plane(2.5P1,2.5P2,-Ph)),opacity(0.5)+cyan,penPlane,light=nolight); // P1 x P2
// - intersections (keyword DANGER means it's hard to calculate, so I did it by hand)
//draw(-1.25Y--1.25Y,penPlane); // perp & reaction
draw(-q--q,penPlane); // (Ph x q) & reaction
draw(-Ph--Ph,penPlane); // (Ph x q) & (P1 x P2)
//draw(-PhPerp/1.83--PhPerp/1.83,penPlane); // (Ph x q) & perp (DANGER)
//draw(-RTPerp*1.12--RTPerp*0.88,penPlane); // (P1 x P2) & perp (DANGER, and a bit wrong)

// phiH
triple cross_ql = cross(q,l); // q x l
triple cross_qPh = cross(q,Ph); // q x Ph
//draw(O--cross_ql, magenta, Arrow3(size=3)); // q x l
//draw(O--cross_qPh,  magenta, Arrow3(size=3)); // q x Ph
real arcHpos = 0.5; // x position of arcH, w.r.t. Ph x-component
path3 arcH = shift(X*Ph.x*arcHpos) * 
             rotate(-90,X) *
             arc(O,cross_ql/2*arcHpos,cross_qPh/2*arcHpos); // arcH
draw(arcH,red); // arcH
// - supports
draw(X*Ph.x*arcHpos--arcpoint(arcH,0),penSupport); // arcH horizontal radius
draw(X*Ph.x*arcHpos--arcpoint(arcH,length(arcH)),penSupport); // arcH (Ph x q) radius


// phiR
triple cross_qRT = cross(q,RT);
//draw(O--cross_ql, magenta, Arrow3(size=3)); // q x l
//draw(O--cross_qRT, magenta, Arrow3(size=3)); // q x RT
real arcRpos = 1;
path3 arcR = /*shift(X*Ph.x*arcRpos) * */
             rotate(-90,X) *
             arc(O,cross_qRT*arcRpos,cross_ql*arcRpos); // arcH
draw(arcR,red); // arcH
// - supports
draw(O--arcpoint(arcR,length(arcR)),penSupport); // arcR horizontal radius
draw(RT--arcpoint(arcR,0)); // RT to RT_perp line
draw(O--arcpoint(arcR,0),penSupport); // arcR RT_perp radius
