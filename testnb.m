function [post_p,test_lab] = testnb(xt,pw,cp,numfeat,numClass)
[row,len] = size(xt);
for k = 1 : len
    temp = xt(:,k);
    for i = 1: numClass
        prod = 1;
        for j = 1:row
            prod = prod*cp(j,(i-1)*numfeat(j)+temp(j));
        end
        post_p(k,i) = prod*pw(i);
    end
    [~,inx] = max(post_p(k,:));
    test_lab(k) = inx;
end
end