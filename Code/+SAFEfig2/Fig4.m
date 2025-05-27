function Fig4
% requires the violin plot function  for matlab which can be found there:
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
loadSurveyData;

FontSz = 6;
Violin_Mksize = 8;
Violin_Alpha = 0.4;
Stats = {};
% keep only PhD students in main dataset
K = strcmp(dgs.CurrentRole,'PhD Student');

% find same commitment in main and prolific datasets
H = dataProl.Properties.VariableNames;
Attention = strcmp(H','I commit to establish a mechanism for sharing lab management up'); % this was the question to make sure participant were paying attention, we don't keep it

ProlData=struct();
ProlData.importance = NaN(size(dataProl,1),length(answ.question_labels));
for i=1:length(H)

    dd = find(contains(comm,H{i}) );
    if ~isempty(dd) & ~Attention(i)
        ProlData.importance(:,dd) = table2array(dataProl(:,i));
    end
end
GoodC = ~isnan(ProlData.importance(1,:));
%%
default_figure([1 1 8.3 11.7]);
clf;
xh = .5;
yh = .5;

i=1;
hs{i}=my_subplot(5,5,1,[xh yh]);
hs{i}.Position(1) = hs{i}.Position(1)+.02;
hs{i}.Position(2) = hs{i}.Position(2) + .01;
axis off;
hp=hs{i}.Position;
axes('position',[hp(1) hp(2)-.07 1.4*hp(3) hp(4)]);

avg_imp1 = mean(answ.importance(K,GoodC),1);
avg_impProl = mean(ProlData.importance(:,GoodC),1);

lm = fitlm(avg_imp1, avg_impProl, "Intercept",true, "RobustOpts","on");

plot(gca,avg_imp1, avg_impProl,'o','MarkerFaceColor',colour.PhD./256, 'MarkerEdgeColor',colour.PhD./256,'MarkerSize',4);
[cc,p] = corr(avg_imp1', avg_impProl');S = pRules(p);
Stats{1,1} = ['a',{p}];
hold(gca,'on')
plot(gca,lm,'Marker','.','MarkerEdgeColor','none','MarkerFaceColor','none')
axis(gca,'square')
legend(gca,'off')
title(gca,{'Importance score',[' r = ',num2str(round(cc,3)),S]},'FontSize',FontSz)
box off;
xlabel('Unpaid Survey')
ylabel('Paid Survey')
xlim([3.3 5])
ylim([3.3 5])
set(gca,'FontSize',FontSz)
V0 = get(gca,'Position');
addLetter(gca,'a')
%% violin plots of the averaged importance score across participants, comparing paid and unpaid surveys

avg_imp1 = mean(answ.importance(K,GoodC),2);
avg_impProl = mean(ProlData.importance(:,GoodC),2);

axes('position',[V0(3)+V0(1)+0.075 V0(2) V0(3) V0(4)]);
Violin({avg_imp1}, 1, 'ViolinColor',{colour.PhD./255},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
Violin({avg_impProl}, 2, 'ViolinColor',{0.7*colour.PhD./255},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
set(gca,'XTick',1:2,'XTickLabel',{'Unpaid','Paid'},'FontSize',FontSz)
xtickangle(45)
ylabel('Mean importance','FontSize',FontSz)
ylim([1 5])


% statistics
p = ranksum(avg_imp1,avg_impProl);
S = pRules(p);
Stats{2,1} = ['b',{p}];
title(['Mann-Whitney ',S])

set(gca,'FontSize',FontSz)
V0 = get(gca,'Position');
addLetter(gca,'b')


nS = cellfun(@(x) length(x),Stats);
T = {};
for i=1:length(Stats)
    for j=1:nS
        if j<=length(Stats{i})
        T{i,j} = Stats{i}{j};
        end
    end
end
T = cell2table(T);
%%
writetable(T,fullfile(OutF,'Fig4_stats.xlsx'));
saveas(gcf, fullfile(OutF,'Fig4.pdf'));
print(gcf, fullfile(OutF,'Fig4.png'),'-dpng','-r600');

