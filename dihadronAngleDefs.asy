/*** webGL ***/
//settings.outformat="html";
// note: may need to change permission 'none' to 'read|write' in /etc/ImageMagick-6/policy.xml
//settings.offline=true;
/*************/
settings.render=16;


import three;
//size(1000);
size(20cm);

// pens
real lwSupport = 0.5;
real lwPlane = 0.4;
pen penSupport = black + linetype(new real[] {2,3}) + linewidth(lwSupport);
pen penPlane = black + linewidth(lwPlane);
pen penVec = linewidth(4lwSupport);
pen penArc = red + linewidth(lwSupport);

// coordinate system
//draw(O--2X ^^ O--2Y ^^ O--2Z,red);
draw(O--1.5X,penSupport);

// virtual photon (Feynman squiggle)
triple q = X;
real sq = 0.08;
path3 qPhot = (
  O..
  (1*sq, sq, 0)..(2*sq, 0, 0)..(3*sq,-sq, 0)..(4*sq, 0, 0)..
  (5*sq, sq, 0)..(6*sq, 0, 0)..(7*sq,-sq, 0)..(8*sq, 0, 0)..
  (9*sq, sq, 0)..(10*sq, 0, 0)..
  (11*sq,0, 0)..(12*sq, 0, 0)..
  q
);

// electron
triple b = X-Y; // beam electron
triple l = -X-Y; // scattered electron

// hadron momenta
//triple P1 = X + 0.3Y + 0.4Z; // orig
//triple P2 = 0.8X + 0.5Y + 0.2Z; // orig
//triple P1 = X - 0.3Y + 0.6Z;
//triple P2 = 0.8X + 0.8Y + 0.3Z;
triple P1 = X - 0.3Y + 0.6Z;
triple P2 = 0.8X + 0.8Y + 0.2Z;

// dihadron momenta
triple Ph = P1 + P2;
triple R = P1 - P2;

// draw momenta
real sa=10; // arrow size
draw(shift(-q)*(O--l), brown+penVec, Arrow3(size=sa)); // l
draw(shift(-q-X+Y)*(O--b), brown+penVec, Arrow3(size=sa)); // b
//draw(-q--O, purple+penVec, Arrow3(size=sa)); // q
draw(shift(-q)*qPhot, purple+penVec, Arrow3(size=sa)); // q
draw(O--P1, black+penVec, Arrow3(size=sa)); // P1
draw(O--P2, black+penVec, Arrow3(size=sa)); // P2
draw(O--Ph, deepgreen+penVec, Arrow3(size=sa)); // Ph
draw(shift(P2)*(O--R), orange+penVec, Arrow3(size=sa)); // R

// momentum projections to T frame and perp frame
triple RT = R - Ph * dot(R,Ph)/dot(Ph,Ph); // RT
triple RTPerp = RT - q * dot(RT,q)/dot(q,q); // RT, projected to perp plane
triple RPerp = R - q * dot(R,q)/dot(q,q); // RPerp
triple PhPerp = Ph-q*dot(Ph,q)/dot(q,q); // PhPerp
draw((O--RT), blue+penVec, Arrow3(size=sa)); // RT
//draw((O--RPerp), red, Arrow3(size=sa)); // RPerp

// draw planes
draw(surface(plane(3X,3Y,-1.5*(X+Y))),opacity(1.0)+lightgrey,penPlane,light=nolight); // reaction
//draw(surface(plane(2.5Y,2.5Z,-1.25*(Y+Z))),opacity(0.5)+magenta,penPlane,light=nolight); // perp
draw(surface(shift(-q)*plane(2q,2Ph,-Ph)),opacity(0.5)+green,penPlane,light=nolight); // Ph x q
draw(surface(plane(2.5P1,2.5P2,-Ph)),opacity(0.5)+cyan,penPlane,light=nolight); // P1 x P2
// - intersections (keyword DANGER means it's hard to calculate, so I did it by hand)
//draw(-1.25Y--1.25Y,penPlane); // perp & reaction
draw(-q--q,penPlane); // (Ph x q) & reaction
draw(-Ph--Ph,penPlane); // (Ph x q) & (P1 x P2)
triple cross_ZP1P2 = cross(Z,cross(P1,P2)); // Z x P1 x P2
draw(-2.5cross_ZP1P2--1.66cross_ZP1P2,penPlane); // (P1 x P2) & reac (DANGER)
//draw(-PhPerp/1.83--PhPerp/1.83,penPlane); // (Ph x q) & perp (DANGER)
//draw(-RTPerp*1.12--RTPerp*0.88,penPlane); // (P1 x P2) & perp (DANGER, and a bit wrong)

// phiH
triple cross_ql = cross(q,l); // q x l
triple cross_qPh = cross(q,Ph); // q x Ph
//draw(O--cross_ql, magenta, Arrow3(size=sa)); // q x l
//draw(O--cross_qPh,  magenta, Arrow3(size=sa)); // q x Ph
real arcHpos = 0.4; // x position of arcH, w.r.t. Ph x-component
path3 arcH = shift(X*Ph.x*arcHpos) * 
             rotate(-90,X) *
             arc(O,cross_ql/2*arcHpos,cross_qPh/2*arcHpos); // arcH
draw(arcH,penArc); // arcH
// - supports
draw(X*Ph.x*arcHpos--arcpoint(arcH,0),penSupport); // arcH horizontal radius
draw(X*Ph.x*arcHpos--arcpoint(arcH,length(arcH)),penSupport); // arcH (Ph x q) radius


// phiR
triple cross_qRT = cross(q,RT);
//draw(O--cross_ql, magenta, Arrow3(size=sa)); // q x l
//draw(O--cross_qRT, magenta, Arrow3(size=sa)); // q x RT
real arcRpos = 1;
path3 arcR = /*shift(X*Ph.x*arcRpos) * */
             rotate(-90,X) *
             arc(O,cross_qRT*arcRpos,cross_ql*arcRpos); // arcH
draw(arcR,penArc); // arcH
// - supports
draw(O--arcpoint(arcR,length(arcR)),penSupport); // arcR horizontal radius
draw(RT--arcpoint(arcR,0),penSupport); // RT to RT_perp line
draw(O--arcpoint(arcR,0),penSupport); // arcR RT_perp radius


// 90 degree markings
real sr = 0.1;
path3 rightang = (0,-sr,0)--(sr,-sr,0)--(sr,0,0);
draw(rightang,black+linewidth(lwSupport)); // for arcR
draw(shift(X*Ph.x*arcHpos)*rightang,black+linewidth(lwSupport)); // for arcH

// labels
transform ls = scale(0.8); // font size
label(ls*"$\phi_h$",shift(0.10Z-0.07Y)*arcpoint(arcH,0)); // phiH
label(ls*"$\phi_{R_\perp}$",shift(0.15Z-0.12Y)*arcpoint(arcR,length(arcR))); // phiR
label(ls*scale(0.9)*"$P_1$",shift(-0.12Y+0.1X)*P1); // P1
label(ls*"$P_2$",shift(0.00Y+0.2X)*P2); // P2
label(ls*scale(0.8)*"$P_h$",shift(0.4X-0.1Y+0.1Z)*Ph); // Ph
label(ls*scale(0.9)*"$2R$",shift(0.3X+0.2Y+0.05Z)*shift(P2)*R); // R
label(ls*scale(0.9)*"$R_\perp$",shift(0.1Y-0.18Z)*RPerp); // RPerp
label(ls*scale(1.2)*"$\ell'$",shift(-0.10Y)*shift(-q)*l); // l
label(ls*scale(1.6)*"$\ell$",shift(-0.05X+0.10Y)*shift(-q)*-b); // l

// camera angle
///*
currentprojection=perspective(
camera=(6.14817053411128,-1.9739792180911,2.01951609669298),
up=(-0.0113332592707233,0.00636119866960834,0.0402663850373713),
target=(0.0875868959048827,-0.0218834774748546,0.00533301687500609),
zoom=0.746215396636627,
angle=18.5487698928139,
autoadjust=false);
//*/
