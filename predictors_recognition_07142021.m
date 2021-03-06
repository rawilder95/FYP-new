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

%% Predictor on x axis, final recognition on y axis (sp and list: ignoring IFR)
list= [];
full_sp= {};
full_list= {};
sum_sp= {};
sum_list= {};
total_recall= {};
total_list= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:));
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recalls= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:);
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            recalls(~ismember(recitemnos, presitemnos))=nan;
%             get sp and list count numerators
            rec_sp=[];
            for i = 1:LL
                %ignore nans. Do not count them towards numerator and denominators
                sp_nan= sum(isnan(recognized(:,i)));
                list_nan= sum(isnan(recognized(i,:)));
                rec_sp(i)= nansum(nansum(recognized(:,i)))./(LL-sp_nan); %all possible items that could have been recognized in serial position i;
                rec_list(i)= nansum(nansum(recognized(i,:)))./(LL-list_nan); %all possible items that could have been recognized on list i;
                
               
            end 
            
          
            ifr_recall= data.recalls(ifr_idx,:);
            ifr_recall(isnan(recognized))= nan;
            ifr_list= data.pres.list(ifr_idx,:);
            ifr_list(isnan(recognized))= nan;
            full_sp{subj, ses}= rec_sp;
            full_list{subj, ses}= rec_list;
            
            total_recall{subj,ses}= ifr_recall;
            total_list{subj,ses}= ifr_list;
        end 
    end 
  
  
    
end 


full_sp= cell2mat(full_sp(~cellfun('isempty', full_sp)));
full_list= cell2mat(full_list(~cellfun('isempty', full_list)));
sum_sp= cell2mat(sum_sp(~cellfun('isempty', sum_sp)));
sum_list= cell2mat(sum_list(~cellfun('isempty', sum_list)));
total_recall= cell2mat(total_recall(~cellfun('isempty', total_recall)));
total_list= cell2mat(total_list(~cellfun('isempty', total_list)));

% full_list= cell2mat(full_list(~cellfun('isempty', full_list)));
%% Plot predictor on x axis, final recognition on y axis (sp and list: ignoring IFR)
close all;

subplot(2,1,1)
plot(mean(full_sp), 'o-') 
title('Recognition as a Function of Serial Position')
subtitle('sum(recognized== 1 in serial position( i )/LL')
xlim([1,LL])
ylim([0.75, 1])
ylabel('Probability')
xlabel('Serial Position')

subplot(2,1,2)
plot(nanmean(full_list), 'o-')
xlim([1,LL])
ylim([0.75, 1])
subtitle('sum(recognized== 1 in list( i )/LL')
title('Recognition as a Function of List')
ylabel('Probability')
xlabel('List')
%% Histogram SP and List and Recognized
full_list={};
full_recall={};
full_op= {};
full_lag= {};
lag_proportion= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)));
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recall= data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:);
            recognized= data.pres.recognized(ifr_idx,:);
%             recall(isnan(recognized))=nan;
            presitemnos= data.pres_itemnos(ifr_idx,:);
            recitemnos= data.rec_itemnos(ifr_idx,:);
            recitemnos(recitemnos<1)=nan;
           
%             recall(~ismember(recitemnos,presitemnos))=nan;
            recall(recall<1)= 0;
             op= zeros(size(recall));
                op= repmat(1:length(recall(1,:)), LL, 1);
                op(recall==0)= 0;
                op(isnan(recall))= 0;
                
            lag= LL- recall+op-1;
            list= zeros(size(recall));
                for i = 1:LL
                    list(i,:)= i;
                end 
            list(recall<1)= nan;
            list(~ismember(recitemnos,presitemnos))= nan;
            list(list>LL)=nan;
            lag_mask= ismember(recitemnos,presitemnos);
            lag(recall<1)=nan;
            fr_lag= lag;
            fr_lag(lag_mask==0)= nan;
%             list(~ismember,presitemnos))=nan;
              for i = 1:21
                ifr_lag(i)= nansum(nansum(lag== i-1));
                frec_lag(i)= nansum(nansum(fr_lag== i -1));
                end 
            
            full_recall{subj,ses}= recall;
            full_list{subj,ses}= list;
            full_op{subj,ses}= op;
            full_lag{subj,ses}= lag;
            lag_proportion{subj,ses}= frec_lag./ifr_lag;
            
        end 
    end 
end 
full_list= cell2mat(full_list(~cellfun('isempty', full_list)));
full_recall= cell2mat(full_recall(~cellfun('isempty', full_recall)));
full_op= cell2mat(full_op(~cellfun('isempty', full_op)));
full_lag= cell2mat(full_lag(~cellfun('isempty', full_lag)));
lag_proportion= cell2mat(lag_proportion(~cellfun('isempty', lag_proportion)));

%% Histogram SP IFR that was also Recognized
close all;
figure(3)
histogram(full_recall)
% ylim([0,7000])
title('Serial Position: IFR Items That Were Final Recognized')
ylabel('Frequency')
xlabel('Serial Position')
xlim([0.5 LL+0.5])
xticks([1:LL])

%% Lag Proporiton
close all;
figure(3)
plot(nanmean(lag_proportion), 'o-')
ylim([0,1])
title('Study-Test Lag: IFR and Tested in Final Recognition/ Recognized')
ylabel('Probability of Recognition')
xlabel('Study-Test Lag')
xlim([1,21])
xticks([1:21])
xticklabels([0:20])
%% Histogram List IFR that was also Recognized
close all;
figure(3)
histogram(all_list)
ylim([0,8000])
title('List: IFR Items That Were Final Recognized')
ylabel('Frequency')
xlabel('List')
xlim([0.5,LL+0.5])
xticks([1:LL])
%% Histogram Output Position IFR that was also Recognized
close all;
figure(3)
histogram(full_op)
ylim([0,8000])
title('Output Position: IFR Items That Were Final Recognized')
ylabel('Frequency')
xlabel('Output Position')
xlim([0.5,LL+0.5])
xticks([1:LL])
%% Histogram Lag IFR that was also Recognized
close all;
figure(3)
histogram(full_lag)
ylim([0,8000])
title('Study-Test Lag: IFR Items That Were Final Recognized')
ylabel('Frequency')
xlabel('Study-Test Lag')
xlim([0, 20])
xticks([0:20])


%% Histogram of all values going into each predictor (ie IFR and tested in recognition)

all_recall= {};
all_op= {};
all_list= {};
all_lag= {};

list=[];
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
            if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:));
                ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
                recall= data.recalls(ifr_idx,:);
                recognized= zeros(size(recall));
                recognized(:,1:LL)=data.pres.recognized(ifr_idx,:);
                recitemnos= data.rec_itemnos(ifr_idx,:);
                presitemnos= data.pres_itemnos(ifr_idx,:);
                    find_nan_rec= presitemnos(isnan(recognized));
                    recitemnos(ismember(recitemnos, find_nan_rec))= nan;
                recall(isnan(recitemnos))=nan;


                op= zeros(size(recall));
                op= repmat(1:length(recall(1,:)), LL, 1);
                op(recall==0)= 0;
                op(isnan(recall))= nan;
                list= zeros(size(recall));
                for i = 1:LL
                    list(i,:)= i;
                end 
            
                list(recall== 0)= nan;
                list(isnan(recall))= nan;
                lag= LL-recall+op-1;
                lag(recall==0)= nan;
                lag(isnan(recall))=nan;
                all_recall{subj, ses}= recall;
                all_lag{subj,ses}= lag;
                all_op{subj,ses}= op;
                all_list{subj,ses}= list;


        end 
    end 
end 

all_recall= cell2mat(all_recall(~cellfun('isempty', all_recall)));
all_op=  cell2mat(all_op(~cellfun('isempty', all_op)));
all_list=  cell2mat(all_list(~cellfun('isempty', all_list)));
all_lag=  cell2mat(all_lag(~cellfun('isempty', all_lag)));


%% Serial Position Histogram IFR only
close all
figure(1)

histogram(all_recall)
xlim([1,LL])
xlim([0.5,LL+0.5])
xticks([1:LL])
xlabel('Serial Position')
ylim([0, 7000])
ylabel('Frequency')
title('Serial Position: Items that were IFR and Tested in Recognition')

%% Output Position Histogram IFR only

figure(2)
histogram(all_op)
xlim([1,LL])
xlim([0.5,LL+0.5])
xticks([1:LL])
xlabel('Output Position')
ylim([0, 7000])
ylabel('Frequency')
title('Output Position: Items that were IFR and tested in Recognition')

%% List Histogram IFR only

figure(3)
histogram(full_list)
xlim([1,LL])
xlim([1,LL])
xticks([1:LL])
xlabel('List')
ylim([0, 7000])
ylabel('Frequency')
title('List: Items that were IFR and tested In Recognition')
%% Lag Histogram IFR only

figure(3)
histogram(all_lag)
xlim([0,20])
xlim([0,20])
xticks([0:20])
xlabel('Lag')
ylim([0, 7000])
ylabel('Frequency')
title('Lag: Items that were IFR and tested in Recognition')


%%  histogram for items which were final recognized (out of IFR and tested in recognition)
total_recall= {};
full_op= {};
full_list= {}; 
full_lag= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
            if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:));
                ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
                recall= data.recalls(ifr_idx,:);
                recognized= zeros(size(recall));
                recognized(:,1:LL)=data.pres.recognized(ifr_idx,:);
                recitemnos= data.rec_itemnos(ifr_idx,:);
                presitemnos= data.pres_itemnos(ifr_idx,:);
                presitemnos(isnan(recognized))=nan;
                recall(~ismember(recitemnos,presitemnos))=0;
                find_nan_rec= presitemnos(isnan(recognized));
                    recitemnos(ismember(recitemnos, find_nan_rec))= nan;
                recall(isnan(recitemnos))= nan;


                op= zeros(size(recall));
                op= repmat(1:length(recall(1,:)), LL, 1);
                op(recall==0)= 0;
                op(isnan(recall))= nan;
                list= repmat(1:LL, length(recall(1,:)),1)';
                list(recall== 0)= 0;
                list(isnan(recall))= nan;
                lag= LL-recall+op-1;
                lag(recall==0)= 0;
                lag(isnan(recall))=nan;
                total_recall{subj, ses}= recall;
                full_lag{subj,ses}= lag;
                full_op{subj,ses}= op;
                full_list{subj,ses}= list;

        end 
    end 
end 

total_recall= cell2mat(total_recall(~cellfun('isempty', total_recall)));
full_op=  cell2mat(full_op(~cellfun('isempty', full_op)));
full_list=  cell2mat(full_list(~cellfun('isempty', full_list)));
full_lag=  cell2mat(full_lag(~cellfun('isempty', full_lag)));

full_lag(total_recall<1)= nan;
total_recall(total_recall<1)= nan;
full_op(full_op<1)= nan;
full_list(full_list<1)= nan;

%% Serial Position Histogram

figure(1)
histogram(total_recall)
xlim([1,LL])
xlim([0.5,LL+0.5])
xticks([1:LL])
xlabel('Serial Position')
ylim([0, 7000])
ylabel('Frequency')
title('Serial Position: Items That were both IFR and Final Recognized')

%% Output Position Histogram
close all
histogram(full_op)
xlim([1,LL])
xticks(1:16)
xlabel('Output Position')
ylabel('Frequency')
title('Output Position: Items That were both IFR and Final Recognized')
%% List Histogram
close all
histogram(full_list)
xlim([0.5,LL+0.5]) %for visability
xticks(1:16)
xlabel('List')
ylabel('Frequency')
title('List: Items That were both IFR and Final Recognized')
ylim([0,8000])
%% Lag Histogram
close all
histogram(full_lag)
xlim([0,20]) %for visability
xticks(0:20)
xlabel('Lag')
ylabel('Frequency')
title('Lag: Items IFR and Final Recognition')

%% Probability of Serial Position Curve
p_rec= {};
for subj = 1:length(nsubj)
    for ses = 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:))
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recall= data.recalls(ifr_idx,:);
            recognized= zeros(size(recall));
            recognized(:,1:LL)= data.pres.recognized(ifr_idx,:);
%             recall(isnan(recognized))=nan;
            ifr_num= [];
            ifr_denom= [];
            presitemnos= zeros(size(recall));
            presitemnos(:,1:LL)= data.pres_itemnos(ifr_idx,:);
            recitemnos= data.rec_itemnos(ifr_idx,:);
            recitemnos(recitemnos<1)=nan;
%             presitemnos(recognized==0)=nan;
            recall(~ismember(recitemnos,presitemnos))=nan;
            recall(recall<1)= nan;
            for i = 1:LL
                ifr_num(i)= sum(sum(recall==i & recognized== 1));
                ifr_denom(i)= sum(sum(recall==i));
            end 
            p_rec{subj,ses}= ifr_num./ifr_denom;
            
        end 
    end 
end 

p_rec= cell2mat(p_rec(~cellfun('isempty', p_rec)));

close all;
plot(nanmean(p_rec), 'o-')
xlim([1,LL])
xlabel('Serial Position')
ylim([0.5 1])
ylabel('Probability')
title('Probability of Final Recognition ?? Serial Position')
subtitle('Num= IFR & Recognized, Denom= IFR')