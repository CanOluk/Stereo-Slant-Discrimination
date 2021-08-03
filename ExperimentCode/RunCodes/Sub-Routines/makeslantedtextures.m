function [ orirandm,phrandm,texL, texR, mean_lum, maskLs, maskRs ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,slant,tilt,surface_size,shape,insidepatch,surface_sizeinside,aspect_ratio,mean_lum,referenceslant,zrand)

%% Inputs
% ipd: distance between eyes in cm
% screenDist: distance to screen in cm
% screenWidth and screenWidthPx: width of the screen in cm and in pixels
% slant: rotation around the y-axis (This is not same as usual definition of slant from Stevens paper)
% tilt: rotation around the x-axis
% surface_size: size of the surface in pixels, if the shape is 1 or 2 it is
% the 3d size of the object, if the shape is 3, it is the fixed right image
% size.
% shape: 1 is rectangle, 2 is ellipse, 3 is right image size fixed (I only
% used 1 and 3).
% insidepatch: dummy variable 1 if the there is a blank patch inside of the
% surface.
% surface_sizeinside: size of the inside patch in visual degrees (fixed in the right image)
% aspect_ratio: if the shape is 1, parameter is not used. if the shape is 2, it is the aspect ratio of the ellipse. if the
% shape is 3, the random jitter in the ratio of height of the right side to
% the left side in the right image.
% mean_lum: mean luminance of the right texture.
% referenceslant: reference slant of this condition, only relevant for
% randomizing the ratio of heights because it is randomized around the ratio set by the reference slant.
% zrand: the change in the surface depth

%% Outputs
% orirandm:random seed before sampling orientations of sine-waves
% phrandm: random seed before sampling phases of sine-waves 
% texL: left texture (mean luminance is subtracted and background is marked by -1)
% texR: right texture (mean luminance is subtracted and background is marked by -1)
% mean_lum: mean luminance of texture generated for right image
% maskLs: if the shape is 1, binary mask for blank window, if the shape is 3, binary mask for test plane
% maskRs: if the shape is 1, binary mask for blank window, if the shape is 3, binary mask for test plane

%% variables calculated
pixelsPerCm = screenWidthPx/screenWidth;
screenDist_pxN = screenDist*pixelsPerCm;
ipd_px = ipd*pixelsPerCm;
screenDist_px = ((screenDist-zrand)*pixelsPerCm);
surface_size_px = surface_size;%*pixelsPerCm;
surface_sizeinside_px = surface_sizeinside*pixelsPerCm;

Rslant = [cosd(slant),0,sind(slant);...                 % slant rotation matrix
            0,1,0; -sind(slant),0,cosd(slant)];
Rtilt = [1,0,0; 0, cosd(tilt), -sind(tilt); ...         % tilt rotation matrix
            0,sind(tilt),cosd(tilt)];   

%% texture
freq = .01:.005:.3;     % frequencies for the sine waves that make up the texture
N = length(freq);       % number of frequencies
orirandm=rng;
theta = 2*pi*rand(N,1); % orientation of each sine wave in the texture
phrandm=rng;
ph = 2*pi*rand(N,1);    % phase of each sine wave in the texture
%% Calculate the point on the texture plane that should be drawn at each pixel
%  this particular code makes a single rotation that is composed of
%  rotation around x and y axis (combines two rotation matrix)

% choose the size of the texture you will render. This is a little bit of
% a hack.  You could find the projected corners of the surface and
% calculate a texture just large enough for that.  With the hack it's
% possible that you won't render a texture large enough (this is not true
% for the ellipses). 1.25 is BIG enough!


sz_x = round(1.25*surface_size_px(1));%
sz_y = round(1.25*surface_size_px(2));%


% create the pixels space
x = -sz_x:sz_x; 
y = -sz_y:sz_y;
[Xp,Yp] = meshgrid(x,y);


% exact inverse of the rotation matrix (see calculateRotationInverse.m)
s = slant; t = tilt;
invR = [ cosd(s)/(cosd(s)^2 + sind(s)^2), 0,  -sind(s)/(cosd(s)^2 + sind(s)^2); ...
         (sind(s)*sind(t))/(cosd(s)^2*cosd(t)^2 + cosd(s)^2*sind(t)^2 + cosd(t)^2*sind(s)^2 + sind(s)^2*sind(t)^2),...
            cosd(t)/(cosd(t)^2 + sind(t)^2), ...
            (cosd(s)*sind(t))/(cosd(s)^2*cosd(t)^2 + cosd(s)^2*sind(t)^2 + cosd(t)^2*sind(s)^2 + sind(s)^2*sind(t)^2);...
         (cosd(t)*sind(s))/(cosd(s)^2*cosd(t)^2 + cosd(s)^2*sind(t)^2 + cosd(t)^2*sind(s)^2 + sind(s)^2*sind(t)^2), ...
         -sind(t)/(cosd(t)^2 + sind(t)^2), (cosd(s)*cosd(t))/(cosd(s)^2*cosd(t)^2 + cosd(s)^2*sind(t)^2 + cosd(t)^2*sind(s)^2 + sind(s)^2*sind(t)^2)];
     

% I took the line-plane intersection method straight from wikipedia: 
% https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection
p0 = [0,0,screenDist_px];   % point on the plane
ll0 = [-ipd_px/2,0,0];      % point on the line (from left eye)
lr0 = [ipd_px/2,0,0];       % point on the line (from right eye)

n = Rslant*Rtilt*[0;0;1];   % normal to the plane
n = n'/norm(n);

ldotnL = (Xp+ipd_px/2).*n(1) + Yp*n(2) + screenDist_pxN*n(3);
ldotnR = (Xp-ipd_px/2).*n(1) + Yp*n(2) + screenDist_pxN*n(3);

dl = (p0-ll0)*n'./ldotnL;
dr = (p0-lr0)*n'./ldotnR;

XR = nan(size(dr));
XL = nan(size(dr));

Y = nan(size(dr));
YR = nan(size(dr));

for i=1:size(dr,2)
   vd = screenDist_pxN*ones(size(dr,1),1);
   pl =  bsxfun(@plus,...
       bsxfun(@times,dl(:,i), [Xp(:,i)+ipd_px/2,Yp(:,i),vd]),...
       ll0 - [0,0,screenDist_px]);
      
   temp = invR(1:2,:)*pl';
   XL(:,i) = temp(1,:)';
   Y(:,i) = temp(2,:)';   
 
   pr = bsxfun(@plus,...
       bsxfun(@times,dr(:,i), [Xp(:,i)-ipd_px/2,Yp(:,i),vd]),...
       lr0 - [0,0,screenDist_px]);
   
%    temp = 
   XR(:,i) = (invR(1,:)*pr')';
YR(:,i) = (invR(2,:)*pr')';
end

%% create masks for perspective geometry for a rectangle (this is what the code is using)

if shape==1
maskL = XL<surface_size_px(1) & XL>-1*surface_size_px(1) ...
           & Y<surface_size_px(2) & Y>-1*surface_size_px(2);
maskR = XR<surface_size_px(1) & XR>-1*surface_size_px(1) ...
           & Y<surface_size_px(2) & Y>-1*surface_size_px(2);

%% calculate the mask for perspective geometry for an ellipse 
elseif shape==2

H = surface_size_px(2);
patch_orientation = 0; %degrees
G = H*aspect_ratio;

maskL= (((XL*cosd(patch_orientation)-Y*sind(patch_orientation))/G).^2 ...
    + ((XL*sind(patch_orientation)+Y*cosd(patch_orientation))/H).^2) < 1; 

maskR= (((XR*cosd(patch_orientation)-Y*sind(patch_orientation))/G).^2 ...
    + ((XR*sind(patch_orientation)+Y*cosd(patch_orientation))/H).^2) < 1; 
 
%% calculate the mask for a right image fixed trapezoid
% for these equations check the appendix
elseif shape==3
    wN=sqrt((ipd_px/2)^2+(screenDist_pxN^2));
    w=sqrt((ipd_px/2)^2+(screenDist_px^2));
    mu=acosd(((wN^2+w^2-(screenDist_pxN-screenDist_px)^2))/(2*wN*w));
    betaN=atand((-surface_size_px(1)+(ipd_px/2))/screenDist_pxN);
    
    alpha2=atand((ipd_px/2)/screenDist_pxN)-betaN;
    alpha1=atand((ipd_px/2+surface_size_px(1))/screenDist_pxN)-betaN-alpha2;
    
    rightsizerr=(wN*sind(alpha2))/sind(referenceslant+90+betaN);
    %leftsizerr=(wN*sind(alpha1))/sind(90-alpha1-alpha2-betaN-referenceslant);
    if screenDist_pxN>screenDist_px
        
        
        rightsize=(w*sind(alpha2+mu))/sind(slant+90+betaN);
        leftsize=(w*sind(alpha1-mu))/sind(90-alpha1-alpha2-betaN-slant);
    else
        
        
        rightsize=(w*sind(alpha2-mu))/sind(slant+90+betaN);
        leftsize=(w*sind(alpha1+mu))/sind(90-alpha1-alpha2-betaN-slant);
    end
    
    %y_distl=surface_size_px(2)*(screenDist_pxN/(screenDist_pxN+(sind(referenceslant)*leftsizerr)));
    y_distr=surface_size_px(2)/((screenDist_pxN-(sind(referenceslant)*rightsizerr))/screenDist_pxN);
    
    ap=(y_distr/surface_size_px(2))^2;
    ap=ap+aspect_ratio;
    y_distr=surface_size_px(2)*sqrt(ap);
    y_distl=surface_size_px(2)*(1/sqrt(ap));
    
    
    
    y0_distl=y_distl*((screenDist_px+(sind(slant)*leftsize))/(screenDist_pxN));
    y0_distr=y_distr*((screenDist_px-(sind(slant)*rightsize))/(screenDist_pxN));
    
    leftsize=round(leftsize,5);
    rightsize=round(rightsize,5);
    
    maskL = round(XL,5)<=rightsize & round(XL,5)>=-1*leftsize ...
        & Y<=(((y0_distr-y0_distl)/(rightsize+leftsize))*(XL+leftsize))+y0_distl& Y>=(((y0_distl-y0_distr)/(rightsize+leftsize))*(XL+leftsize))-y0_distl;
    maskR = round(XR,5)<=rightsize & round(XR,5)>=(-1*leftsize) ...
        & YR<=(((y0_distr-y0_distl)/(rightsize+leftsize))*(XR+leftsize))+y0_distl& YR>=(((y0_distl-y0_distr)/(rightsize+leftsize))*(XR+leftsize))-y0_distl;
    maskLs=maskL;
    maskRs=maskR;

end

%% put a fixed sized right image patch inside

if insidepatch==1
    wN=sqrt((ipd_px/2)^2+(screenDist_pxN^2));
    w=sqrt((ipd_px/2)^2+(screenDist_px^2));
    betaN=atand((surface_sizeinside_px(1)-(ipd_px/2))/screenDist_pxN);
    alpha=atand((ipd_px/2)/screenDist_pxN)+betaN;
    if screenDist_pxN>screenDist_px
        rightsize=(w*sind(alpha))/sind(slant+90-betaN);
        leftsize=(w*sind(alpha))/sind(90-2*alpha+betaN-slant);
    else
        rightsize=(w*sind(alpha))/sind(slant+90-betaN);
        leftsize=(w*sind(alpha))/sind(90-2*alpha+betaN-slant);
    end
    
    maskLs = XL<rightsize & XL>-1*leftsize ...
        & Y<surface_sizeinside_px(2) & Y>-1*surface_sizeinside_px(2);
    maskRs = XR<rightsize & XR>-1*leftsize ...
        & Y<surface_sizeinside_px(2) & Y>-1*surface_sizeinside_px(2);
    
else
    if shape==1
        maskLs=maskL;
        maskRs=maskR;
    end
    
    
    
end

%% texture
texL = zeros(size(XL));
texR = texL;

% add together sine waves
% tic;
for i=1:length(freq)

XYL = XL*cos(theta(i)) + Y*sin(theta(i));
XYR = XR*cos(theta(i)) + Y*sin(theta(i)); 
texL = texL + sin(XYL.*freq(i) + ph(i));
texR = texR + sin(XYR.*freq(i) + ph(i));
 
end



% set the background to black
if shape==2 || shape==3
texL(~maskL) = -mean_lum-1;
texR(~maskR) = -mean_lum-1;

elseif shape==1
mean_lum=mean(mean(texR(maskR)));
texL(~maskL) = mean_lum;
texR(~maskR) = mean_lum;
end
if insidepatch==1
texL(maskLs) = mean_lum;
texR(maskRs) = mean_lum;

end

% normalize to fit between 0 and 1.
nrm = 4*max(abs([texL(maskL);texR(maskR)]));
if shape==1
texL = ceil(255*(texL/nrm + .5));
texR = ceil(255*(texR/nrm + .5));
mean_lum=round(255*(mean_lum/nrm + .5));
elseif shape==2 || shape==3
texL(maskL) = ceil(255*(texL(maskL)/nrm + .5));
texR(maskR) = ceil(255*(texR(maskR)/nrm + .5));
texL(maskL) = texL(maskL)-mean_lum;
texR(maskR) = texR(maskR)-mean_lum;
end


