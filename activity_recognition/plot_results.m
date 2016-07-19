%% plot data w # of folds on x-axis
load accuracyAll.mat
close all
h = figure; hold on;
set(h, 'position', [560   476   582   472]);

n_bootstrap = 100;
folds = {2,[2 10],[2 10 30]}; %# of folds in each run
symb = {'o','^','s'};         %symbol for subjects
% symbcol = {'r','b','m'};      %color for symbol  
linecol = [.47 .77 .19;.95 .33 .1];
markersize = 7;
colors = [.8 0 0; 0 .7 0; 0 0 .8];
hl = [];
for s = 1:length(acc_sw_all)
    hold on
    errorbar(folds{s}+0.0*rand(size(folds{s})),mean((1-acc_sw_all{s})*100,2),1.96*std((1-acc_sw_all{s})*100,[],2)/sqrt(n_bootstrap),'-g','LineWidth',1,'color',linecol(1,:),...
        'Marker',symb{s},'MarkerFaceColor',linecol(1,:),'MarkerEdgeColor',linecol(1,:),'MarkerSize',1)
    
    scatter(folds{s}+0.0*rand(size(folds{s})),mean((1-acc_sw_all{s})*100,2),80,linecol(1,:),'filled',symb{s});
    
    hl(2*s-1) = plot(-10,-10,symb{s},'MarkerFaceColor',linecol(1,:),'MarkerEdgeColor',linecol(1,:),'markersize',8);
    
    errorbar(folds{s}+0.0*rand(size(folds{s})),mean((1-acc_rw_all{s})*100,2),1.96*std((1-acc_rw_all{s})*100,[],2)/sqrt(n_bootstrap),'-r','LineWidth',1,'color',linecol(2,:),...
        'Marker',symb{s},'MarkerFaceColor',linecol(2,:),'MarkerEdgeColor',linecol(2,:),'MarkerSize',1)
    
    scatter(folds{s}+0.0*rand(size(folds{s})),mean((1-acc_rw_all{s})*100,2),80,linecol(2,:),'filled',symb{s});

    hl(2*s) = plot(-10,-10,symb{s},'MarkerFaceColor',linecol(2,:),'MarkerEdgeColor',linecol(2,:),'markersize',8);

end
legend(hl, 'subject-wise 2 subj','record-wise 2 subj','subject-wise 10 subj','record-wise 10 subj','subject-wise 30 subj','record-wise 30 subj')
alpha(.6);
xlabel('Number of Folds')
ylabel('Classification Error (%)')
set(gca, 'fontsize',12);
axis([0 35 0 30]);