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
datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
load(datafile);

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
nlists= unique(data.ffr.list(~isnan(data.ffr.list)));
nlists= nlists(nlists>0);
nses= unique(data.session);
recalls= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        ifr_idx= data.subject== nsubj(subj)& data.session== nses(ses);
       
        recall= data.recalls(ifr_idx,:);
        if ~isempty(recall)
         op= repmat(1:length(recall(1,:)), length(recall(:,1)));
         op(recall==0,:)=0;
        end 
        
        
    
    end 
    recalls{subj, ses}= recall;
    ops{subj,ses}= op;
end 
% recalls= recalls(~cellfun('isempty', recalls))
recalls= cell2mat(recalls);
ops= cell2mat(ops);
close all;
p_recalls= spc(data.recalls, data.subject, LL);
h= plot(mean(p_recalls), 'o-')
h.Parent.Parent.Color= 'w';
xlim([1 16])
ax= gca;
ax.FontSize= 15
title('Probability of Immediate Free Recall', 'FontSize', 20)
ylabel('Probability of Recall','FontSize', 15)
xlabel('Serial Position','FontSize', 15)
%%

close all;


 nlists= LL;
for i = 1:nlists
    pffr{i}= spc(data.ffr.sp, data.ffr.subject, LL, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/16, 16)
h1= plot(mean(pfr'), '-o')
xlim([1 length(pfr)])
ylim([0.15, 0.5])
h1.Parent.Parent.Color= 'w'
ax= gca;
ax.FontSize= 15
title('Probability of Final Free Recall', 'FontSize', 20)
ylabel('Probability of Recall','FontSize', 15)
xlabel('Serial Position','FontSize', 15)

%%
close all;
op= data.recalls;
op(data.recalls== 0)=0;
 nlists= LL;
for i = 1:nlists
    pffr{i}= spc(op, data.ffr.subject, LL, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/16, 16)
% op_recalls= spc(op, data.subject, LL);
% plot(mean(op_recalls))

%%











%% negative recency
nlists= LL
close all;
for i = 1:nlists
    pffr{i}= spc(data.ffr.op, data.ffr.subject, LL, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/LL, LL)
h1= plot(mean(pfr'), '-o')
xlim([1 length(pfr)])
ylim([0, 1])
h1.Parent.Parent.Color= 'w'
ax2= gca;
ax2.FontSize= 15
title('Probability of FFR ƒ OP', 'FontSize', 15)
ylabel('Probability of Recall','FontSize', 15)
xlabel('Output Position','FontSize', 15)

%%
rec_mask= make_clean_recalls_mask2d(data.recalls);
data.op= data.recalls
data.op= repmat(1:length(data.recalls(1,:)), 10992,1)
data.op(~rec_mask)=0
p= spc(data.ffr.op, data.ffr.subject, 20)
close all;
plot(mean(p))

%%
close all; 

nlists= 16;
for i = 1:nlists
    pffr{i}= spc(data.ffr.list, data.ffr.subject, LL, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);
pfr= reshape(pfr, length(pfr)/16, 16)

h1= plot(mean(pfr), '-o')
xlim([1 length(pfr)])
h1.Color= 'b'
ylim([0, 0.5])
h1.Parent.Parent.Color= 'w'
ax2= gca;
ax2.FontSize= 15
title('Probability of FFR ƒ OP', 'FontSize', 15)
ylabel('Probability of Recall','FontSize', 15)
xlabel('Output Position','FontSize', 15)





%%
p= spc(data.ffr.list, data.ffr.subject, LL)




 nlists= LL;
for i = 1:nlists
    pffr{i}= spc(data.ffr.list, data.ffr.subject, LL, data.ffr.recalled & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/16, 16)
close all;
plot(mean(pfr), 'o-')
xlim([1 16])
ylim([0 1])
xlabel('List Position')
ylabel('Probability of FFR')
title('Probability of FFR ƒ List')
ax3= gca  
ax3.FontSize= 15


%%
close all;
for i = 1:nlists
    pffr{i}= spc(data.ffr.sp, data.ffr.subject, LL, ones(size(data.ffr.sp)) & data.ffr.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/LL, LL)
h1= plot(mean(pfr'), '-o')
xlim([1 length(pfr)])
ylim([0, 1])
h1.Parent.Parent.Color= 'w'
ax2= gca;
ax2.FontSize= 15
title('Probability of FFR ƒ Serial Position', 'FontSize', 15)
ylabel('Probability of Recall','FontSize', 15)
xlabel('Serial Position','FontSize', 15)


%%
close all
pfc= pfr(data.recalls, data.subject, LL)
plot(mean(pfc), '-o')
xlim([1,16])
ax2= gca;
ax2.FontSize= 15
title('Probability of First Recall ƒ Serial Position', 'FontSize', 15)
ylabel('PFR','FontSize', 15)
xlabel('Serial Position','FontSize', 15)

