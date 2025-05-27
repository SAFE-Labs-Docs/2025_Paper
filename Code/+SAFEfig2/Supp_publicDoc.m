function Supp_publicDoc

% requires the violin plot function  for matlab which can be found there:
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
loadSurveyData;

CList = {'All';'PI' ;  'PostDoc';'PhD' ;'RA'};
uniqueRoles= {'PI' ; 'Postdoc'; 'PhD Student' ;  'RA' };
which_cat = strcmp('CurrentRole', dgs.Properties.VariableNames);
FontSz=6;
default_figure([1 1 8.3 11.7]);
clf;
%% public vs internal documentation
 axes('position',[0.05 .8 0.3 0.1]);
 V = get(gca,'Position');
Nall = [];
for k = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{k}); % keep observations for each category
    ifPublic = answ.ifPublic(idx,:); Asked = find(~isnan(ifPublic(1,:)));
    ifPublic = ifPublic(:,Asked);
    N=[];
    for j=1:size(ifPublic,2)
        N(j) = 100*(sum(ifPublic(:,j))/sum(idx));
        hold on
        bar((j-1)*(length(uniqueRoles)+1) + k,N(j),'FaceColor',colour.(CList{k+1})./255)
    end
    Nall = [Nall;N];
end
set(gca,'XTick',(1:length(Asked))*(length(uniqueRoles)+1) - (length(uniqueRoles)+1)/2,'XTickLabel',answ.question_labels(Asked),'FontSize',FontSz)
ylabel('Publicly document? (%)')
set(gca,'FontSize',FontSz)
xtickangle(60)
addLetter(gca,'a')

% add legends
axes('position',[V(1)+V(3)+0.2 V(2)+V(4)+0.02 0.01 0.01]);
hold on
for i=1:length(uniqueRoles)
    qw{i} = bar(nan,nan,'FaceColor',colour.(CList{i+1})./255);
end
axis off
legend([qw{:}], uniqueRoles,'FontSize',FontSz)
legend('boxoff')


saveas(gcf, fullfile(OutF,'Supp_Fig4_publicDoc.pdf'));
print(gcf, fullfile(OutF,'Supp_Fig4_publicDoc.png'),'-dpng','-r600');
