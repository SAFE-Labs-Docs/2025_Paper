function S = procKWmultcompare(c,gnames)

dd = find(c(:,end)<0.05);
S = {};
for i=1:length(dd)
    S{1,i} = [gnames{c(dd(i),1)},'-',gnames{c(dd(i),2)},' - p = ',num2str(c(dd(i),end))];
end