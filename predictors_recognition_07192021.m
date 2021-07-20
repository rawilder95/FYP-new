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
load('updated_peers_recognition.mat')
data= new_data;

ifr= data;

this_ses = [];

ifr_op= [];

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
nses= unique(data.session);
nsubj= unique(ifr.subject);
nses= unique(ifr.session);
rec_mask_full= make_clean_recalls_mask2d(data.recalls);
data.recalls(~rec_mask_full)=0;


for subj= 1:length(nsubj)
    for ses= 1:length(nses)
%         Set variables for nonempty sessions
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:))
           ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
           recall= data.recalls(ifr_idx,:);
           recognized= zeros(size(recall));
           recognized(:, 1:LL)= data.pres.recognized(ifr_idx,:);
           presitemnos= data.pres_itemnos(ifr_idx,:);
           recitemnos= data.rec_itemnos(ifr_idx,:);
           ifr_mask= ismember(recitemnos,presitemnos);
          
           find_nan= presitemnos(isnan(recognized));
           recitemnos(ismember(recitemnos, find_nan))= nan;
           sp= [];
           
           recall(isnan(recitemnos))= nan;
           for i = 1:LL
               sp(i)= sum(sum(recall==i));
               sp_rec(i)= sum(sum(recall(ifr_mask==1)==i));
               
           end 
        end
    end 
end 