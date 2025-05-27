root = 'C:\Users\bugeon\Documents\GitHub';
data_repo = [root,'\Survey\Data'];
code_repo =  [root,'\Survey\Code'];
survey_table = 'SurveyResults_curated.xlsx';
feedback_survey_table = 'workshop_feedback_curated.xlsx';
prolific_survey_table = 'SAFE Labs Handbook--Prolific(1-79).xlsx';
commitment_table = 'Commitments.xlsx';
addpath(data_repo);
addpath(genpath(code_repo));
addpath( [root,'\Violinplot-Matlabv2'])
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
OutF = code_repo;