function Fig5
loadSurveyData;
%%
FontSz=6;
default_figure([1 1 8.3 11.7]);
clf;

RoleList = {'PI' ; 'Postdoc'; 'PhD Student' ;  'RA' };
CList = {'All';'PI' ;  'PostDoc';'PhD' ;'RA'};
NList = {'Group Leader' ;  'PostDoc';'PhD' ;'Staff'};
%% implementation comparison
axes('position',[0.05 0.8 0.3 0.12]);
impledistbycat=[];
which_cat = strcmp('CurrentRole', dgs.Properties.VariableNames);
for i=1:length(RoleList)
idx = strcmp(dgs{:, which_cat}, RoleList{i}); % keep observations for each category
impledistbycat(i,:) = 100*(histcounts(answ.implement(idx, :), [-0.1:0.4:1.2])./sum(idx));
end
ProlImp = io.yesno2num(table2cell(dataProl(:,end)));
ProlImpdist = 100*(histcounts(ProlImp, [-0.1:0.4:1.2])./size(ProlImp,1));
b = bar([impledistbycat(1:3,:);ProlImpdist;impledistbycat(4,:)]');
for i=1:length(RoleList)
    b(i).FaceColor = colour.(CList{i+1})./255;
end
b(length(RoleList)).FaceColor = 0.7*colour.PhD./255;
b(length(RoleList)+1).FaceColor = colour.RA./255;

ylim([0 100])
ylabel('Percentage (%)','FontSize',FontSz)
set(gca, 'XTick', 1:3, 'XTickLabel', {'No','Maybe','Yes'},'FontSize',FontSz)
title('Implement in your lab?','FontSize',FontSz);
box off;
set(gca,'FontSize',FontSz)
legend([NList(1:3);'PhD from Paid survey';NList(4)],'Location','bestoutside')
legend('boxoff')  
addLetter(gca,'a')
%%
saveas(gcf, fullfile(OutF,'Fig5.pdf'));
print(gcf, fullfile(OutF,'Fig5.png'),'-dpng','-r600');