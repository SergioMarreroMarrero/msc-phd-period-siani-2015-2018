clear all
close all
profile on
% Cargar  una fotografía en una matriz
A=imread('fotoclase','jpg');
% Cambiamos el tamaño
A = imresize (A, [700 1000]);
% Ver la foto y asignarla como objeto
figure(1);
a=imshow(A);
% Pasar la imagen a grises
B=rgb2gray(A);
% Ver la imagen en grises
figure(2);
b=imshow(B);
% Para meter bordes
C=edge(B,'log');
figure(3);
c=imshow(C);
% Ahora buscamos los bordes
D=bwlabel(C,4);
figure(4)
d=imshow(D);
% Encontrar las etiquetas más repetidas
% 1) Número de bordes más grandes
numerodebordes=max(D(:));
% 2) Borde más largo
tam=0;
for i=1:numerodebordes
    tam(i)=sum(D(:)==i);
end
%
[bordesmaslargos,pos]=sort(tam);
for i=1:3
B(D==pos(end-i+1))=0;
imshow(B)
end
%
% Pintar el borde mas largo
profile viewer



