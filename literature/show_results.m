clear;
close all;

h = figure;
set(h, 'position', [179.4000  296.2000  899.2000  420.0000]);

%% plotting accuracies

subplot 121;

good = 100 - [nan 82.8 95 87 87 95.81 99.78 95 61 nan 86.7 nan 86.2 85 86.2 nan 89 78.6 96 89.8 90 nan 96.7 nan 91.8 nan 73.14 nan 90.6 60 78.4 nan 83.6 68.75];
bad = 100 - [93.3 100 96.12 nan 80 96.4 97.5 82.4 93.5 99.3 97.5 nan 72.7 nan 99.9 98 85.2 94.4 88 88 nan 94 97.3 92.4 95.1 nan 91.4 99.6 ];

hold on;
plot(ones(size(good))+.1*rand(size(good))-.05, good, '.', 'markersize', 10, 'color', [.47 .77 .19]);
plot(2*ones(size(bad))+.1*rand(size(bad))-.05, bad, '.', 'markersize', 10, 'color', [.95 .33 .1]);

boxplot(good', 'positions', 1, 'whisker', 0, 'colors', 'k');
boxplot(bad', 'positions', 2, 'whisker', 0, 'colors', 'k');
h=findobj(gca,'tag','Outliers');
set(h, 'visible', 'off');

plot([1.05 1.05], [prctile(good,80) 30], ':k');
plot([1.95 1.95], [prctile(bad,90) 30], ':k');
plot([1.05 1.95], [30 30], ':k');
text(1.5, 33, sprintf('** P = %.4f', ranksum(good, bad)), 'horizontalalignment', 'center');

text(1.1, nanmedian(good), sprintf('%.2f%%',nanmedian(good)));
text(2.1, nanmedian(bad), sprintf('%.2f%%',nanmedian(bad)));

set(gca, 'xtick', [1 2], 'xticklabel', {sprintf('Subject-wise (%d)',sum(~isnan(good))), sprintf('Record-wise (%d)',sum(~isnan(bad)))});
% xlabel('Cross-Validation');
ylabel('Reported Classification Error (%)');
xlim([0.5 2.5]);
ylim([0 max([good,bad])]);
box off;

%% plotting citations

subplot 122;

good = [107 99 45 44 26 23 23 23 22 22 18 18 18 18 17 13 11 10 10 8 8 6 5 4 4 4 4 3 3 2 2 2 2 2];
bad = [142 62 49 42 21 18 18 17 15 15 12 10 9 9 9 6 6 6 5 5 4 3 3 2 2 2 2 2];

hold on;
plot(ones(size(good))+.1*rand(size(good))-.05, good, '.', 'markersize', 10, 'color', [.47 .77 .19]);
plot(2*ones(size(bad))+.1*rand(size(bad))-.05, bad, '.', 'markersize', 10, 'color', [.95 .33 .1]);

boxplot(good', 'positions', 1, 'whisker', 0, 'colors', 'k');
boxplot(bad', 'positions', 2, 'whisker', 0, 'colors', 'k');
h=findobj(gca,'tag','Outliers');
set(h, 'visible', 'off');


% plot([1.05 1.05], [prctile(good,75) 30], ':k');
% plot([1.95 1.95], [prctile(bad,75) 30], ':k');
% plot([1.05 1.95], [30 30], ':k');
% text(1.5, 33, sprintf('P = %.4f', ranksum(good, bad)), 'horizontalalignment', 'center');

text(1.1, median(good), sprintf('%.2f',median(good)));
text(2.1, median(bad), sprintf('%.2f',median(bad)));

set(gca, 'xtick', [1 2], 'xticklabel', {sprintf('Subject-wise (%d)',length(good)), sprintf('Record-wise (%d)',length(bad))});
% xlabel('Cross-Validation');
ylabel('Number of Citations');
xlim([0.5 2.5]);
ylim([0 max([good,bad])]);

box off;
