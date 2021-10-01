Train= readtable('titanic\train.csv');
Test = readtable('titanic\test.csv');

%数据预处理
%检查数据缺少情况并进行填补，删除'PassengerId'，'Name'，'Ticket','Fare'
%样本特征8个
% Pclass(1-3) Sex(1男 2女) Age(1-5) SibSp(1-3)  Parch(1-3) Embarked(1-5) nCabins(1-5)

Train(:,{'PassengerId','Name','Ticket','Fare'}) = [];
Test(:,{'PassengerId','Name','Ticket','Fare'}) = [];
vars = Train.Properties.VariableNames;
vars_T = Test.Properties.VariableNames;

d = [];
d_T = [];
d(1) = sum(isnan(Train.Survived));
d(2) = sum(isnan(Train.Pclass));
d(3) = sum(cellfun(@isempty, Train.Sex));
d(4) = sum(isnan(Train.Age));
d(5) = sum(isnan(Train.SibSp));
d(6) = sum(isnan(Train.Parch));
d(7) = sum(cellfun(@isempty, Train.Cabin));
d(8) = sum(cellfun(@isempty, Train.Embarked));

d_T(1) = sum(isnan(Test.Pclass));
d_T(2) = sum(cellfun(@isempty, Test.Sex));
d_T(3) = sum(isnan(Test.Age));
d_T(4) = sum(isnan(Test.SibSp));
d_T(5) = sum(isnan(Test.Parch));
d_T(6) = sum(cellfun(@isempty, Test.Cabin));
d_T(7) = sum(cellfun(@isempty, Test.Embarked));

for c = 1 : width(Train)
    x = sprintf('%s %d %d', vars{1,c}, d(c) , height(Train));
    disp(x);
end
for c = 1 : width(Test)
    x_T = sprintf('%s %d %d', vars_T{1,c}, d_T(c) , height(Test));
    disp(x_T);
end


%Sex特征
for i = 1 : height(Train)
    if strcmp(Train.Sex{i} ,'male')
        Train.Sex{i}=1;
    else
        Train.Sex{i}=2;
    end
end
 
for i = 1 : height(Test)
    if strcmp(Test.Sex{i} ,'male')
        Test.Sex{i}=1;
    else
        Test.Sex{i}=2;
    end
end
Train.Sex = cell2mat(Train.Sex);
Test.Sex = cell2mat(Test.Sex);
disp(grpstats(Train(:,{'Survived','Sex'}), 'Sex'));

%Age特征 利用训练集的平均年龄填补训练集与测试集的空缺
avgAge = nanmean(Train.Age);             
Train.Age(isnan(Train.Age)) = avgAge;   
Test.Age(isnan(Test.Age)) = avgAge; 
disp(grpstats(Train(:,{'Survived','Age'}), 'Age'));
for i = 1 : height(Train)
    if Train.Age(i) <12
        Train.Age(i)=1;
    elseif Train.Age(i) <30
        Train.Age(i)=2;
    elseif Train.Age(i) <60
        Train.Age(i)=3;
    elseif Train.Age(i)<75
        Train.Age(i)=4;
    else
        Train.Age(i)=5;
    end
end
 
for i = 1 : height(Test)
    if Test.Age(i) <12
        Test.Age(i)=1;
    elseif Test.Age(i) <30
        Test.Age(i)=2;
    elseif Test.Age(i) <60
        Test.Age(i)=3;
    elseif Test.Age(i) <75
        Test.Age(i)=4;
    else
        Test.Age(i)=5;
    end
end
disp(grpstats(Train(:,{'Survived','Age'}), 'Age'));

%SibSp特征
disp(grpstats(Train(:,{'Survived','SibSp'}), 'SibSp'));
for i = 1 : height(Train)
    if Train.SibSp(i) <1
        Train.SibSp(i)=1;
    elseif Train.SibSp(i) <3
        Train.SibSp(i)=2;
    else
        Train.SibSp(i)=3;
    end
end
for i = 1 : height(Test)
    if Test.SibSp(i) <3
        Test.SibSp(i)=1;
    elseif Test.SibSp(i) <3
        Test.SibSp(i)=2;
    else
        Test.SibSp(i)=3;
    end
end
disp(grpstats(Train(:,{'Survived','SibSp'}), 'SibSp'));


%Parch特征
disp(grpstats(Train(:,{'Survived','Parch'}), 'Parch'));
for i = 1 : height(Train)
    if Train.Parch(i) <1
        Train.Parch(i)=1;
    elseif Train.Parch(i) <4
        Train.Parch(i)=2;
    else
        Train.Parch(i)=3;
    end
end
for i = 1 : height(Test)
    if Test.Parch(i) <1
        Test.Parch(i)=1;
    elseif Test.Parch(i) <4
        Test.Parch(i)=2;
    else
        Test.Parch(i)=2;
    end
end
disp(grpstats(Train(:,{'Survived','Parch'}), 'Parch'));

% cabin特征
% 补充cabin空缺，并转为1 2 
train_cabins = cellfun(@strsplit, Train.Cabin, 'UniformOutput', false);
test_cabins = cellfun(@strsplit, Test.Cabin, 'UniformOutput', false);
 
% count the number of tokens
Train.nCabins = cellfun(@length, train_cabins);
Test.nCabins = cellfun(@length, test_cabins);
 
% deal with exceptions - only the first class people had multiple cabins 修正cabin
Train.nCabins(Train.Pclass ~= 1 & Train.nCabins > 1,:) = 1;
Test.nCabins(Test.Pclass ~= 1 & Test.nCabins > 1,:) = 1;
 
% if |Cabin| is empty, then |nCabins| should be 0 修正cabin
Train.nCabins(cellfun(@isempty, Train.Cabin)) = 0;
Test.nCabins(cellfun(@isempty, Test.Cabin)) = 0;
disp(grpstats(Train(:,{'Survived','nCabins'}), 'nCabins'));

%{
for i = 1 : height(Train)
    if Train.nCabins(i) <1
        Train.nCabins(i)=1;
    else
        Train.nCabins(i)=2;
    end
end
for i = 1 : height(Test)
    if Test.nCabins(i) <1
        Test.nCabins(i)=1;
    else
        Test.nCabins(i)=2;
    end
end
%}
Train.nCabins = Train.nCabins + 1;
Test.nCabins = Test.nCabins + 1;
disp(grpstats(Train(:,{'Survived','nCabins'}), 'nCabins'));


% Embarked is not available
% get most frequent value
disp(grpstats(Train(:,{'Survived','Embarked'}), 'Embarked'));
 
% apply it to missling value，并对应1 2 3
for i = 1 : height(Train)
    if isempty(Train.Embarked{i})
        Train.Embarked{i}='S';
    end
    if strcmp(Train.Embarked{i} ,'S')
        Train.Embarked{i}=1;
    elseif strcmp(Train.Embarked{i} , 'Q')
        Train.Embarked{i}=2;       
    else
        Train.Embarked{i}=3;
    end
end
 
for i = 1 : height(Test)
    if isempty(Test.Embarked{i})
        Test.Embarked{i}='S';
    end
    if strcmp(Test.Embarked{i} ,'S')
        Test.Embarked{i}=1;
    elseif strcmp(Test.Embarked{i} , 'Q')
        Test.Embarked{i}=2;       
    else
        Test.Embarked{i}=3;
    end
end

Train.Embarked =cell2mat(Train.Embarked);
Test.Embarked = cell2mat(Test.Embarked);
disp(grpstats(Train(:,{'Survived','Embarked'}), 'Embarked'));

Train(:,{'Cabin'}) = [];
Test(:,{'Cabin'}) = [];

%构建模型
data = Train.Variables;
t = data(:,2:end);
l = (data(:,1)+1)';   %0-1变为1-2
X = t';
idx = randperm(891);
X_train = X(:, idx(1:700));
y_train = l(idx(1:700));
X_test = X(:, idx(700:end));
y_test = l(idx(700:end));

[pw,cp,numfeat,numclass] = nb(X_train, y_train);
[post_p,test_lab] = testnb(X_test,pw,cp,numfeat,numclass);
right = y_test == test_lab;
rate = sum(right)/length(y_test);
disp(['NB Accuracy:' num2str(rate*100) '%']);

data_T = Test.Variables;
t = data_T';
[post_p_T,test_lab_T] = testnb(t,pw,cp,numfeat,numclass);
PassengerId = (1 : 418)';
Survived = (test_lab_T-1)';
T = table(PassengerId, Survived);
writetable(T,'submission.csv');