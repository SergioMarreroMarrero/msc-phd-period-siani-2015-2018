% %clear all;
% 
% N = 500;
% Vout = NaN(1, 500);
% for i = 1 : N,
%     Vout(i) = EAnalogIn(-1, 0, 0, 0);
% end
% 
% figure(1);
% plot(Vout); grid on;
% hold on;
% plot(Vout, '.');
% hold off;
% 
% 
% sortedVout = unique(sort(Vout));
% figure(2);
% plot(sortedVout, '.');
% 
% quantum = diff(sortedVout);
% figure(3);
% plot(quantum);
% 
% figure(4);
% stem(double(diff(Vout) == 0));

%%
numOfRealizations = 5 ;
distance = [10 : 10 : 70];
numOfDistances = numel(distance);
 
measuredVout = NaN(numOfRealizations, numOfDistances);

for realizIndx = 1 : numOfRealizations,
    for distIndx = 1 :  numOfDistances,
            disp(['Realization ' int2str(realizIndx)   ...
                ', distance ' num2str(distance(distIndx) + 20)]);
            pause;
        measuredVout(realizIndx, distIndx) = EAnalogIn(-1, 0, 0, 0);
        disp(['Vout = ' num2str(measuredVout(realizIndx, distIndx))]);
        
    end;
end;
%%
figure(5);
plot(measuredVout, '.-'); 
grid on;
