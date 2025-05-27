function S = pRules(p)
S = ' - NS';
if p<0.05
    S = '*';
end
if p<0.01
    S = '**';
end
if p<0.001
    S = '***';
end