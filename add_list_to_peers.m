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
load('data_PEERS1_ifr_frecog_e1_minop.mat')

ifr= data;

this_ses = [];

ifr_op= [];

% datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
% load(datafile);

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
% nlists= unique(data.ffr.list(~isnan(data.ffr.list)));
% nlists= nlists(nlists>0);
nses= unique(data.session);
nsubj= unique(ifr.subject);
nses= unique(ifr.session);
rec_mask_full= make_clean_recalls_mask2d(data.recalls);
data.recalls(~rec_mask_full)=0;
ifr_idx= [];
data.pres.list= zeros(size(data.pres.recognized));
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)))
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            list= data.pres.list(ifr_idx,:);
                    for i = 1:length(list(:,1))
                        list(i,:)= i;
                    end
                    data.pres.list(ifr_idx,:)= list;
        end 
                    
    end 
end 
            
            
data.pres.list(data.recalls(:,1:16)==0)=0;
data.pres.list(isnan(data.pres.recognized))= nan;


    savefile= 'updated_peers_recognition.mat';
    

    
    
    new_data= data
    
   
    save('updated_peers_recognition.mat', 'new_data')