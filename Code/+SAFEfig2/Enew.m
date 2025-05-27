% function Enew
loadSurveyData;
%%
FontSz=10;
default_figure([1 1 8 12]);
clf;
step=0; id=1;
cc=cell(3,1);
ax1 = axes('position',[0.01 0.3 0.15 0.4]);
V1 = get(ax1,'Position');
for i=1:length(answ.question_labels)
    if i~=1 & answ.themes.questions(i-1)~= answ.themes.questions(i)
        step = step + 0;
        id = id+1;
    else
        step = step + 0;
    end
    text(ax1,9,length(answ.question_labels)-i-step,answ.question_labels{i},...
        'Color',colour.(answ.themes.names{answ.themes.questions(i)+1})./256,...
        'HorizontalAlignment','right','FontSize',12)
    cc{id} = [cc{id};length(answ.question_labels)-i-step];
end
ylim(ax1,[-1.2 length(answ.question_labels)-1.2])
axis off
ccM = cellfun(@mean,cc);
for j=1:length(ccM)
    text(ax1,-2,ccM(j)-0.5,answ.themes.names{j},'VerticalAlignment','middle',...
        'HorizontalAlignment','center','Rotation',90,'FontSize',16,'FontWeight','bold',...
        'Color',colour.(answ.themes.names{j})./256)
end
xlim(ax1,[-3 4.5])
%
axC = 0.3*[1 1 1];
ax2 = axes('position',[V1(1) + V1(3) + 0.1 V1(2) 0.05 V1(4)]);
N =  {'Publicly Document','Internally Document','Establish'};
M = zeros(length(answ.question_labels),3);
M(:,1) = contains(comm,'publicly');
M(:,3) = contains(comm,'establish');
M(:,2) = ~contains(comm,'establish') & ~contains(comm,'publicly');
imagesc(ax2,M)
colormap(flipud(gray))
set(gca,'XTick',[],'YTick',[],'XColor',axC,'YColor',axC)
XL = xlim;YL = ylim;
for i=1:size(M,1)
    hold on
    plot(XL,[1 1]*(i-0.5),'Color',axC)
end

for i=1:size(M,2)
    hold on
    plot([1 1]*(i-0.5),YL,'Color',axC)
end
plot([1 1]*(i+0.5),YL,'Color',axC)
set(gca,'XTick',1:3,'XTickLabel',N,'FontSize',FontSz)
xtickangle(90)
box off
V2 = get(ax2,'Position');

%% total nb of participant per Current role
axes('position',[V2(1)+V2(3)+0.1 V2(2)+V2(4) 4*V2(3) V2(4)/3]);

[roleLabels,~,frequency] = unique(dgs.CurrentRole);
roleLabels = strrep(roleLabels, 'PhD Student', 'PhD');
roleLabels = strrep(roleLabels, 'PI', 'Group Leader');
roleLabels = strrep(roleLabels, 'RA', 'Staff');
bar(histc(frequency,1:4), 'FaceColor', 'flat', 'CData', [colour.PI; colour.PostDoc; colour.PhD; colour.RA]./255, 'BarWidth', 0.7);
set(gca, "XTickLabel", roleLabels,'XTickLabelRotation', 90,'FontSize',FontSz)
box off
xExtent = 0.1;
xlim([0.5 4.5])
ylabel('Number of participants')
set(gca,'FontSize',FontSz)
V0 = get(gca,'Position');
xtickangle(45)
addLetter(gca,'b')
%% percentage of participant in each year of experience per Current role
axes('position',[V0(1) + V0(3) + 0.1 V0(2) V0(3) V0(4)]);
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
    plot(1:5, pDat, '-', 'Color', plotCols(i,:), 'LineWidth', 1.5)
    plot(1:5, pDat, '.', 'Color', plotCols(i,:), 'MarkerSize', 15)
end
pDat = cellfun(@(x) mean(strcmp(dgs.YearsInRole, x)), subYearLabels);
 pDat= pDat.*100;
pM  = plot(1:5, pDat, '-ok', 'LineWidth', 3,'MarkerSize', 3,'MarkerFaceColor','k');
legend(pM,{'Average'},'Position',[0.736143329352186,0.816238052982619,0.12499999825377,0.01736111069719])
% legend(pM,{'Average'})
legend('boxoff')
ylabel({'Percentage of ','participants (%)'})
xlabel({'Years of experience','in position'})
set(gca, "XTickLabel", subYearLabels,'XTickLabelRotation', 90,'FontSize',FontSz)
box off
xlim([0.5 5.5])
ylim([0 50])
set(gca,'FontSize',FontSz)
V1 = get(gca,'Position');
addLetter(gca,'c')
%% total nb of participant per Country
axes('position',[V0(1) V0(2)-V0(4) - 0.1 V0(3)+V1(3)+ 0.1 V0(4)]);

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
xlim([0.5 endIdx+0.5])
ylim([0 50])
ylabel('Number of participants')
set(gca,'FontSize',FontSz)
% set(gca,'XColor','none');
V2 = get(gca,'Position');
xtickangle(45)
set(gca,'Color','none')
addLetter(gca,'d')
%% total nb of participant per Field
axes('position',[V2(1) V2(2)-V2(4) - 0.05 V2(3) V2(4)]);
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
xlim([0.5 endIdx+0.5])
ylabel('Number of participants')
set(gca,'FontSize',FontSz)
xtickangle(45)
set(gca,'Color','none')
% set(gca,'XColor','none');
addLetter(gca,'e')
%% logo
axes('position',[V0(1)-0.35 V0(2) V0(3) V0(4)]);
I = imread(fullfile(data_repo,'Logo.png'));
imshow(I)
axis off

addLetter(gca,'a')
%%
saveas(gcf, fullfile(OutF,'Figure3.pdf'));
print(gcf, fullfile(OutF,'Figure3.png'),'-dpng','-r600');