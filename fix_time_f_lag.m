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


%basic subfields
%datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
dfile= dir('*.mat')
%load(datafile);
load(dfile(2).name)
nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);


for subj= 1:length(nsubj)
    for ses= 1:length(unique(data.session))
        
        ifr_idx= data.subject== nsubj(subj) & data.session== ses;
        ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== ses;
        times= data.times(ifr_idx,:);
        rec_itemnos= data.rec_itemnos(ifr_idx, :);
        rec_itemnos(rec_itemnos<1)= nan;
        ffr_itemnos= data.ffr.rec_itemnos(ffr_idx,:);
        ffr_itemnos(ffr_itemnos<1)=nan;
        wasit_recalled= ismember(rec_itemnos, ffr_itemnos);
        rec_times= times;
        rec_times(~wasit_recalled)= 0;
        
        recall= data.recalls(ifr_idx,:);
       
        ifr_mask= make_clean_recalls_mask2d(recall);
       
        recall(~ifr_mask)=0;
       
%         j= histogram(recall, 'NumBins', LL+1, 'BinLimits', [1 LL]);
%         kv1= j.Values;
%         h= histogram(recall(wasit_recalled), 'NumBins', LL, 'BinLimits', [1 LL]);
%         kv2= h.Values;
%         which_subj{subj,ses}= data.subject(data.subject==nsubj(subj));
%         keep_vals{subj,ses}= kv2/16;
       
    end 
    if sum(sum(ifr_idx))>0
        all_times{subj,ses}= rec_times;
        pfr_all{subj,ses}= wasit_recalled;
        all_recall{subj,ses}= recall;
    end 
end 
all_times= all_times(~cellfun('isempty', all_times));
pfr_all= pfr_all(~cellfun('isempty', pfr_all));
all_recall= all_recall(~cellfun('isempty', all_recall));

all_recall= cell2mat(all_recall);
cell2mat(which_subj)

avg_times= mean(cell2mat(all_times));
avg_times(avg_times<=0)=nan;
avg_data= mean(cell2mat(pfr_all));
avg_data(avg_data<=0)=nan;
%%
close all
h= plot(avg_data, 'o-')
pfr_all= cell2mat(pfr_all);
std_pfr= std(std(pfr_all))/sqrt(length(mean(pfr_all)));
errorbar(mean(pfr_all), std_pfr/2*(ones(size(mean(pfr_all)))));
xlim([0 sum(sum(~isnan(avg_times)))])
xticks([0:2:sum(sum(~isnan(avg_times)))])
xticklabels(avg_times/100) %in seconds, because ms is tought to fit on x axis
title('Probability of Free Recall as a Function of Elapsed Time')
%In my notes I had that you wanted STD to reflect individual data points


%%

close all;


    [p_recalls] = spc(data.recalls, data.subject, LL);


std_recalls= std(mean(p_recalls))/sqrt(length(mean(p_recalls)));


plot(mean(p_recalls), '-o')
errorbar(mean(p_recalls), std_recalls/2*(ones(size(mean(p_recalls)))));
xlabel('Order of Items Presented');
ylabel('Probability of Initial Free Recall')
title('Serial Position Curve for Initial Free Recall Data')
xticks([1:16])
xlim([1 16])

close all;
plot(mean(pfr_all));


% plot(mean(recall))
%%
close all
% kv1= kv1(cellfun(@(kv1) length(kv1)>1, kv1));
% kv1= cell2mat(kv1)
% kv2= kv2(cellfun(@(kv2) length(kv2)>1, kv2));
% kv2= cell2mat(kv2)
if iscell(which_subj)
keep_vals= cell2mat(which_subj);
end 



[p_recalls] = spc(all_recall, which_subj, LL);

