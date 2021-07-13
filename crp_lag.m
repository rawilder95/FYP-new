clc
clear all;
recall= [8     7     1     2     3     5     6     4];

real_transitions= [];
p_transitions= []; %possible positive
n_transitions= [];% posible negative
beenrecalled= [];
LL= 8; % LJL added semicolon to suppress output :)

for idx= 1:LL-1
    %Matches the website sample
    real_transitions(idx)= recall(idx+1)-recall(idx);
end

total_transitions= [(LL-1)*-1:-1,1:LL-1];
get_count= zeros(size(total_transitions));

 % so far so good
 ntrange= zeros(LL-1,LL-1);

 for idx= 1:LL
  
     
     ntrange(idx, 1:length((1:LL)-recall(idx)))= (1:LL)-recall(idx);
     
     thisrow= ntrange(idx,:);
     beenrecalled= recall(1:idx-1);
     if ~isempty(beenrecalled)
         dnc= beenrecalled-recall(idx);
          thisrow(ismember(thisrow, dnc))=0;
     end
     
      ntrange(idx, 1:length((1:LL)-recall(idx)))= thisrow;
     
 end
    


for i = 1:length(total_transitions)
    %matches!
    get_count(i)= sum(sum(real_transitions==total_transitions(i)));
    count_trans(i,:)= [total_transitions(i),count(ntrange,total_transitions(i))];
end

count_trans(:,3)= get_count';
prob_trans= count_trans(:,3)./count_trans(:,2);
plot_prob= [prob_trans(1:length(prob_trans)/2)',NaN,prob_trans(length(prob_trans)/2+1:end)'];
plot_prob(isnan(plot_prob))=0;
close all
plot(plot_prob, '-o');
xlabel('Lag');
ylabel('Conditional Response Probability')
to_label= [-7:2:7];
xticks([1:2:(LL-1)*2]);
xticklabels(to_label);
title('CRP: Single-Trial Example')




