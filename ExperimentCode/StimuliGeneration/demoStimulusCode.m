% demo code

% rig-related variables
ipd = 6.5;              % inter-pupillary distance (cm)
screenDist = 100;       % distance from screen to observer (cm)
screenWidth = 55;       % width of screen (cm)
screenWidthPx = 1920;   % width of screen (pixels)
PPCM = screenWidthPx/screenWidth; % pixel per cm

% rotation around the x axis and y axis
tilt = 0; 
slant = 50;

%% USE SHAPE=1 TO GENERATE REFERENCE PLANE
shape=1; % shape dummy variable
surface_sizeR = [11.5*PPCM,8*PPCM]; % size of the reference plane in pixels in three dimensional space
insidepatchR=1; % dummy variable for blank window inside
surface_sizeinsideR=[3.8 2.8];  % size of the blank window in visual degrees (fixed in the right image)

zrand= -2 ; % depth of the surface relative to monitor, 2 cm behind, 102 cm depth
mean_lum=128; % mean luminance

% these two are not used when the shape is 1.
aspect_ratioR=0; % no meaning of this for shape 1
refslant=0; % no meaning of this for shape 1

[orirandm,phrandm,RPtexL, RPtexR, meanlum ,maskLsR, maskRsR ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
    slant,tilt,surface_sizeR,shape,insidepatchR,surface_sizeinsideR,aspect_ratioR,mean_lum,refslant,zrand);

% Outputs
% orirandm:random seed before sampling orientations of sine-waves
% phrandm: random seed before sampling phases of sine-waves 
% texL: left texture
% texR: right texture
% mean_lum: mean luminance of texture generated for right image
% maskLs: if the shape is 1, binary mask for blank window
% maskRs: if the shape is 1, binary mask for blank window
%% USE SHAPE=3 TO GENERATE TEST PLANE

shape=3; % shape dummy variable
surface_size=[69 69]; % size of the test plane in pixels (the width is 2*69+1, the average height 2*69+1) in the right image
insidepatchR=0; % % dummy variable for blank window inside
surface_sizeinsideR=[0 0];  % size of the blank window in visual degrees (fixed in the right image)
zrand=1; % depth of the surface relative to monitor, 1 cm infront, 99 cm depth
mean_lum=128; % mean luminance

aspect_ratio=0; % the change (random jitter) for the ratio of heights.

% the reference slant condition, this is required because the ratio of edges set the what is expected from the reference slant, no matter what the true slant is. the random jitter generated around it.
refslant=50; 


[orirandm,phrandm,RPtexL, RPtexR, meanlum ,maskLsR, maskRsR ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
    slant,tilt,surface_size,shape,insidepatchR,surface_sizeinsideR,aspect_ratio,mean_lum,refslant,zrand);

% Outputs
% orirandm:random seed before sampling orientations of sine-waves
% phrandm: random seed before sampling phases of sine-waves 
% texL: left texture (mean luminance is subtracted and background is marked by -1)
% texR: right texture (mean luminance is subtracted and background is marked by -1)
% mean_lum: mean luminance of texture generated for right image
% maskLs: if the shape is 3, binary mask for test plane
% maskRs: if the shape is 3, binary mask for test plane


% for shape=3, if tilt is zero, this code would give your very
% similar results. However, if you have both non-zero slant and tilt, only this code makes
% sures that right image is fixed. The ratio of height is not randomized or
% set to the reference slant in this code, the fixed right image controlled
% inside the code and currently fixed to be a square but you can specify the right image
% exactly. I haven't used this code in my experiment so it still have small bugs (there are also some pixelations due to rounding).

[ orirandm,phrandm,texL, texR, mean_lum, maskLs, maskRs ] = makeslantedtextures_anyslanttilt(ipd,screenDist,screenWidth,screenWidthPx,...
    slant,tilt,surface_size,shape,insidepatchR,surface_sizeinsideR,aspect_ratio,mean_lum,refslant,zrand);
