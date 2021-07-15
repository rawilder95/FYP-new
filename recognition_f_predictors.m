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
ifr_idx= [];
list= [];

for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session == nses(ses)));
            ifr_idx= data.subject== nsubj(subj) & data.session == nses(ses);
            ifr_recall= data.recalls(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            presitemnos(presitemnos<1)= nan;
            recitemnos= data.rec_itemnos(ifr_idx,:);
            recitemnos(recitemnos<1)= nan;
            itemnos_mask= ismember(recitemnos, presitemnos);
            
%             ifr_recall(~itemnos_mask)= nan;
            ifr_recall(ifr_recall<1)= nan;
            ifr_op= ifr_recall;
            for i = 1:length(ifr_op(:,1))
                ifr_op(i,:)= 1:length(ifr_op(1,:));
            end
            ifr_op(isnan(ifr_recall))= nan;
             ifr_lag= [];
            for i = 1:length(ifr_recall(1,:))
                ifr_lag(:,i)= LL-ifr_recall(:,i)+i-1;
            end
            ifr_lag(isnan(ifr_recall))= nan;
            
            frecog= data.pres.recognized(ifr_idx,:);
            
            recog_pres= presitemnos;
            recog_pres(~(data.pres.recognized(ifr_idx,:)==1))= nan;
            ifr_recall= reshape(ifr_recall, numel(ifr_recall), 1);
            ifr_op= reshape(ifr_op, numel(ifr_op), 1);
            ifr_lag= reshape(ifr_lag, numel(ifr_lag), 1);
            frecog= reshape(frecog, numel(frecog), 1);
            recog_pres= reshape(recog_pres, numel(recog_pres), 1);
            itemnos_mask= reshape(itemnos_mask, numel(itemnos_mask), 1);
            
            final_recog= ifr_recall(itemnos_mask);
            
        end
        
    
    
    
    end
% %     full_data{subj, ses}= [ifr_recall, ifr_op, ifr_lag, frecog, recog_pres, itemnos_mask, final_recog];
end 
%%
full_data= full_data(~cellfun('isempty', full_data));
full_data= cell2mat(full_data);
close all
recall= full_data(:,1);
rec_mask= full_data(:,end-1);
rec_mask= logical(rec_mask);
subplot(2,1,1)
histogram(full_data(:,1))
subplot(2,1,2)
histogram(full_data(:,end))

%recognized is presented in fixed order cols and rows still correspond to
%serial position 

%%
full_data= {};
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)))
        ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
        %set recitemnos to nan if it was repeated or intruded
        recitemnos= data.rec_itemnos(ifr_idx,:);
        presitemnos= data.pres_itemnos(ifr_idx,:);
        mask_recog= ismember(presitemnos, recitemnos);
        recog= data.pres.recognized(ifr_idx,:);
        
        recall= data.recalls(ifr_idx,:);
        recall= recall(:,1:LL);
        ifr_op= recall;
        list= data.pres.list(ifr_idx,:);
            for i = 1:length(ifr_op(:,1))
                ifr_op(i,:)= 1:length(ifr_op(1,:));
            end
       ifr_op(recall<1)= 0;
       
       ifr_lag= [];
            for i = 1:length(recall(1,:))
                ifr_lag(:,i)= LL-recall(:,i)+i-1;
            end
            ifr_lag(isnan(recall))= 0;
            
            
            
            
        full_data{subj, ses}= [reshape(recall, numel(recall), 1), reshape(mask_recog, numel(mask_recog),1), reshape(ifr_op, numel(ifr_op),1), reshape(ifr_lag, numel(ifr_lag), 1), reshape(list, numel(list), 1)];
        
        end 
    end 
end 

full_data= full_data(~cellfun('isempty', full_data));
full_data= cell2mat(full_data);
recall= full_data(:,1);
fin_rec= full_data(:,2);
op= full_data(:,3);
lag= full_data(:,4);
list= full_data(:,5);
list(list<1)= nan;
close all;
subplot(2,1,1)
h1= histogram(recall(recall>0));
title('IFR SP')
subplot(2,1,2)
h2= histogram(recall(fin_rec & recall>0));
title('Final Recognition SP')
ylim([0, 8000])

ifr_sp= h1.Values;
frec_sp= h2.Values;

close all;
subplot(2,1,1)
plot(ifr_sp./length(full_data), 'o-')
title('IFR SP')
xlim([1,16])
subplot(2,1,2)
plot(frec_sp./ length(full_data), 'o-')
title('Final Recognition SP')
xlim([1,16])
ylim([0,0.06])

%%
close all;
subplot(2,1,1)

h1= histogram(op(op>0));
title('IFR OP')
subplot(2,1,2)

h2= histogram(op(fin_rec & op>0));
title('Final Recognition OP')
ylim([0, 8000])

ifr_op= h1.Values;
frec_op= h2.Values;


close all;
subplot(2,1,1)

plot(ifr_op./length(full_data), 'o-')
title('IFR OP')
xlim([1,16])
subplot(2,1,2)

plot(frec_op./ length(full_data), 'o-')
title('Final Recognition OP')
xlim([1,16])
ylim([0,0.06])
%%
close all;
subplot(2,1,1)
h1= histogram(lag);
title('IFR Lag')
subplot(2,1,2)
h2= histogram(lag(fin_rec==1));
title('Final Recognition Lag')
ylim([0, 8000])

ifr_lag= h1.Values;
frec_lag= h2.Values;

close all;
subplot(2,1,1)
plot(ifr_lag./length(full_data), 'o-')
xlim([0,21])
xticks(0:1:20)
title('IFR Lag')
subplot(2,1,2)
plot(frec_lag./length(full_data), 'o-')
xlim([1,20])
xticks(0:2:20)
ylim([0,0.06])
title('Final Recognition Lag')

%%
close all;
subplot(2,1,1)
h1= histogram(list);
title('IFR List')
subplot(2,1,2)
h2= histogram(list(fin_rec==1));
title('Final Recognition List')
ylim([0, 6000])

ifr_list= h1.Values;
frec_list= h2.Values;


close all;
subplot(2,1,1)
plot(ifr_list./length(full_data), 'o-')
xlim([1,16])
title('IFR List')
subplot(2,1,2)
plot(frec_list./ length(full_data), 'o-')
ylim([0,0.06])
xlim([1,16])
title('Final Recognition List')
%%
% close all;
% for i = 1:length(LL)
%     p{i}= spc(data.pres.recalled, data.subject, LL)




ifr_idx= data.subject== nsubj(1) & data.session== nses(2);
recall= data.recalls(ifr_idx,:)
op= recall;
for i = 1:length(op(:,1))
   op(i,:)= i;
end 
    
op(recall<1)= 0;

lag= LL+recall;
lag(recall<1)= 0;


recitemnos= data.rec_itemnos(ifr_idx,:);
presitemnos= data.pres_itemnos(ifr_idx,:);
recognized= data.pres.recognized(ifr_idx,:);
presitemnos(~recognized)= nan;
recitemnos(recitemnos<1)= nan;
itemnos_mask= ismember(recitemnos, presitemnos)
close all
lag(recall<1)= nan;
h1= histogram(lag)


%%
p_spc= {};
p_lag= {};
p_frecog= {};
list= [];

for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session == nses(ses)));
            ifr_idx= data.subject== nsubj(subj) & data.session == nses(ses);
            ifr_recall= data.recalls(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            presitemnos(presitemnos<1)= nan;
            recitemnos= data.rec_itemnos(ifr_idx,:);
            recitemnos(recitemnos<1)= nan;
            itemnos_mask= ismember(recitemnos, presitemnos);
            subjects= data.subject(ifr_idx,:);
%             ifr_recall(~itemnos_mask)= nan;
            ifr_recall(ifr_recall<1)= nan;
            ifr_op= ifr_recall;
            for i = 1:length(ifr_op(:,1))
                ifr_op(i,:)= 1:length(ifr_op(1,:));
            end
            list= data.pres.list(ifr_idx,:);
            ifr_op(isnan(ifr_recall))= nan;
             ifr_lag= [];
            for i = 1:length(ifr_recall(1,:))
                ifr_lag(:,i)= LL-ifr_recall(:,i)+i-1;
            end
            ifr_lag(isnan(ifr_recall))= nan;
            
            frecog= data.pres.recognized(ifr_idx,:);
        
           
           p_spc{subj,ses}= spc(ifr_recall, subjects, LL);
           p_lag{subj,ses}= spc(ifr_lag, subjects, LL);
           p_frecog{subj,ses}= spc(frecog, subjects, LL);
        end
        
    
    
    
    end
end 



p_frecog= p_frecog(~cellfun('isempty', p_frecog));
p_frecog= cell2mat(p_frecog);


close all
plot(mean(p_frecog'))


%%


% p = spc(recognized, subjects, LL)

[list,sp]= find(data.pres.recognized(1:16,:)==1)
[list'; sp']


% Do it this way ffr_lag/ifr_lag
% take recognized matrix, and transform list and serial position (make your
% own version of ffr.list and ffr.sp)

% Making my own 'frecog' subfield as a function, save that datafile and
% then just load that in. 

% Study-test lag you can plug it into spc just like any other predictor

%% Redoing it After Meeting
p_sp= {};
p_op= {};
p_lag= {};
p_spr= {};
p_list= {};
for subj = 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject== nsubj(subj) & data.session== nses(ses)))
            ifr_idx= data.subject== nsubj(subj) & data.session== nses(ses);
            recall= data.recalls(ifr_idx,:);
            recall(recall<1)= nan;
            op= recall;
            for i = 1:length(op(:,1))
                op(i,:)= 1:length(op(1,:));
            end 
            
            
            op(isnan(recall))=nan;
            lag= LL-recall+op-1;
            p_sp{subj,ses}= spc(recall, data.subject(ifr_idx), LL);
            p_op{subj,ses}= spc(op, data.subject(ifr_idx), LL);
            recognized= data.pres.recognized(ifr_idx,:);
            list= data.pres.list(ifr_idx,:);
%             for nlist = 1:LL
%                 p_spr{subj,ses}= spc(recall(:,1:16), data.subject(ifr_idx), LL, recognized==1 & list== nlist);
%             end 
              for i = 1:LL
                  spr_denom(i)= sum(sum(recall==i));
                  spr_num(i)= sum(sum(recall(:,1:16)==i & recognized>0));
              end 
              
              p_spr{subj,ses}= spr_num./spr_denom;
                  
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
           
            
            presitemnos(recognized<1)= nan;
            
            ifr_mask= ismember(recitemnos, presitemnos);
            rec_lag= lag;
            rec_lag(~ifr_mask)= nan;
            lag_denom= [];
            lag_num= [];
            for i = 0:20
                lag_denom(i+1)= sum(sum(lag==i));
            end 
            
            for i = 0:20
                lag_num(i+1)= sum(sum(rec_lag==i));
            end 
            p_lag{subj,ses}= lag_num./lag_denom;
            
            list(list<1)=nan;
            for i = 1:LL
                list_denom(i)= sum(sum(list==i));
                list_num(i)= sum(sum(list== i & recognized== 1));
            end 
            p_list{subj,ses}= list_num./list_denom;
        end
    end 
end 

p_lag= nanmean(cell2mat(p_lag(~cellfun('isempty', p_lag))))
p_sp= mean(cell2mat(p_sp(~cellfun('isempty', p_sp))))
p_spr= nanmean(cell2mat(p_spr(~cellfun('isempty', p_spr))))
p_list= nanmean(cell2mat(p_list(~cellfun('isempty', p_list))))

%%


close all




close all
p= plot(p_lag, 'o-')
xlim([0,21])
xticks([1:21])
xticklabels([0:20])
title('Probability of Final Recognition ƒ Lag')
xlabel('Lag')
ylabel('Probability')

% close all
% % subplot(2,1,1)
% % plot(p_sp, 'o-')
% % title('Initial Recall')
% % xlabel('Serial Position')
% % xlim([1,16])
% % subplot(2,1,2)
% plot(p_spr, '-o')
% title('Probability of Final Recognition ƒ Serial Position')
% xlabel('Serial Position')
% xlim([1,16])
% ylim([0.5,1])
% ylabel('Probability')

%%

close all
plot(p_list, '-o')
xlim([1,LL])
xticks([1:16])
title('Probability of Final Recognition ƒ List')
ylabel('Probability')
xlabel('List')

%%

recog= data.pres.recognized;
sp= zeros(size(data.pres.recognized));
for i = 1:length(sp(:,1))
    sp(i,:)= 1:length(sp(1,:));
end 

sp(isnan(recog))= nan;
sp(recog== 0)= 0;
recog(isnan(recog))= -1;

p = spc(sp, data.subject, LL, recog);

% recalls= data.recalls;
% recalls(~ismember(recitemnos, presitemnos))= nan;
% recalls= recalls(:,1:16);
% sp= 
%%

spc_rec= {};
list_rec= {};
lag_rec= {};
op_rec= {}; 
sp_both_rec= {};
sp_both= [];
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject==nsubj(subj) & data.session== nses(ses)))
            ifr_idx= (data.subject==nsubj(subj) & data.session== nses(ses));
            sp= zeros(size(data.pres.recognized(ifr_idx,:)));
            list= data.pres.list(ifr_idx,:);
            recall= data.recalls(ifr_idx,1:16);
            st_lag= LL-recall-sp+1;
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            rec_mask= ismember(recitemnos, presitemnos);
            for i = 1:length(sp(:,1))
                sp(i,:)= 1:length(sp(1,:));
            end 
            for i = 1:LL
            sp_both(i)= sum(sum(data.recalls(ifr_idx,:)== i));
            end 
            recognized= data.pres.recognized(ifr_idx,:);
            
            if any(any(isnan(recognized)))
                continue
                disp(recognized)
            else
                st_lag(~recognized)= nan;
                spc_rec{subj,ses}= spc(sp, data.subject(ifr_idx,:), LL, logical(recognized));
                list_rec{subj, ses}= spc(list, data.subject(ifr_idx,:), LL, logical(recognized));
                lag_rec{subj, ses}= spc(st_lag, data.subject(ifr_idx,:), LL, logical(recognized));
                
            end 
        end 
    end 
end 
spc_rec= spc_rec(~cellfun('isempty', spc_rec));
spc_rec= cell2mat(spc_rec);

list_rec= list_rec(~cellfun('isempty', list_rec));
list_rec= cell2mat(list_rec);

lag_rec= lag_rec(~cellfun('isempty', lag_rec));
lag_rec= cell2mat(lag_rec);
%%
close all;
subplot(2,1,1)
plot(p_sp)
xlim([1,LL])
ylim([0.5,1])
title('SP IFR and Final Rec')
subplot(2,1,2)
plot(mean(spc_rec), 'o-')
title('SP Final Rec Not Necessarily IFR')

%%
close all
subplot(2,1,1)
plot(p_list, 'o-')
xlim([1,LL]) 
ylim([0.5, 1])
title('List IFR and Final Rec') 
xlabel('List')
subplot(2,1,2)
plot(mean(list_rec), 'o-')
xlim([1,LL]) 
ylim([0.5, 1])
title('List Recognition Only') 
xlabel('List')
%%
close all
subplot(2,1,1)
plot(p_lag, 'o-')
xlim([1,LL]) 
ylim([0.1, 1])
title('Study Test Lag IFR and Final Rec') 
subplot(2,1,2)
plot(mean(lag_rec), 'o-')
xlim([1,LL]) 
ylim([0.1, 1])
title('Study Test Lag Final Recognition Only') 
%%

spc_rec= {};
list_rec= {};
lag_rec= {};
op_rec= {}; 
sp_both_rec= {};
sp_both= [];
for subj= 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject==nsubj(subj) & data.session== nses(ses)))
            ifr_idx= (data.subject==nsubj(subj) & data.session== nses(ses));
            sp= zeros(size(data.pres.recognized(ifr_idx,:)));
            list= data.pres.list(ifr_idx,:);
            recall= data.recalls(ifr_idx,1:16);
            st_lag= LL-recall-sp+1;
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            rec_mask= ismember(recitemnos, presitemnos);
            for i = 1:length(sp(:,1))
                sp(i,:)= 1:length(sp(1,:));
            end 
            for i = 1:LL
            sp_both(i)= sum(sum(data.recalls(ifr_idx,:)== i));
            end 
            recognized= data.pres.recognized(ifr_idx,:);
            
            if any(any(isnan(recognized)))
                continue
                disp(recognized)
            else
                st_lag(~recognized)= nan;
                spc_rec{subj,ses}= spc(sp, data.subject(ifr_idx,:), LL, logical(recognized));
                list_rec{subj, ses}= spc(list, data.subject(ifr_idx,:), LL, logical(recognized));
                lag_rec{subj, ses}= spc(st_lag, data.subject(ifr_idx,:), LL, logical(recognized));
                
            end 
        end 
    end
end 
    
    
    
    %%
for subj = 1:length(nsubj)
    for ses= 1:length(nses)
        if ~isempty(data.recalls(data.subject==nsubj(subj) & data.session== nses(ses)))
            ifr_idx= (data.subject==nsubj(subj) & data.session== nses(ses));
%             sp= zeros(size(data.pres.recognized(ifr_idx,:)));
            op= zeros(size(recall));
            for i = 1:length(recall(1,:))
                op(:,i)= i;
            end 
            op(recall<1)= 0;
            list= data.pres.list(ifr_idx,:);
            recall= data.recalls(ifr_idx,:);
            st_lag= LL-recall-op+1;
            st_lag(recall<1)= 0;
            recognized= data.pres.recognized(ifr_idx,:);
            zeros(data.pre)
            recall()
            recitemnos= data.rec_itemnos(ifr_idx,:);
            presitemnos= data.pres_itemnos(ifr_idx,:);
            rec_mask= ismember(recitemnos, presitemnos);
            for i = 1:LL
            end 
        end 
            
        end 
        
    end 

