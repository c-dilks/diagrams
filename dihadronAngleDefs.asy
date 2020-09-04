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
pen penArc = red + linewidth(4*lwSupport);

// coordinate system
//draw(O--1.5X ^^ O--1.5Y ^^ O--1.5Z,red+linewidth(1));

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
triple P1 = 0.5X - 0.4Y + 0.7Z; // orig
//triple P1 = 0.5X - 0.4Y + 1.2Z; // test
triple P2 = 0.4X + 0.6Y + 0.2Z; // orig

// dihadron momenta
triple Ph = P1 + P2;
triple R = (P1 - P2)/2;

// draw momenta
real sa=10; // arrow size
draw(shift(-q)*(O--l), brown+penVec, Arrow3(size=sa)); // l
draw(shift(-q-X+Y)*(O--b), brown+penVec, Arrow3(size=sa)); // b
//draw(-q--O, purple+penVec, Arrow3(size=sa)); // q
draw(shift(-q)*qPhot, purple+penVec, Arrow3(size=sa)); // q
draw(O--P1, black+penVec, Arrow3(size=sa)); // P1
draw(O--P2, black+penVec, Arrow3(size=sa)); // P2
draw(O--Ph, deepgreen+penVec, Arrow3(size=sa)); // Ph
draw(shift(P2)*(O--2R), orange+penVec, Arrow3(size=sa)); // R
draw((O--R), red+penVec, Arrow3(size=sa)); // R

// momentum projections to T frame and perp frame
triple RT = R - Ph * dot(R,Ph)/dot(Ph,Ph); // RT
triple RTPerp = RT - q * dot(RT,q)/dot(q,q); // RT, projected to perp plane
triple RPerp = R - q * dot(R,q)/dot(q,q); // RPerp
triple PhPerp = Ph-q*dot(Ph,q)/dot(q,q); // PhPerp
draw((O--RT), blue+penVec, Arrow3(size=sa)); // RT
draw(R--RT,penSupport);
//draw((O--RPerp), magenta, Arrow3(size=sa)); // RPerp

// draw planes
/* reaction plane */
draw(surface(plane(3X,3Y,-1.5*(X+Y))),opacity(1.0)+lightgrey,penPlane,light=nolight);
/* (Ph x q) plane: start with reaction plane, and rotate it about q until
 * it intersects with Ph */
draw(
  surface(
    rotate(degrees(atan2(Ph.z,Ph.y)),X)*
    plane(1.5X,1.5Y,-0.3Y)
  ),opacity(0.5)+green,penPlane,light=nolight
);
/* (P1 x P2) plane: start with the perp plane. We know that (P1 x P2) intersects the 
 * reaction plane along Z x P1 x P2; denote this cross product as S. Rotate the perp plane
 * about the Z axis until it intersects with S. Then we need to rotate about the S axis
 * by 90deg minus the angle between the Z axis and P1 x P2, and the resulting plane will contain
 * both P1 and P2 */
triple cross_P1P2 = cross(P1,P2); // P1 x P2
triple S = cross(Z,cross_P1P2); // useful vector product Z x P1 x P2
draw(
  surface(
    rotate(90-degrees(-acos(dot(cross_P1P2,Z)/(length(cross_P1P2)*length(Z)))),S)*
    rotate(degrees(-atan2(S.x,S.y)),Z)*
    plane(2.5Y,2.5Z,-1.25*(Y+Z))
    /*plane(3P1,3P2,-Ph)*/
  ),opacity(0.5)+cyan,penPlane,light=nolight
);
/* perp plane */
//draw(surface(plane(2.5Y,2.5Z,-1.25*(Y+Z))),opacity(0.5)+magenta,penPlane,light=nolight);

// intersections of planes
// (keyword MANUAL means it's hard to calculate, so it was adjusted by hand)
draw(O--1.5q,penPlane); // (Ph x q) & reaction
draw(O--1.35Ph/length(Ph),penPlane); // (Ph x q) & (P1 x P2) // MANUAL
draw(-1.25*S/length(S)--1.25*S/length(S),penPlane); // (P1 x P2) & reac
//draw(-1.25Y--1.25Y,penPlane); // perp & reaction

// phiH
triple cross_ql = cross(q,l); // q x l
triple cross_qPh = cross(q,Ph); // q x Ph
//draw(O--cross_ql, magenta, Arrow3(size=sa)); // q x l
//draw(O--cross_qPh,  magenta, Arrow3(size=sa)); // q x Ph
real arcHpos = 1.2; // x position of arcH, w.r.t. Ph x-component
path3 arcH = shift(X*Ph.x*arcHpos) * 
             rotate(-90,X) *
             arc(O,cross_ql/4*arcHpos,cross_qPh/4*arcHpos); // arcH
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
draw(RT/10--(RT/10+Ph/10)--Ph/10,black+linewidth(lwSupport)); // for RT and Ph
draw(0.9RT--
     shift(0.9RT)*0.4(R-RT)--
     shift(0.9RT+0.4(R-RT))*0.1RT,black+linewidth(lwSupport)); // for R projected to RT

// labels
transform ls = scale(1); // font size
label(ls*"$\phi_h$",shift(0.20Z-0.07Y)*arcpoint(arcH,0)); // phiH
label(ls*"$\phi_{R_\perp}$",shift(-0.08Y+0.25Z)*arcpoint(arcR,length(arcR))); // phiR
label(ls*scale(0.9)*"$P_1$",shift(-0.12Y+0.1X)*P1); // P1
label(ls*"$P_2$",shift(0.00Y+0.1X)*P2); // P2
label(ls*scale(0.9)*"$P_h$",shift(0.05X-0.1Y-0.1Z)*Ph); // Ph
label(ls*scale(0.9)*"$2R$",shift(0.3X+0.1Y+0.05Z)*shift(P2)*R); // R
label(ls*scale(0.9)*"$R_T$",shift(0.2X+0.1Y+0.10Z)*RT); // RT
label(ls*scale(1.2)*"$\ell'$",shift(-0.07Y)*shift(-q)*l); // l
label(ls*scale(1.6)*"$\ell$",shift(-0.07X+0.10Y)*shift(-q)*-b); // b

// camera angle
currentprojection=perspective(
camera=(5.26680633120671,-3.27904704036387,2.68207001822205),
up=(-0.00200888155472742,0.00157000034913387,0.00579740879648513),
target=(0.0875868959048818,-0.0218834774748542,0.00533301687500609),
zoom=0.505067952995518,
angle=27.1284281286697,
autoadjust=false);
