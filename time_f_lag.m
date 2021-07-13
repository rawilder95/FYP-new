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
if ~strcmp(pwd, '/Users/rebeccawilder/Desktop/CMR/')
    cd ('/Users/rebeccawilder/Desktop/CMR/')
end 


%basic subfields
datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
load(datafile);
nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
ifr_mask= make_clean_recalls_mask2d(data.recalls);

%% Elapsed Response Time by OP (Replacing IRT Calculation)
temp_idx= cell(length(nsubj), length(unique(data.session)));
%can't actually take this because non-recalled items have no recorded rt's.
%for multiple missing, successive values, you cannot just assume the rt for the
%missing value and therefore cannot take the difference between successive
%previous times and current time.  
temp_idx= [];
for subj= 1:length(nsubj)
    for ses= 1:length(unique(data.session))
    data_idx= data.subject== nsubj(subj) & data.session== ses;
    
    if sum(sum(data_idx))<1
        
        continue
        
    else
        temp_idx= data.times(data_idx, :);
         temp_idx(~ifr_mask(data_idx,:))=nan;
        irt_idx{subj,ses}=temp_idx;
    end
    
    end
end


 irt_idx= irt_idx(~cellfun('isempty',irt_idx));
 temp_idx= temp_idx/1000;
 for i = 1:length(temp_idx(:,1))
     counter= 0;
     for j = 1:length(temp_idx(1,:))
         k(i,j)= temp_idx(i,j)- counter;
         counter= counter+temp_idx(i,j);
        
     end 
 end 



%% Elapsed Response Times by Output
   close all;
    temp_idx= irt_idx(~cellfun('isempty',irt_idx));

 for i = 1:56
     for j = 1:length(temp_idx)
         by_op= temp_idx{j}; %sort rt's by op
         
         all_time{j,i}= by_op(:,i);
     end
 end
 
rt_op= cell2mat(all_time)

  plot(nanmean(rt_op)/1000,1:56, '-o')
  

   %ylim([1,25])
   xlim([1,sum(sum(~isnan(nanmean(rt_op))))])
   errorbar(nanmean(rt_op), nanstd(rt_op))
   ylabel('Elapsed Time (in secs)')
   xlabel('Output Position')
   title('Temporal Spacing as a Function of Output Position')
  
   
   
   %% Final Free Recall as a Function of Response Time
   
   rt_pfr= cell(size(temp_idx));
   pfr= cell(size(temp_idx));
   for subj= 1:length(nsubj)
    for ses= 1:length(unique(data.session))
    data_idx= data.subject== nsubj(subj) & data.session== ses;
    rec_idx= data.rec_itemnos(data_idx,:);
    rec_idx(rec_idx<1)= nan;
    ffr_idx= data.ffr.rec_itemnos(subj,:);
    ffr_idx(ffr_idx<1)= nan;
    if ~sum(sum(data_idx))<1
        temp_idx= data.times(data_idx, :);
        rec_idx(temp_idx>0);
        temp_mask= ismember(rec_idx, ffr_idx);
        temp_idx(~temp_mask)= nan; %IFR time for FFR successfully recalled items
        

       
        
        
        

        
    end
    
    
    end
    rt_pfr{subj,ses}= temp_idx;
    
   end
   
close all
   rt_pfr= rt_pfr(~cellfun('isempty',rt_pfr));
   
   
   %probability of final free recall as a function of response times. This
   %looks at it in context of IFR not FFR. Look into this. 
   rt_pfr= cell2mat(rt_pfr);
%    pfr= zeros(size(rt_pfr));
%    pfr(~isnan(rt_pfr))=1;
%    rt_pfr= rt_pfr/1000;
%    rt_pfr= nanmean(rt_pfr)
%    pfr1= mean(pfr);
%    pfr1(pfr1<=0)= nan;
%    
%    plot(pfr1, '-o')
% 
%    xticklabels(round(rt_pfr, 1))
%    xlabel('Elapsed Recall Time in Seconds')
%    ylabel('Probability of Final Free Recall')
%    title('Probability of Final Free Recall as a Function of Recall Time')
  


%% Debugging to see why PFR values so low
% times= data.times;
% pfr= zeros(size(times));
% 
% rec_itemnos= data.rec_itemnos;
% ffr_itemnos= data.ffr.rec_itemnos;
% 
% ffr_mask= data.ffr.recalled;
% ffr_itemnos(~ffr_mask)= nan;
% rec_itemnos(rec_itemnos<1)= nan;
% rec_itemnos(~ffr_mask)= nan;
% 
% rec_itemnos(~ismember(rec_itemnos, ffr_itemnos) & ~isnan(rec_itemnos))= nan;
% times(isnan(rec_itemnos))= nan;
% 
% pfr(~isnan(rec_itemnos))= 1; 
% pfr= nanmean(pfr);
% times= nanmean(times);
% times(isnan(times))=0;
% 
% 
% close all;
%    
%    plot(pfr(1:20))
%    xlim([1 20])
pfr= [];
times= [];
rec_itemnos= [];
ffr_itemnos= [];
for subj= 1:length(nsubj)
    for ses= 1:length(unique(data.session))
        ifr_idx= data.subject== nsubj(subj) & data.session== ses;
        times{subj,ses}= data.times(ifr_idx,:);
        ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== ses;
        pfr_idx= data.ffr.sp(ffr_idx,:);
        pfr_idx(pfr_idx>=1)=1;
        pfr{subj,ses}= pfr_idx;
        rec_itemnos{subj,ses}= data.rec_itemnos;
        ffr_itemnos{subj,ses}= data.ffr.rec_itemnos;
        
    end 
end 
pfr= pfr(~cellfun('isempty', pfr));
pfr= cell2mat(pfr);
times= times(~cellfun('isempty', times));

mean(pfr)

