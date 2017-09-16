function [path, obs,nScans,nPath,rangerDataOut] = ExtractPathScans(filename, th0)

% function [pos obs] = ExtractPathScans(filename, th0)
% IN: 
%   filename - log filename [char]
%   th0 - initial robot angle [rad]
% OUT: 
%   path.{time, x, y}
%   obs.{x{NSCANS}, y{NSCANS}}
% EXAMPLE:
%   [pos obs] = ExtractPathObs2('mydata2012_05_09_13_01_36.log', 45/180*pi)

rangerName = 'laser';
positionName = 'position2d';

obs = []; path = [];
nScans = 0; nPath = 0;

try
    fP = fopen(filename);
catch
    disp(['GetObstacles: ERROR file not found' filename]);
    return;
end

% First ranger header
[rangerLine, pos] = NextTokenLine( fP, rangerName );

% Ranger configuration
[rangerLine, pos] = NextTokenLine( fP, rangerName );

rangerConf = str2num(rangerLine(pos+length(rangerName)+1:end));

minAngle = rangerConf(5);
maxAngle = rangerConf(6);
maxDist = rangerConf(8);
% nData = rangerConf(9);

% First position header
[positionLine, pos] = NextTokenLine( fP, positionName );

obs.x{1} = [];
obs.y{1} = [];

finish = 0;
while ~finish

    % Next position
    [positionLine, pos] = NextTokenLine( fP, positionName );
    
    if ~isempty(positionLine)
        nPath = nPath+1;

  
        positionData = str2num(positionLine(1:pos-1));
        try
            path.time(nPath) = positionData(1);
        catch
            disp('ExtractPathObs2: Error reading log file')
        end
        positionData = str2num(positionLine(pos+length(positionName)+1:end));
        
        % odometric positions
        path.x(nPath) = positionData(4); path.y(nPath) = positionData(5);
        path.th(nPath) = positionData(6);
        
        % odometric velocities
        path.vx(nPath) = positionData(7); path.vy(nPath) = positionData(8);
        path.vth(nPath) = positionData(9);        
        
        % Next scan
        [rangerLine, pos] = NextTokenLine( fP, rangerName );


        
        if ~isempty(rangerLine)
            rangerData = str2num(rangerLine(pos+length(rangerName)+1:end));
            nData = rangerData(9);
            rangerData = rangerData(10:2:end);
            rangerData(rangerData>=maxDist) = NaN;

            %%%
            angles = minAngle:(maxAngle-minAngle)/(nData-1):maxAngle;

            xo = rangerData .* cos(angles + path.th(nPath) ); 
            yo = rangerData .* sin(angles + path.th(nPath) ); 

            nScans = nScans+1;
            
            rangerDataOut(:,nScans)=rangerData; %%%
            obs.x{nScans} = xo+path.x(nPath);
            obs.y{nScans} = yo+path.y(nPath);

        else
            finish = 1;
        end

    else
        finish = 1;
    end
end

for i = 1:nScans
    [a, m] = cart2pol(obs.x{i}, obs.y{i});
    [obs.x{i}, obs.y{i}] = pol2cart(a+th0, m);
    
    [pTheta, pR]=cart2pol(path.x(i),path.y(i));
    [path.x(i), path.y(i)]=pol2cart(pTheta+th0,pR);
end
