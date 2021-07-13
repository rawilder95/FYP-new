warning("OFF")
clc;
clear;
close all;
target_dir= '/Users/rebeccawilder/First-Year-Project';
current_dir= pwd;
if ~strcmp(current_dir, target_dir)
    cd(target_dir)
end
addpath(genpath(target_dir))
   
% %this is actually important
addpath(genpath('/Users/rebeccawilder/Desktop/CMR/'))
% if ~strcmp(pwd, '/Users/rebeccawilder/Desktop/CMR/')
%     cd ('/Users/rebeccawilder/Desktop/CMR/')
% end 
counter= 0;

%basic subfields
load('data_PEERS1_ifr_ffr_e1_minop.mat')

ifr= data;

this_ses = [];



%%
% datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
% load(datafile);

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
nlists= unique(data.ffr.list(~isnan(data.ffr.list)));
nlists= nlists(nlists>0);
nses= unique(data.session)
nsubj= unique(ifr.subject)
nses= unique(ifr.session)

% for i = 1:length(unique(ifr.subject))
%     for j = 1:length(ses)
%         idx= data.subject== i & data.session==j;
%         if ~isempty data.recall(idx,:)
%             which_ses =  unique(data.session)
%         end 
%     end 
% end 

     which_ses= {} 
for i = 1:length(nsubj)
    if isempty(ifr.recalls(ifr.subject==nsubj(i),:))
        continue
    else
        which_ses{i}= [unique(ifr.session(ifr.subject==nsubj(i),:))'];
    
    end 
end 
    
which_ses= which_ses(~cellfun('isempty', which_ses))
ifr_mask= make_clean_recalls_mask2d(data.recalls);


dist_spec= [];
all_data= [];
nses= unique(data.session);
std_mat= zeros(size(data.recalls(data.subject== nsubj(1) & data.session== nses(1),:)));
for subj = 1:length(nsubj)
    for ses= 1:7
        
        ifr_idx= data.subject==nsubj(subj) & data.session== nses(ses);
        if ~isempty(data.recalls(ifr_idx,:))

        
           %One distractor per list
           % Assigning one distractor to entire session may account for why
           % all conditions look similar and the recency in DFR.
           %Look at actual Matrix in all_data with hists.
            %Set up serial position col:
            %correct numel and correct num of NaNs
            ifr_sp= data.recalls(ifr_idx,:);
            k= ifr_sp;
            
            %this is separate from ifr_sp for debugging, because ifr_sp is
            %reshaped
            recall= ifr_sp;
            recall(recall<1)=nan;
            
           
            rec_mask= ifr_sp>0; %mask for intrusions and misses
            ifr_sp(~rec_mask)=nan;
            ifr_sp= reshape(ifr_sp', numel(ifr_sp),1);
            %ifr_sp= ifr_sp(~isnan(ifr_sp));
            
            %Set up output position col:
            %correct numel and correct num of NaNs 
            ifr_op= std_mat;
            for i = 1:length(ifr_op(1,:))
                
                ifr_op(:,i)= i;
            end
            
            ifr_op(~rec_mask)=nan;
            ifr_op= reshape(ifr_op', numel(ifr_op),1);
            %ifr_op= ifr_op(~isnan(ifr_op));
            
            
            %Set up CDFR and DFR col: 
            %1= IFR, 2= DFR short, 3= DFR long, 4= CDFR short, 5 = CDFR
            %long
            
         %dist_cond= [data.pres.distractor(ifr_idx,:), data.pres.final_distractor(ifr_idx,:)];
            
            
            % Column 1 0-0: IFR: 1, Column 2: 0
            % Column 1 0-8: DFR: 2, Column 2: 8
            % Column 1 0-16: DFR: 3, Column 2: 16
            % Column 1 8-8: CDFR: 4, Column 2: 0
            % Column 1 16-16: CDFR: 5, Column 2: 8
             
%             dist_col= nan(size(recall));
%             for dist_idx = 1:length(nlists)
%                 if dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)==0
%                     dist_col(dist_idx,:)= 1;
%                 elseif dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)== 8000
%                     dist_col(dist_idx,:)= 2;
%                 elseif dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)== 16000
%                     dist_col(dist_idx,:)= 3; %dfr long
%                 elseif dist_cond(dist_idx,1)== 8000 & dist_cond(dist_idx,2)== 8000
%                     dist_col(dist_idx,:)= 4; %cdfr short
%                 elseif dist_cond(dist_idx,1)== 16000 & dist_cond(dist_idx,2)== 16000
%                     dist_col(dist_idx,:)= 5; %cdfr long
%                 end 
%             end
%      
%             dist_col(isnan(recall))=nan;
%              dist_col= reshape( dist_col', numel( dist_col),1);
% 
%             for dist_idx= 1:length(dist_cond(:,1))
%                 if dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)==0
%                     dist_col(dist_idx,1)= 1; %ifr
%                 elseif dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)== 8000
%                     dist_col(dist_idx,1)= 2; %dfr short
%                 elseif dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)== 16000
%                     dist_col(dist_idx,1)= 3; %dfr long
%                 elseif dist_cond(dist_idx,1)== 8000 & dist_cond(dist_idx,2)== 8000
%                     dist_col(dist_idx,1)= 4; %cdfr short
%                 elseif dist_cond(dist_idx,1)== 16000 & dist_cond(dist_idx,2)== 16000
%                     dist_col(dist_idx,1)= 5; %dfr short
%                 else
%                     dist_cond(dist_idx,:);
%                 end 
%                 dist_col;
%             end 
% %             
%             
% 0+0= 0 IFR
% 0+8= 8 DFR short
% 0+16= 16 DFR long
% 8 + 8= 16 CDFR short
% 16+ 16= CDFR long



            %Set up response times col: 
            %correct numel and correct num of NaNs 
            ifr_rt= data.times(ifr_idx,:);
            ifr_rt(~rec_mask)=nan;
            ifr_rt= reshape(ifr_rt', numel(ifr_rt),1);
            %ifr_rt= ifr_rt(~isnan(ifr_rt));
%             counter= [];
%             dist_bet= nan(size(ifr_rt));
%             for dist_count = 0:length(ifr_rt)/12:length(dist_bet)-26
%                 counter= [counter, dist_count];
%                 if dist_count == 0
%                     dist_bet(dist_count+1:dist_count+1+26-1)= dist_col(dist_count+1);
%                 else
%                     dist_bet(dist_count:dist_count+26)= dist_col(dist_count/26);
%                 end 
%             end 
          
            ifr_lag= [];
            %Set up lag col (actual lag spacing)
            for i = 1:length(recall(1,:))
                ifr_lag(:,i)= LL-recall(:,i)+i-1;
            end 
            ifr_lag(isnan(recall))=nan;
            ifr_lag= reshape(ifr_lag', numel(ifr_lag),1);
            %ifr_lag= ifr_lag(~isnan(ifr_lag));
            
            
            %Set up subjects ID col: 
            ifr_subj= nan(size(ifr_sp));
            ifr_subj(:,:)= nsubj(subj);
            
            %Set up session ID col: 
            ifr_ses= zeros(size(ifr_sp));
            ifr_ses(:,:)= ses;
            ifr_ses(~rec_mask)= nan;
            %Set up list ID col:
            %correct numel and correct num of NaNs
            ifr_list= std_mat;
            for i = 1:length(ifr_list(:,1))
                ifr_list(i,:)= i;
            end
           
            
            ifr_list(~rec_mask)= nan;
            ifr_list= reshape(ifr_list', numel(ifr_list),1);
            %ifr_list= ifr_list(~isnan(ifr_list));
            
            
            
            %Set up rec itemnos ID col:
            %correct numel and correct num of NaNs
            ifr_itemnos= data.rec_itemnos(ifr_idx,:);
            ifr_itemnos(~rec_mask)=nan;
            %This is also for debugging
            rec_itemnos= ifr_itemnos;
            
            ifr_itemnos= reshape(ifr_itemnos', numel(ifr_itemnos),1);
            %ifr_itemnos= ifr_itemnos(~isnan(ifr_itemnos));
            
            %Find out which ifr lags were ffr
            ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== nses(ses);
            ffr_itemnos= data.ffr.rec_itemnos(ffr_idx,:);
            ffr_lag= ismember(ifr_itemnos, ffr_itemnos);
            ffr_sp= data.ffr.recalled(ffr_idx,:);
            
         mask_idx= ismember(ifr_itemnos, ffr_itemnos);
         ffr_intv= ifr_lag;
         ffr_intv(~mask_idx)= nan;
         
         ifr_subj(isnan(ifr_rt))=nan;
         
         dist_col(isnan(ifr_rt))= nan;
         ffr= ffr_lag;
         ffr= ffr(~isnan(ifr_rt));
%          
         ifr_subj= ifr_subj(~isnan(ifr_subj));
         ifr_ses= ifr_ses(~isnan(ifr_ses));
         ifr_list= ifr_list(~isnan(ifr_list));
         ifr_itemnos= ifr_itemnos(~isnan(ifr_itemnos));
         ifr_rt= ifr_rt(~isnan(ifr_rt));
         ifr_sp= ifr_sp(~isnan(ifr_sp));
         ifr_op= ifr_op(~isnan(ifr_op));
         ifr_lag= ifr_lag(~isnan(ifr_lag));
         ffr_lag= ffr_lag(~isnan(ffr_lag));
%          dist_col= dist_col(~isnan(dist_col));
         
         

%             
%             if ~isequal(size(ifr_sp), size(ndist))
%                 disp('not equal')
%             end 
            %     dist_id{subj, ses}= dist_spec;
%          
%                 
            all_data{subj, ses}= [ifr_subj, ifr_ses, ifr_list, ifr_itemnos, ifr_rt, ifr_sp, ifr_op, ifr_lag, ffr];
            %ffr_data{subj, ses}= [ffr_sp, ffr_op, ffr_intv];
            %each subj-ses combination should have 141 indices to start,
            %however, with nans 
           

            %For pulling single sample subject/ses
%             if subj== 1 & ses==1
%                 sample1= [ifr_subj, ifr_ses, ifr_list, ifr_itemnos, ifr_rt, ifr_sp, ifr_op, ifr_lag, ffr_lag, ndist];
%             else
%                 continue
%             end
        end 
    end 

            
        
end 
    
all_data= all_data(~cellfun('isempty', all_data));
all_data= cell2mat(all_data);

% this_data= all_data(~isnan(all_data),:)
%This is to get items that were both IFR/FFR
% all_data= all_data(all_data(:,end-1)==1,:)


%% Saving Output
%name file something similar to output function
%if statement for if file exists warning about over-writing if it does
    
   

    savefile= 'newdata.csv';
    

    
    
    %savefile2= [savefile, ".csv"]
    
   
    dlmwrite(savefile, all_data)
    %dlmwrite(savefile2, ffr_data)




%%
close all
figure(1)
% DFR Short
dfrs= all_data(all_data(:,end)==2, :);
dfrl= all_data(all_data(:,end)==3, :);
% CDFR Short
cdfrs= all_data(all_data(:,end)==4, :);
cdfrl= all_data(all_data(:,end)==5, :);


% subplot(4,1,1)
h= histogram(dfrs(:,6));
h.Font
% title('Delayed Free Recall SP')
% ylim([0 2000])
% subplot(4,1,2)
% histogram(dfrs(:,7))
% title('Delayed Free Recall OP')
% subplot(4,1,3)
% histogram(dfrs(:,8))
% title('Delayed Free Recall Lag')
% subplot(4,1,4)
% histogram(dfrs(:,5))
% title('Delayed Free Recall RT')

% figure(3)
% subplot(4,1,1)
% histogram(dfrl(:,6))
% title('Delayed Free Recall Long SP')
% ylim([0 2000])
% subplot(4,1,2)
% histogram(dfrl(:,7))
% title('Delayed Free Recall Long OP')
% subplot(4,1,3)
% histogram(dfrl(:,8))
% title('Delayed Free Recall Long Lag')
% subplot(4,1,4)
% histogram(dfrl(:,5))
% title('Delayed Free Recall Long RT')


figure(2)
subplot(4,1,1)
histogram(cdfrs(:,6))
title('CDFR SP')
subplot(4,1,2)
histogram(cdfrs(:,7))
title('CDFR OP')
subplot(4,1,3)
histogram(cdfrs(:,8))
title('CDFR Lag')
subplot(4,1,4)
histogram(cdfrs(:,5))
title('CDFR RT')



% close all;
% subplot(2,1,1)
% histogram(all_data(all_data(:,end)==2,7))
% subplot(2,1,2)
% histogram(all_data(all_data(:,end)==4,7))
%%
close all;
h= histogram(cdfrs(:,6))
getvals= h.Values



%%
close all;
wasit_recalled= all_data(:,end);
dfr= all_data(wasit_recalled==2 | wasit_recalled== 3,:)
h= histogram(all_data(:,7))
h.BinEdges= [1:26]


%%
rng(1);
seed= rng;
k= norm(1, 3000)
p= fitdist(k, 'logistic', ffr_lag)
