function out= cofg(weights, locations)
% Comments are introduced by percent signs, as here.
% These initial comments will be written to the terminal
% if you type ’help cofg’. It is useful to remind the
% user how to call the function by putting in the line:
% cg = cofg(weights, locations)
cg = 5
out = weights * locations' / sum(weights);

