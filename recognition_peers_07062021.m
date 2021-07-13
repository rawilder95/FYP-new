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
   
%this is actually important
addpath(genpath('/Users/rebeccawilder/Desktop/CMR/'))
if ~strcmp(pwd, '/Users/rebeccawilder/Desktop/CMR/')
    cd ('/Users/rebeccawilder/Desktop/CMR/')
end 
counter= 0;

basic subfields
load('data_PEERS1_ifr_frecog_e1_minop.mat')

ifr= data;

this_ses = [];

ifr_op= [];

datafile= 'data_PEERS1_ifr_ffr_e1_minop.mat';
load(datafile);

nsubj= unique(data.subject);
LL= data.listLength;
nsubj= unique(data.subject);
nlists= unique(data.ffr.list(~isnan(data.ffr.list)));
nlists= nlists(nlists>0);
nses= unique(data.session);
nsubj= unique(ifr.subject);
nses= unique(ifr.session);
rec_mask_full= make_clean_recalls_mask2d(data.recalls);
data.recalls(~rec_mask_full)=0;

% for i = 1:length(unique(ifr.subject))
%     for j = 1:length(ses)
%         idx= data.subject== i & data.session==j;
%         if ~isempty data.recall(idx,:)
%             which_ses =  unique(data.session)
%         end 
%     end 
% end 

     which_ses= {};
for i = 1:length(nsubj)
    if isempty(ifr.recalls(ifr.subject==nsubj(i),:))
        continue
    else
        which_ses{i}= [unique(ifr.session(ifr.subject==nsubj(i),:))'];
    
    end 
end 
    
which_ses= which_ses(~cellfun('isempty', which_ses));
ifr_mask= make_clean_recalls_mask2d(data.recalls);


dist_spec= [];
all_data= [];
nses= unique(data.session);
std_mat= zeros(size(data.recalls(data.subject== nsubj(1) & data.session== nses(1),:)));
all_data= {};
for subj = 1:length(nsubj)
    for ses= 1:length(nses)
       
        
        ifr_idx= data.subject==nsubj(subj) & data.session== nses(ses);
        if ~isempty(data.recalls(ifr_idx,:))
            
        if subj == 90 & ses == 2| subj== 145 & ses== 4 | subj== 28 & ses== 5
            sprintf('skipping subject %d in session %d', nsubj(subj), nses(ses))
            continue
            
        end 
        
           %One distractor per list
           % Assigning one distractor to entire session may account for why
           % all conditions look similar and the recency in DFR.
           %Look at actual Matrix in all_data with hists.
            %Set up serial position col:
            %correct numel and correct num of NaNs
            ifr_sp= data.recalls(ifr_idx,:);
            k= ifr_sp;
            
          
            
            %this is separate from ifr_sp for debugging, because ifr_sp is
            %reshaped
            recall= ifr_sp;
            recall(recall<1)=nan;
            
           frecog= zeros(size(ifr_sp));
           frecog(ifr_idx,1:16)= data.pres.recognized(ifr_idx,:);
            rec_mask= ifr_sp>0; %mask for intrusions and misses
            ifr_sp(~rec_mask)=nan;
          
            ifr_sp= reshape(ifr_sp', numel(ifr_sp),1);
            %ifr_sp= ifr_sp(~isnan(ifr_sp));
            
            
            %Set up output position col:
            %correct numel and correct num of NaNs 
            ifr_op= ifr_sp;
            for i = 1:length(ifr_op(1,:))
                
                ifr_op(:,i)= i;
            end
            
            ifr_op(~rec_mask)=nan;
            ifr_op= reshape(ifr_op', numel(ifr_op),1);
            
            % call lag transitions function 
            lag_in= zeros(16,27);
            lag_out= zeros(16,27);
%             lag_in(:,2:end)= get_lag_transitions(recall);
%             lag_in= reshape(lag_in, numel(lag_in),1);
%             lag_out(:,1:end-1)= get_lag_transitions(recall);
            %set up transitions col
%             lag_in(isnan(ifr_sp))=nan;
%             lag_out(isnan(ifr_sp))= nan;
                lag_in= data.lag_in(ifr_idx,:);
                lag_out= data.lag_out(ifr_idx,:);

if nsubj(subj)==1 & nses(ses)==1
    keyboard
end

            %Set up response times col: 
            %correct numel and correct num of NaNs 
            ifr_rt= data.times(ifr_idx,:);
            ifr_rt(~rec_mask)=nan;
            ifr_rt= reshape(ifr_rt', numel(ifr_rt),1);
            %ifr_rt= ifr_rt(~isnan(ifr_rt));
%             counter= [];
%             dist_bet= nan(size(ifr_rt));
%             for dist_count = 0:length(ifr_rt)/12:length(dist_bet)-26
%                 counter= [counter, dist_count];
%                 if dist_count == 0
%                     dist_bet(dist_count+1:dist_count+1+26-1)= dist_col(dist_count+1);
%                 else
%                     dist_bet(dist_count:dist_count+26)= dist_col(dist_count/26);
%                 end 
%             end 
          
            ifr_lag= [];
            %Set up lag col (actual lag spacing)
            for i = 1:length(recall(1,:))
                ifr_lag(:,i)= LL-recall(:,i)+i-1;
            end 
            ifr_lag(isnan(recall))=nan;
            ifr_lag= reshape(ifr_lag', numel(ifr_lag),1);
            %ifr_lag= ifr_lag(~isnan(ifr_lag));
            
            
            %Set up subjects ID col: 
            ifr_subj= nan(size(ifr_sp));
            ifr_subj(:,:)= nsubj(subj);
            
            %Set up session ID col: 
            ifr_ses= zeros(size(ifr_sp));
            ifr_ses(:,:)= ses;
            ifr_ses(~rec_mask)= nan;
            %Set up list ID col:
            %correct numel and correct num of NaNs
            ifr_list= std_mat;
            for i = 1:length(ifr_list(:,1))
                ifr_list(i,:)= i;
            end
           
            
            ifr_list(~rec_mask)= nan;
            ifr_list= reshape(ifr_list', numel(ifr_list),1);
            %ifr_list= ifr_list(~isnan(ifr_list));
            
            
            
            %Set up rec itemnos ID col:
            %correct numel and correct num of NaNs
            ifr_itemnos= data.rec_itemnos(ifr_idx,:);
            ifr_itemnos(~rec_mask)=nan;
            %This is also for debugging
            rec_itemnos= ifr_itemnos;
            
            ifr_itemnos= reshape(ifr_itemnos', numel(ifr_itemnos),1);
            %ifr_itemnos= ifr_itemnos(~isnan(ifr_itemnos));
            
            %Find out which ifr lags were ffr
%             ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== nses(ses);
%             ffr_itemnos= data.ffr.rec_itemnos(ffr_idx,:);
% %             ffr_lag= ismember(ifr_itemnos, ffr_itemnos);
% %             ffr_sp= data.ffr.recalled(ffr_idx,:);
%             
%          mask_idx= ismember(ifr_itemnos, ffr_itemnos);
%          ffr_intv= ifr_lag;
%          ffr_intv(~mask_idx)= nan;
         
         ifr_subj(isnan(ifr_rt))=nan;
         
         dist_col(isnan(ifr_rt))= nan;
%          ffr= ffr_lag;
%          ffr= ffr(~isnan(ifr_rt));
          
         %final recognition regressor
         
         frecog= reshape(frecog', numel(frecog),1);
       
         



         ifr_subj= ifr_subj(~isnan(ifr_subj));
         ifr_ses= ifr_ses(~isnan(ifr_ses));
         ifr_list= ifr_list(~isnan(ifr_list));
         frecog= frecog(~isnan(ifr_sp))
         ifr_itemnos= ifr_itemnos(~isnan(ifr_itemnos));
         ifr_rt= ifr_rt(~isnan(ifr_rt));
         ifr_sp= ifr_sp(~isnan(ifr_sp));
         ifr_op= ifr_op(~isnan(ifr_op));
         ifr_lag= ifr_lag(~isnan(ifr_lag));
%          ffr_lag= ffr_lag(~isnan(ffr_lag));
         lag_in= lag_in(~isnan(ifr_sp));
         lag_out= lag_out(~isnan(ifr_sp));
%          lag_transitions= lag_transitions(~isnan(ifr_sp));
%          dist_col= dist_col(~isnan(dist_col));
         
         

%             
%             if ~isequal(size(ifr_sp), size(ndist))
%                 disp('not equal')
%             end 
            %     dist_id{subj, ses}= dist_spec;
%          
                
            all_data{subj, ses}= [ifr_subj, ifr_ses, ifr_list, ifr_itemnos, ifr_rt, ifr_sp, ifr_op, ifr_lag, lag_in, lag_out, frecog];
            %ffr_data{subj, ses}= [ffr_sp, ffr_op, ffr_intv];
            %each subj-ses combination should have 141 indices to start,
            %however, with nans 
           

            %For pulling single sample subject/ses
%             if subj== 1 & ses==1
%                 sample1= [ifr_subj, ifr_ses, ifr_list, ifr_itemnos, ifr_rt, ifr_sp, ifr_op, ifr_lag, ffr_lag, ndist];
%             else
%                 continue
%             end
        end 


    end  
   
        
end 
    
all_data= all_data(~cellfun('isempty', all_data));
all_data= cell2mat(all_data);

%  Save Output
    
   

    savefile= 'newdata_recog.csv';
    

    
    
    %savefile2= [savefile, ".csv"]
    
   
    dlmwrite(savefile, all_data)
    %dlmwrite(savefile2, ffr_data)
    %%
    close all;
data.list= zeros(size(data.subject))
frecog_sp= data
 LL= data.listLength;
 for i = 1:length(nsubj)
     for j= 1:length(nses)
     data.list(data.subject== nsubj(i) & data.session== nses(j))= 1:sum(data.subject== nsubj(i) & data.session== nses(j));
     end 
 end
  recog= data.pres.recognized;
  recog(isnan(recog))= 0;
  
  data.list= repmat(data.list,1,16)
 
 %%
 ffr= data.pres;
 ffr.recalled
 p= spc(data.recalls(:,1:16), data.subject, LL, ffr.recalled)
 %%

 close all
for i = 1:max(data.list)
    pffr{i}= spc(data.recalls, data.subject, LL, recog & data.list==i);

end 

for i = 1:length(pffr)
    npfr{i}= mean(pffr{i});
end 

pfr= cell2mat(npfr);

pfr= reshape(pfr, length(pfr)/LL, LL)
h1= plot(mean(pfr'), '-o')
xlim([1 length(pfr)])
ylim([0.15, 0.5])
h1.Parent.Parent.Color= 'w'
ax= gca;
ax.FontSize= 15
title('Probability of Final Free Recall', 'FontSize', 20)
ylabel('Probability of Recall','FontSize', 15)
xlabel('Serial Position','FontSize', 15)
    
%%
close all;
p= {};
pfrecog= {};
data.pres.recognized(isnan(data.pres.recognized))=0;
recalls= data.recalls(:,1:16);
subjects= data.subject;
rec_frecog= data.recalls(:,1:16);

rec_frecog(~data.pres.recognized)= 0;
data.pres.recognized= logical(data.pres.recognized);

for i = 1:LL
    p{i}= spc(rec_frecog, subjects, LL, data.pres.recognized & data.list== i);
end 
for i = 1:length(p)
    pfrecog{i}= mean(p{i})
end 
    pfr= cell2mat(pfrecog)
    pfr= reshape(pfr, length(pfr)/LL, LL)
    h1= plot(mean(pfr'), '-o')
%%

op= zeros(size(recalls))
for i = 1: length(op(:,1))
    op(i,:)= 1:length(op(1,:));
end

op(recalls<1)= 0;

lag= recalls+op-1;
lag(recalls<1)= nan;
data.list(recalls<1)= 0;
list= data.list;
%%
figure(1)
 subplot(2,1,1)
 h1= histogram(recalls(recalls>0))
 ylim([0,8000])
 xlabel('Serial Position')
title('Initial Recall')
 subplot(2,1,2)
 h2= histogram(recalls(recalls>0 & data.pres.recognized==1))
 ylim([0,8000]) 
 xlabel('Serial Position')
title('Final Recognition')
figure(3)
ifr_sp= h1.Values
recog_sp= h2.Values
close all
figure(2)
plot(recog_sp./ifr_sp, '-o')
xlim([1,16])
title('Probability of Final Recognition ƒ SP') 

%%
 close all
 subplot(2,1,1)
 h1= histogram(op(op>0))
 ylim([0,10000])
 xlabel('Output Position')
title('Initial Recall')
 subplot(2,1,2)
 h2= histogram(op(op>0 & data.pres.recognized==1))
 ylim([0, 10000]) 
 xlabel('Output Position')
title('Final Recognition')
figure(3)
ifr_op= h1.Values
recog_op= h2.Values
close all
figure(2)
plot(recog_op./ifr_op, '-o')
xlim([1,16])
title('Probability of Final Recognition ƒ OP') 
%%

  close all
 subplot(2,1,1)
 h1= histogram(lag(lag>=0 & lag<= 20))
 ylim([0,15000])
 xlabel('Output Position')
title('Initial Recall')
 subplot(2,1,2)
 h2= histogram(lag(lag>0 & data.pres.recognized==1))
 ylim([0,15000]) 
 xlabel('Output Position')
title('Final Recognition')
figure(3)
ifr_lag= h1.Values
recog_lag= h2.Values
close all
figure(2)
plot(recog_lag./ifr_lag, '-o')
xlim([1,16])
title('Probability of Final Recognition ƒ Lag') 

%%  
 close all
 subplot(2,1,1)
 h1= histogram(list(list>0))
 ylim([0,10000])
 xlabel('List Position')
 title('Initial Recall')
 subplot(2,1,2)
 h2= histogram(list(list>0 & data.pres.recognized==1))
 ylim([0,10000]) 
 xlabel('List Position')
 title('Final Recognition')
%  figure(3)
% ifr_list= h1.Values
% recog_list= h2.Values
% close all
% figure(2)
% plot(recog_list./ifr_list, '-o')
% xlim([1,16])
% title('Probability of Final Recognition ƒ List') 

 
 %%
close all
 histogram(all_data(:,end-1))
 histogram(all_data(:, end-2))
 