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
            
          find_int= [];
          %Items recalled as an error: Intrusions out of all recalled items
          

          find_int= intrusions>0;
          %Items that were recalled
          rec_mask1= make_clean_recalls_mask2d(recall);
          
          ifr_cond= ismember(presitemnos, recitemnos);
          ifr_cond(isnan(recognized))=0;
          for i = 1:LL
              nm1(i)= sum(sum(ifr_cond(:,i)==1 & find_int==0));
              dnm1(i)= sum(sum(~isnan(recognized(:,i))& find_int==0));
              
          end 
          
          include_ifr{subj,ses}= nm1./dnm1; 
          
          
          
          get_int= recognized;
          get_int(ismember(presitemnos, recitemnos))=0;
%           intitems= data.pres.intruded(ifr_idx,:);
%           
%           intitems(intitems<1)=nan;
%           get_intitemnos= recitemnos(ismember(recall,intitems));
%           rec_int= ismember(presitemnos, get_intitemnos);

          
          for i = 1:LL
              nm2(i)= sum(sum(find_int(:,i)==1 & recognized(:,i)== 1));
              dnm2(i)= sum(~isnan(recognized(:,i)) & find_int(:,i)==1);
          end
          
          ifr_aserror{subj,ses}= nm2./dnm2;
          
          
          %Exclude IFR: Only items that were not recalled initially
          no_ifr= ~ismember(presitemnos,recitemnos);
          no_ifr(isnan(recognized))=0;
%           no_ifr(recognized==0)=0;
          for i = 1:LL
              nm3(i)= sum(sum(no_ifr(:,i)==1 & find_int(:,i)==0));
              dnm3(i)= sum(sum(~isnan(recognized(:,i)) & find_int(:,i)== 0));
          end 
          exclude_ifr{subj,ses}= nm3./dnm3;
          
          
          % Add these values all together
          all_cond{subj,ses}= include_ifr{subj,ses}+ exclude_ifr{subj,ses};
          %- ifr_aserror{subj,ses};
        end 
    end 
end 

include_ifr= cell2mat(include_ifr(~cellfun('isempty', include_ifr)));
ifr_aserror= cell2mat(ifr_aserror(~cellfun('isempty', ifr_aserror)));
exclude_ifr= cell2mat(exclude_ifr(~cellfun('isempty', exclude_ifr)));
all_cond= cell2mat(all_cond(~cellfun('isempty', all_cond)));
ifr_aserror(isnan(ifr_aserror))=0;



%%
close all
pnames= {'Conditional on IFR', 'IFR Intrusions', 'Exclude IFR Items', 'All Conditions Combined'}
plot(mean(include_ifr), 'o-')
hold on

plot(mean(ifr_aserror), 'ro-')
hold on
plot(mean(exclude_ifr), 'o-')
hold on
plot(mean(all_cond), 'mo-' )

xlim([1 LL])
legend(pnames, 'location', 'bestoutside')





