clear
clc

ca=1;
cb=1;
l1=10;
pn=0.001;
fe=1;

a1=ca-l1/2;
a2=ca+l1/2;
b1=cb-l1/2;
b2=cb+l1/2;

npt=round((l1/pn)/10)+1;% El número de puntos a repartir en cada tramo será
pa=npt;pb=npt;

[FS3D,i,j,fitness,fitnessmin] = minimoexhaustivo(a1,a2,b1,b2,pa,pb);
graficos3d;




[FSRabmin,FRab,npmt,et,p,npt] = marcosoptimosgeneral(ca,cb,l1,pn,fe );


