% this code transforms inputs to parameters that are used in the
% experiment.

% the code controls:
% reference slant, noise level, feedback, scaling of slant differences,
% randomseeds for textures, number of repetions for each slant difference
% level.


% dataset one textures
if dummy==1
    if int(sesn)==1 % slant 0 session
        slant=0; feedback=0 ;numofrep=10;
        if paofse==1 %feedback block
            subname2='x_8_1_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2 % 5 percent noise block
            subname2='x_8_1_2'; scale=1;   noise_levels=5;
        elseif paofse==3 % 17.5 percent noise block
            subname2='x_8_1_3'; scale=1.2; noise_levels=17.5;
        elseif paofse==4 % 34 percent noise block
            subname2='x_8_1_4';scale=1.4;noise_levels=34;
        end
    elseif int(sesn)==2
        slant=0; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_3_2_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_3_2_2';scale=1.4;noise_levels=34;
        elseif paofse==3
            subname2='x_3_2_3'; scale=1.2; noise_levels=17.5;
        elseif paofse==4
            subname2='x_3_2_4'; scale =1 ;   noise_levels=5;
        end
    elseif int(sesn)==3
        slant=sign(rand()-0.5)*12.5; feedback=0 ;numofrep=10; % slant's orientation is randomly selected since the other half of the block will cover the other orientation.
        if paofse==1
            subname2='x_7_3_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_7_3_2';scale=1;noise_levels=5;
        elseif paofse==3
            subname2='x_7_3_3'; scale=1; noise_levels=17.5;
        elseif paofse==4
            subname2='x_7_3_4'; scale=1.2;   noise_levels=34;
        end
    elseif int(sesn)==4
        slant=sign(rand()-0.5)*12.5; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_1_4_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_1_4_2';scale=1.2;noise_levels=34;
        elseif paofse==3
            subname2='x_1_4_3'; scale=1; noise_levels=17.5;
        elseif paofse==4
            subname2='x_1_4_4'; scale=1  ;   noise_levels=5;
        end
    elseif int(sesn)==5
        slant=sign(rand()-0.5)*25; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_5_5_1'; scale=0.5;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_5_5_2';scale=0.5;noise_levels=5;
        elseif paofse==3
            subname2='x_5_5_3'; scale=0.7; noise_levels=17.5;
        elseif paofse==4
            subname2='x_5_5_4'; scale=1  ;   noise_levels=34;
        end
    elseif int(sesn)==6
        slant=sign(rand()-0.5)*25; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_6_6_1'; scale=0.5;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_6_6_2';scale=1;noise_levels=34;
        elseif paofse==3
            subname2='x_6_6_3'; scale=0.7; noise_levels=17.5;
        elseif paofse==4
            subname2='x_6_6_4'; scale=0.5  ;   noise_levels=5;
        end
    elseif int(sesn)==7
        slant=sign(rand()-0.5)*50; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_4_7_1'; scale=0.4;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_4_7_2';scale=0.4;noise_levels=5;
        elseif paofse==3
            subname2='x_4_7_3'; scale=0.5; noise_levels=17.5;
        elseif paofse==4
            subname2='x_4_7_4'; scale=0.7  ;   noise_levels=34;
        end
    elseif int(sesn)==8
        slant=sign(rand()-0.5)*50; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_2_8_1'; scale=0.4;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_2_8_2';scale=0.7;noise_levels=34;
        elseif paofse==3
            subname2='x_2_8_3'; scale=0.5; noise_levels=17.5;
        elseif paofse==4
            subname2='x_2_8_4'; scale=0.4  ;   noise_levels=5;
        end
        
        % if you like to take these as inputs 
        % slant =input('Slant of Reference Plane? \n');                  
        % scale= input('Scale of deltaslants? \n');
        
        % feedback=input('Feedback : Yes for 1 No for 0 \n');
        % numofrep=input('Number of trials for each point : \n');
    end
    % if you like to take these as inputs 
    %  subname2 = input('enter the subject name of experiment which stimuli will be copied in randomized order \n for random new experiment leave empty \n','s');
    %  noise_levels=input('Noise Level \n');
    %  scale= input('Scale of deltaslants? \n');
    
    % load the randomseeds 
    load(strcat(subname2,'.mat'))
    % the orientation of the slant for the start is already selected for
    % these, so I will just use it. If you are generating new random seeds,
    % comment this one!!!
    slant=the_output(1,3);
    
    % change the name string to reflect the conditions that will be
    % running, participant key, session number, what session correspond to,
    % part of the session
    if paofse==1
        subname=strcat(subname,'_',num2str(sesn),'_',num2str(int(sesn)),'_',num2str(paofse));
    else
        subname(end)=[];
        subname=strcat(subname,num2str(paofse));
    end
    
    % dataset two textures, only difference is xx rather than x in
    % randomseeds.
elseif dummy==2
    if int(sesn)==1
        slant=0; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_7_1_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_7_1_2'; scale=1;   noise_levels=5;
        elseif paofse==3
            subname2='xx_7_1_3'; scale=1.2; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_7_1_4';scale=1.4;noise_levels=34;
        end
    elseif int(sesn)==2
        slant=0; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_3_2_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_3_2_2';scale=1.4;noise_levels=34;
        elseif paofse==3
            subname2='xx_3_2_3'; scale=1.2; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_3_2_4'; scale =1 ;   noise_levels=5;
        end
    elseif int(sesn)==3
        slant=12.5; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_5_3_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_5_3_2';scale=1;noise_levels=5;
        elseif paofse==3
            subname2='xx_5_3_3'; scale=1; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_5_3_4'; scale=1.2;   noise_levels=34;
        end
    elseif int(sesn)==4
        slant=12.5; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_6_4_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_6_4_2';scale=1.2;noise_levels=34;
        elseif paofse==3
            subname2='xx_6_4_3'; scale=1; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_6_4_4'; scale=1  ;   noise_levels=5;
        end
    elseif int(sesn)==5
        slant=25; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_4_5_1'; scale=0.5;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_4_5_2';scale=0.5;noise_levels=5;
        elseif paofse==3
            subname2='xx_4_5_3'; scale=0.7; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_4_5_4'; scale=1  ;   noise_levels=34;
        end
    elseif int(sesn)==6
        slant=25; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_8_6_1'; scale=0.5;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_8_6_2';scale=1;noise_levels=34;
        elseif paofse==3
            subname2='xx_8_6_3'; scale=0.7; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_8_6_4'; scale=0.5  ;   noise_levels=5;
        end
    elseif int(sesn)==7
        slant=50; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_2_7_1'; scale=0.4;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_2_7_2';scale=0.4;noise_levels=5;
        elseif paofse==3
            subname2='xx_2_7_3'; scale=0.5; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_2_7_4'; scale=0.7  ;   noise_levels=34;
        end
    elseif int(sesn)==8
        slant=50; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_1_8_1'; scale=0.4;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_1_8_2';scale=0.7;noise_levels=34;
        elseif paofse==3
            subname2='xx_1_8_3'; scale=0.5; noise_levels=17.5;
        elseif paofse==4
            subname2='xx_1_8_4'; scale=0.4  ;   noise_levels=5;
        end
        
        % slant =input('Slant of Reference Plane? \n');                  % slant of surface (degrees)
        % scale= input('Scale of deltaslants? \n');
        
        % feedback=input('Feedback : Yes for 1 No for 0 \n');
        % numofrep=input('Number of trials for each point : \n');
    end
    %subname2 = input('enter the subject name of experiment which stimuli will be copied in randomized order \n for random new experiment leave empty \n','s');
    %  noise_levels=input('Noise Level \n');
    %  scale= input('Scale of deltaslants? \n');
    load(strcat(subname2,'.mat'))
    slant=sign(the_output(1,3)).*slant;
    if paofse==1
        subname=strcat(subname,'_',num2str(sesn),'_',num2str(int(sesn)),'_',num2str(paofse));
    else
        subname(end)=[];
        subname=strcat(subname,num2str(paofse));
    end
end