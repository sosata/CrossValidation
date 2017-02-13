%% Load data
clear
close all
subjects = [load('./UCIHARDataset/train/subject_train.txt');...
    load('./UCIHARDataset/test/subject_test.txt')];
class = [load('./UCIHARDataset/train/y_train.txt');...
    load('./UCIHARDataset/test/y_test.txt')];
features = [load('./UCIHARDataset/train/X_train.txt');...
    load('./UCIHARDataset/test/X_test.txt')];

Np = size(features,1);
n_subjects = length(unique(subjects));
n_features = size(features,2);
% [subjects_uniq, indsu] = unique(subjects);

n_bootstrap = 100;
ntrees = 50;

n_subjects_run = [10];   %total subjects in each run
n_tests = {[5 1]}; %# of test subjects in each run

acc_sw_all = cell(1,length(n_subjects_run));    %each cell contains results for one run
acc_rw_all = cell(1,length(n_subjects_run));


%loop through selected number of subjects to cross-validate

for s = 1:length(n_subjects_run)
    
    acc_sw = zeros(length(n_tests{s}), n_bootstrap); %initialize variables with all results
    acc_rw = zeros(length(n_tests{s}), n_bootstrap);
    
    for k = 1:length(n_tests{s}),
        
        disp(['Nsubj ', num2str(n_subjects_run(s)), ' - ', 'Run ',num2str(k),'/',num2str(length(n_tests{s}))]);
        
        n_test = n_tests{s}(k); %# of subjects in test fold
        
        n_records = zeros(n_bootstrap,1);   %save # of records for each run
        
        parfor i = 1:n_bootstrap,

            %Subject-wise
            subjects_uniq = randsample(n_subjects,n_subjects_run(s));
            subjects_test = randsample(subjects_uniq,n_test);
            subjects_train = subjects_uniq(~ismember(subjects_uniq,subjects_test));
            
            indtest = find(ismember(subjects,subjects_test));
            n_records(i) = length(indtest);  %# of records
            indtrain = find(ismember(subjects,subjects_train));
            
            features_test = features(indtest,:);
            features_train = features(indtrain,:);
            class_test = class(indtest);
            class_train = class(indtrain);
            
            %classifier
            RF = TreeBagger(ntrees, features_train, class_train);
            [class_pred, ~] = predict(RF, features_test);
            class_pred = str2double(class_pred);
            
            acc_sw(k,i) = mean(class_pred==class_test);
            
            %record-wise
            ind = [indtest;indtrain];
            indtest = randsample(ind,n_records(i));
            indtrain = ind(~ismember(ind,indtest));
            features_test = features(indtest,:);
            features_train = features(indtrain,:);
            class_test = class(indtest);
            class_train = class(indtrain);

            %classifier
            RF = TreeBagger(ntrees, features_train, class_train);
            [class_pred, ~] = predict(RF, features_test);
            class_pred = str2double(class_pred);
            
            acc_rw(k,i) = mean(class_pred==class_test);
        end
        
    end
    
    acc_sw_all{s} = acc_sw;
    acc_rw_all{s} = acc_rw;
    
    save(['accuracy' num2str(n_subjects_run(s)) 'subj.mat'], 'acc_sw', 'acc_rw');
    
end

