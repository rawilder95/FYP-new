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

%% Probability Final Recognition ƒ Serial Position & List
% Disregard IFR
sp_prob= {};
list_prob= {};
lag_prob= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
%         Set variables for nonempty sessions
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:))
           ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
           recall= data.recalls(ifr_idx,:);
           
           recognized= data.pres.recognized(ifr_idx,:);
           presitemnos= data.pres_itemnos(ifr_idx,:);
           recitemnos= data.rec_itemnos(ifr_idx,:);
           ifr_mask= ismember(recitemnos,presitemnos);
           %Find the NaNs in presitemnos from recognized
           find_nan= presitemnos(isnan(recognized));
           recitemnos(ismember(recitemnos, find_nan))= nan;
           recall(isnan(recitemnos))= nan;
           presitemnos(isnan(recognized))= nan;
%            presitemnos(recognized==0)= -1;
%            get serial position denominator
           for i = 1:length(recognized(1,:))
               sp_denom(i)= nansum(recognized(:,i));
           end 
           
%             get list position denominator
           for i = 1:length(recognized(:,1))
               list_denom(i)= nansum(recognized(i,:));
           end 
           recog_mask= ismember(presitemnos, recitemnos);
           ifr_recog= recognized;
           ifr_recog(~recog_mask)= 0;
           recall_mask= ismember(recitemnos, presitemnos);
           
%            get serial position numerator
            for i = 1:length(recognized(1,:))
                sp_num(i)= sum(nansum(recognized(:,i)));
            end 
            
%            get lag position numerator
            for i = 1:length(recognized(:,1))
                list_num(i)= sum(nansum(recognized));
            end 

           sp_prob{subj,ses}= sp_num./sp_denom;
           list_prob{subj,ses}= list_num./list_denom;
           
           %set op and lag variables
           op= repmat(1:length(recall), [length(recall(:,1)),1]);
           op(isnan(recall))= nan;
           op(recall==0)= 0;
           st_lag= LL- recall+op-1;
           st_lag(isnan(recall))= nan;
           st_lag(recall==0)= 0;
           frec_lag= st_lag;
           frec_lag(~recall_mask)=inf;
           frec_lag(recall== 0)= 0;
           frec_lag(isnan(recall))=nan;
           if any(any(isnan(recognized)))
               break
           end 
          
           %get lag denominator

           

        end
    end 
end 

sp_prob= cell2mat(sp_prob(~cellfun('isempty', sp_prob)));
list_prob= cell2mat(list_prob(~cellfun('isempty', list_prob)));
lag_prob= cell2mat(lag_prob(~cellfun('isempty', lag_prob)));
%% Plotting Figures Final Recognition Probability Only

figure(4)

subplot(2,1,1)
plot(nanmean(sp_prob), 'o-');
xlim([1 LL])
ylim([0.5 1])
title('Final Recognition ƒ Serial Position') 
subtitle('Disregard IFR')
ylabel('Probability')
xlabel('Serial Position')

subplot(2,1,2)
xlim([1 LL])
plot(nanmean(list_prob), 'o-');
xlim([1 LL])
ylim([0.5 1])
title('Final Recognition ƒ List') 
subtitle('Disregard IFR')
ylabel('Probability')
xlabel('List')
%% Just in case a baseline clear all
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
%% FFR
lag_prop= {};
op_prop= {};
list_prop= {};
sp_prop= {};
sp_ifr= {};
op_ifr= {};
list_ifr= {};
lag_ifr= {};
lag_fr= {};
op_fr= {};
list_fr= {};
sp_fr= {};
sp_ifr_fr= {};


for subj= 1:length(nsubj)
    for ses= 1:length(nses)
%         Set variables for nonempty sessions
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:))
           ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
           recall= zeros(LL, 30);
           recall(:,1:28)= data.recalls(ifr_idx,:);
           
           recognized= data.pres.recognized(ifr_idx,:);
           presitemnos= data.pres_itemnos(ifr_idx,:);
           
           recitemnos= data.rec_itemnos(ifr_idx,:);
%            Set up OP variable
           
           op= repmat(1:length(recall(1,:)), [LL,1]);
           op(recall==0)=0;
           
%            Set up list variable
           list= zeros(size(recall));
           for i = 1:LL
               list(i,:)=i;
           end 
           list(recall==0)=0;
               


%            Set lag variable
           st_lag= [];
           st_lag= LL- recall+op-1;
           st_lag(recall==0)= nan;
%            Mask out items not tested in Final Recognition
           pres_nan= presitemnos(isnan(recognized)); %Same as find_nan
           presitemnos(ismember(presitemnos, pres_nan))= nan; %mask in presitemnos
           recitemnos(ismember(recitemnos, pres_nan))= nan; %mask in recitemnos
           % ^ the above line is indexing by the value of the itemnos not
           % the location within the matrix.  
           
           recall(isnan(recitemnos))= nan; %Mask out by index in recitemnos matrix
           st_lag(isnan(recitemnos))= nan; %Mask out non-FR items for st_lag
           pres_fr= presitemnos(recognized==0); %Make presitemnos var where recognized==0 is masked out as NaN
           
           %instead of masking out by presitemnos(isnan(recognized))
           %I'm grabbing the numbers of the items and saying ~not these
           %itemnos.  It looks similar but it's not the same thing. 
           ifr_mask= ismember(recitemnos, pres_fr);
           fr_lag= st_lag;
           fr_lag(ifr_mask)= nan;
           op(isnan(recitemnos))= nan;
           list(isnan(recitemnos))= nan;
           fr_list= list;
           fr_list(ifr_mask==1)=nan;
           fr_op= op;
           fr_op(ifr_mask==1)=nan;
           fr_sp= recall;
           fr_sp(ifr_mask==1)= nan;
           
           
           lag_denom= zeros(1, 21);
           
           lag_num= zeros(1, 21);
           for i = 1:30
               lag_denom(i)= sum(sum(st_lag== i-1));
               lag_num(i)= sum(sum(fr_lag==i-1));
           end 
           
           for i = 1:23
               op_denom(i)= sum(sum(op==i));
               op_num(i)= sum(sum(fr_op==i));
               
           end 
           list_denom= zeros(1,LL);
           for i = 1:LL
               list_denom(i)= sum(sum(list==i));
               list_num(i)= sum(sum(fr_list==i));
           end 
           
           sp_denom= zeros(1,LL);
           sp_num= zeros(1,LL);
           
           for i = 1:LL
               sp_denom(i)= sum(sum(recall== i));
               sp_num(i)= sum(sum(fr_sp==i));
           end 
          
           for i = 1:LL
               
           end 
           lag_prop{subj,ses}= lag_num./lag_denom;
           op_prop{subj,ses}= op_num./op_denom;
           list_prop{subj,ses}= list_num./list_denom;
           sp_ifr_fr{subj,ses}= sp_num./sp_denom;
           sp_prop{subj,ses}= sp_num./sp_denom;
           sp_ifr{subj,ses}= recall;
           op_ifr{subj,ses}= op;
           list_ifr{subj,ses}= list;
           lag_ifr{subj,ses}= st_lag;
           lag_fr{subj, ses}= fr_lag;
           op_fr{subj, ses}= fr_op;
           list_fr{subj,ses}= fr_list;
           sp_fr{subj,ses}= fr_sp;
           
           
        end 
    end 
end 

lag_prop= cell2mat(lag_prop(~cellfun('isempty', lag_prop)));
op_prop= cell2mat(op_prop(~cellfun('isempty', op_prop)));
list_prop= cell2mat(list_prop(~cellfun('isempty', list_prop)));
sp_prop= cell2mat(sp_prop(~cellfun('isempty', sp_prop)));
sp_ifr= cell2mat(sp_ifr(~cellfun('isempty', sp_ifr)));
op_ifr= cell2mat(op_ifr(~cellfun('isempty', op_ifr)));
list_ifr= cell2mat(list_ifr(~cellfun('isempty', list_ifr)));
lag_ifr= cell2mat(lag_ifr(~cellfun('isempty', lag_ifr)));
sp_fr= cell2mat(sp_fr(~cellfun('isempty', sp_fr)));
op_fr= cell2mat(op_fr(~cellfun('isempty', op_fr)));
list_fr= cell2mat(list_fr(~cellfun('isempty', list_fr)));
lag_fr= cell2mat(lag_fr(~cellfun('isempty', lag_fr)));
sp_ifr_fr= cell2mat(sp_ifr_fr(~cellfun('isempty', sp_ifr_fr)));


 

%% Plot Study-Test Lag 
% Numerator= IFR and Final Recognized
% Denominator= IFR and Tested in FR
close all;
plot(nanmean(lag_prop), 'o-')
xlim([1,31])
xticks([1:31])
xticklabels(0:30)
xlabel('Study-Test Lag')
ylabel('Probability')
title('Probability of Final Recognition ƒ Study-Test Lag')
ylim([0.75,1])
saveas(gcf, 'output', 'fig')
%% Plot Output 
% Numerator= IFR and Final Recognized
% Denominator= IFR and Tested in FR
close all;
plot(nanmean(op_prop), 'o-')
xlim([1,LL])
xticks([1:LL])
xticklabels(1:LL)
xlabel('Output Position')
ylabel('Probability')
title('Probability of Final Recognition ƒ Output Position')
ylim([0.75,1])
%% Plot List

% Numerator= IFR and Final Recognized
% Denominator= IFR and Tested in FR
close all;
plot(nanmean(list_prop), 'o-')
xlim([1,LL])
xticks([1:LL])
xticklabels(1:LL)
xlabel('List Position')
ylabel('Probability')
title('Probability of Final Recognition ƒ List Position')
ylim([0.75,1])

%% Plot Serial Position
% Numerator= IFR and Final Recognized
% Denominator= IFR and Tested in FR
% close all;
figure(3)

plot(nanmean(sp_ifr_fr), 'o-')
xlim([1,LL])
xticks([1:LL])
xticklabels(1:LL)
xlabel('Serial Position')
ylabel('Probability')
title('Probability of Final Recognition ƒ Serial Position')
ylim([0.75, 1])
%% Lag IFR Histogram

close all;
subplot(2,1,1)
histogram(lag_ifr)
xlim([1,31])
xticks([1:31])
xticklabels(0:30)
xlabel('Study-Test Lag')
ylabel('Frequency')
title('Histogram of IFR Study-Test Lag Values')
subtitle('IFR Items Tested in Final Recognition')
ylim([0 7000])

subplot(2,1,2)
histogram(lag_fr)
xlim([1,31])
xticks([1:31])
xticklabels(0:30)
xlabel('Study-Test Lag')
ylabel('Frequency')
title('Histogram of IFR and Recognized Study-Test Lag Values')

ylim([0 7000])
% They look close but if you click on the values they're different
%% OP IFR Histogram

close all;
subplot(2,1,1)
op_ifr(op_ifr==0)=nan;
histogram(op_ifr)
xlim([1,LL])
xticks([1:LL])

xlabel('Output Position')
ylabel('Frequency')
title('Histogram of Output Position Values')
subtitle('IFR Items Tested in Final Recognition')
ylim([0 8000])

subplot(2,1,2)
op_ifr(op_fr==0)=nan;
histogram(op_fr)
xlim([1,LL])
xticks([1:LL])

xlabel('Output Position')
ylabel('Frequency')
title('Histogram of Output Position Values That Were Final Recognized')

ylim([0 8000])




%% List IFR Histogram

close all;
subplot(2,1,1)
% list_ifr(list_ifr==0)=nan;
histogram(list_ifr)
xlim([1,LL])
xticks([1:LL])
xlabel('List Position')
ylabel('Frequency')
title('Histogram of List Position Values')
subtitle('IFR Items Tested in Final Recognition')
ylim([0 7000])
subplot(2,1,2)

% list_ifr(list_ifr==0)=nan;
histogram(list_fr)
xlim([1,LL])
xticks([1:LL])
xlabel('List Position')
ylabel('Frequency')
title('Histogram of List Position Values That Were Final Recognized')

ylim([0 7000])

%% SP IFR Histogram

close all;
subplot(2,1,1)
histogram(sp_ifr)
xlim([1,LL])
xticks([1:LL])

xlabel('Serial Position')
ylabel('Frequency')
title('Histogram of Serial Position Values')
subtitle('IFR Items Tested in Final Recognition')
ylim([0 7000])

subplot(2,1,2)
histogram(sp_ifr)
xlim([1,LL])
xticks([1:LL])

xlabel('Serial Position')
ylabel('Frequency')
title('Histogram of Serial Position Values That Were Final Recognized')
subtitle('IFR Items Tested in Final Recognition')
ylim([0 7000])

%% Serial Position Curve For Items That Are Correctly Recognized at SP 12

% Serial position curve for proportion of items which 
% are correctly recognized (at eg SP 12), out of items 
% which are immediately free recalled (at eg SP 12) 
% and tested in recognition (at eg SP 12)


sp12_prop= {};
sp_prop= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)));
        ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
        recall= data.recalls(ifr_idx,:);
        presitemnos= data.pres_itemnos(ifr_idx,:);
        recitemnos= data.rec_itemnos(ifr_idx,:);
        recognized= data.pres.recognized(ifr_idx,:);
        fr12= nansum(recognized(:,12));
        find_nan= presitemnos(isnan(recognized));%37 of items not tested in final recognition
        recitemnos(ismember(recitemnos, find_nan))= nan; %Mask out in recitemnos
        not_fr= presitemnos(recognized==0); %Get the presitemnos
        recitemnos(ismember(recitemnos, not_fr))= nan; %Match the itemnos and mask out in recitemnos
        %Find items that were not recognized
        
        recall(isnan(recitemnos))=nan;
        %Everything necessary is masked out beforehand
        for i = 1:LL
            ifr_sp(i)= sum(sum(recall== i));
            fr(i)= nansum(recognized(:,i));
        end 
        ifr12= sum(sum(recall==12));
        sp_prop{subj,ses}= ifr_sp./fr;
        sp12_prop{subj,ses}= ifr12/fr12;
        end
        
    end 
end 

sp12_prop= cell2mat(sp12_prop(~cellfun('isempty', sp12_prop)));
sp_prop= cell2mat(sp_prop(~cellfun('isempty', sp_prop)));
nanmean(sp12_prop)
nanmean(sp_prop)
close all
p= plot(nanmean(sp_prop), '-o');
xlim([1 LL])
title('Serial Position Proportion IFR & FFR')
hold on;
plot(12,nanmean(sp12_prop), 'r*' )
xlabel('Serial Position')
ylabel('Probability')
legend({'SP Prop All', 'SP Prop 12'})

%% Predictors for Recognition Matrix
all_recognized= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)));
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recall= data.recalls(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            recitemnos= data.rec_itemnos(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:);
            find_nan= presitemnos(isnan(recognized));%37 of items not tested in final recognition
            recitemnos(ismember(recitemnos, find_nan))= nan; %Mask out in recitemnos
            not_fr= presitemnos(recognized==0); %Get the presitemnos
            not_ifr= recitemnos(recall==0);
            %Find items that were not recognized
            recall(isnan(recitemnos))=nan;
            recall(recall==0)= inf;
            recitemnos(isinf(recall))=inf;
            
            op= repmat(1:length(recall(1,:)), [16,1]);
            op(recall== inf)= inf;%Because we can't set this to zero or NaN
            list= zeros(size(recall));
            for i = 1:LL
                list(i,:)= i;
            end 
            list(recall==inf)= inf;
            list(isnan(recall))= nan;
            st_lag= LL- recall+op-1;
            st_lag(recall==inf)=inf; 
            subject= zeros(size(recall));
            subject(:,:)= unique(data.subject(ifr_idx,:));
%             subject(recall==inf)=inf;
            session= zeros(size(recall));
            session(:,:)= unique(data.session(ifr_idx,:));
%             session(recall==inf)=inf;
            sp_all= recall(ismember(recitemnos,presitemnos));
            op_all= op(ismember(recitemnos,presitemnos));
            stlag_all= st_lag(ismember(recitemnos,presitemnos));
            list_all= list(ismember(recitemnos,presitemnos));
            subject_all= subject(ismember(recitemnos, presitemnos));
            session_all= session(ismember(recitemnos,presitemnos));
            recognized_all= recognized(ismember(presitemnos,recitemnos));
            all_recognized{subj,ses}= [subject_all, session_all, sp_all, op_all, stlag_all, list_all, recognized_all];
            if any(any(isnan(recognized)))
%                 keyboard
            end 
            
        end 
    end 
end 

all_recognized= cell2mat(all_recognized(~cellfun('isempty', all_recognized)));

savefile= 'recognition_mat_7212021.csv';
    dlmwrite(savefile, all_recognized)
%% Past Attempts. Ignore.
%I'm leaving this hear temporarily, just in case. 


% %   % Redoing SP and List Recognition Only
% % 
% %   
% %   sp= [];
% %   list= [];
% %   
% %   sp_prop= {};
% %   list_prop= {};
% %   
% % for subj= 1:length(nsubj)
% %     for ses= 1:length(nses)
% %         if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:))
% %             ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
% %             recognized= data.pres.recognized(ifr_idx,:);
% %             
% %             for i = 1:LL
% %                 sp(i)= sum(nansum(recognized(:,i)))/(LL- sum(sum(isnan(recognized(:,i)))));
% %                 list(i)= sum(nansum(recognized(i,:)))/(LL- sum(sum(isnan(recognized(i,:)))));
% %             end 
% %         end 
% %         sp_prop{subj,ses}= sp;
% %         list_prop{subj,ses}= list;
% % 
% %         
% %         
% %         
% %         
% %         
% %     end 
% % end 
% % sp_prop= cell2mat(sp_prop(~cellfun('isempty', sp_prop)));
% % list_prop= cell2mat(list_prop(~cellfun('isempty', list_prop)));
% % 
% % close all;
% % subplot(2,1,1)
% % p1= plot(mean(sp_prop), 'o-')
% % p1.Color= [0 0.5 1]
% % ylim([0.75,1])
% % xlim([1,LL])
% % title('Probability of Recognition (SP)')
% % subtitle('Replicated Original Recognition SP')
% % xlabel('Serial Position')
% % ylabel('Probability')
% % 
% % colormap(pink)
% % subplot(2,1,2)
% % p2= plot(mean(list_prop), 'o-')
% % p2.Color= [0.9 0 0.9]
% % ylabel('Probability')
% % ylim([0.75, 1])
% % title('Probability of Recognition (List)')
% % subtitle('Replicated Original Recognition List')
% % xlabel('List')
% % xlim([1, LL])
% % %
% % 
% % sp2= [];
% % sp_ifr_fr= {};
% % for subj= 1:length(nsubj)
% %     for ses= 1:length(nses)
% %         
% %         ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
% %         if sum(ifr_idx)~=0
% %         recall= data.recalls(ifr_idx,:);
% %         recognized= data.pres.recognized(ifr_idx,:);
% %         presitemnos= data.pres_itemnos(ifr_idx,:);
% %         recitemnos= data.rec_itemnos(ifr_idx,:);
% %         
% %         
% %         find_nan= presitemnos(isnan(recognized));
% %         recall(ismember(recitemnos, find_nan))= nan;
% %         recitemnos(isnan(recall))=nan;
% %         was_recalled= ismember(presitemnos(~isnan(recognized)),recitemnos);
% %         
% %         ifr_fr= recognized;
% %         ifr_fr(~was_recalled)= 0;
% %         
% %         
% %         
% %         sp1= [];
% %         sp2= [];
% %         for i = 1:LL
% %             sp1(i)= sum(sum(recall==i));
% %             sp2(i)= nansum(ifr_fr(:,i));
% %         end
% %         sp_ifr_fr{subj,ses}= sp2./sp1;
% %         
% %         end
% %         
% %         
% %         
% %        
% %     end 
% % 
% %         
% % end 
% % 
% % sp_ifr_fr= cell2mat(sp_ifr_fr(~cellfun('isempty', sp_ifr_fr)));
% % 
% % close all;
% % plot(nanmean(sp_ifr_fr))
% % 
% % 
% % %
% % % Going through and trying to find where code breaks
% % 
% % sp2= [];
% % sp_ifr_fr= {};
% % for subj= 1:length(nsubj)
% %     for ses= 1:length(nses)
% %         
% %         ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
% %         if sum(ifr_idx)~=0
% %         recall= data.recalls(ifr_idx,:);
% %         recognized= data.pres.recognized(ifr_idx,:);
% %         presitemnos= data.pres_itemnos(ifr_idx,:);
% %         recitemnos= data.rec_itemnos(ifr_idx,:);
% %         
% %         
% %         This should be masking out correctly but the count is still off
% % e.g subject 63 session 4
% %         find_nan= presitemnos(isnan(recognized)); %find the not tested in recognition items
% %         recall(ismember(recitemnos, find_nan))= nan; %find the itemnos that match find_nan and set them to NaN in recall
% %         
% %         was_recalled= ismember(presitemnos(~isnan(recognized) & recognized>0),recitemnos); %Of tested recognition items, which were recalled during IFR
% %         
% %         ifr_fr= recognized;
% %         ifr_fr(~ismember(presitemnos, recitemnos))=0;
% %         Just tried it out, does not work.
% %         ifr_fr= ismember(recitemnos, presitemnos(~isnan(recognized))) 
% %         for i = 1:LL
% %             sp1(i)= sum(sum(was_it_recog(:,1))); % how many IFR items presented in SP(i)?
% %             sp2(i)= nansum(ifr_fr(:,i)); %SP= col for FR, how many IFR and FR items recognized in SP(i)?
% %         end 
% %         if any(any(isinf(sp2./sp1)))
% %             keyboard
% %         end 
% %         
% %         was_it_recog= ismember(recitemnos,presitemnos)
% % 
% %         Subject 84, Session 7, List 11, SP 7 is not getting masked out
% %         for some reason in final recognition.  
% %         sp_ifr_fr{subj,ses}= sp2./sp1;
% %         if any(any(isinf(sp_ifr_fr{subj,ses})))
% %             keyboard
% %             sp_ifr_fr{subj,ses}(isinf(sp_ifr_fr{subj,ses}))=nan;
% %         end 
% %             
% %         end 
% %        
% %     end 
% % 
% %         
% % end 
% % 
% % sp_ifr_fr= cell2mat(sp_ifr_fr(~cellfun('isempty', sp_ifr_fr)));
% % 
% % close all;
% % plot(nanmean(sp_ifr_fr))

%% Start Here For Running (IFR & FR) ÷ IFR, Recognition Predictors
sp_ifr_fr= {};
list_ifr_fr= {};
op_ifr_fr= {};
lag_ifr_fr= {};
sp_12= {};
all_recognized= {};
op_getdenom= {};
op_getnum= {};



for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)))
            recall= [];
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recall= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            recitemnos= data.rec_itemnos(ifr_idx,:);
            op= repmat(1:length(recall(1,:)), [LL 1]);
            op(recall==0)=0;
            lag= LL- recall+op-1;
%             Set lag to inf because it can't be NaN or 0 
            lag(recall==0)= inf;
    %         Manually create list var
            list = zeros(size(recall));
            for i= 1:LL
                list(i,:)= i;
            end 
            list(recall==0)=0;
    %         Mask out all of the items not tested in FR
            pres_nan= presitemnos(isnan(recognized));
            recall(ismember(recitemnos, pres_nan))= nan;
            op(isnan(recall))=nan;
            list(isnan(recall))=nan;
    %         The var 'ifr_fr' refers to sp ifr_fr.  
            ifr_fr= recall;
            wasnot_recog= ismember(recitemnos,presitemnos(recognized==0));
            ifr_fr(wasnot_recog)= 0;
            op_fr= op;
            op_fr(wasnot_recog)= 0;
            list_fr= list;
            list_fr(wasnot_recog)= 0;
            lag_fr= lag;
            lag_fr(wasnot_recog)= inf;
            
            
            for i = 1:LL
                sp_denom(i)= sum(sum(recall==i));
                sp_num(i)= sum(sum(ifr_fr==i));
                list_denom(i)= sum(sum(list==i));
                list_num(i)= sum(sum(list_fr==i));
            end 
            
            for i= 1:LL+4
                op_denom(i)= sum(sum(op==i));
                op_num(i)= sum(sum(op_fr==i));
            end 
            
            for i = 1:30
                lag_denom(i)= sum(sum(lag==i-1));
                lag_num(i)= sum(sum(lag_fr==i-1));
            end 
    %       Set recognition matrix to size(recall)
            recog= zeros(size(recall));
            recog(:,1:LL)= recognized;
            if ~isempty(recog(ismember(recitemnos, presitemnos(isnan(recognized)))))
                recog(ismember(recitemnos, presitemnos(isnan(recognized))))= inf;
            end 

    %        
            %Reshape predictors the way it was done in IFR FR models
            recall= reshape(recall', numel(recall), 1);
            op= reshape(op', numel(recall), 1);
            lag= reshape(lag', numel(lag), 1);
            lag(isinf(lag))= nan; 
            %Change it back to NaN because non tested items
            %have already been removed.

            list= reshape(list', numel(list), 1);
            subject= recall;
            subject(:,1)= nsubj(subj);
            session= recall;
            session(:,1)= nses(ses);
            recog= reshape(recog', numel(recog), 1);






            sp_all= recall(recall>0 & ~isnan(recog));
            op_all = op(recall>0 & ~isnan(recog));
            list_all= list(recall>0 & ~isnan(recog));
            lag_all= lag(recall>0 & ~isnan(recog));
            subject_all= subject(recall>0 & ~isnan(recog));
            session_all= session(recall>0 & ~isnan(recog));
            recog_all= recog(recall>0 & ~isnan(recog));
            sp_ifr_fr{subj,ses}= sp_num./sp_denom;
            list_ifr_fr{subj,ses}= list_num./list_denom;
            op_ifr_fr{subj,ses}= op_num./op_denom;
            lag_ifr_fr{subj,ses}= lag_num./lag_denom;
            sp_12{subj,ses}= sp_num(12)./sp_denom(12);
            all_recognized{subj,ses}= [subject_all, session_all, sp_all, op_all, list_all, lag_all, recog_all];
            op_getdenom{subj,ses}= op_denom;
            op_getnum{subj,ses}= op_num;
            
        end 

        
        
        
        
    end 
end 
sp_ifr_fr= cell2mat(sp_ifr_fr(~cellfun('isempty', sp_ifr_fr)));
list_ifr_fr= cell2mat(list_ifr_fr(~cellfun('isempty', list_ifr_fr)));
op_ifr_fr= cell2mat(op_ifr_fr(~cellfun('isempty', op_ifr_fr)));
lag_ifr_fr= cell2mat(lag_ifr_fr(~cellfun('isempty', lag_ifr_fr)));
sp_12= cell2mat(sp_12(~cellfun('isempty', sp_12)));
op_getdenom= cell2mat(op_getdenom(~cellfun('isempty', op_getdenom)));
op_getnum= cell2mat(op_getnum(~cellfun('isempty', op_getnum)));

% Save Data
all_recognized= cell2mat(all_recognized(~cellfun('isempty', all_recognized)));
savefile= 'recognition_mat_7212021.csv';
    dlmwrite(savefile, all_recognized)
%% Plot SP IFR & FR/ IFR
close all;
plot(nanmean(sp_ifr_fr), 'o-')
hold on
plot(12, nanmean(sp_12), 'r*')
xlim([1 LL])
ylim([0 1])
xlabel('Serial Position')
ylabel('Probability of FR')
title('Probability of Final Recognition ƒ Serial Position')
legend({'ALL SP', 'SP 12'}, 'Location', 'se')
%% Plot List IFR & FR / IFR

close all; 
plot(nanmean(list_ifr_fr), 'o-')
xlim([1 LL])
ylim([0.75 1])
xlabel('List')
ylabel('Probability of FR')
title('Probability of Final Recognition ƒ List')

%% Plot OP IFR & FR / IFR

close all;

plot(nanmean(op_ifr_fr), 'o-')
xlim([1 20])
ylim([0.75 1])
xlabel('Output Position')
ylabel('Probability of FR')
title('Probability of Final Recognition ƒ Output Position')
hold on
plot(15, nanmean(op_getnum(:,15)./op_getdenom(:,15)), 'r*')
hold on
plot(16, nanmean(op_getnum(:,16)./op_getdenom(:,16)), 'g*')
hold on
plot(17, nanmean(op_getnum(:,17)./op_getdenom(:,17)), 'b*')
legend({'Output Position Curve', 'Prob OP 15', 'Prob OP 16','Prob OP 17'}, 'Location', 'SE')

%% Plot Lag IFR & FR/ IFR
close all;

plot(nanmean(lag_ifr_fr), 'o-')
ylim([0.75 1])
xlim([1 30])
xticks(1:2:30)
xticklabels(0:2:30)
xlabel('Study-Test Lag')
ylabel('Probability of FR')
title('Probability of Final Recognition ƒ Study-Test Lag')


%% Probability of FR ƒ SP and List **NOT IFR Items**
% sum(sum(FR_only(:,1))./FR_only(:,1)
nifr_sp= {};
nifr_list= {};
ifr_sp= {};
ifr_list= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)))
            recall= [];
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recall= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:);
            list = zeros(size(recall));
            for i= 1:LL
                list(i,:)= i;
            end 
            list(recall==0)=0;
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            %Find rec_itemnos for IFR items
            was_recalled= recitemnos(recitemnos>0);
            %Match the pres_itemnos that match IFR rec_itemnos
            recognized2= recognized;
%             recognized2(~ismember(presitemnos, was_recalled))=nan;
            %If an item was recalled and is in presitemnos, set it to NaN
            recognized2(ismember(presitemnos, was_recalled))= nan;
            for i = 1:LL
                fr_num_sp(i)= sum(sum(recognized2(:,i)==1));
                %Denominator taken out of all possible opportunities i.e.
                %~isnan(recognition(:,i)) that an item in that SP could
                %have been recalled
                fr_denom_sp(i)= sum(sum(~isnan(recognized2(:,i))));
                fr_num_list(i)= sum(sum(recognized2(i,:)==1));
                fr_denom_list(i)= sum(sum(~isnan(recognized(i,:))));
                ifr_num_sp(i)= sum(sum(recall== i));
                ifr_denom_sp(i)= LL;
               
            
%                 ifr_num_list(i)= sum(nansum(recognized2(i,:)==1));
%                 ifr_denom_list(i)= LL- sum(sum(isnan(recognized2(i,:))));
                
            end 
            
            nifr_sp{subj,ses}= fr_num_sp./fr_denom_sp;
            nifr_list{subj,ses}= fr_num_list./fr_denom_list;
            ifr_sp{subj,ses}= ifr_num_sp./ ifr_denom_sp; 
%             ifr_list{subj,ses}= ifr_num_list ./ ifr_denom_list;
        end 
    end 
end 


nifr_sp= cell2mat(nifr_sp(~cellfun('isempty', nifr_sp)));
%Check to see if there are any infs or probs>1
nifr_sp(nifr_sp>1)
nifr_sp(isinf(nifr_sp))
%None! 

nifr_list= cell2mat(nifr_list(~cellfun('isempty', nifr_list)));
nifr_list(nifr_list>1)
nifr_list(isinf(nifr_list))
%Also none!

%Include IFR and FR as a comparison 
ifr_sp= cell2mat(ifr_sp(~cellfun('isempty', ifr_sp)));
ifr_list= cell2mat(ifr_list(~cellfun('isempty', ifr_list)));

%% Plot Figures SP
figure(2)
close all;
%FR Only
% subplot(2,1,1)
plot(nanmean(nifr_sp), 'o-', 'Color', [0.4170    0.3023    0.1863])
ylim([0 1])
xlim([1 LL])
xticks([1:LL])
title('Probability of Final Recognition ƒ Serial Position')
subtitle('No IFR Items')
ylabel('Probability')
xlabel('Serial Position')

% IFR Comparison
% subplot(2,1,2)
% plot(nanmean(nifr_list), 'o-', 'Color', [0.7203    0.1468    0.3456])
% ylim([0 1])
% xlim([1 LL])
% xticks([1:LL])
% xlabel('List')
% title('Probability of Final Recognition ƒ List')
% subtitle('No IFR Items')
% ylabel('Probability')

%% Double Checking Something with Final Rec
sp_all= {};
just_rec= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        ifr_idx= data.subject== nsubj(subj) & data.session == nses(ses);
        if sum(sum(ifr_idx))>0
            recall= data.recalls(ifr_idx,:); 
            recognized= data.pres.recognized(ifr_idx,:);
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            
            not_tested= presitemnos(isnan(recognized));
            %Mask out non-tested (recognition) items 
            recall(ismember(recitemnos, not_tested))= nan;
            not_recognized= presitemnos(recognized==0);
            ifr_only= recall;
            ifr_only(ismember(recitemnos, not_recognized))= 0;
            for i = 1:LL
                sp_prop(i)= sum(sum(ifr_only==i))./sum(sum(recall==i));
            end 
            sp_all{subj,ses}= sp_prop;
            just_rec{subj,ses}= nanmean(recognized);
        end 
    end 
end 

sp_all= cell2mat(sp_all(~cellfun('isempty', sp_all)));
just_rec= cell2mat(just_rec(~cellfun('isempty', just_rec)));

close all;
subplot(2,1,1)
plot(nanmean(sp_all), '-o')
xlim([1 LL])
subplot(2,1,2)
plot(nanmean(just_rec), '-o')
xlim([1 LL])
ylim([0.75 1])