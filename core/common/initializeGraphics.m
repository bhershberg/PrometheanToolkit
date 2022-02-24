% run this script at the top of your file whenever you work with graphics
% in order to ensure that you're using the 'standard' visual dimensions for
% row and column placements in functions such as placeButton(),
% placeText(), relativePosition(), etc.
%
% Note that some of these variable names are also built-in matlab
% functions, so you might need to pre-declare certain variables so that
% matlab knows they are variables and not functions.
%
% For example:
%
%   initializeGraphics;
%   dimY = py;
%
%   ...will trip an error because py() is a built-in function.
%
% So just do this instead:
%
%   py = 0;
%   initializeGraphics;
%   dimY = py;
%
%   ...will work!

guiW = 1280;
guiH = 720;
dfx = 0.01; % dfx = default relative x-padding
dfy = 0.01; % dfx = default relative y-padding
dfh = 0.08; % dfh = default relative height
dfw = 0.15; % dfw = default relative width
px = 10;    % px = default absolute pixel x-padding
py = 10;    % py = default absolute pixel y-padding
ph = 24;    % ph = default absolute pixel height
pw = 198;   % pw = default absolute pixel width
green = [0.6941 0.8196 0.6784]; %[0.7451 0.8863 0.8039];
red = [0.8196 0.6784 0.6784];
blue = [196, 225, 255] ./ 255;
grey = [0.9400    0.9400    0.9400];
yellow = [255, 252, 179] ./ 255;
