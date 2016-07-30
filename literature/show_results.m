clear;
close all;

h = figure;
set(h, 'position', [179.4000  296.2000  899.2000  420.0000]);

%% plotting accuracies

subplot 121;

acc_swcv = 100 - [nan 82.8 95 87 87 95.81 99.78 95 61 nan 86.7 nan 86.2 85 86.2 nan 89 78.6 96 89.8 90 nan 96.7 nan 91.8 nan 73.14 nan 90.6 60 78.4 nan 83.6 68.75];
acc_rwcv = 100 - [93.3 100 96.12 nan 80 96.4 97.5 82.4 93.5 99.3 97.5 nan 72.7 nan 99.9 98 85.2 94.4 88 88 nan 94 97.3 92.4 95.1 nan 91.4 99.6 ];
ncite_swcv = [107 99 45 44 26 23 23 23 22 22 18 18 18 18 17 13 11 10 10 8 8 6 5 4 4 4 4 3 3 2 2 2 2 2];
ncite_rwcv = [142 62 49 42 21 18 18 17 15 15 12 10 9 9 9 6 6 6 5 5 4 3 3 2 2 2 2 2];

hold on;
plot(ones(size(acc_swcv))+.1*rand(size(acc_swcv))-.05, acc_swcv, '.', 'markersize', 10, 'color', [.47 .77 .19]);
plot(2*ones(size(acc_rwcv))+.1*rand(size(acc_rwcv))-.05, acc_rwcv, '.', 'markersize', 10, 'color', [.95 .33 .1]);

boxplot(acc_swcv', 'positions', 1, 'whisker', 0, 'colors', 'k');
boxplot(acc_rwcv', 'positions', 2, 'whisker', 0, 'colors', 'k');
h=findobj(gca,'tag','Outliers');
set(h, 'visible', 'off');

plot([1.05 1.05], [prctile(acc_swcv,80) 30], ':k');
plot([1.95 1.95], [prctile(acc_rwcv,90) 30], ':k');
plot([1.05 1.95], [30 30], ':k');
text(1.5, 33, sprintf('** P = %.4f', ranksum(acc_swcv, acc_rwcv)), 'horizontalalignment', 'center');

text(1.1, nanmedian(acc_swcv), sprintf('%.2f%%',nanmedian(acc_swcv)));
text(2.1, nanmedian(acc_rwcv), sprintf('%.2f%%',nanmedian(acc_rwcv)));

set(gca, 'xtick', [1 2], 'xticklabel', {sprintf('Subject-wise (%d)',sum(~isnan(acc_swcv))), sprintf('Record-wise (%d)',sum(~isnan(acc_rwcv)))});
% xlabel('Cross-Validation');
ylabel('Reported Classification Error (%)');
xlim([0.5 2.5]);
ylim([0 max([acc_swcv,acc_rwcv])]);
box off;

text(0,40,'A','fontsize',18,'fontweight','bold');

%% plotting citations

subplot 122;

hold on;
plot(ones(size(ncite_swcv))+.1*rand(size(ncite_swcv))-.05, ncite_swcv, '.', 'markersize', 10, 'color', [.47 .77 .19]);
plot(2*ones(size(ncite_rwcv))+.1*rand(size(ncite_rwcv))-.05, ncite_rwcv, '.', 'markersize', 10, 'color', [.95 .33 .1]);

boxplot(ncite_swcv', 'positions', 1, 'whisker', 0, 'colors', 'k');
boxplot(ncite_rwcv', 'positions', 2, 'whisker', 0, 'colors', 'k');
h=findobj(gca,'tag','Outliers');
set(h, 'visible', 'off');


% plot([1.05 1.05], [prctile(ncite_swcv,75) 30], ':k');
% plot([1.95 1.95], [prctile(ncite_rwcv,75) 30], ':k');
% plot([1.05 1.95], [30 30], ':k');
% text(1.5, 33, sprintf('P = %.4f', ranksum(ncite_swcv, ncite_rwcv)), 'horizontalalignment', 'center');

text(1.1, median(ncite_swcv), sprintf('%.2f',median(ncite_swcv)));
text(2.1, median(ncite_rwcv), sprintf('%.2f',median(ncite_rwcv)));

set(gca, 'xtick', [1 2], 'xticklabel', {sprintf('Subject-wise (%d)',length(ncite_swcv)), sprintf('Record-wise (%d)',length(ncite_rwcv))});
% xlabel('Cross-Validation');
ylabel('Number of Citations');
xlim([0.5 2.5]);
ylim([0 max([ncite_swcv,ncite_rwcv])]);
box off;

text(0,140,'B','fontsize',18,'fontweight','bold');
