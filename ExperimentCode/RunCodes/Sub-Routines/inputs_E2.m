% this code transforms inputs to parameters that are used in the
% experiment.

% the code controls:
% reference slant, noise level, feedback, scaling of depth differences,
% randomseeds for textures, number of repetions for each slant difference
% level.


% dataset one textures
if dummy==1
    if int(sesn)==1
        slant=44; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='x_8_1_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_8_1_2'; scale=1;   noise_levels=5;
        elseif paofse==4
            subname2='x_8_1_3'; scale=1; noise_levels=17.5;
        elseif paofse==6
            subname2='x_8_1_4';scale=1;noise_levels=34;
        elseif paofse==3
            subname2='x_7_3_1'; scale=1;  noise_levels=17.5;feedback=1; numofrep=5;
        elseif paofse==5
            subname2='x_7_3_2'; scale=1;  noise_levels=34;feedback=1; numofrep=5;
        end
        
        
    elseif int(sesn)==2
        slant=44; feedback=0 ;numofrep=10;
        if paofse==5
            subname2='x_3_2_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='x_3_2_2';scale=1;noise_levels=34;
        elseif paofse==4
            subname2='x_3_2_3'; scale=1; noise_levels=17.5;
        elseif paofse==6
            subname2='x_3_2_4'; scale =1 ;   noise_levels=5;
        elseif paofse==3
            subname2='x_7_3_3'; scale=1;  noise_levels=17.5;feedback=1; numofrep=5;
        elseif paofse==1
            subname2='x_7_3_4'; scale=1;  noise_levels=34;feedback=1; numofrep=5;
        end
        
    end
    
    
    % load the randomseeds
    load(strcat(subname2,'.mat'))
    
    % change the name string to reflect the conditions that will be
    % running, participant key, session number, what session correspond to,
    % part of the session
    if paofse==1
        subname=strcat(subname,'_E2_',num2str(sesn),'_',num2str(int(sesn)),'_',num2str(paofse));
    else
        subname(end)=[];
        subname=strcat(subname,num2str(paofse));
    end
elseif dummy==2
    if int(sesn)==1
        slant=44; feedback=0 ;numofrep=10;
        if paofse==1
            subname2='xx_7_1_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_7_1_2'; scale=1;   noise_levels=5;
        elseif paofse==4
            subname2='xx_7_1_3'; scale=1; noise_levels=17.5;
        elseif paofse==6
            subname2='xx_7_1_4';scale=1;noise_levels=34;
        elseif paofse==3
            subname2='xx_3_2_1'; scale=1;  noise_levels=17.5;feedback=1; numofrep=5;
        elseif paofse==5
            subname2='xx_3_2_2'; scale=1;  noise_levels=34;feedback=1; numofrep=5;
        end
    elseif int(sesn)==2
        slant=44; feedback=0 ;numofrep=10;
        if paofse==5
            subname2='xx_5_3_1'; scale=1;  noise_levels=5;feedback=1; numofrep=5;
        elseif paofse==2
            subname2='xx_5_3_2';scale=1;noise_levels=34;
        elseif paofse==4
            subname2='xx_5_3_3'; scale=1; noise_levels=17.5;
        elseif paofse==6
            subname2='xx_5_3_4'; scale =1 ;   noise_levels=5;
        elseif paofse==3
            subname2='xx_3_2_3'; scale=1;  noise_levels=17.5;feedback=1; numofrep=5;
        elseif paofse==1
            subname2='xx_3_2_4'; scale=1;  noise_levels=34;feedback=1; numofrep=5;
        end
    end
    load(strcat(subname2,'.mat'))
    if paofse==1
        subname=strcat(subname,'_E2_',num2str(sesn),'_',num2str(int(sesn)),'_',num2str(paofse));
    else
        subname(end)=[];
        subname=strcat(subname,num2str(paofse));
    end
end