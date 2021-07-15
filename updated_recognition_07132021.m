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
% ifr_idx= [];
% list= [];
% total_sp= [];
% total_list= {};
% spc_sp= {};
% 
% for subj= 1:length(nsubj)
%     for ses= 1:length(nses)
%         if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session == nses(ses)));
%             ifr_idx= data.subject== nsubj(subj) & data.session == nses(ses);
%             ifr_recall= data.recalls(ifr_idx,:);
%             presitemnos= data.pres_itemnos(ifr_idx,:);
%             presitemnos(presitemnos<1)= nan;
%             recitemnos= data.rec_itemnos(ifr_idx,:);
%             recognized= data.pres.recognized(ifr_idx,:);
%             itemnos_mask= ismember(recitemnos, presitemnos);
%             for i = 1:length(recognized(1,:))
%             %     how many times was an item from serial position i recognized out of
%             %     all possible trials? 
%                 sp(i)= nansum(nansum(recognized(:,i)))/LL;
%             end
%             total_sp{subj,ses}= sp;
%             for i = 1:length(recognized(:,1))
%             %     how many items were recognized from list i out of all possible items
%             %     that could have been recognized.
%                 list(i)= nansum(nansum(recognized(i,:)))/LL;
%             end
%             
%             ifr_mask= [];
%            rec_mask= ismember(recitemnos,presitemnos);
%         end 
%         
%     
%     
%     
%     end
% end 
% 
% total_sp= total_sp(~cellfun('isempty', total_sp));
% total_sp= cell2mat(total_sp);
% total_list= total_list(~cellfun('isempty', total_list));
% total_list= cell2mat(total_list);
% 
% close all
% plot(mean(total_sp),'-o')
% xlabel('Serial Position')
% ylabel('Probability Final Recognition')
% title('Final Recognizition ƒ Serial Position') 
% 
% close all
% plot(mean(total_list), '-o')
% xlabel('List')
% ylabel('Probability Final Recognition')
% title('Final Recognizition ƒ List')
% 
% presitemnos(~recognized)= nan;
% 
% for i = 1:length(rec_mask)
% end 
% 
% %%
% ifr_op= repmat(1:LL,16,1);
% ifr_op(data.recalls(ifr_idx,1:16)== 0)=0;
% rec_mask= ismember(presitemnos, recitemnos);
% % serial position
% for i = 1:length(recognized(1,:))
% %     how many times was an item from serial position i recognized out of
% %     all possible trials? 
%     sp(i)= sum(sum(recognized(:,i)))/LL;
% end 
% recitemnos= recitemnos(:,1:16);
% % list
% for i = 1:length(recognized(:,1))
% %     how many items were recognized from list i out of all possible items
% %     that could have been recognized.
%     list(i)= sum(sum(recognized(i,:)))/LL;
% end 
% 
% 
% close all 
% plot(sp, '-o')
% ylim([0.5, 1])
% xlim([1,LL])
% 
% % presitemnos(~recognized)=nan;
% % ismember(recitemnos, presitemnos)
% % 
% % % output position
% % 
% % op_mask = ismember(recitemnos, presitemnos)
% % for i = 1:LL
% %     op(i)= sum(sum(rec_mask(i,:)))/LL;
% % end 
% % 
% % close all 
% plot(op, '-o')
%% Predictor on x axis, final recognition on y axis (sp and list: ignoring IFR)
list= [];
full_sp= {};
full_list= {};
sum_sp= {};
sum_list= {};
total_recall= {};
total_list= {}
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses),:));
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recalls= data.recalls(ifr_idx,:);
            recognized= data.pres.recognized(ifr_idx,:);
            recalls(~ismember(recitemnos, presitemnos))=nan;
%             get sp and list count numerators
            rec_sp=[];
            for i = 1:LL
                %ignore nans. Do not count them towards numerator and denominators
                sp_nan= sum(isnan(recognized(:,i)));
                list_nan= sum(isnan(recognized(i,:)));
                rec_sp(i)= nansum(nansum(recognized(:,i)))./ (LL-sp_nan); %all possible items that could have been recognized in serial position i;
                rec_list(i)= nansum(nansum(recognized(i,:)))./(LL-list_nan); %all possible items that could have been recognized on list i;
                 
            end 

            full_sp{subj, ses}= rec_sp;
            full_list{subj, ses}= rec_list;
            sum_sp{subj,ses}= sp;
            sum_list{subj,ses}= list;
            total_recall{subj,ses}= recalls;
            total_list{subj,ses}= data.pres.list(ifr_idx,:);
        end 
    end 
end 


full_sp= cell2mat(full_sp(~cellfun('isempty', full_sp)));
full_list= cell2mat(full_list(~cellfun('isempty', full_list)));
sum_sp= cell2mat(sum_sp(~cellfun('isempty', sum_sp)));
sum_list= cell2mat(sum_list(~cellfun('isempty', sum_list)));

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
plot(mean(full_list), 'o-')
xlim([1,LL])
ylim([0.75, 1])
subtitle('sum(recognized== 1 in list( i )/LL')
title('Recognition as a Function of List')
ylabel('Probability')
xlabel('List')
%% Histogram Recognized SP
close all;
histogram(sum_sp)
title('Recognition Serial Position')
subtitle('sum(recognized== 1 in serial position( i )/LL')
xlim([1,LL])

ylabel('Probability')
xlabel('Serial Position')

%% Histogram of all values going into each predictor (ie IFR and tested in recognition)

all_recall= {};
all_op= {};
all_list= {};
all_lag= {};

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
%                 recall(~ismember(recitemnos,presitemnos))=0;
                recall(isnan(presitemnos))=nan;


                op= zeros(size(recall));
                op= repmat(1:length(recall(1,:)), LL, 1);
                op(recall==0)= 0;
                op(isnan(recall))= nan;
                list= repmat(1:LL, length(recall(1,:)),1)';
                list(recall== 0)= 0;
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
close all;
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
histogram(all_list)
xlim([1,LL])
xlim([0.5,LL+0.5])
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
                recall(isnan(presitemnos))=nan;


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

%% Lag Histogram
close all
histogram(full_lag)
xlim([0,20]) %for visability
xticks(0:20)
xlabel('Lag')
ylabel('Frequency')
title('Lag: Items IFR and Final Recognition')

%% 
