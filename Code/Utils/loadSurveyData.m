%% Specify the path to data and code (CHANGE AS NEEDED)
setPaths_LFR;
%% Import the data using readtable (works well for Excel files)

data = io.importSurvey(data_repo,survey_table);
dataProl = readtable(fullfile(data_repo, prolific_survey_table),'VariableNamingRule','preserve');
dataProl(~strcmp(dataProl.('Are you currently a PhD Student'),'Yes'),:) = [];

%%  Parse the table for demographics and answers

% returns a table with demographic data
[dgs, dgs_labels] = io.parseDGs(data);

% returns a structure with the answers to the questions and labels
% summarising the questions
answ = io.parseQuestions(data);

%%
colour.Teams     = [235, 120, 140];     % Rose
colour.Policies   = [180, 130, 215]; % Purple
colour.Careers   = [245, 160, 105];    % As fractions: [0.96, 0.63, 0.41]
colour.PI     = [50, 120, 220];   % As fractions: [0.39, 0.67, 0.92]
colour.PostDoc    = [215, 125, 20];  % As fractions: [0.43, 0.78, 0.61]
colour.PhD     = [145, 35, 170];   % As fractions: [0.37, 0.75, 0.75]
colour.RA    = [220, 190, 60];    % As fractions: [0.75, 0.49, 0.63]
colour.All    = [0, 0, 0];    % As fractions: [0.75, 0.49, 0.63]

%% get commitments full statement

comm = table2cell(readtable(fullfile(data_repo, commitment_table),'ReadVariableName',false))';
% comm = [table2cell(comm)',answ.question_labels];