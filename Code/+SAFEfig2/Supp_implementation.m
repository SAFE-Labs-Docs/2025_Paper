function Supp_implementation

% requires the violin plot function  for matlab which can be found there:
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
loadSurveyData;
MinPersonCountry = 12; % minimum nb of person in a country to be considered in analysis
[uniqueS,~,idx] = unique(dgs.Country,'stable');
count = hist(idx,unique(idx));
KeepCountries = count > MinPersonCountry ;
RoleList = uniqueS(KeepCountries);
CList = RoleList;
CList(strcmp(CList,'United Kingdom')) = {'UK'};
NList = CList;
Alph = string(('a':'z').').';
Violin_Mksize = 8;
Violin_Alpha = 0.4;
FontSz=6;
default_figure([1 1 8.3 11.7]);
clf;
%% plot whether participants would implement this Handbook split by countries

impledistbycat=[];
which_cat = strcmp('Country', dgs.Properties.VariableNames);
for i=1:length(RoleList)
    idx = strcmp(dgs{:, which_cat}, RoleList{i}); % keep observations for each category
    impledistbycat(i,:) = 100*(histcounts(answ.implement(idx, :), [-0.1:0.4:1.2])./sum(idx));
end

axes('position',[0.05 0.85 0.3 0.11]);
V = get(gca,'Position');
b = bar(impledistbycat');
hold on

ylim([0 100])
ylabel('Percentage (%)','FontSize',FontSz)
set(gca, 'XTick', 1:3, 'XTickLabel', {'No','Maybe','Yes'},'FontSize',FontSz)
title('Implement in your lab?','FontSize',FontSz);
box off;
set(gca,'FontSize',FontSz)
legend(CList,'FontSize',FontSz,'location','northeastoutside')
legend('boxoff')
addLetter(gca,'a')
%% plot whether participants would implement this Handbook split by roles and seniority

RoleList = {'PI' ; 'Postdoc'; 'PhD Student' };
CList = {'All';'PI' ;  'PostDoc';'PhD' };
NList = {'Group Leader' ;  'PostDoc';'PhD'};
Ua = unique(dgs.YearsInRole);
Ua = [Ua(end);Ua(1:end-1)];

for k = 1:length(RoleList)
    dgsSub = dgs(strcmp(dgs.CurrentRole,RoleList{k}),:);
    Imp = answ.implement(strcmp(dgs.CurrentRole,RoleList{k}));
    impledistbycat=[];
    if k==1
        axes('position',V + [V(3)+0.05 0 -0.17 0]);
        V0 = get(gca,'Position');
    else
        axes('position',V0 + [(k-1)*V0(3)*1.4 0 0 0]);
    end
    which_cat = strcmp('YearsInRole', dgs.Properties.VariableNames);
    for i=1:length(Ua)
        idx = strcmp(dgsSub{:, which_cat}, Ua{i}); % keep observations for each category
        impledistbycat(i,:) = 100*(histcounts(Imp(idx, :), [-0.1:0.4:1.2])./sum(idx));
    end
    imagesc(impledistbycat)
    clim([0 100])
    hold on
    title(NList{k})
    if k==1
        set(gca, 'YTick', 1:length(Ua), 'YTickLabel', Ua,'FontSize',FontSz)
        ylabel('Years of experience')
    else
        set(gca, 'YTick', 1:length(Ua), 'YTickLabel', [])
    end
    set(gca, 'XTick', 1:3, 'XTickLabel', {'No','Maybe','Yes'},'FontSize',FontSz)
    cmap = createCustomSaturationColormap(colour.(CList{k+1})./256);
    colormap(gca,cmap)
    set(gca,'FontSize',FontSz)
    addLetter(gca,Alph{k+1})
end
axes('position',V0 + [k*V0(3)*1.1 0 0 0]);
axis off
colormap(gca,flipud(gray))
clim([0 100])
c = colorbar;
c.Label.String = 'Percentage (%)';

saveas(gcf, fullfile(OutF,'Supp_Fig5_implementation.pdf'));
print(gcf, fullfile(OutF,'Supp_Fig5_implementation.png'),'-dpng','-r600');