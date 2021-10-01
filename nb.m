function [pw, cp, numfeat, numclass] = nb(x, y)
[row,~] = size(x);
lab = unique(y);
numclass = length(lab);
for i = 1 : numclass      %prior
    pw(i) = sum(y ==lab(i));
    pw(i) = pw(i) / length(y);   
end
for i = 1 : row    % 计算条件概率
    a = unique(x(i,:)); 
    numfeat(i) = length(a);
    for j = 1:numclass
        b = sum(y == lab(j));
        for k = 1:numfeat(i)
            c = sum (x(i,y==lab(j)) == a(k)); 
            cp(i,k+numfeat(i)*(j-1)) = c/b; 
        end
    end
end
end