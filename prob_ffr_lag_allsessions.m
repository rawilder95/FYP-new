
clear all;
close all;
addpath(genpath('/Users/rebeccawilder/First-Year-Project/'))
if ~strcmp(pwd, '/Users/rebeccawilder/Desktop/CMR/')
    cd ('/Users/rebeccawilder/Desktop/CMR/')
end 

cd('/Users/rebeccawilder/First-Year-Project')

%basic subfields
datafile= dir('*.mat');
load(datafile(2).name);
nsubj= unique(data.subject);
LL= data.listLength;
ifr_mask= make_clean_recalls_mask2d(data.recalls);
ppfr_mat= zeros(20,30,7,43);
nses= unique(data.session)
%Loop through subjects
for subj= 1:length(nsubj)
    %Loop through sessions
    for s= 1:7
        ifr_idx= data.session== nses(s) & data.subject== nsubj(subj);
        
        ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session == nses(s);
        
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
            lag_num= nan(30,1);
            lag_denom= nan(30,1);
            
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
                lag_denom(ifr_lag_max+1)= sum(sum(ifr_lag== ifr_lag_max));
            end 
               
            for ffr_lag_max= 0:max(max(ffr_lag))
                    lag_num(ffr_lag_max+1)= sum(sum(ffr_lag==ffr_lag_max));
            end
            
           
            pfr_mat(:,:,s,subj)= lag_num(1:20,:)./lag_denom(1:20,:);
          
        else
            
            pfr_mat(:,:,s,subj)= nan;

        end
            
            %We're only doing up to lag 20
            %make things 3 dim array take avg across subj and avg across
            %session
           
            
    end
    
    %c1(subj, s)= any(any(isinf(lag_num(1:20,:)./lag_denom(1:20,:))));
    %Look over by hand need to reshape by every 35 to take average of
    %sessions
   %pffr{subj}= cell2mat(session_i(~cellfun('isempty',session_i)));

    lag{subj,s}= ifr_lag;
    recall{subj,s}= ifr_lag;
end 

lag= cell2mat(lag(~cellfun('isempty',lag)));
recall= cell2mat(recall(~cellfun('isempty',recall)));


for ses_loop= 1:7
    for main_loop= 1:43 
        sq(1:20,ses_loop,main_loop)= pfr_mat(:,:,ses_loop,main_loop);
        
    end 
end 
stdev= std(nanmean(sq(:,:)'))/sqrt(length(nanmean(sq(:,:)')));
h1= plot(nanmean(sq(:,:)'), 'o-')
errorbar(nanmean(sq(:,:)'), (stdev)*ones(size(nanmean(sq(:,:)'))), '-o')
ylim([0.1 0.5])
xlim([1 20])
title('Probability FFR as a Function of Lag', 'FontSize', 20)
xlim([1 20])
ylim([0.1 0.75])
ylabel('Probability of FFR', 'FontSize', 15)
xlabel('Lag', 'FontSize', 15)
ax= gca;
ax.FontSize= 15

%%
% close all;
% plot(ifr_lag, ifr_recall, '*')
% xlabel('Lag')
% ylabel('Serial Position')
% heatmap(ifr_lag, ifr_recall)
% xlim([1 16])

rec_lag= table(recall, lag)
heatmap(recall, lag, rec_lag)
%%
load patients
tbl = table(LastName,Age,Gender,SelfAssessedHealthStatus,...
    Smoker,Weight,Location);
h = heatmap(tbl,'Smoker','SelfAssessedHealthStatus');