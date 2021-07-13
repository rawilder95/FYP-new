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
    for ses= 1:7
        ifr_idx= data.subject==nsubj(subj) & data.session== ses;
        ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== ses;
        rec_itemnos= data.rec_itemnos(ifr_idx,:);
        rt= data.times(ifr_idx,:);
        ffr_itemnos= data.ffr.rec_itemnos(ffr_idx,:);
        ffr= ismember(rec_itemnos, ffr_itemnos);
        ffr_times= rt;
        ffr_times(~ffr)= 0;
    end 
    all_rt{subj,ses}= rt;
    all_ffr{subj,ses}=ffr_times;
    
    
end 

all_rt= cell2mat(all_rt(~cellfun('isempty',all_rt)));
all_ffr= cell2mat(all_ffr(~cellfun('isempty',all_ffr)));

all_rt(all_rt<1)= nan;
all_ffr(all_ffr<1)= nan;

[n1, e1, b1]= histcounts(all_rt, [0:500:10000,11000:2000:75000]);
[n2, e2, b2]= histcounts(all_ffr, [0:500:10000,11000:2000:75000]);
close all
k= n2./n1;

% No longer relevant-- was to check that the source of the 0 1 probabilities 
% find_idx1= find(k==0);
% find_idx2= find(k==1);
% [n1(find_idx1),n2(find_idx1)]
% [n1(find_idx2), n2(find_idx2)]


% Do ./ for each person within for loop and then take the average outside.
% Pretty similar code --> more just a theoretical principle.
% Couldn't take STD because data was parsed by subject
%Set Bin limits set edges 0:500:10000,11000:2000:75000 
plot(e1(2:end)/1000, n2./n1, 'o-')
xlim([0.5 max(e1/1000)])
xticks([(e1/1000)])
xlabel('Elapsed Response Time in Seconds')
ylabel('Probability of Final Free Recall')




