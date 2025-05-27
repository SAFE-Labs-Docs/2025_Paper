function score = public2num(cellstring)

nA = numel(cellstring);

score = nan(nA,1);

for iA = 1:nA

    switch cellstring{iA}
        case 'Publicly Documented'
            score(iA) = 1;
        case 'Documented'
            score(iA) = 0;
%         case 'Partially'
%             score(iA) = 0;
%         case 'Maybe'
%             score(iA) = 0.5;

    end

end
end