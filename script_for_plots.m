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
datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
load(datafile)
nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
%%
%basic subfields
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
       
        recall(~wasit_recalled)= 0;
        
%         dist_cond= data.pres.distractor(ifr_idx,:);
%             dist_dur= data.pres.final_distractor(ifr_idx,:);
%             
%             for dist_idx = 1:length(dist_dur)
%                 if dist_cond(dist_idx)== 0
%                     dist_spec(dist_idx)= 1;
%                 elseif dist_cond(dist_idx)== 8000 & dist_dur(dist_idx)== 8000
%                     dist_spec(dist_idx)= 2;
%                 elseif dist_cond(dist_idx)== 8000 & dist_dur(dist_idx)== 16000
%                     dist_spec(dist_idx)= 3;
%                 elseif dist_cond(dist_idx)== 16000 & dist_dur(dist_idx)== 8000
%                     dist_spec(dist_idx)= 4;
%                 elseif dist_cond(dist_idx)== 16000 & dist_dur(dist_idx)== 16000
%                     dist_spec(dist_idx)= 5;
% 
%                 end 
            end 
%             dist_id{subj, ses}= dist_spec;
 
       
    end 

       
 
 


[p_recalls]= spc(data.recalls, data.subject , LL);

close all

plot(mean(p_recalls))



% plot(mean(rec_toplot), '-o')
std_rtp= std(std(p_recalls))./mean(p_recalls)/2;
e= errorbar(mean(p_recalls), std_rtp);
e.Marker= 'o'
xlim([1 16])
xticks([1:16])
ylabel('Probability IFR')
xlabel('Serial Position')
title('Probability of Immediate Free Recall')




%%
plot(mean(p_recalls), 'o-')
xlabel('Serial Position')
ylabel('Probability of Final Free Recall')

title('Probability of Final Free Recall as a Function of Serial Position')


%%
close all;
histogram(data.ffr.sp(data.ffr.recalled), 'NumBins', 16)
xlim([1 16])
xlabel('Serial Position')
ylabel('Probability of Final Free Recall')

%%
close all;
wasit_recalled= data.ffr.sp;
wasit_recalled(wasit_recalled<1)=0;
% pfr= spc(data.ffr.list==1, data.ffr.subject, LL);
% plot(pfr)

% data.ffr.sp(data.ffr.sp<1)=nan;
% 
% h= histogram(data.ffr.sp)
% keep_vals= h.Values
% close all
% 
% 
% h= hist(data.ffr.sp, numel(unique(data.ffr.sp)));
% 
% 
% 
pffr= {};

% list= data.ffr.list(~isnan(data.ffr.list) & data.ffr.list>0)
% for i = 1:length(unique(list))
%     
% end 


 nlists= LL;
for i = 1:nlists
    pffr{i}= spc(data.ffr.sp, data.ffr.subject, LL, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/16, 16)
%plot(mean(pfr'), '-o')
xlim([1 length(pfr)])
ylim([0.15, 0.5])
hold on
std_pfr= std(mean(pfr'))*mean(pfr')
e= errorbar(mean(pfr'), std_pfr);
e.Marker= 'o';
xlabel('Serial Position')
ylabel('Probability of FFR')
title('Probability of Final Free Recall SPC')
ax2= gca;
ax2.FontSize= 15

%%
close all;
rec_mask= make_clean_recalls_mask2d(data.recalls);
rec_mask(:,1:15) = 0;

p= data.recalls;
pfc= spc(data.recalls, data.subject, LL, rec_mask)

plot(mean(pfc))

