function Supp_seniority

% requires the violin plot function  for matlab which can be found there:
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
loadSurveyData;

RoleList = {'PI' ; 'Postdoc'; 'PhD Student' ;  'RA' };
CList = {'All';'PI' ;  'PostDoc';'PhD' ;'RA'};
NList = {'Group Leader' ;  'PostDoc';'PhD' ;'Staff'};
Alph = string(('a':'z').').';
Violin_Mksize = 8;
Violin_Alpha = 0.4;
FontSz=6;
default_figure([1 1 8.3 11.7]);
clf;
%% violin plot of importance score for PI split by seniority
for k=1:length(RoleList)-1
    axes('position',[0.05 + (k-1)*0.2 0.8 0.15 0.11]);
    avg_imp = mean(answ.importance,2);
    Ua = unique(dgs.YearsInRole);
    Ua = [Ua(end);Ua(1:end-1)];

    for j=1:length(Ua)
        dummy = strcmp(RoleList{k},dgs.CurrentRole) & strcmp(dgs.YearsInRole,Ua{j});
        Violin({avg_imp(dummy)}, j , 'ViolinColor',{colour.(CList{k+1})./256},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
    end

    set(gca,'XTick',1:length(Ua),'XTickLabel',Ua,'FontSize',FontSz)
    xtickangle(45)
    if k==1
    ylabel('Mean importance','FontSize',FontSz)
    end
    xlabel('Years of experience','FontSize',FontSz)
    ylim([1 5])
    XL = xlim;
    plot(XL,[3 3],'--','Color',[0.8 0.8 0.8])
    ThisR = strcmp('PI',dgs.CurrentRole);
    [p,~,stats] = kruskalwallis(avg_imp(ThisR),dgs.YearsInRole(ThisR),'off');
    [c,~,~,gnames] = multcompare(stats,'display','off');

    S = pRules(p);
    title({RoleList{k},['Kruskal Wallis ',S]})
    set(gca,'FontSize',FontSz)

    addLetter(gca,Alph{k})
end
saveas(gcf, fullfile(OutF,'Supp_Fig2_seniority.pdf'));
print(gcf, fullfile(OutF,'Supp_Fig2_seniority.png'),'-dpng','-r600');
