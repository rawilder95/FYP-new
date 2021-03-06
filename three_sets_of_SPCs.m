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


%% SPC FR Ignore IFR
close all
figure(1)
p_names= {'No NaNs', 'Low NaNs', 'Mid-High NaNs', 'High NaNs'};
plot(nanmean(low_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Ignore IFR Items')
xlabel('Serial Position')
ylabel('Probability')
hold on
plot(nanmean(lomid_nan), '-o')
hold on
plot(nanmean(himid_nan), '-o')
plot(nanmean(hi_nan), '-o')
legend(p_names, 'Location', 'se', 'FontSize', 12)
set(gca, 'FontSize', 14)
%%

rng(1)
s= rng;
close all;
figure(1)


subplot(2,2,1)
p1= plot(nanmean(low_nan), '-o')
p1.Color= rand([1,3])

ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('No NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,2)
p2= plot(nanmean(lomid_nan), '-o')
p2.Color= rand([1,3])
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('Mid-Low NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,3)
p3= plot(nanmean(himid_nan), '-o')
p3.Color= rand([1,3])
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition, Ignoring IFR')
subtitle('Mid-High NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,4)
p4= plot(nanmean(hi_nan), '-o')
p4.Color= rand([1,3])
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


%% Conditional IFR Items 
close all

p_names= {'No NaNs', 'Low NaNs', 'Mid-High NaNs', 'High NaNs'};
plot(nanmean(low_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR Items')
xlabel('Serial Position')
ylabel('Probability')
hold on
plot(nanmean(lomid_nan), '-o')
hold on
plot(nanmean(himid_nan), '-o')
plot(nanmean(hi_nan), '-o')
legend(p_names, 'Location', 'se')
set(gca, 'FontSize', 14)

%%
close all;
rng(1)
s= rng;
subplot(2,2,1)
p1= plot(nanmean(low_nan), '-o')
p1.Color= rand([1,3])
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('No NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,2)
p2= plot(nanmean(lomid_nan), '-o')
p2.Color= rand([1,3])
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('Mid-Low NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,3)
p3= plot(nanmean(himid_nan), '-o')
p3.Color= rand([1,3])
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Conditional on IFR')
subtitle('Mid-High NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,4)
p4= plot(nanmean(hi_nan), '-o')
p4.Color= rand([1,3])
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
                ifr_rn(ismember(presitemnos, wasit_rc))=nan;
                for i = 1:LL
                    sp_denom(i)= sum(sum(~isnan(ifr_rn(:,i))));
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
                ifr_rn(ismember(presitemnos, wasit_rc))=nan;
                for i = 1:LL
                    sp_denom1(i)= sum(sum(~isnan(ifr_rn(:,i))));
                    sp_num1(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
                low_nan{subj,ses}= sp_num1./sp_denom1;
              
%             Mid-Low NaNs    
            elseif all(lomid == ismember(nancat, this_nan)');
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))= nan;
                for i = 1:LL
                    sp_denom2(i)= sum(sum(~isnan(ifr_rn(:,i))));
                    sp_num2(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
              
                
                lomid_nan{subj,ses}= sp_num2./sp_denom2;
%             Mid-High NaNs     
            elseif all(himid == ismember(nancat, this_nan)');
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=nan;
                for i = 1:LL
                    sp_denom3(i)= sum(sum(~isnan(ifr_rn(:,i))));
                    sp_num3(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
                himid_nan{subj,ses}= sp_num3./sp_denom3;
                
%             High NaNs    
            elseif all(hi == ismember(nancat, this_nan)');
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
                ifr_rn= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=nan;
                for i = 1:LL
                    sp_denom4(i)= sum(sum(~isnan(ifr_rn(:,i))));
                    sp_num4(i)= sum(sum(ifr_rn(:,i)==1));
                end
                
                hi_nan{subj,ses}= sp_num4./sp_denom4;
%                 if any(any(isnan(recognized)))
%                     keyboard
%                 end 
               
            end 
        end 
    end 
end 

low_nan= cell2mat(low_nan(~cellfun('isempty', low_nan)));
lomid_nan= cell2mat(lomid_nan(~cellfun('isempty', lomid_nan)));
himid_nan= cell2mat(himid_nan(~cellfun('isempty', himid_nan)));
hi_nan= cell2mat(hi_nan(~cellfun('isempty', hi_nan)));
all_nan= cell2mat(all_nan(~cellfun('isempty', all_nan)));
%% Exclude IFR Overlayed
close all

p_names= {'No NaNs', 'Low NaNs', 'Mid-High NaNs', 'High NaNs'};
plot(nanmean(low_nan), '-o')
ylim([0.5 1])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
xlabel('Serial Position')
ylabel('Probability')
hold on
plot(nanmean(lomid_nan), '-o')
hold on
plot(nanmean(himid_nan), '-o')
plot(nanmean(hi_nan), '-o')
legend(p_names)
set(gca, 'FontSize', 14)

%% Plot No NaNs 
rng(2)
s= rng;
close all;
subplot(2,2,1)
plot(nanmean(low_nan), '-o')
p1.Color= rand([1,3])
ylim([0 1])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('No NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,2)
p1= plot(nanmean(lomid_nan), '-o')
p1.Color= rand([1,3])
ylim([0 1])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('Mid-Low NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,3)
p1= plot(nanmean(himid_nan), '-o')
p1.Color= rand([1,3])
ylim([0 1])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('Mid-High NaNs')
xlabel('Serial Position')
ylabel('Probability')

subplot(2,2,4)
p1= plot(nanmean(hi_nan), '-o')
p1.Color= rand([1,3])
ylim([0 1])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('High NaNs')
xlabel('Serial Position')
ylabel('Probability')

%% Plot All NaN
close all;
plot(nanmean(all_nan), '-o')
ylim([0 1])
xlim([1 LL])
title('SPC Final Recognition Exclude IFR Items')
subtitle('Not Conditional on NaN Count, Spot Checking Work')
xlabel('Serial Position')
ylabel('Probability')
%%
exclude_ifr= {};
include_ifr= {};
all_fr= {};
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
                
                ifr_nr= recognized;
%                 find presitemnos that match recalled items
%                 set those indices in ifr_rn to 0
                ifr_rn(ismember(presitemnos, wasit_rc))=0;
                ifr_nr(~ismember(presitemnos, wasit_rc))=0;
                for i = 1:LL
                    sp_denom(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num(i)= sum(sum(ifr_rn(:,i)==1));
                    sp_denom1(i)= sum(sum(~isnan(recognized(:,i))));
                    sp_num1(i)= sum(sum(ifr_rn(:,i)==0));
                    sp_denom2(i)= sum(~isnan(recognized(:,i)));
                    sp_num2(i)= sum(sum(recognized(:,i)==1));
                    
                   
                end
                exclude_ifr{subj,ses}= sp_num./sp_denom;
                include_ifr{subj,ses}= sp_num1./sp_denom1;
                all_fr{subj,ses}= sp_num2./sp_denom2;
                e_ifr= sp_num2./sp_denom2- sp_num./sp_denom;
            
        end 
    end 
end 


exclude_ifr= cell2mat(exclude_ifr(~cellfun('isempty', exclude_ifr)));
include_ifr= cell2mat(include_ifr(~cellfun('isempty', include_ifr)));
all_fr= cell2mat(all_fr(~cellfun('isempty', all_fr)));
close all;
p_names= {'FR Items Exclude IFR/ All FR', 'FR Items Conditional IFR/ All FR Items'}; 
plot(nanmean(exclude_ifr), '-o')
xlim([1 LL])
xticks([1:LL])
hold on 
plot(nanmean(include_ifr), '-o')
legend(p_names, 'Location', 's')
title('SPC FR: Conditional Numerators, Nonconditional Denominator')
%% 
close all;
plot(mean(all_fr), 'o-')
xlim([1 LL])
ylim([0 1])

%%
close all
p_names= {'Final Recognized Ignoring IFR', 'Exclude IFR + Include IFR'};
plot(mean(all_fr))
hold on
plot(mean(exclude_ifr+include_ifr))
ylim([0 1])

mean(all_fr)- mean(exclude_ifr- include_ifr);

close all
errorbar(mean(all_fr), (std(all_fr)).^2)
hold on
ylim([0 1])
xlim([1 LL])
mean_diff= mean(exclude_ifr+include_ifr);
errorbar(mean_diff, std(include_ifr+exclude_ifr).^2)
legend(p_names, 'Location', 'se')
title('Ignore IFR Condition vs Sum Conditional IFR Num')


%%
yes_recall= {};
no_recall = {};
all_recall= {};
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
            
            %Items that were recalled
           rec_mask1= make_clean_recalls_mask2d(recall);
           rec_mask1;
           
      
           %Items that were not recalled
           rec_mask2= recognized;
           recitemnos(ismember(recitemnos(rec_mask), presitemnos));
           
                %Something was recalled
                wasit_rc= recitemnos(recall~=0 & ~isnan(recall));
               
                %Initially recalled correctly and correctly recognized in
                %the numerator
                yes_rc= recognized;
                yes_rc(~ismember(presitemnos, wasit_rc))= 0;
                yes_rc(isnan(recognized))= nan;
                
                %Recalled as an Error
                %Recognized but not recalled 
                
                
%                 ifr_er= ~ismember(presitemnos,recitemnos) 
%                 rec_er= recognized;
%                 rec_er(~ismember(presitemnos,recitemnos))= 0;
                
                
                not_rc= recognized;
                not_rc(ismember(presitemnos, wasit_rc))= 0;
                not_rc(isnan(recognized))= nan;
                
                for i = 1:LL
                    
                    
                    sp_num1(i)= sum(sum(yes_rc(:,i)==1));
                    sp_denom1(i)= sum(~isnan(yes_rc(:,i)));
                    sp_num2(i)= sum(sum(not_rc(:,i)==1));
                    sp_denom2(i)= sum(~isnan(not_rc(:,i)));
                    
                    
                end 
                %conditional on recall
%                     yes_recall{subj,ses}= spc(recognized, data.subject(ifr_idx,:), LL, ismember(presitemnos, wasit_rc));
%                     no_recall{subj,ses}= spc(recognized, data.subject(ifr_idx,:), LL, ~ismember(presitemnos, wasit_rc));
%                     all_recall{subj,ses} =spc(recognized, data.subject(ifr_idx,:), LL);
%                     
                
        end 
    end 
end 

yes_recall= cell2mat(yes_recall(~cellfun('isempty', yes_recall)));
no_recall= cell2mat(no_recall(~cellfun('isempty', no_recall)));
all_recall= cell2mat(all_recall(~cellfun('isempty', all_recall)));

was_recalled= recognized;
was_recalled(yes_rc==0)= 0;
not_recalled= recognized;
not_recalled(not_rc==1)= nan;
close all;
% p= spc(yes_recall, subjects, LL);
ylim([0 1])
xlim([1 LL])