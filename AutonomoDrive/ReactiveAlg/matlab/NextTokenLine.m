function [nextLine pos] = NextTokenLine( fP, token )

% function [nextLine pos] = NextTokenLine( fP, token )

% Look for next token line
pos = [];
nextLine = [];

while isempty(pos) && ~feof(fP)
    nextLine = fgetl(fP);
    pos = strfind(nextLine, token);
end

if feof(fP)
    pos = [];
    nextLine = [];
end
