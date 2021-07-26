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

close all;

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
           
           for i = 1:max(max(op))
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
close all;

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
  %% Redoing SP and List Recognition Only

  
  sp= [];
  list= [];
  
  sp_prop= {};
  list_prop= {};
  
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:))
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recognized= data.pres.recognized(ifr_idx,:);
            
            for i = 1:LL
                sp(i)= sum(nansum(recognized(:,i)))/(LL- sum(sum(isnan(recognized(:,i)))));
                list(i)= sum(nansum(recognized(i,:)))/(LL- sum(sum(isnan(recognized(i,:)))));
            end 
        end 
        sp_prop{subj,ses}= sp;
        list_prop{subj,ses}= list;

        
        
        
        
        
    end 
end 
sp_prop= cell2mat(sp_prop(~cellfun('isempty', sp_prop)));
list_prop= cell2mat(list_prop(~cellfun('isempty', list_prop)));

close all;
subplot(2,1,1)
p1= plot(mean(sp_prop), 'o-')
p1.Color= [0 0.5 1]
ylim([0.75,1])
xlim([1,LL])
title('Probability of Recognition (SP)')
subtitle('Replicated Original Recognition SP')
xlabel('Serial Position')
ylabel('Probability')

colormap(pink)
subplot(2,1,2)
p2= plot(mean(list_prop), 'o-')
p2.Color= [0.9 0 0.9]
ylabel('Probability')
ylim([0.75, 1])
title('Probability of Recognition (List)')
subtitle('Replicated Original Recognition List')
xlabel('List')
xlim([1, LL])
%%

sp2= [];
sp_ifr_fr= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        
        ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
        if sum(ifr_idx)~=0
        recall= data.recalls(ifr_idx,:);
        recognized= data.pres.recognized(ifr_idx,:);
        presitemnos= data.pres_itemnos(ifr_idx,:);
        recitemnos= data.rec_itemnos(ifr_idx,:);
        
        
        find_nan= presitemnos(isnan(recognized));
        recall(ismember(recitemnos, find_nan))= nan;
        was_recalled= ismember(presitemnos,recitemnos);
        k= recognized;
        recognized(~was_recalled)= nan;
        
        
        for i = 1:LL
            sp1(i)= sum(sum(recall==i));
            sp2(i)= nansum(recognized(:,i));
        end
        sp_ifr_fr{subj,ses}= sp2./sp1;
        end
        
    end 
end 

sp_ifr_fr= cell2mat(sp_ifr_fr(~cellfun('isempty', sp_ifr_fr)));