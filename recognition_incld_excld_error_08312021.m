warning("OFF")
clc;
clear all;
close all;
target_dir= '/Users/rebeccawilder/FYP-New';
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
load('updated_peers_recognition.mat');
data= new_data;

nsubj= unique(data.subject);
LL= data.listLength;

nses= unique(data.session);

% rec_mask_full= make_clean_recalls_mask2d(data.recalls);
% data.recalls(~rec_mask_full)=0;

recalls= {};
include_ifr= {};
ifr_aserror = {};
exclude_ifr= {};
subjects= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
        if ~isempty(data.recalls(ifr_idx,:))
            recall= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:); 
            this_nan= sum(sum(isnan(recognized)));
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            find_nan= presitemnos(isnan(recognized));
            recall(ismember(recitemnos,find_nan))= nan;
            intrusions= data.pres.intruded(ifr_idx,:);
            %mask out non-tested items
            recitemnos(ismember(recitemnos, presitemnos(isnan(recognized))))= nan;
            
            %Find the intrusions
            find_int= intrusions>1;
            
            %Recognition for IFR Items
            ifr_cond= ismember(presitemnos,recitemnos);
            for i = 1:LL
                incld_num(i)= sum(sum(ifr_cond(:,i)==1 & find_int(:,i)==0));
                incld_denom(i)= sum(sum(~isnan(ifr_cond(:,i))));
            end 
            include_ifr{subj,ses}= incld_num./incld_denom;
            
            
            

            %Recognition for Non-IFR Items Only, No Intrusions
            exc_cond= ~ismember(presitemnos,recitemnos);
            for i = 1:LL
                excld_num(i)= sum(sum(exc_cond(:,i)==1 & find_int(:,i)==0));
                excld_denom(i)= sum(sum(~isnan(exc_cond(:,i))));
            end 
            exclude_ifr{subj,ses}= excld_num./excld_denom;
            
            
            %Recognition for Errors Only
            for i = 1:LL
                err_num(i)= sum(sum(recognized==1 & find_int(:,i)==1));
                err_denom(i)= sum(sum(~isnan(recognized(:,i))));
            end 
            ifr_aserror{subj,ses}= err_num./err_denom;
            
            
            
        end 
    end 
end 

include_ifr= cell2mat(include_ifr(~cellfun('isempty', include_ifr)));
ifr_aserror= cell2mat(ifr_aserror(~cellfun('isempty', ifr_aserror)));
exclude_ifr= cell2mat(exclude_ifr(~cellfun('isempty', exclude_ifr)));

ifr_aserror(isnan(ifr_aserror))=0;

mean(exclude_ifr+include_ifr-ifr_aserror)
