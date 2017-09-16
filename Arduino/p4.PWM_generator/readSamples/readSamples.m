function readSamples(inputFilename)

fileId = fopen(inputFilename);
data = fread(fileId, '*char');
fclose(fileId);

% retain only digits.
data(~isstrprop(data, 'digit')) = ' ';
numbers = str2num(data.');

numOfSamples = numel(numbers) / 2;
numbers = reshape(numbers, [2, numOfSamples]).';

time = numbers(:, 1);
voltage = numbers(:, 2);

plot(time, voltage, 'b',   ...
  time, voltage, 'b.');
xlabel('time (ms)');
ylabel('voltage (mV)');
grid on;
currentAxis = axis;
currentAxis(3 : 4) = [-0.2, 3.5] * 1e3;
axis(currentAxis);
figure(gcf);

thresholdTime = .15 * time(end);
averageWindow = (time > thresholdTime);
disp(sprintf('Mean: %f', mean(voltage(averageWindow))));
disp(sprintf('Error: %f', max(voltage(averageWindow)) - min(voltage(averageWindow))));
end