function [ FSminR] = funcionfitness(a,b)

FSminR=exp(-1/(a^2+b^2));
FSminR=FSminR+(2*rand(1)-1)*0.1;


end

