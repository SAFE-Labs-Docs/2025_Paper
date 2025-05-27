loadSurveyData;
%% Specify the path to data and code (CHANGE AS NEEDED)

clear; 

data_repo = 'C:\Users\bugeon\Documents\GitHub\Survey/Data';
code_repo = 'C:\Users\bugeon\Documents\GitHub\Survey/Code';
survey_table = 'SurveyResults_curated.xlsx';
feedback_survey_table = 'workshop_feedback_curated.xlsx';
addpath(data_repo);
addpath(genpath(code_repo));
%% Import the data using readtable (works well for Excel files)

data = io.importSurvey(data_repo,survey_table);
%%  Parse the table for demographics and answers

% returns a table with demographic data
[dgs, dgs_labels] = io.parseDGs(data);

% returns a structure with the answers to the questions and labels
% summarising the questions
answ = io.parseQuestions(data);


%% Do some basic plotting
options.Sort = 0;
options.PI_only = 0;

% plots pie charts with demographics
plt.dgspie(dgs);

% plots histograms and distributions of answers

[sorted_imp_indices,sorted_est_indices] = plt.anshist(answ);
% split histograms by role
plt.anshist(answ,dgs, 'CurrentRole', {'PI' ; 'PhD Student' ; 'Postdoc'},sorted_imp_indices,sorted_est_indices);
%%
% plots histograms divided by demographic category of choice. You can
% select which categories to plot for clarity
plt.ansbycat(answ, dgs, 'Country', {'United Kingdom' ; 'Italy' ; 'France'});
% questions are sorted by the difference between PI and others, labels in
% bold indicate the questions for which we ask whether to publicly document or not
plt.ansbycat(answ, dgs, 'CurrentRole', {'PI' ; 'PhD Student' ; 'Postdoc'}, options);
options.PI_only = 1;
options.Sort = 0;
plt.ansbycat(answ, dgs, 'YearsInRole',{'<1','1-2','2-3','3-4','4+'},options);

% plots correlation of answers split by demographic category. 
plt.answcorr(answ, dgs, 'CurrentRole');
plt.answcorr(answ, dgs, 'Country');

% UMAP projection of data (still playing with pars)
plt.UMAPproj(answ, dgs, 'CurrentRole', {'euclidean', 0.1, 7});
plt.UMAPproj(answ, dgs, 'YearsInRole', {'euclidean', 0.1, 7});
plt.UMAPproj(answ, dgs, 'Country', {'euclidean', 0.1, 7});
% PCA projection of data
plt.PCAproj(answ, dgs, 'CurrentRole')

%% SAFE labs meeting 2024 - feedback survery results
plt.feedbackSummary(data_repo,feedback_survey_table)

%% initial formats and topics preference for applicants - missing the question labels! 
load(fullfile(data_repo,'workshop_topics.mat'))
load(fullfile(data_repo,'workshop_formats.mat'))