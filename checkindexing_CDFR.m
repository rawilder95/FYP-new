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

% two individual FFR sessions, and check that this lines up properly: 
% For the first few recalled items from each session, look at their serial positions in data.ffr
% For the same first few recalled items from the session, corresponding lists in data.ffr
% For each of those lists, pull out the distractor durations by looking at the corresponding data.pres fields
% Check if the output of your code lines up with the proper recalled serial positions, lists, and distractor indices
dist_spec= [];
all_data= [];
%%
nses= unique(data.session);
std_mat= zeros(size(data.recalls(data.subject== nsubj(1) & data.session== nses(1),:)));
for subj = 1
    for ses= 1:1
        
        ifr_idx= data.subject==nsubj(subj) & data.session== nses(ses);
        ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== nses(ses);
        if sum(sum(ifr_idx))==0
            continue
        else
            recalls= data.recalls(ifr_idx,:);
            rec_itemnos= data.rec_itemnos(ifr_idx,:);
            srecitemnos= rec_itemnos(1:5,1:5);
            srecalls= recalls(1:5,1:5);
            ffr= data.ffr.sp(ffr_idx,:);
            ffr(ffr<1)=nan;
            sffr= ffr(1,1:5);
            recalls(recalls<1)= nan;
            rec_itemnos(rec_itemnos<1)=nan;
           
            ffr_itemnos= data.ffr.rec_itemnos(ffr_idx, :);
            
            ffr_itemnos(ffr_itemnos<1)=nan;
            sffritemnos= ffr_itemnos(1,1:5);
            dc= ffr(ismember(ffr_itemnos, rec_itemnos(1:5,1:5)));
            
            
            
            ffr_list= data.ffr.list(ffr_idx,:);
            ffr_list(ffr_list<1)=nan;
            sffrlist= ffr_list(1,1:5);
            pres_recalled= data.pres.recalled(ifr_idx,:);
            sprecalled= pres_recalled(1:5,1:5);
            dist1= data.pres.distractor(ifr_idx,:);
            dist2= data.pres.final_distractor(ifr_idx,:);
            dist_cond= [dist1, dist2];
            
            
            
            
           
            
        end 
        
    end
    
    
    
 %Check variables for the each sub/session against all_data (big_matrix)
 %and make sure they're the same
    
%Calculate counts by hand for SP, Lag, OP compare that to wha 
% Nevermind this was actually fine
% Give it a week before looking at recognition data.
% If we don't look at regression data, it could just be a future idea -->
% something to include in later studies.  

% Final memory test spacing effect is stronger in recall versus recognition
% Some cases where session has FFR before final rec --> but we wouldn't
% look at those sessions, only sessions with just the final rec.  
% Spacing or lag effect whether it was FFR or Final Rec -- in recognition,
% not as tasking of a retrieval, spacing effect is stronger --> could
% possibly serve as explanation. 

% Goal was never to look at lag differently, checking other regressors to
% make sure effect in lag is actually implicated in spacing effect (not
% output position, sp etc.) 
% Talk about each of the variables I used as regressors --> what it is +
% hist of all items + IFR + IFR that was FFR only + tiny blurb about N
% intervening presented items (only do it with lags that are on top of
% each other).  


% When plotting for presentation do NOT use subplot, because plots are
% squished.  If you pull up all 5 regressors (across different conditions)
% y axis consistent across each analysis (but not for ffr). 

%Send Lynn revised writeups after looking at histograms in R





%           8000        8000
%            0        8000
%            0       16000
%         8000        8000
%            0           0
%            0        8000
%        16000       16000
%            0           0
%         8000        8000
%            0        8000
%        16000       16000
%            0       16000    
        
end 
%list1= CDFRs 4
%list2= DFRs 2
%list3= DFRl 3
%list4= CDFRs 4
%list5= IFRn 1
