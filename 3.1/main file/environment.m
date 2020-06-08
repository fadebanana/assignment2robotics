
%% 
axis equal;
camlight

xlabel('x');
ylabel('y');
zlabel('z');
bgi=imread('background.jpg'); 
xImage = [-0.8 0.6; -0.8 0.6];
yImage = [-0.6 -0.6; -0.6 -0.6];
zImage = [1 1; -0.795 -0.795];
surf(xImage,yImage,zImage,'CData',bgi,'FaceColor','texturemap'); 
hold on;

xlabel('x');
ylabel('y');
zlabel('z');
bgi2=imread('background2.jpg'); 
xImage = [-0.8 -0.8; -0.8 -0.8];
yImage = [-0.6 0.6; -0.6 0.6];
zImage = [1 1; -0.795 -0.795];
surf(xImage,yImage,zImage,'CData',bgi2,'FaceColor','texturemap');
hold on; 

xlabel('x');
ylabel('y');
zlabel('z');
bgi3=imread('floor.jpg'); 
xImage = [-0.8 -0.8; 0.8 0.8];
yImage = [-0.6 0.6; -0.6 0.6];
zImage = [-0.795 -0.795; -0.795 -0.795];
surf(xImage,yImage,zImage,'CData',bgi3,'FaceColor','texturemap');
hold on; 

tableLocation= transl(0,0,-0.4);
loadply('table.ply',tableLocation); 

paperLocation = transl(0.42,0.45,-0.399);
loadply('paper.ply',paperLocation);

lampLocation= transl(-0.1,-0.3,-0.4);
loadply('light.ply',lampLocation); 


cupLocation= transl(-0.3,-0.3,-0.4);
loadply('cup.ply',cupLocation); 

buttonLocation= transl(-0.3,-0.2,-0.4);
loadply('button.ply',buttonLocation); 

chairLocation= transl(-0.4,0,0);
loadply('chair.ply',chairLocation);

lightCurtain

lightLocation= transl(0.395,0.45,-0.4);
loadply('lightcurtian.ply',lightLocation); 
hold on; 
lightLocation1= transl(0.395,-0.054,-0.4);
loadply('lightcurtian.ply',lightLocation1); 
hold on; 
lightLocation2= transl(-0.055, 0.45,-0.4);
loadply('lightcurtian.ply',lightLocation2); 
hold on; 
lightLocation3= transl(-0.055, -0.054,-0.4);
loadply('lightcurtian.ply',lightLocation3);




