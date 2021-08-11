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

ifr_sp= data;

this_ses = [];

ifr_op= [];

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
nses= unique(data.session);
nsubj= unique(ifr_sp.subject);
nses= unique(ifr_sp.session);
rec_mask_full= make_clean_recalls_mask2d(data.recalls);
data.recalls(~rec_mask_full)=0;

% Get NaN Categories Set Up
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
        if ~isempty(data.recalls(ifr_idx,:))
            recall= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:); 
%             Get the NaN categories for next for loop
            nnans(subj,ses)= sum(sum(isnan(recognized)));
        end 
    end 
end 

nancat= unique(nnans);



%% %%%%%%%%%%%%%%%%%%%%%%%  SPC Ignoring IFR  %%%%%%%%%%%%%%%%%%%%%%% %%
% Preset cells for different NaN Categories
low_nan= {};
lomid_nan= {};
himid_nan= {};
hi_nan= {};

lo= [1 0 0 0];
lomid= [0 1 0 0];
himid= [0 0 1 0];
hi= [0 0 0 1];
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
        if ~isempty(data.recalls(ifr_idx,:))
            recall= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:); 
            this_nan= sum(sum(isnan(recognized)));
%             Sort categories for subj/ses by ismember
            if all(lo == ismember(nancat, this_nan)');
                for i = 1:LL
                    sp_denom1(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num1(i)= sum(sum(recognized(:,i)== 1));
                end 
                low_nan{subj,ses}= sp_num1./sp_denom1;
                
            elseif all(lomid == ismember(nancat, this_nan)');
                for i = 1:LL
                    sp_denom2(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num2(i)= sum(sum(recognized(:,i)== 1));
                    
                end 
                lomid_nan{subj,ses}= sp_num2./sp_denom2;
                
            elseif all(himid == ismember(nancat, this_nan)');
                for i = 1:LL
                    sp_denom3(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num3(i)= sum(sum(recognized(:,i)== 1));
                end 
                himid_nan{subj,ses}= sp_num3./sp_denom3;
                
            elseif all(hi == ismember(nancat, this_nan)');
                for i = 1:LL
                    sp_denom4(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num4(i)= sum(sum(recognized(:,i)== 1));
                end 
                hi_nan{subj,ses}= sp_num4./sp_denom4;
            end 
        end 
    end 
end 

low_nan= cell2mat(low_nan(~cellfun('isempty', low_nan)));
lomid_nan= cell2mat(lomid_nan(~cellfun('isempty', lomid_nan)));
himid_nan= cell2mat(himid_nan(~cellfun('isempty', himid_nan)));
hi_nan= cell2mat(hi_nan(~cellfun('isempty', hi_nan)));

%% Plot No NaNs 
close all;
plot(nanmean(low_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('No NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Low NaN's 
close all;
plot(nanmean(lomid_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('Mid-Low NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Mid-Hi NaNs 
close all;
plot(nanmean(himid_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('Mid-High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Hi-NaNs
close all;
plot(nanmean(hi_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% %%%%%%%%%%%%%%%%%%%%%%%  SPC Conditional on IFR  %%%%%%%%%%%%%%%%%%%%%%% %%


% Preset cells for different NaN Categories
low_nan= {};
lomid_nan= {};
himid_nan= {};
hi_nan= {};

lo= [1 0 0 0];
lomid= [0 1 0 0];
himid= [0 0 1 0];
hi= [0 0 0 1];


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
            
            
%             Sort categories for subj/ses by ismember

%             No NaNs
            if all(lo == ismember(nancat, this_nan)');
                wasit_rn= presitemnos(recognized==0);
                ifr_rn= recall;
                ifr_rn(ismember(recitemnos, wasit_rn))=0;
                for i = 1:LL
                    sp_denom1(i)= sum(sum(recall==i));
                    sp_num1(i)= sum(sum(ifr_rn== i));
                end
                
                low_nan{subj,ses}= sp_num1./sp_denom1;
              
%             Mid-Low NaNs    
            elseif all(lomid == ismember(nancat, this_nan)');
                wasit_rn= presitemnos(recognized==0);
                ifr_rn= recall;
                ifr_rn(ismember(recitemnos, wasit_rn))=0;
                for i = 1:LL
                    sp_denom2(i)= sum(sum(recall==i));
                    sp_num2(i)= sum(sum(ifr_rn== i));
                end
                
                lomid_nan{subj,ses}= sp_num2./sp_denom2;
%             Mid-High NaNs     
            elseif all(himid == ismember(nancat, this_nan)');
                wasit_rn= presitemnos(recognized==0);
                ifr_rn= recall;
                ifr_rn(ismember(recitemnos, wasit_rn))=0;
                for i = 1:LL
                    sp_denom3(i)= sum(sum(recall==i));
                    sp_num3(i)= sum(sum(ifr_rn== i));
                end
                
                himid_nan{subj,ses}= sp_num3./sp_denom3;
                
%             High NaNs    
            elseif all(hi == ismember(nancat, this_nan)');
                wasit_rn= presitemnos(recognized==0);
                ifr_rn= recall;
                ifr_rn(ismember(recitemnos, wasit_rn))=0;
                for i = 1:LL
                    sp_denom4(i)= sum(sum(recall==i));
                    sp_num4(i)= sum(sum(ifr_rn== i));
                end
                
                hi_nan{subj,ses}= sp_num4./sp_denom4;
               
            end 
        end 
    end 
end 

low_nan= cell2mat(low_nan(~cellfun('isempty', low_nan)));
lomid_nan= cell2mat(lomid_nan(~cellfun('isempty', lomid_nan)));
himid_nan= cell2mat(himid_nan(~cellfun('isempty', himid_nan)));
hi_nan= cell2mat(hi_nan(~cellfun('isempty', hi_nan)));

%% Plot No NaNs 
close all;
plot(nanmean(low_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('No NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Low NaN's 
close all;
plot(nanmean(lomid_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('Mid-Low NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Mid-Hi NaNs 
close all;
plot(nanmean(himid_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('Mid-High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Hi-NaNs
close all;
plot(nanmean(hi_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% %%%%%%%%%%%%%%%%%%%%%%%  SPC Excluding IFR Items %%%%%%%%%%%%%%%%%%%%%%% %%


% Preset cells for different NaN Categories
low_nan= {};
lomid_nan= {};
himid_nan= {};
hi_nan= {};
%  Checking my calculation for all 
%  excluded items against previous code
all_nan= {};
lo= [1 0 0 0];
lomid= [0 1 0 0];
himid= [0 0 1 0];
hi= [0 0 0 1];


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
            
           
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=0;
                for i = 1:LL
                    sp_denom(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num(i)= sum(sum(ifr_rn(:,i)==1));
                end
                all_nan{subj,ses}= sp_num./sp_denom;
        
                
%             Sort categories for subj/ses by ismember

%             No NaNs
            if all(lo == ismember(nancat, this_nan)');
%                 recall ~= 0 --> that item was recalled, 
%                 barring items masked out from find_nan
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=0;
                for i = 1:LL
                    sp_denom1(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num1(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
                low_nan{subj,ses}= sp_num1./sp_denom1;
              
%             Mid-Low NaNs    
            elseif all(lomid == ismember(nancat, this_nan)');
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=0;
                for i = 1:LL
                    sp_denom2(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num2(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
              
                
                lomid_nan{subj,ses}= sp_num2./sp_denom2;
%             Mid-High NaNs     
            elseif all(himid == ismember(nancat, this_nan)');
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=0;
                for i = 1:LL
                    sp_denom3(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num3(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
                himid_nan{subj,ses}= sp_num3./sp_denom3;
                
%             High NaNs    
            elseif all(hi == ismember(nancat, this_nan)');
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=0;
                for i = 1:LL
                    sp_denom4(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num4(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
                hi_nan{subj,ses}= sp_num4./sp_denom4;
               
            end 
        end 
    end 
end 

low_nan= cell2mat(low_nan(~cellfun('isempty', low_nan)));
lomid_nan= cell2mat(lomid_nan(~cellfun('isempty', lomid_nan)));
himid_nan= cell2mat(himid_nan(~cellfun('isempty', himid_nan)));
hi_nan= cell2mat(hi_nan(~cellfun('isempty', hi_nan)));
all_nan= cell2mat(all_nan(~cellfun('isempty', all_nan)));

%% Plot No NaNs 
close all;
plot(nanmean(low_nan), '-o')
ylim([0 0.75])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('No NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Low NaN's 
close all;
plot(nanmean(lomid_nan), '-o')
ylim([0 0.75])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('Mid-Low NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Mid-Hi NaNs 
close all;
plot(nanmean(himid_nan), '-o')
ylim([0 0.75])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('Mid-High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot Hi-NaNs
close all;
plot(nanmean(hi_nan), '-o')
ylim([0 0.75])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot All NaN
close all;
plot(nanmean(all_nan), '-o')
ylim([0 0.75])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('Not Conditional on NaN Count, Spot Checking Work')
xlabel('Serial Position')
ylabel('Probability')
