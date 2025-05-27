clear;

%% Analysis of application preferences

data_repo = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Data';
code_repo = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Code';

data_folder = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Data';
addpath(data_folder);

addpath(genpath(code_repo));

%%
load('workshop_topics.mat');
load('workshop_formats.mat');

topic_labels = {'Recruitment', 'Funding', 'EDI', 'Team Management', 'Sustainable Research', 'Institutional Policy', 'Career Development', 'Encouraging Feedback'};
format_labels = {'Open forum', 'Subgroup discuss', 'Ask me anything with expert', 'Brainstorm case study', 'Presentation from expert'};
%%

[nA nT] = size(topics);

topics = zscore(topics, [], 2); 
ave_topic = mean(topics);
std_topic = std(topics)/sqrt(nA);

[nA nF] = size(formats);

formats = zscore(formats, [], 2); 
ave_formats = mean(formats);
std_formats = std(formats)/sqrt(nA);


figure; 
subplot(1,2,1)
bar(1:nT, ave_topic, 0.8, 'FaceColor', 'k', 'EdgeColor', 'k'); hold on
errorbar(1:nT, ave_topic, std_topic, '.k')
set(gca, 'XtickLabel', topic_labels)
formatAxes
ylabel('Applicants preference zscore')
title('SAFE topics')

subplot(1,2,2)
bar(1:nF, ave_formats, 0.8, 'FaceColor', 'k', 'EdgeColor', 'k'); hold on
errorbar(1:nF, ave_formats, std_formats, '.k')
set(gca, 'XtickLabel', format_labels)
formatAxes
title('SAFE formats')

%% demographics

nationality = categorical({'Denmark', 'Austria', 'Italy', 'Italy', 'Czheck Rep', 'Italy', 'France',...
    'Ireland', 'Netherlands', 'Germany', 'France', 'Italy', 'Belgium', 'France', 'Italy',...
    'Netherlands', 'Italy', 'Netherlands', 'France', 'UK', 'France'});
nationality = reordercats(nationality, {'Italy', 'France', 'Belgium', 'UK', 'Germany', 'Netherlands', 'Ireland', 'Czheck Rep', 'Austria', 'Denmark'});

nationality_adm = categorical({ 'Italy', 'Italy','UK', 'Germany', 'France', 'Netherlands', 'Belgium', 'Ireland', 'Austria'});
nationality_adm = reordercats(nationality_adm, {'Italy','UK', 'Germany', 'France', 'Netherlands', 'Belgium', 'Ireland', 'Austria'});



figure; 
subplot(1,2,1)
pie(nationality);
formatAxes
title('Application institution country')

subplot(1,2,2)
pie(nationality_adm);
formatAxes
title('Selected institution country')

%% Analysis of workshop feedback

data_repo = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Data';
code_repo = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Code';

data_folder = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Data';
addpath(data_folder);

addpath(genpath(code_repo));

opts = detectImportOptions(fullfile(data_folder, "workshop_feedback.csv"));
preview(fullfile(data_folder, "workshop_feedback.csv"),opts)

fb = readmatrix(fullfile(data_folder, "workshop_feedback.csv"));

%%

mean_fb = mean(fb, 1);
std_fb = std(fb, [], 1);

figure('Position',[295 296 854 420])


subplot(2, 1,1)
barh(1:7, mean_fb(1:7), 'k'); hold on
% errorbar(mean_fb(1:7),1:7,std_fb(1:7),'.k','horizontal');
plot(fb(:, 1:7), repmat(1:7,9,1) + randn(size(fb(:, 1:7)))/10, 'or'); hold on


set(gca, 'XTick', [1:5], 'YTickLabel', {'Did SAFE Labs meet your overall expectations?',...
    'SAFE Labs was a unique meeting that fulfilled an important niche',...
    'Discussions were productive and participants were respectful of each other s opinions',...
    'I learnt something new that I intend to implement in my own lab',...
    'I will change a practice in my lab as a result of attending SAFE Labs',...
    'I will share the outcomes with colleagues in my institution',...
    'I think future iterations of SAFE Labs would be useful for other new PIs'})

formatAxes
title('How much would you agree with the following statements?')


subplot(2, 1,2)
 
barh(1:7, mean_fb(18:24), 'k'); hold on
% errorbar(mean_fb(18:24),1:7,std_fb(18:24),'.k','horizontal');
plot(fb(:, 18:24), repmat(1:7,9,1) + randn(size(fb(:, 18:24)))/10, 'or'); hold on


set(gca, 'XTick', [1:5], 'YTickLabel', {'Team Management',...
    'Encouraging Feedback',...
    'Career Development',...
    'Recruitment',...
    'EDI',...
    'Sustainability/Work Life Balance',...
    'Case Studies'})

formatAxes
title('Please indicate how useful you found each of the sessions')















