function D
loadSurveyData;

%%
figure;
currPos = get(gcf, 'Position');
set(gcf, 'Position', currPos.*[1,1,1.5,1]);  
nCols = 6;
xExtent = 0.1;
set(gca, 'Position', [0.1 0.1 xExtent 0.8])
xlim([0.5 4.5])
[roleLabels,~,frequency] = unique(dgs.CurrentRole);


subplot(1,nCols,2:nCols); [countries,~,frequency] = unique(dgs.Country); cla
countries = strrep(countries, 'The Netherlands', 'Netherlands');
countries = strrep(countries, 'United Kingdom', 'UK');

countryCounts = histc(frequency,1:max(frequency));
[sortedCountryCounts, sortIdx] = sort(countryCounts, 'descend');
sortedCountries = countries(sortIdx);
endIdx = find(sortedCountryCounts < 2, 1);
endIdx = length(sortedCountryCounts+1);
bar(1:endIdx-1, sortedCountryCounts(1:endIdx-1)', 'k', 'FaceColor', 'flat');
set(gca, "XTickLabel", sortedCountries(1:endIdx-1), 'XTickLabelRotation', 90, 'XTick', 1:endIdx-1)
box off
xlim([0.5 endIdx+0.5])
currPos = get(gca, 'Position');

set(gca, 'Position', [currPos(1) 0.1 xExtent*endIdx/length(roleLabels) 0.8])
%%
functionPath = mfilename('fullpath');
export_fig(functionPath, '-pdf');