clc;
clear all;
close all;
addpath(genpath('/Users/rebeccawilder/Desktop/CMR/'))
if ~strcmp(pwd, '/Users/rebeccawilder/Desktop/CMR/')
    cd ('/Users/rebeccawilder/Desktop/CMR/')
end 

%basic subfields
datafile= dir('*.mat');
load(datafile(2).name);
nsubj= unique(data.subject);
LL= data.listLength;
ifr_mask= make_clean_recalls_mask2d(data.recalls);
ppfr_mat= zeros(20,30,7,43);
lag_num= nan(30,30);
lag_denom= nan(30,30);
%Loop through subjects
for subj= 1:length(nsubj)
    %Loop through sessions
    for s= 1:7
        ifr_idx= data.session== s & data.subject== nsubj(subj);
        
        ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session == s;
        
        %Set conditional variable for calculations if subject has
        %data for currentt session
        if sum(sum(ifr_idx))~=0
            
            %Mask needs to go here
            ifr_recall= data.recalls(ifr_idx,:);
            ifr_mask= make_clean_recalls_mask2d(ifr_recall);
            ifr_rec_itemnos= data.rec_itemnos(ifr_idx,:);
            ifr_recall(~ifr_mask)= nan;
            ifr_rec_itemnos(~ifr_mask)= nan;
            
            
            %good way to spotcheck random Ss for n NaNs; 
            %if s1-s2== 0 --> correct number of NaNs
            %size(ifr_rec_itemnos(~isnan(ifr_rec_itemnos)))-size(unique(ifr_rec_itemnos(~isnan(ifr_rec_itemnos))))
            ifr_lag= LL- ifr_recall-1;
            for add_op = 1:length(ifr_lag(1,:))
               ifr_lag(:,add_op)= ifr_lag(:,add_op)+add_op;
            end
            %Mask out ffr by rec_itemnos
            ffr_mask1= ifr_rec_itemnos(ifr_mask);
            ffr_rec_itemnos= data.ffr.rec_itemnos(ffr_idx,:);
            ffr_mask2= ismember(ffr_rec_itemnos, ffr_mask1);
            
            
            %Set ffr rec_itemnos to nan if it was not ifr and or was a
            %repeated ifr
            ffr_rec_itemnos(~(ffr_mask2 | data.ffr.recalled(ffr_idx,:)))= nan;
            ffr_mask3= make_clean_recalls_mask2d(ffr_rec_itemnos);
            ffr_rec_itemnos(~ffr_mask3)= nan;
            ffr_recall= data.ffr.sp(ffr_idx,:);
            ffr_op= data.ffr.op(ffr_idx,:);
            ffr_lag= [];
            for gffrlag= 1:length(ffr_rec_itemnos)
                if isnan(ffr_rec_itemnos(gffrlag))
                    ffr_lag(gffrlag)= nan;
                else
                    ffr_lag(gffrlag)= ifr_lag(ifr_rec_itemnos==ffr_rec_itemnos(gffrlag));
                end
            end 
                    
            ffr_lag(isnan(ffr_rec_itemnos))=nan;
            
            %not calculating ffr_lag correctly
            
            
            
            
            
            for ifr_lag_max= 0:max(max(ifr_lag))
                    if ifr_lag_max<LL
                        ifr_lag_idx= LL:-1:LL-(ifr_lag_max-1);
                        for ifr_sp_idx= 1:length(ifr_lag_idx)
                            lag_denom(ifr_lag_max+1, ifr_sp_idx)= sum(sum(ifr_lag== ifr_lag_max & ifr_recall== ifr_lag_idx(ifr_sp_idx)));
                        end
                    elseif ifr_lag_max== LL
                        for ifr_sp_idx= 1:LL
                            %this condition is different because 16 has the max
                            %number of output possibilities
                            lag_denom(ifr_lag_max+1,ifr_sp_idx)= sum(sum(ifr_lag==LL & ifr_recall== ifr_sp_idx));
                        end 
                    else
                        ifr_lag_idx= ifr_lag_max-LL+1:LL;
                        for ifr_sp_idx= 1:length(ifr_lag_idx)
                            lag_denom(ifr_lag_max+1, ifr_sp_idx)= sum(sum(ifr_lag==LL & ifr_recall== ifr_lag_idx(ifr_sp_idx)));
                        end
                        
                    end
            end
               
            for ffr_lag_max= 0:max(max(ffr_lag))
                    if ffr_lag_max<LL
                        ffr_lag_idx= LL:-1:LL-(ffr_lag_max-1);
                        for ffr_sp_idx= 1:length(ffr_lag_idx)
                            lag_num(ffr_lag_max+1, ffr_sp_idx)= sum(sum(ffr_lag== ffr_lag_max & ffr_recall== ffr_lag_idx(ffr_sp_idx)));
                        end
                    elseif ifr_lag_max== LL
                        for ffr_sp_idx= 1:LL
                            %this condition is different because 16 has the max
                            %number of output possibilities
                            lag_num(ffr_lag_max+1,ffr_sp_idx)= sum(sum(ffr_lag==LL & ffr_recall== ffr_sp_idx));
                        end 
                    else
                        ifr_lag_idx= ifr_lag_max-LL+1:LL;
                        for ifr_sp_idx= 1:length(ifr_lag_idx)
                            lag_denom(ifr_lag_max+1, ifr_sp_idx)= sum(sum(ifr_lag==LL & ifr_recall== ifr_lag_idx(ifr_sp_idx)));
                        end
                        
                    end
            end
            
            pfr_mat(:,:, s, subj)= (lag_num(1:20,:)./lag_denom(1:20,:));
        else
            pfr_mat(:,:, s, subj)= nan;
            

        end
            
            %We're only doing up to lag 20
            %make things 3 dim array take avg across subj and avg across
            %session
           
            
    end
    c1(subj, s)= any(any(isinf(lag_num(1:20,:)./lag_denom(1:20,:))));
    %Look over by hand need to reshape by every 35 to take average of
    %sessions
   %pffr{subj}= cell2mat(session_i(~cellfun('isempty',session_i)));

    
end 


close all;

sq= pfr_mat;

for ses_loop= 1:7
    for main_loop= 1:43 
        sq(1:20,:,ses_loop,main_loop)= pfr_mat(:,:,ses_loop,main_loop);
        
    end 
end 

stdev= nanstd(nanmean(sq(:,:)'))/sqrt(length(nanmean(sq(:,:)')));


h1= plot(nanmean(sq(:,:)'), '*-');
ylim([0.1 0.5])

e= errorbar(nanmean(sq(:,:)'), (stdev)*ones(size(nanmean(sq(:,:)'))))

xlim([1 17])% last ~isnan x data point
xticks(2:16)

title('Probability of Final Free Recall as a Function of Intervening Presented Items')
subtitle('Averaging Across Subject & Session')
ylabel('Probability of Final Free Recall')
xlabel('N Studied Items Between Presentation and Initial Retrieval ')

