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
datafile= 'data_PEERS1_ifr_ffr_e2_minop.mat';
load(datafile);

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
nlists= unique(data.ffr.list(~isnan(data.ffr.list)));
nlists= nlists(nlists>0);

ifr_mask= make_clean_recalls_mask2d(data.recalls);


cd('/Users/rebeccawilder/Desktop/CMR/behavioral_toolbox_release1.01/analyses')
[p_first_recall] = pfr(data.recalls, data.subject, LL)

close all;
plot(mean(p_first_recall), '-p')
title('Probability of First Recall')
subtitle('Computes recall probability by serial position for the first output position')
ylabel('Probability of First Recall')
xlabel('Serial Position')
xlim([1,LL])





%% calculate OP 
npfr= {}
close all
data.output= nan(size(data.recalls));
data.output= repmat(1:length(data.output(1,:)), length(data.recalls(:,1)), 1);
for i = 1:nlists
    pffr{i}= spc(data.ffr.op, data.ffr.subject, 26, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/26, 26)
%plot(mean(pfr'), '-o')
xlim([1 length(pfr)])
ylim([0.15, 0.5])
hold on
std_pfr= std(mean(pfr'))*mean(pfr')
e= errorbar(mean(pfr'), std_pfr);
e.Marker= 'o';
xlabel('Serial Position')
ylabel('Probability of FFR')
title('Probability of Final Free Recall Output')

data.output(data.recalls==0)=0;

% p = spc(data.output, data.subject, 26)
% p = mean(p)
% plot(p, '-o')
% 
% e= errorbar(1:26, p, abs(ones(size(p))*std(p)/sqrt(length(p))))
% 
% p2= spc(data.ffr.op, data.ffr.subject, LL)
% 
% npfr= cell2mat(npfr)
% 
% close all;
% plot(npfr)
