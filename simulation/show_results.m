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
    xlabel('cross-subject noise (\it{b})');
    ylabel('within-subject noise (\it{c})');
    
    h = subplot(2,3,cnt+3);
%     set(h, 'position', [.6 plot_vertical_pos(cnt) .3 .2]);
    imagesc((1-acc_sw_)', [0 1]);
    colormap hot;
    set(gca, 'xtick', tick_pos, 'xticklabel', tick_lab, 'fontsize', 14);
    set(gca, 'ytick', tick_pos, 'yticklabel', tick_lab, 'fontsize', 14);
    xlabel('cross-subject noise (\it{b})');
    ylabel('within-subject noise (\it{c})');
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


h = figure;
set(h,'position', [560   500   753   448]);

cnt = 0;
for i = [4 8 12 16 20 24 28 32],
    cnt = cnt+1;
    load(sprintf('error_%dsubject.mat',i));
    rw_mean(cnt) = 1-mean(mean(acc_rw_));
    rw_std(cnt) = std(std(acc_rw_));
    sw_mean(cnt) = 1-mean(mean(acc_sw_));
    sw_std(cnt) = std(std(acc_sw_));
    
end

errorbar(rw_mean,rw_std,'-','linewidth',1, 'color',[.7 0 0]);
hold on;
errorbar(sw_mean,sw_std,'-','linewidth',1, 'color', [0 .55 .55]);
set(gca, 'xtick', 1:8, 'xticklabel', {'4','8','12','16','20','24','28','32'});
xlim([.5 8.5]);
ylim([0 .5]);
xlabel('Number of Subjects');
ylabel('Classification Error');
hl = legend('Record-wise CV','Subject-wise CV','location','northeast');
set(hl, 'fontsize', 14);
set(gca,'fontsize', 14);
box off;



