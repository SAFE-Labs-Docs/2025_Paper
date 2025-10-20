clear;
% 
% %% Analysis of application preferences
% 
% data_repo = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Data';
% code_repo = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Code';
% 
% data_folder = '/Users/federico/Documents/GitHub/SAFELabs/Survey/Data';
% addpath(data_folder);
% 
% addpath(genpath(code_repo))

%% Set Paths

%path to the code
code_repo = 'D:\OneDrive - Fondazione Istituto Italiano Tecnologia\Documents\Code\2025_bioRxiv\Code';
addpath(genpath(code_repo));
%let's set all the other paths
setPaths_LFR;
data_folder = data_repo;
%% load application data
load('workshop_topics.mat');
load('workshop_formats.mat');

topic_labels = {'Recruitment', 'Funding', 'EDI', 'Team Management', 'Sustainable Research', 'Institutional Policy', 'Career Development', 'Encouraging Feedback'};
format_labels = {'Open forum', 'Subgroup discuss', 'Ask me anything with expert', 'Brainstorm case study', 'Presentation from expert'};

%% Topics selection

[nA nT] = size(topics);

ave_topic = mean(topics);
std_topic = std(topics)/sqrt(nA);
[~,idx] = sort(ave_topic, "ascend");

sort_ave_topic = ave_topic(idx);
sort_std_topic = std_topic(idx);
sort_topic_labels = topic_labels(idx);

[nA nF] = size(formats);

ave_formats = mean(formats);
std_formats = std(formats)/sqrt(nA);
[~,idx]  = sort(ave_formats, "ascend");

sort_ave_formats = ave_formats(idx);
sort_std_formats = std_formats(idx);
sort_format_labels = format_labels(idx);


%% Demographics

% these are the responses, hardcoded here since it was quicker than parsing
% the survey again
nationality = categorical({'Denmark', 'Austria', 'Italy', 'Italy', 'Czheck Rep', 'Italy', 'France',...
    'Ireland', 'Netherlands', 'Germany', 'France', 'Italy', 'Belgium', 'France', 'Italy',...
    'Netherlands', 'Italy', 'Netherlands', 'France', 'UK', 'France'});
nationality = reordercats(nationality, {'Italy', 'France', 'Netherlands','UK', 'Germany',  'Belgium', 'Ireland', 'Austria','Czheck Rep',  'Denmark'});

nationality_adm = categorical({ 'Italy', 'Italy','UK', 'Germany', 'France', 'Netherlands', 'Belgium', 'Ireland', 'Austria'});
nationality_adm = reordercats(nationality_adm, {'Italy', 'France', 'Netherlands','UK', 'Germany',  'Belgium', 'Ireland', 'Austria'});

% these are the responses extracted from open answers
rfield = {'Ecology & Evolution',...
    'Immuno & Microbiology',...
    'Neuro & Behavior',...
    'Developmental',...
    'Cell & Molecular',...
    'Neuro & Behavior',...
    'Ecology & Evolution',...
    'Neuro & Behavior',...
    'Neuro & Behavior',...
    'Cell & Molecular',...
    'Neuro & Behavior',...
    'Cell & Molecular',...
    'Neuro & Behavior',...
    'Neuro & Behavior',...
    'Cancer',...
    'Cell & Molecular'...
    'Immuno & Microbiology',...
    'Ecology & Evolution', ...
    'Neuro & Behavior'...
    'Cancer'};

rfield_adm = {'Neuro & Behavior', 'Neuro & Behavior', 'Neuro & Behavior', ...
    'Neuro & Behavior', 'Developental', 'Cell & Molecular', 'Immuno & Microbiology', ...
    'Cancer', 'Ecology & Evolution', 'Immuno & Microbiology'};

% fields chosen in the main survey
daf = {'Neuro & Behavior', 'Cell & Molecular', ...
    'Cancer', 'Developmental', 'Immuno & Microbiology', 'Synthetic & Structural',...
    'Other', 'Ecology & Evolution', 'Plants', 'Bionformatics'};

for iF = 1:numel(daf)
    rfield_count(iF)= sum(cell2mat(strfind(rfield, daf{iF})));
end


for iF = 1:numel(daf)
    rfield_count_adm(iF)= sum(cell2mat(strfind(rfield_adm, daf{iF})));
end

countries = categories(nationality);
country_count = countcats(nationality);
country_count = 100*country_count/sum(country_count);
[~, idx] = sort(country_count, "descend");
sort_country_count = country_count(idx);
sort_countries = countries(idx);

countries_adm = categories(nationality_adm);
country_count_adm = countcats(nationality_adm);
country_count_adm = 100*country_count_adm/sum(country_count_adm);


country_count_adm_padded = zeros(size(country_count));
country_count_adm_padded(1:numel(country_count_adm)) = country_count_adm;
sort_country_count_adm_padded = country_count_adm_padded;

rfield_count = 100*rfield_count/sum(rfield_count);
[~, idx] = sort(rfield_count, "descend");
sort_rfield_count = rfield_count(idx);
sort_rfield = daf(idx);


rfield_count_adm = 100*rfield_count_adm/sum(rfield_count_adm);
sort_rfield_count_adm = rfield_count_adm(idx);
%% Analysis of workshop feedback

opts = detectImportOptions(fullfile(data_folder, "workshop_feedback.csv"));
preview(fullfile(data_folder, "workshop_feedback.csv"),opts)

fb = readmatrix(fullfile(data_folder, "workshop_feedback.csv"));

statements = {'Did SAFE Labs meet your overall expectations?',...
    'SAFE Labs was a unique meeting \n that fulfilled an important niche',...
    'Discussions were productive and \n participants were respectful of opinions',...
    'I learnt something new that I \n intend to implement in my own lab',...
    'I will change a practice in my \n lab as a result of attending SAFE Labs',...
    'I will share the outcomes with \n colleagues in my institution',...
    'Future iterations of SAFE Labs \n would be useful for other new PIs'};

sessions = {'Team Management',...
    'Encouraging Feedback',...
    'Career Development',...
    'Recruitment',...
    'EDI',...
    'Sustainability/Work Life Balance',...
    'Case Studies'};


mean_fb = mean(fb, 1);
std_fb = std(fb, [], 1);

statements_eval = mean_fb(1:7);
sessions_eval = mean_fb(18:24);
std_statements = std_fb(1:7);
std_sessions= std_fb(18:24);

[~, idx_st] = sort(statements_eval, 'ascend');
[~, idx_ses] = sort(sessions_eval,'ascend');

statements_eval_sort = statements_eval(idx_st);
std_statements_sort = std_statements(idx_st);

sessions_eval_sort = sessions_eval(idx_ses);
std_sessions_sort = std_sessions(idx_ses);

statements_sort= statements(idx_ses);
sessions_sort= sessions(idx_ses);

%%

data = readtable(fullfile(data_repo, internal_handbook_survey),'VariableNamingRule','preserve');

comm_str = table2cell(readtable(fullfile(data_repo, commitment_table),'ReadVariableName',false))';

[numResp, numCols] = size(data);

question_labels = io.getQLab();

publ_idx = find(contains(data.Properties.VariableNames, 'Should it be'));
Q_comm_idx = publ_idx-2;
comm_idx = find(contains(data.Properties.VariableNames, 'I commit'));

[~, comm_order] = intersect(comm_idx, Q_comm_idx);


for iQ = 1:numel(publ_idx)

ifPublic(:, iQ) = io.public2num(data.(data.Properties.VariableNames{publ_idx(iQ)}));

end

Q_comm = question_labels(comm_order);

shouldbeP = sum(ifPublic, 1)./size(ifPublic, 1);
[~, Pidx] = sort(shouldbeP, 'ascend');
shouldbeP_sort =shouldbeP(Pidx);
Q_comm_sort =Q_comm(Pidx);

%%
addpath('/Users/federico/Documents/GitHub/SAFELabs/Survey/Code/Utils')

default_figure([1 1 16 4]);

subplot(1,4,1)
plot([0 nT+1], [4 4], '--r');hold on;
errorbar(1:nT, sort_ave_topic, sort_std_topic, 'o','Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:nT ],'XtickLabel', sort_topic_labels, 'XTickLabelRotation', 45)
ylim([1 5])
xlim([0 nT+1])
formatAxes
ylabel('Average score')
title('SAFE topics')

annotation('textbox',[0.1 0.9 0.05 0.05], ...
    'String','a','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')

subplot(1,4,2)
plot([0.5 nF+0.5], [4 4], '--r');hold on;
errorbar(1:nF, sort_ave_formats, sort_std_formats, 'o','Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:nF], 'XtickLabel', sort_format_labels, 'XTickLabelRotation', 45);
formatAxes
ylim([1 5])
xlim([0.5 nF+0.5])
title('SAFE formats')
annotation('textbox',[0.32 0.9 0.05 0.05], ...
    'String','b','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')


subplot(1,4,3)

% plot(1:numel(countries), sort_country_count, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', [0.6 0.6 0.6]); hold on
% plot(1:numel(countries), sort_country_count_adm_padded, 'o', 'Color', [0 0 0], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k'); hold on
bar(1:numel(countries), sort_country_count_adm_padded, 0.8, 'k'); hold on
set(gca, 'Xtick', 1:numel(countries), 'XTicklabels', sort_countries, 'XTickLabelRotation', 45)
ylim([0 45])
formatAxes
ylabel('% participants')
% legend('Application')
annotation('textbox',[0.52 0.9 0.05 0.05], ...
    'String','c','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')


subplot(1,4,4)

% plot(1:numel(daf), sort_rfield_count, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', [0.6 0.6 0.6]); hold on
% plot(1:numel(daf), sort_rfield_count_adm, 'o', 'Color', [0 0 0], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k');hold on
bar(1:numel(daf), sort_rfield_count_adm, 0.8, 'k');hold on
set(gca, 'Xtick', 1:numel(daf), 'XTicklabels', sort_rfield, 'XTickLabelRotation', 45)
ylim([0 45])
formatAxes
ylabel('% participants')
% legend('Application')
annotation('textbox',[0.72 0.9 0.05 0.05], ...
    'String','d','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')

%%

% statements_sort_split1  = {'Did SAFE Labs meet your',...
%     'I will share the outcomes with',...
%     'Future iterations of SAFE Labs',...
%     'SAFE Labs was a unique meeting',...
%     'I learnt something new that I',...
%     'I will change a practice in my',...
%     'Discussions were productive and'};
%
% statements_sort_split2  = {'overall expectations?',...
%     'colleagues in my institution',...
%     'would be useful for other new PIs',...
%     'that fulfilled an important niche',...
%     'intend to implement in my own lab',...
%     'lab as a result of attending SAFE Labs',...
%     'participants were respectful of opinions'};

% these shenanigans are needed to add carriage return to axis ticks labels
global_split1  = {'Did SAFE Labs meet your'};
global_split2  = {'overall expectations?'};
global_sort_split = [global_split1; global_split2];
global_sort_split = strjust(pad(global_sort_split),'right'); % 'left'(default)|'right'|'center
globalLabels = strtrim(sprintf('%s\\newline%s\n', global_sort_split{:}));


statements_sort_split1  = {'I will share the outcomes with',...
    'Future iterations of SAFE Labs',...
    'SAFE Labs was a unique meeting',...
    'I learnt something new that I',...
    'I will change a practice in my',...
    'Discussions were productive and'};

statements_sort_split2  = {'colleagues in my institution',...
    'would be useful for other new PIs',...
    'that fulfilled an important niche',...
    'intend to implement in my own lab',...
    'lab as a result of attending SAFE Labs',...
    'participants were respectful of opinions'};

statements_sort_split = [statements_sort_split1; statements_sort_split2];
% To use right or center justification,
statements_sort_split = strjust(pad(statements_sort_split),'right'); % 'left'(default)|'right'|'center
tickLabels = strtrim(sprintf('%s\\newline%s\n', statements_sort_split{:}));

% plot
% figure ('Position', [2.1528 3.4722 7.3333 5.5556]);
default_figure([1 1 16 7]);

ax1 = subplot(10, 10, [2,3]);
plot([3 3], [0.5 1.5], '--r');hold on;
errorbar(statements_eval_sort(1),1,std_statements_sort(1),'ok','horizontal', 'Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:5], 'YTick',  [1],'YTickLabel',globalLabels)
xlabel('Score')
xlim([1 6])
ylim([0.5 1.5])
formatAxes
title('Overall eval')
annotation('textbox',[0.02 0.93 0.05 0.05], ...
    'String','a','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')

ax2= subplot(10, 10,  sort([22:10:80, 23:10:80], 'ascend'))
plot([3 3], [1.5 7.5], '--r');hold on;
errorbar(statements_eval_sort(2:7),2:7,std_statements_sort(2:7),'ok','horizontal', 'Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:5], 'YTick',  [2:7],'YTickLabel',tickLabels)
xlim([1 6])
ylim([1.5 7.5])
formatAxes
title('Statements eval')
annotation('textbox',[0.02 0.73 0.05 0.05], ...
    'String','b','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')
xlabel('Score')
linkaxes([ax1, ax2], 'x')


subplot(10, 10,  sort([25:10:80, 26:10:80], 'ascend'))
plot([0.5 7.5], [3 3], '--r');hold on;
errorbar(1:7,sessions_eval_sort,std_sessions,'ok','Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
ylim([1 6])
xlim([0.5 7.5])

set(gca, 'YTick', [1:5], 'XTick',  [1:7],'XTickLabel',sessions_sort, 'XTickLabelRotation', 45)
ylabel('Score')
formatAxes
title('Sessions Eval')

annotation('textbox',[0.42 0.73 0.05 0.05], ...
    'String','c','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')


% saveas(gcf, fullfile(code_repo,'Apps_&_Workshop_feedback.pdf'));

subplot(10, 10,  sort([28:10:80, 29:10:80, 30:10:80], 'ascend'))
plot([1, numel(publ_idx)], [0.1 0.1], '--r');hold on
plot([1, numel(publ_idx)], [0.5 0.5], '--r');
bar(1:numel(publ_idx), shouldbeP_sort, 0.8, 'k'); hold on
set(gca, 'XTick', 1:numel(publ_idx), 'XTickLabel', Q_comm_sort, 'XTickLabelRotation', 45)
ylabel('Publicly document? (%)')
formatAxes
title('Handbook Internal Survey')

annotation('textbox',[0.64 0.73 0.05 0.05], ...
    'String','d','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')



%%


default_figure([1 1 10 11]);

subplot(6, 10, [2,3 12, 13])
plot([0 nT+1], [4 4], '--r');hold on;
errorbar(1:nT, sort_ave_topic, sort_std_topic, 'o','Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:nT ],'XtickLabel', sort_topic_labels, 'XTickLabelRotation', 45)
ylim([1 5])
xlim([0 nT+1])
formatAxes
ylabel('Average score')
title('SAFE topics')

annotation('textbox',[0.1 0.9 0.05 0.05], ...
    'String','a','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')

subplot(6, 10, [4, 5, 14, 15])
plot([0.5 nF+0.5], [4 4], '--r');hold on;
errorbar(1:nF, sort_ave_formats, sort_std_formats, 'o','Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:nF], 'XtickLabel', sort_format_labels, 'XTickLabelRotation', 45);
formatAxes
ylim([1 5])
xlim([0.5 nF+0.5])
title('SAFE formats')
annotation('textbox',[0.32 0.9 0.05 0.05], ...
    'String','b','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')


subplot(6, 10, [7, 8, 17, 18])

% plot(1:numel(countries), sort_country_count, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', [0.6 0.6 0.6]); hold on
% plot(1:numel(countries), sort_country_count_adm_padded, 'o', 'Color', [0 0 0], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k'); hold on
bar(1:numel(countries), sort_country_count_adm_padded, 0.8, 'k'); hold on
set(gca, 'Xtick', 1:numel(countries), 'XTicklabels', sort_countries, 'XTickLabelRotation', 45)
ylim([0 45])
formatAxes
ylabel('% participants')
% legend('Application')
annotation('textbox',[0.52 0.9 0.05 0.05], ...
    'String','c','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')


subplot(6, 10, [9, 10, 19, 20])

% plot(1:numel(daf), sort_rfield_count, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', [0.6 0.6 0.6]); hold on
% plot(1:numel(daf), sort_rfield_count_adm, 'o', 'Color', [0 0 0], 'LineWidth', 2, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k');hold on
bar(1:numel(daf), sort_rfield_count_adm, 0.8, 'k');hold on
set(gca, 'Xtick', 1:numel(daf), 'XTicklabels', sort_rfield, 'XTickLabelRotation', 45)
ylim([0 45])
formatAxes
ylabel('% participants')
% legend('Application')
annotation('textbox',[0.72 0.9 0.05 0.05], ...
    'String','d','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')



ax1 = subplot(6, 10, [32,33]);
plot([3 3], [0.5 1.5], '--r');hold on;
errorbar(statements_eval_sort(1),1,std_statements_sort(1),'ok','horizontal', 'Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:5], 'YTick',  [1],'YTickLabel',globalLabels)
xlabel('Score')
xlim([1 6])
ylim([0.5 1.5])
formatAxes
title('Overall eval')
annotation('textbox',[0.1 0.5 0.05 0.05], ...
    'String','e','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')

ax2= subplot(6, 10, [42, 43, 52, 53])
plot([3 3], [1.5 7.5], '--r');hold on;
errorbar(statements_eval_sort(2:7),2:7,std_statements_sort(2:7),'ok','horizontal', 'Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
set(gca, 'XTick', [1:5], 'YTick',  [2:7],'YTickLabel',tickLabels)
xlim([1 6])
ylim([1.5 7.5])
formatAxes
title('Statements eval')
annotation('textbox',[0.1 0.33 0.05 0.05], ...
    'String','f','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')
xlabel('Score')
linkaxes([ax1, ax2], 'x')


subplot(6, 10, [44, 45, 54, 55])
plot([0.5 7.5], [3 3], '--r');hold on;
errorbar(1:7,sessions_eval_sort,std_sessions,'ok','Color','k', 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0],'MarkerSize',5);
ylim([1 6])
xlim([0.5 7.5])

set(gca, 'YTick', [1:5], 'XTick',  [1:7],'XTickLabel',sessions_sort, 'XTickLabelRotation', 45)
ylabel('Score')
formatAxes
title('Sessions Eval')

annotation('textbox',[0.34 0.33 0.05 0.05], ...
    'String','g','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')


% saveas(gcf, fullfile(code_repo,'Apps_&_Workshop_feedback.pdf'));

subplot(6, 10, [47, 48, 49, 50, 57, 58, 59, 60])
plot([1, numel(publ_idx)], [0.1 0.1], '--r');hold on
plot([1, numel(publ_idx)], [0.5 0.5], '--r');
bar(1:numel(publ_idx), shouldbeP_sort, 0.8, 'k'); hold on
set(gca, 'XTick', 1:numel(publ_idx), 'XTickLabel', Q_comm_sort, 'XTickLabelRotation', 45)
ylabel('Publicly document? (%)')
formatAxes
title('Handbook Internal Survey')

annotation('textbox',[0.52 0.33 0.05 0.05], ...
    'String','h','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')






