/*** webGL ***/
//settings.outformat="html";
// note: may need to change permission 'none' to 'read|write' in /etc/ImageMagick-6/policy.xml
//settings.offline=true;
/*************/
settings.render=20;


import three;
//size(1000);
size(20cm);

// pens
real lwSupport = 0.8;
real lwPlane = 0.8;
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
triple P1 = 0.6X - 0.5Y + 0.9Z;
triple P2 = 0.7X + 0.6Y + 0.2Z;

// dihadron momenta
triple Ph = P1 + P2;
triple R = (P1 - P2)/2;

// draw momenta
real sa=15; // arrow size
draw(shift(-q)*(O--l), brown+penVec, Arrow3(size=sa)); // l
draw(shift(-q-X+Y)*(O--b), brown+penVec, Arrow3(size=sa)); // b
//draw(-q--O, purple+penVec, Arrow3(size=sa)); // q
draw(shift(-q)*qPhot, purple+penVec, Arrow3(size=sa)); // q
draw(O--P1, black+penVec, Arrow3(size=sa)); // P1
draw(O--P2, black+penVec, Arrow3(size=sa)); // P2
draw(O--Ph, brown+penVec, Arrow3(size=sa)); // Ph
draw(shift(P2)*(O--2R), brown+penVec, Arrow3(size=sa)); // 2R
//draw((O--R), red+penVec, Arrow3(size=sa)); // R

// momentum projections to T frame and perp frame
triple RT = R - Ph * dot(R,Ph)/dot(Ph,Ph); // RT
triple RTPerp = RT - q * dot(RT,q)/dot(q,q); // RT, projected to perp plane
triple RPerp = R - q * dot(R,q)/dot(q,q); // RPerp
triple PhPerp = Ph-q*dot(Ph,q)/dot(q,q); // PhPerp
draw((O--RT), blue+penVec, Arrow3(size=sa)); // RT
draw(P1--RT,penSupport);
//draw((O--RPerp), magenta, Arrow3(size=sa)); // RPerp

// draw planes
/* reaction plane */
draw(surface(plane(3X,3Y,-1.5*(X+Y))),opacity(1.0)+palegrey,penPlane,light=nolight);
/* (Ph x q) plane: start with reaction plane, and rotate it about q until
 * it intersects with Ph */
draw(
  surface(
    rotate(degrees(atan2(Ph.z,Ph.y)),X)*
    plane(1.5X,1.5Y,-0.3Y)
  ),
  opacity(0.5)+purple,
  light=nolight,
  penPlane
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
  ),
  opacity(0.5)+yellow,
  light=nolight,
  penPlane
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
//draw(rotate(-90,X)*(O--cross_ql), magenta, Arrow3(size=sa)); // q x l, rotated
//draw(rotate(-90,X)*(O--cross_qPh),  magenta, Arrow3(size=sa)); // q x Ph, rotated
real arcHpos = 0.8; // x position of arcH, w.r.t. Ph x-component
path3 arcH = shift(X*Ph.x*arcHpos) * 
             rotate(-90,X) *
             arc(O,cross_ql/2*arcHpos,cross_qPh/2*arcHpos); // arcH
draw(arcH,penArc); // arcH
// - supports
draw(X*Ph.x*arcHpos--arcpoint(arcH,0),penSupport); // arcH horizontal radius
draw(X*Ph.x*arcHpos--arcpoint(arcH,length(arcH)),penSupport); // arcH (Ph x q) radius


// phiR
triple cross_qRT = cross(q,RT);
//draw(rotate(-90,X)*(O--cross_ql), magenta, Arrow3(size=sa)); // q x l, rotated
//draw(rotate(-90,X)*(O--cross_qRT), magenta, Arrow3(size=sa)); // q x RT, rotated
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
draw(rightang,black+linewidth(2*lwSupport)); // for arcR
draw(shift(X*Ph.x*arcHpos)*rightang,black+linewidth(2*lwSupport)); // for arcH
draw(RT/6--(RT/6+Ph/8)--Ph/8,black+linewidth(2*lwSupport)); // for RT and Ph
draw(0.8RT--
     shift(0.8RT)*0.2(P1-RT)--
     shift(0.8RT+0.2(P1-RT))*0.2RT,black+linewidth(2*lwSupport)); // for R projected to RT

// labels
transform ls = scale(2); // font size
label(ls*"$\phi_h$",shift(0.30Z-0.16Y)*arcpoint(arcH,0)); // phiH
label(ls*"$\phi_{R_\perp}$",shift(-0.17Y+0.15Z)*arcpoint(arcR,length(arcR))); // phiR
label(ls*scale(0.85)*"$P_1$",shift(-0.15Y+0.07X-0.05Z)*P1); // P1
label(ls*scale(0.8)*"$P_2$",shift(-0.75Y+0.85X+0.6Z)*P2); // P2
label(ls*scale(0.8)*"$P_h$",shift(-0.05X-0.2Y+0.10Z)*Ph); // Ph
label(ls*scale(0.8)*"$2R$",shift(0.30X-0.4Y+0.39Z)*shift(P2)*R); // 2R
label(ls*scale(0.9)*"$R_T$",shift(0.10X-0.20Y+0.12Z)*RT); // RT
//label(ls*scale(0.9)*"$R$",shift(0.2X-0.15Y+0.15Z)*R); // R
label(ls*scale(1.2)*"$\ell'$",shift(-0.1Y)*shift(-q)*l); // l
label(ls*scale(1.6)*"$\ell$",shift(-0.1X+0.2Y)*shift(-q)*-b); // b
label(ls*"reaction plane",(1.1,-1.0,0.1));
label(ls*"dihadron plane",(-0.05,-1.4,1.25));
draw((-0.05,-1.4,1.14)--(-0.05,-1.2,0.9),black+linewidth(lwSupport));
label(ls*"$q\times P_h$ plane",(0.90,0.8,1.3));
draw((0.50,0.8,1.1)--(0.70,0.27,1.1),black+linewidth(1.3*lwSupport));


// camera angle
currentprojection=perspective(
camera=(4.74220256337573,-3.5315177420403,3.26345287535543),
up=(-0.00254791654721809,0.00204692887711345,0.00584494908788072),
target=(0.0875868959048809,-0.0218834774748546,0.00533301687500565),
zoom=0.505067952995518,
angle=27.1284281286697,
autoadjust=false);
