function Fig2
loadSurveyData;
%%
FontSz=6;
default_figure([1 1 8.3 11.7]);
clf;

%% total nb of participant per Current role
axes('position',[0.1 0.8 0.09 0.11]);

[roleLabels,~,frequency] = unique(dgs.CurrentRole);
roleLabels = roleLabels([1 3 2 4]);
frequency0 = frequency;
frequency0(frequency == 2) = 3;
frequency0(frequency == 3) = 2;
roleLabels = strrep(roleLabels, 'PhD Student', 'PhD');
roleLabels = strrep(roleLabels, 'PI', 'Group Leader');
roleLabels = strrep(roleLabels, 'RA', 'Staff');
bar(histc(frequency0,1:4), 'FaceColor', 'flat', 'CData', [colour.PI; colour.PostDoc; colour.PhD; colour.RA]./255, 'BarWidth', 0.7);
set(gca, "XTickLabel", roleLabels,'XTickLabelRotation', 90,'FontSize',FontSz)
box off
xExtent = 0.1;
xlim([0.25 4.5])
ylabel('Number of participants')
set(gca,'FontSize',FontSz)
V0 = get(gca,'Position');
xtickangle(45)
addLetter(gca,'a')

%% percentage of participant in each year of experience per Current role
axes('position',[V0(1) + V0(3) + 0.04 V0(2) 0.13 V0(4)]);
hold on
[roleLabels,~,frequency] = unique(dgs.CurrentRole);
plotCols = [colour.PI; colour.PostDoc; colour.PhD; colour.RA]./255;
for i = 1:length(roleLabels)
    subYears = dgs.YearsInRole(frequency==i);
    subYearLabels =  [{'<1' }, {'1-2'}, {'2-3'}, {'3-4'}, {'4+' }];
    pDat = zeros(1, length(subYearLabels));
    for j = 1:length(subYearLabels)
        pDat(j) = mean(strcmp(subYears, subYearLabels{j}));
    end
    pDat= pDat.*100;
    plot(1:5, pDat, '-', 'Color', plotCols(i,:), 'LineWidth', 1)
    plot(1:5, pDat, '.', 'Color', plotCols(i,:), 'MarkerSize', 7)
end
% excluding phd student
gg = strcmp(dgs.CurrentRole,'PhD Student');
pDat = cellfun(@(x) sum(strcmp(dgs.YearsInRole(~gg), x)), subYearLabels);
pDat= pDat/sum(pDat).*100;

pDat = cellfun(@(x) sum(strcmp(dgs.YearsInRole, x)), subYearLabels);
pDat= pDat/sum(pDat).*100;

pM  = plot(1:5, pDat, '-ok', 'LineWidth', 1.5,'MarkerSize', 2,'MarkerFaceColor','k');
legend(pM,{'Average'},'Location','best')
% legend(pM,{'Average'})
legend('boxoff')
ylabel({'Percentage of participants (%)'})
xlabel({'Years of experience in position'})
set(gca, "XTickLabel", subYearLabels,'XTickLabelRotation', 90,'FontSize',FontSz)
box off
xlim([0.5 5.5])
ylim([0 50])
set(gca,'FontSize',FontSz)
V1 = get(gca,'Position');
addLetter(gca,'b')

%% total nb of participant per Field
axes('position',[V0(1) + 2*V0(3)+0.12 V0(2) 0.17 V0(4)]);
xlim([0.5 4.5])
[roleLabels,~,frequency] = unique(dgs.CurrentRole);
[fields,~,frequency] = unique(dgs.Field);

FieldCounts = histc(frequency,1:max(frequency));
[sortedFieldCounts, sortIdx] = sort(FieldCounts, 'descend');
sortedfields = fields(sortIdx);
endIdx = length(sortedFieldCounts+1);
bar(1:endIdx-1, sortedFieldCounts(1:endIdx-1)', 'k', 'FaceColor', 'flat');
set(gca, "XTickLabel", sortedfields(1:endIdx-1), 'XTickLabelRotation', 90, 'XTick', 1:endIdx-1,'FontSize',FontSz)
box off
xlim([0 endIdx+0.5])
ylabel('Number of participants')
set(gca,'FontSize',FontSz)
xtickangle(45)
set(gca,'Color','none')
% set(gca,'XColor','none');
addLetter(gca,'c')

%% total nb of participant per Country
axes('position',[V0(1) V0(2)-V0(4)-0.07 V0(3)+V1(3)+ 0.2 V0(4)]);

xlim([0.5 4.5])
[roleLabels,~,frequency] = unique(dgs.CurrentRole);
[countries,~,frequency] = unique(dgs.Country);
countries = strrep(countries, 'The Netherlands', 'Netherlands');
countries = strrep(countries, 'United Kingdom', 'UK');
countryCounts = histc(frequency,1:max(frequency));
[sortedCountryCounts, sortIdx] = sort(countryCounts, 'descend');
sortedCountries = countries(sortIdx);
endIdx = find(sortedCountryCounts < 2, 1);
endIdx = length(sortedCountryCounts+1);
bar(1:endIdx-1, sortedCountryCounts(1:endIdx-1)', 'k', 'FaceColor', 'flat');
set(gca, "XTickLabel", sortedCountries(1:endIdx-1), 'XTickLabelRotation', 90, 'XTick', 1:endIdx-1,'FontSize',FontSz)
box off
xlim([0 endIdx+0.5])
ylim([0 50])
ylabel('Number of participants')
set(gca,'FontSize',FontSz)
% set(gca,'XColor','none');
xtickangle(45)
set(gca,'Color','none')
addLetter(gca,'d')

%%
saveas(gcf, fullfile(OutF,'Fig2.pdf'));
print(gcf, fullfile(OutF,'Fig2.png'),'-dpng','-r600');