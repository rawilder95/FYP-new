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
datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
% dfile= dir('*.mat')
load(datafile);
% load(dfile(3).name)
nsubj= unique(data.subject);
LL= data.listLength;


for subj = 1:length(nsubj)
    for ses= 1:unique(data.session)
        ifr_idx= data.subject==nsubj(subj) & data.session==ses;
        ffr_idx= data.ffr.subject==nsubj(subj) & data.ffr.session==ses;
        time= data.times(ifr_idx,:);
        recall= data.recalls(ifr_idx,:);
        rec_itemnos= data.rec_itemnos(ifr_idx,:);
        rec_itemnos(rec_itemnos<1)=nan;
        wasit_recalled= ismember(rec_itemnos, data.ffr.rec_itemnos(ffr_idx,:));
        ifr= zeros(size(recall));
        ifr(recall>0)= 1;
        submat= zeros(size(recall(:,1)));
        submat(:,:)= nsubj(subj);
        time(~wasit_recalled)=0;
        all_times{subj,ses}= time;
        all_recalls{subj,ses}= wasit_recalled;
        all_ifr{subj,ses}= ifr;
        subcell{subj,ses}= submat;
        
    end 
end 
all_times= cell2mat(all_times(~cellfun('isempty', all_times)));
all_recalls= cell2mat(all_recalls(~cellfun('isempty', all_recalls)));
all_ifr= cell2mat(all_ifr(~cellfun('isempty', all_ifr)));
subcell= cell2mat(subcell(~cellfun('isempty', subcell)));
%%
close all

% plot(mean(all_times), mean(all_recalls)./mean(all_ifr));
%pfr= spc(wasit_recalled, data.subject(data.subject==nsubj(subj) & data.session==ses), LL)

% pfr= spc(all_recalls, subcell, LL);
% tfr= spc(all_times, subcell, LL);
pfr= pfr(pfr>0);
mean(all_recalls);
  all_times(all_times<1)= nan;


h= histogram(all_times/1000);
keep_vals= h.Values; 
keep_data= h.Data;
keep_bins= h.BinEdges;

% sum(sum(all_times==unat(1)))


%If it was repeated or intruded between when it was IFR and FFR --> take
%out all occurances of repeats, including initial 
%Figure out from hist bins, pull out 10 items --> get proportion of (ifr &
%ffr)/ (all ifr)
%Check histcounts use


%For each bin you want to figure out was it FFR ---> take proportion 
%Num is going to be wasit_recalled
m= keep_data(~isnan(keep_data));
a= all_times(~isnan(all_times));
isequal(a, m);
plot(keep_bins(2:end),keep_vals/length(keep_data), 'o-')
xlim([keep_bins(2), keep_bins(end)])
xlabel('Elapsed Time')
ylabel('Probability of FFR')
title('Probability of FFR as a Function of Response Times')
%%

%look at all the RTs
at_wir= all_times;
at_wir(~all_recalls)= 0; %Mask out anything that wasn't FFR

[n,edges, bins]= histcounts(at_wir);
[n2,edges2, bins2]= histcounts(all_times);

close all
plot(edges(1:end-1)/1000,n./n2, 'o-')
xlim([0 75])
xticks([0:5:75])

xlabel('Elapsed Time in Seconds')
ylabel('Probability of Final Free Recall')

