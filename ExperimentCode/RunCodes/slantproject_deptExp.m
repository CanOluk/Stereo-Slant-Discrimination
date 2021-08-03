% The code for the depth experiment.

clear

% randomseeds for textures used in the experiment for all participants
addpath('random')
% sub-routines
addpath('Sub-Routines')

% take inputs: participant key, session number and dataset number
subname=input('participant initials: \n','s')
subname=strtrim(subname);
sesn=input('enter the session number 1 to 2: \n')
dummy = input(' datasetnumber \n');


% Order of sessions are randomized, either generate the random order or
% read the order.
if exist(strcat(subname,'ssE2.mat'))==2
    load(strcat(subname,'ssE2.mat'))
else
    disp('new participant, quit otherwise')
    int=genvarname(subname);
    int=randperm(2);
    save(strcat(subname,'ssE2.mat'),'int');
end


%% Set keyboard parameters

space_key  = KbName('space');
num1_key   = KbName('1!');
num2_key   = KbName('2@');
num3_key   = KbName('3#');
num4_key   = KbName('4$');
num5_key   = KbName('5%');
num6_key   = KbName('6^');
num7_key   = KbName('7&');
num8_key   = KbName('8*');
% these are stable



% these keyboard parameters are different for mac and windows, these are for mac
% escape_key = KbName('ESCAPE');
% left_key  = KbName('LeftArrow');
% right_key  = KbName ('RightArrow');

% these are for windows
escape_key = KbName('esc');
left_key  = KbName('left');
right_key  = KbName('right');

%% Fixed Variables

% rig-related variables
ipd = 6.5;              % inter-pupillary distance (cm)
screenDist = 100;       % distance from screen to observer (cm)
screenWidth = 55;       % width of screen (cm)
screenWidthPx = 1920;   % width of screen (pixels)
PPCM = screenWidthPx/screenWidth; % pixel per cm

% stimulus-related variables
tilt = 0; % rotation around the x axis (degrees)

% shape: 1 is rectangle, 2 is ellipse, 3 is right image size fixed (I only
% used 1 and 3).
shape=[1 3];

% Reference Plane
surface_sizeR = [11.5*PPCM,8*PPCM]; % the surface is 2*surface_size cm (wide,tall),size of the reference plane in pixels in three dimensional space
insidepatchR=1; % dummy variable for blank window inside
surface_sizeinsideR=[3.8 2.8];   % size of the blank window in visual degrees (fixed in the right image)
refslant=0; % reference slant is 0 fixed.
% these two are not used when the shape is 1.
aspect_ratioR=0; % no meaning of this for shape 1
mean_lum=128;

% Test Plane
surface_sizeE=[69 69]; % size of the test plane in pixels (the width is 2*69+1, the average height 2*69+1) in the right image
insidepatchE=0; % % dummy variable for blank window inside
surface_sizeinsideE=[0 0];


%% Loop for different noise conditions (including feedback block)
% There is 6 parts of this experiment because before each noise level,
% there is a feedback block.
for paofse=1:6
    %% translates inputs to parameters of the experiment
    % controls reference slant, noise level, feedback, scaling of depth differences,
    % randomseeds for textures, number of repetions for each slant difference
    % level.
    inputs_E2
    %%
    % depth differences between reference and test plane, scale is
    % controlled by the inputs. HOWEVER IN THIS CASE, IT IS ALWAYS 1.
    deltaz=scale.*[ -.8 -.4 -0.2 -0.1 0.1 .2 .4 .8];
    
    
    % Experiment parameters
    % total number of trial
    numberoftrials=length(slant)*length(deltaz)*length(noise_levels)*numofrep;
    %  change (random jitter) for the ratio of heights.
    rng('shuffle') % shuffle random to produce a new trial order
    % hald of the trial randomized first, the other half randomization
    % covers the other orientaiton of slant
    trialOrder=[randperm(numberoftrials/2) randperm(numberoftrials/2)+numberoftrials/2];
    %initiate variables
    the_output=zeros(numberoftrials,10);
    combined=cell(numberoftrials+2,3);
    noisernd=cell(numberoftrials,3);
    
    % depth jitter based on saved randomseeds
    expseed=rng;
    if isempty(subname2)
    else
        load(strcat(subname2,'overallrnd.mat'))
        rng(expseed1)
    end
    zrandomizationNOTUSED=round((rand(1,numberoftrials)*2+-1)*10)/10;
    % change (random jitter) for the ratio of heights.
    aspect_ratioE=(rand(1,numberoftrials)/10)-0.05;
    
    
    %% open the screen
    bgcolor = 150;
    Screen('Preference', 'SkipSyncTests', 1);
    AssertOpenGL;
    
    obj.whichScreen = max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    
    %gamma correction
    PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');
    
    PsychImaging('AddTask','RightView','FlipHorizontal');
    
    [obj.theWindow,obj.theRect] = PsychImaging('OpenWindow', obj.whichScreen, [bgcolor,bgcolor,bgcolor],[],[],[],4);
    obj.center = round(obj.theRect(3:4)/2);
    Screen('BlendFunction',obj.theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    %% Draw the experiment start screen
    
    
    % we draw vertical and horizontal line in different eyes to make sure
    % that each eye only recieves the input that is supposed to recieve.
    Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
    Screen('TextSize',obj.theWindow,20)
    Screen('FillRect',obj.theWindow,150)
    Screen('DrawText',obj.theWindow,'Press Spacebar ',obj.theRect(3)/2,obj.theRect(4)/2);
    Screen('DrawLine', obj.theWindow, [255 255 255], 0, obj.theRect(4)/2, obj.theRect(3), obj.theRect(4)/2 );
    Screen('DrawLine', obj.theWindow, [255 255 255], 0, obj.theRect(4)/2+50, obj.theRect(3), obj.theRect(4)/2+50 );
    
    
    Screen('SelectStereoDrawBuffer', obj.theWindow, 1);
    Screen('TextSize',obj.theWindow,20)
    Screen('FillRect',obj.theWindow,150)
    Screen('DrawText',obj.theWindow,'Press Spacebar',obj.theRect(3)/2,obj.theRect(4)/2);
    Screen('DrawLine', obj.theWindow, [255 255 255], obj.theRect(3)/2, 0, obj.theRect(3)/2, obj.theRect(4) );
    Screen('DrawLine', obj.theWindow, [255 255 255], obj.theRect(3)/2+50, 0, obj.theRect(3)/2+50, obj.theRect(4) );
    
    
    Screen('Flip',obj.theWindow);
    
    % escape to exit, space to proceed
    while 1
        pause(0);
        [keyIsDown,secs,keyCode] = KbCheck;
        FlushEvents('keydown');
        if(keyCode(escape_key) == 1)
            Screen('closeall');
            return;
        end
        if(keyCode(space_key) == 1)
            break;
        end %end if
    end %end while loop
    %% generate the reference plane that is fixed for all noise conditions.
    
    % load the random seeds
    if isempty(subname2)
    else
        load(strcat(subname2,'RAND1.mat'))
        rng(combined1{1,1}{1,1})
    end
    %meanlum parameter is irrelevant for shape 1 because its average
    %luminance determined inside the code, but I make sure that it is 128
    [orirandm,phrandm,RPtexL, RPtexR, meanlum ,maskLs, maskRs  ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
        refslant,tilt,surface_sizeR,shape(1),insidepatchR,surface_sizeinsideR,aspect_ratioR,mean_lum,refslant,0);
    
    combined{1,1}={orirandm,phrandm }; % save randomseed anyway
    
    % make sure that generated reference plane have mean luminance of 128
    % in background and in general
    while RPtexL(1,1)~=128 || meanlum~=128
        [orirandm,phrandm,RPtexL, RPtexR, meanlum ,maskLs, maskRs  ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
            refslant,tilt,surface_sizeR,shape(1),insidepatchR,surface_sizeinsideR,aspect_ratioR,mean_lum,refslant,0);
        combined{1,1}={orirandm,phrandm };
    end
    
    %generate texture
    RPLtex = Screen('MakeTexture',obj.theWindow,(RPtexL));
    RPRtex = Screen('MakeTexture',obj.theWindow,(RPtexR));
    
    % refresh to blank screen before trials
    Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
    Screen('FillRect',obj.theWindow,meanlum); %% meanlum
    Screen('SelectStereoDrawBuffer', obj.theWindow,1); %%meanlum
    Screen('FillRect',obj.theWindow,meanlum);
    Screen('Flip',obj.theWindow);
    
    %% trial loop
    for trial_num = 1:numberoftrials
        % when the first half of trials are finished, change the orientation of slant
        if trial_num==(numberoftrials/2)+1
            Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
            Screen('TextSize',obj.theWindow,20)
            Screen('FillRect',obj.theWindow,150)
            Screen('DrawText',obj.theWindow,'Half of the session is over, Press Spacebar to continue',obj.theRect(3)/2,obj.theRect(4)/2);
            
            
            Screen('SelectStereoDrawBuffer', obj.theWindow, 1);
            Screen('TextSize',obj.theWindow,20)
            Screen('FillRect',obj.theWindow,150)
            Screen('DrawText',obj.theWindow,'Half of the session is over, Press Spacebar to continue',obj.theRect(3)/2,obj.theRect(4)/2);
            Screen('Flip',obj.theWindow);
            
            % change orientation of slant
            slant=-slant;
            %% RE-generate the reference plane that is fixed for all noise conditions.
            % THIS IS NOT REQUIRED BECAUSE SLANT IS ZERO BUT TO BE
            % CONSISTENT WITH OTHER EXPERIMENT, WE WILL CHANGE THE TEXTURE
            % ANYWAY.
            
            
            % load the random seeds
            if isempty(subname2)
            else
                load(strcat(subname2,'RAND1.mat'))
                rng(combined1{2,1}{1,1})
            end
            %meanlum parameter is irrelevant for shape 1 because its average
            %luminance determined inside the code, but I make sure that it is 128
            [orirandm,phrandm,RPtexL, RPtexR, meanlum ,maskLs, maskRs  ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
                refslant,tilt,surface_sizeR,shape(1),insidepatchR,surface_sizeinsideR,aspect_ratioR,mean_lum,refslant,-2);
            
            combined{2,1}={orirandm,phrandm }; % save randomseed anyway
            
            % make sure that generated reference plane have mean luminance of 128
            % in background and in general
            while RPtexL(1,1)~=128 || meanlum~=128
                [orirandm,phrandm,RPtexL, RPtexR, meanlum ,maskLs, maskRs  ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
                    refslant,tilt,surface_sizeR,shape(1),insidepatchR,surface_sizeinsideR,aspect_ratioR,mean_lum,refslant,-2);
                combined{2,1}={orirandm,phrandm };
            end
            
            %generate texture
            RPLtex = Screen('MakeTexture',obj.theWindow,(RPtexL));
            RPRtex = Screen('MakeTexture',obj.theWindow,(RPtexR));
            
            while 1
                pause(0);
                [keyIsDown,secs,keyCode] = KbCheck;
                FlushEvents('keydown');
                if(keyCode(escape_key) == 1)
                    Screen('closeall');
                    disp('Closed datafile.');
                    return;
                end
                if(keyCode(space_key) == 1)
                    break;
                end %end if
            end %end while loop
            
            % refresh to blank screen before trials
            Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
            Screen('FillRect',obj.theWindow,meanlum); %% meanlum
            Screen('SelectStereoDrawBuffer', obj.theWindow,1); %%meanlum
            Screen('FillRect',obj.theWindow,meanlum);
            Screen('Flip',obj.theWindow);
        end
        
        %calculate the cond. params.
        my_trial=trialOrder(trial_num);
        my_slant=slant(mod(my_trial,length(slant))+1);
        my_deltaz=deltaz(mod(floor(my_trial/length(slant)),length(deltaz))+1);
        my_noiselevel=noise_levels(mod(floor(my_trial/length(slant)*length(deltaz)),length(noise_levels))+1);
        my_aspectratio=aspect_ratioE(1,my_trial)';
        
        
        % load random seed
        if isempty(subname2)
        else
            load(strcat(subname2,'RAND1.mat'))
            rng(combined1{2+my_trial,1}{1,1})
        end
        
        % generate the test plane
        [orirandm,phrandm,ELtexL, ELtexR, ~, maskLsTEST, maskRsTEST ] = makeslantedtextures(ipd,screenDist,screenWidth,screenWidthPx,...
            my_slant,tilt,surface_sizeE,shape(2),insidepatchE,surface_sizeinsideE,my_aspectratio,mean_lum,slant,my_deltaz);
        combined{2+my_trial,1}={orirandm,phrandm };
        
        % change the background luminance
        ELtexL(~maskLsTEST) = 0;
        ELtexR(~maskRsTEST) = 0;
        
        
        % combine the reference plane with test plane

        STIMr=RPtexR;
        STIMl=RPtexL;

        STIMl(1+((size(STIMl,1)-size(ELtexL,1))/2):((size(STIMl,1)-size(ELtexL,1))/2)+size(ELtexL,1),...
            1+((size(STIMl,2)-size(ELtexL,2))/2):((size(STIMl,2)-size(ELtexL,2))/2)+size(ELtexL,2))=...
            STIMl(1+((size(STIMl,1)-size(ELtexL,1))/2):((size(STIMl,1)-size(ELtexL,1))/2)+size(ELtexL,1),...
            1+((size(STIMl,2)-size(ELtexL,2))/2):((size(STIMl,2)-size(ELtexL,2))/2)+size(ELtexL,2))+ELtexL;

        STIMr(1+((size(STIMr,1)-size(ELtexR,1))/2):((size(STIMr,1)-size(ELtexR,1))/2)+size(ELtexR,1),...
            1+((size(STIMr,2)-size(ELtexR,2))/2):((size(STIMr,2)-size(ELtexR,2))/2)+size(ELtexR,2))=...
            STIMr(1+((size(STIMr,1)-size(ELtexR,1))/2):((size(STIMr,1)-size(ELtexR,1))/2)+size(ELtexR,1),...
            1+((size(STIMr,2)-size(ELtexR,2))/2):((size(STIMr,2)-size(ELtexR,2))/2)+size(ELtexR,2))+ELtexR; 
        %% Add the noise
        % decide on how big blank window inside of the reference plane
        insidejob=maskLs(find(sum(maskLs,2)~=0)',find(sum(maskLs)~=0));
        insidejobR=maskRs(find(sum(maskRs,2)~=0)',find(sum(maskRs)~=0));
        
        % load random seeds
        if isempty(subname2)
        else
            load(strcat(subname2,'RAND2.mat'))
            rng(noisernd1{my_trial,1}{1,1})
        end
        
        % left image noise
        leftnoise=rng; % save current random seed
        noise1=normrnd(0,noise_levels*128/100,[size(insidejob,1) (size(insidejob,2))]);
        insidejob=insidejob.*noise1(1:size(insidejob,1),1:size(insidejob,2));
        
        % right image noise
        rightnoise=rng;% save current random seed
        noise2=normrnd(0,noise_levels*128/100,[size(insidejobR,1) (size(insidejobR,2))]);
        insidejobR=insidejobR.*noise2(1:size(insidejobR,1),1:size(insidejobR,2));
        
        % save random seed
        noisernd{my_trial,1}={leftnoise,rightnoise};
        
        % add noise to stimulus
        STIMl(find(sum(maskLs,2)~=0)',find(sum(maskLs)~=0)) = ...
            STIMl(find(sum(maskLs,2)~=0)',find(sum(maskLs)~=0))+insidejob;
        
        STIMr(find(sum(maskRs,2)~=0)',find(sum(maskRs)~=0)) = ...
            STIMr(find(sum(maskRs,2)~=0)',find(sum(maskRs)~=0))+insidejobR;
        
        %% clipping and location of stimulus
        
        STIMl(STIMl>255)=255;
        STIMr(STIMr>255)=255;
        STIMl(STIMl<0)=0;
        STIMr(STIMr<0)=0;
        
        % we cover part of the screen, so the center is adjusted.
        dest = CenterRectOnPoint([0 0 size(STIMl,2) size(STIMl,1)],obj.center(1),obj.center(2)-(obj.theRect(4)/6));
        
        ELLtex = Screen('MakeTexture',obj.theWindow,((STIMl)));
        ELRtex = Screen('MakeTexture',obj.theWindow,((STIMr)));
        
        %% Present the stimulus
        
        Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
        Screen('DrawTexture',obj.theWindow,ELLtex,[],dest);
        
        
        Screen('SelectStereoDrawBuffer', obj.theWindow, 1);
        Screen('DrawTexture',obj.theWindow,ELRtex,[],dest);
        [,time]=Screen('Flip',obj.theWindow);
        
            %% wait for the response
        
        FlushEvents;
        % knob responses are mapped to l and o, t stops the experiment
        while 1
            if CharAvail
                ch = GetChar;
                if strcmp(ch,'l') || strcmp(ch, 'o')
                    response = ch;
                    react=GetSecs;
                    break;
                elseif strcmp(ch,'t')
                    Screen('closeall');
                    return;
                end
                FlushEvents;
            end
        end
        
        % map response to 2,8.
        if strcmp(ch,'l')
            observer_response =8;
        elseif strcmp(ch, 'o')
            observer_response =2;
        end
        
        % for feedback block, provide the feedback.
        if feedback==1
            if (my_deltaz>0 && observer_response==2) || (my_deltaz<0 && observer_response==8)
                freqs = 1200;
                duration = 0.2;
                sampleFreq = 44100;
                dt = 1/sampleFreq;
                t = [0:dt:duration];
                s=sin(2*pi*freqs(1)*t);
                sound(s,sampleFreq);
            else
                freqs = 400;
                duration = 0.2;
                sampleFreq = 44100;
                dt = 1/sampleFreq;
                t = [0:dt:duration];
                s=sin(2*pi*freqs(1)*t);
                sound(s,sampleFreq);
            end
        end
        reaction_time=react-time;
        
        
        % print the data and collect the data
        fprintf('%d\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %d \n',trial_num, my_trial,my_slant,my_deltaz, my_noiselevel, my_aspectratio,1, reaction_time,observer_response);
        the_output(trial_num,:)=[ trial_num my_trial my_slant my_deltaz my_noiselevel my_aspectratio 1 reaction_time observer_response];
        
        %% wait after the trial for 1.5 seconds
        
        Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
        Screen('DrawTexture',obj.theWindow,RPLtex,[],dest);
        
        
        Screen('SelectStereoDrawBuffer', obj.theWindow, 1);
        Screen('DrawTexture',obj.theWindow,RPRtex,[],dest);
        Screen('Flip',obj.theWindow);
        
        WaitSecs(1.5)

        %%
        if trial_num == numberoftrials
            Screen('SelectStereoDrawBuffer', obj.theWindow, 0);
            Screen('FillRect',obj.theWindow,[meanlum])
            Screen('TextSize',obj.theWindow,20)
            Screen('DrawText',obj.theWindow,strcat(num2str(6-paofse),'  parts left in this session'),obj.theRect(3)/2,obj.theRect(4)/2);
            
            
            Screen('SelectStereoDrawBuffer', obj.theWindow, 1);
            Screen('FillRect',obj.theWindow,[meanlum])
            Screen('TextSize',obj.theWindow,20)
            Screen('DrawText',obj.theWindow,strcat(num2str(6-paofse),'  parts left in this session'),obj.theRect(3)/2,obj.theRect(4)/2);
            Screen('Flip',obj.theWindow);
            while 1
                pause(0);
                [keyIsDown,secs,keyCode] = KbCheck;
                FlushEvents('keydown');
                if(keyCode(space_key) == 1)
                    break;
                end %end if
            end %end while loop
            
            Screen('Flip',obj.theWindow);
        end
    end
    for i=1:numberoftrials+2
        rng(combined{i,1}{1,1});
        combined{i,2}=rand(10,1);
        rng(combined{i,1}{1,2});
        combined{i,3}=rand(10,1);
    end
    
    for i=1:numberoftrials
        rng(noisernd{i,1}{1,1});
        noisernd{i,2}=rand(10,1);
        rng(noisernd{i,1}{1,2});
        noisernd{i,3}=rand(10,1);
    end
    combined1=combined;
    noisernd1=noisernd;
    expseed1=expseed;
    save(strcat(subname,'.mat'),'the_output');
    save(strcat(subname,'RAND1.mat'),'combined1');
    save(strcat(subname,'RAND2.mat'),'noisernd1');
    save(strcat(subname,'overallrnd.mat'),'expseed1');
    
end
%Shut down the screen 
Screen('closeall');