% Column 1 0-0: IFR: 1, Column 2: 0
% Column 1 0-8: DFR: 2, Column 2: 8
% Column 1 0-16: DFR: 2, Column 2: 16


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


ifr_mask= make_clean_recalls_mask2d(data.recalls);


dist_spec= [];
all_data= [];
nses= unique(data.session);
std_mat= zeros(size(data.recalls(data.subject== nsubj(1) & data.session== nses(1),:)));
for subj = 1:length(nsubj)
    for ses= 1:length(unique(data.session))
        
        ifr_idx= data.subject==nsubj(subj) & data.session== nses(ses);
        if ~isempty(data.recalls(ifr_idx,:))

        
           
            %Set up serial position col:
            %correct numel and correct num of NaNs
            ifr_sp= data.recalls(ifr_idx,:);
            k= ifr_sp;
            
            %this is separate from ifr_sp for debugging, because ifr_sp is
            %reshaped
            recall= ifr_sp;
            recall(recall<1)=nan;
            
           
            rec_mask= ifr_sp>0; %mask for intrusions and misses
            ifr_sp(~rec_mask)=nan;
            ifr_sp= reshape(ifr_sp', numel(ifr_sp),1);
            %ifr_sp= ifr_sp(~isnan(ifr_sp));
            
            %Set up output position col:
            %correct numel and correct num of NaNs 
            ifr_op= std_mat;
            for i = 1:length(ifr_op(1,:))
                
                ifr_op(:,i)= i;
            end
            
            ifr_op(~rec_mask)=nan;
            ifr_op= reshape(ifr_op', numel(ifr_op),1);
            %ifr_op= ifr_op(~isnan(ifr_op));
            
            
            %Set up CDFR and DFR col: 
            %1= IFR, 2= DFR short, 3= DFR long, 4= CDFR short, 5 = CDFR
            %long
            
         dist_cond= [data.pres.distractor(ifr_idx,:), data.pres.final_distractor(ifr_idx,:)];
            
            
            % Column 1 0-0: IFR: 1, Column 2: 0
            % Column 1 0-8: DFR: 2, Column 2: 8
            % Column 1 0-16: DFR: 3, Column 2: 16
            % Column 1 8-8: CDFR: 4, Column 2: 0
            % Column 1 16-16: CDFR: 5, Column 2: 8

            for dist_idx= 1:length(d)
                if dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)==0
                    dist_col(dist_idx)= 1 %ifr
                elseif dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)== 8000
                    dis_col(dist_idx)= 2 %dfr short
                elseif dist_cond(dist_idx,1)== 0 & dist_cond(dist_idx,2)== 16000
                    dis_col(dist_idx)= 3 %dfr long
                elseif dist_cond(dist_idx,1)== 8000 & dist_cond(dist_idx,2)== 8000
                    dis_col(dist_idx)= 4 %cdfr short
                elseif dist_cond(dist_idx,1)== 16000 & dist_cond(dist_idx,2)== 16000
                    dis_col(dist_idx)= 5 %dfr short
                end 
            end 
            
            
            for dist_idx = 1:length(dist_cond(:,1))
                
            end
            
            ndist= repmat(dist_spec', 1,length(k(1,:)));
%             ndist(~rec_mask)= nan;
            ndist= reshape(ndist, numel(ndist), 1);
            %ndist= ndist(~isnan(ndist));
            %Set up response times col: 
            %correct numel and correct num of NaNs 
            ifr_rt= data.times(ifr_idx,:);
            ifr_rt(~rec_mask)=nan;
            ifr_rt= reshape(ifr_rt', numel(ifr_rt),1);
            %ifr_rt= ifr_rt(~isnan(ifr_rt));
            
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
            ffr_idx= data.ffr.subject== nsubj(subj) & data.ffr.session== nses(ses);
            ffr_itemnos= data.ffr.rec_itemnos(ffr_idx,:);
            ffr_lag= ismember(ifr_itemnos, ffr_itemnos);
            ffr_sp= data.ffr.recalled(ffr_idx,:);
            
         mask_idx= ismember(ifr_itemnos, ffr_itemnos);
         ffr_intv= ifr_lag;
         ffr_intv(~mask_idx)= nan;
      
         

            
%             if ~isequal(size(ifr_sp), size(ndist))
%                 disp('not equal')
%             end 
            %     dist_id{subj, ses}= dist_spec;
%          
%                 
            all_data{subj, ses}= [ifr_subj, ifr_ses, ifr_list, ifr_itemnos, ifr_rt, ifr_sp, ifr_op, ifr_lag, ffr_lag, ndist];
            


        end 
    end 

            
        
end 
    
all_data= all_data(~cellfun('isempty', all_data));
% ffr_data= ffr_data(~cellfun('isempty', ffr_data));
all_data= cell2mat(all_data);