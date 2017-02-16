clear;
close all;

h = figure;
set(h, 'position', [185         238        1204         718]);

tick_pos = [1 10 20];
tick_lab = num2str([0 1 2]');
plot_vertical_pos = [.7 .4 .1];

cnt = 0;
for i=[4 12 32],
    cnt = cnt+1;
    load(sprintf('error_%dsubject.mat',i));
    
    h = subplot(2,3,cnt);
%     set(h, 'position', [.2 plot_vertical_pos(cnt) .3 .2]);
    imagesc((1-acc_rw_)', [0 1]);
    colormap hot;
    set(gca, 'xtick', tick_pos, 'xticklabel', tick_lab, 'fontsize', 14);
    set(gca, 'ytick', tick_pos, 'yticklabel', tick_lab, 'fontsize', 14);
    set(gca, 'ydir', 'normal');
    xlabel('cross-subject variability (\it{b})');
    ylabel('within-subject variability (\it{c})');
    
    h = subplot(2,3,cnt+3);
%     set(h, 'position', [.6 plot_vertical_pos(cnt) .3 .2]);
    imagesc((1-acc_sw_)', [0 1]);
    colormap hot;
    set(gca, 'xtick', tick_pos, 'xticklabel', tick_lab, 'fontsize', 14);
    set(gca, 'ytick', tick_pos, 'yticklabel', tick_lab, 'fontsize', 14);
    xlabel('cross-subject variability (\it{b})');
    ylabel('within-subject variability (\it{c})');
    set(gca, 'ydir', 'normal');
    
end

hc = colorbar('location', 'manual', 'position', [ .945 .2 .023 .3], 'fontsize', 14);
%xlabel(hc, 'Classification Error', 'fontsize', 12);

subplot 231;

text(-8, 10, 'Record-wise', 'fontsize', 18, 'fontweight', 'bold', 'rotation', 90, 'horizontalalignment', 'center');
text(-8, -15, 'Subject-wise', 'fontsize', 18, 'fontweight', 'bold', 'rotation', 90, 'horizontalalignment', 'center');

text(10, 24, '4 Subjects', 'fontsize', 18, 'fontweight', 'bold', 'horizontalalignment', 'center');
text(36, 24, '12 Subjects', 'fontsize', 18, 'fontweight', 'bold', 'horizontalalignment', 'center');
text(63, 24, '32 Subjects', 'fontsize', 18, 'fontweight', 'bold', 'horizontalalignment', 'center');

text(78.5, -3, 'Classification Error', 'rotation', 90, 'fontsize', 14, 'fontweight', 'bold');

text(-10,20,'A','fontsize',22,'fontweight','bold');

h = figure;
set(h,'position', [455   224   753   590]);

cnt = 0;
for i = [4 8 12 16 20 24 28 32],
    cnt = cnt+1;
    load(sprintf('error_%dsubject.mat',i));
    rw_mean(cnt) = 1-mean(mean(acc_rw_));
    rw_std(cnt) = std(acc_rw_(:))/sqrt(400)*2;
    sw_mean(cnt) = 1-mean(mean(acc_sw_));
    sw_std(cnt) = std(acc_sw_(:))/sqrt(400)*2;

    rw_rep_mean(cnt) = 1-mean(mean(acc_rw_rep_));
    rw_rep_std(cnt) = std(acc_rw_rep_(:))/sqrt(400)*2;
    sw_rep_mean(cnt) = 1-mean(mean(acc_sw_rep_));
    sw_rep_std(cnt) = std(acc_sw_rep_(:))/sqrt(400)*2;
    
end

errorbar(rw_mean,rw_std,'-','linewidth',1, 'color',[.7 0 0]);
hold on
errorbar(sw_mean,sw_std,'-','linewidth',1, 'color', [0 0 0]);
errorbar(rw_rep_mean,rw_rep_std,':','linewidth',3, 'color',[1 .65 .65]);
errorbar(sw_rep_mean,sw_rep_std,':','linewidth',3, 'color', [.65 .65 .65]);
set(gca, 'xtick', 1:8, 'xticklabel', {'4','8','12','16','20','24','28','32'});
xlim([.5 8.5]);
ylim([0 .5]);
xlabel('Number of Subjects');
ylabel('Classification Error');
hl = legend('record-wise CV','subject-wise CV','true error (record-wise)','true error (subject-wise)','location','northeast');
errorbar(sw_mean,sw_std,'-','linewidth',1, 'color', [0 0 0]);
set(hl, 'fontsize', 14);
set(gca,'fontsize', 14);
box off;

text(-.5,.5,'B','fontsize',22,'fontweight','bold');