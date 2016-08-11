[n,t,r] = xlsread('SubjectiveWellbeing.xlsx');

r{1,1} = 'ID';
subjectiveData = cell2dataset(r);


anxious1 = subjectiveData.g1_g1_anxious;
anxious2 = subjectiveData.g2_g2_anxious;
anxious3 = subjectiveData.g3_g3_anxious;
anxious4 = subjectiveData.g4_g4_anxious;
anxious5 = subjectiveData.g5_g5_anxious;
anxious6 = subjectiveData.g6_g6_anxious;

anxious1(cellfun(@ischar, anxious1)) = {NaN};
anxious2(cellfun(@ischar, anxious2)) = {NaN};
anxious3(cellfun(@ischar, anxious3)) = {NaN};
anxious4(cellfun(@ischar, anxious4)) = {NaN};
anxious5(cellfun(@ischar, anxious5)) = {NaN};
anxious6(cellfun(@ischar, anxious6)) = {NaN};

anxious1 = cell2mat(anxious1);
anxious2 = cell2mat(anxious2);
anxious3 = cell2mat(anxious3);
anxious4 = cell2mat(anxious4);
anxious5 = cell2mat(anxious5);
anxious6 = cell2mat(anxious6);

anxious = max([anxious1, anxious2, anxious3, anxious4, anxious5, anxious6],[],2);

satisfied1 = subjectiveData.g1_g1_satisfied;
satisfied2 = subjectiveData.g2_g2_satisfied;
satisfied3 = subjectiveData.g3_g3_satisfied;
satisfied4 = subjectiveData.g4_g4_satisfied;
satisfied5 = subjectiveData.g5_g5_satisfied;
satisfied6 = subjectiveData.g6_g6_satisfied;

satisfied1(cellfun(@ischar, satisfied1)) = {NaN};
satisfied2(cellfun(@ischar, satisfied2)) = {NaN};
satisfied3(cellfun(@ischar, satisfied3)) = {NaN};
satisfied4(cellfun(@ischar, satisfied4)) = {NaN};
satisfied5(cellfun(@ischar, satisfied5)) = {NaN};
satisfied6(cellfun(@ischar, satisfied6)) = {NaN};

satisfied1 = cell2mat(satisfied1);
satisfied2 = cell2mat(satisfied2);
satisfied3 = cell2mat(satisfied3);
satisfied4 = cell2mat(satisfied4);
satisfied5 = cell2mat(satisfied5);
satisfied6 = cell2mat(satisfied6);

satisfied = max([satisfied1, satisfied2, satisfied3, satisfied4, satisfied5, satisfied6],[],2);

happyyest1 = subjectiveData.g1_g1_happyyest;
happyyest2 = subjectiveData.g2_g2_happyyest;
happyyest3 = subjectiveData.g3_g3_happyyest;
happyyest4 = subjectiveData.g4_g4_happyyest;
happyyest5 = subjectiveData.g5_g5_happyyest;
happyyest6 = subjectiveData.g6_g6_happyyest;

happyyest1(cellfun(@ischar, happyyest1)) = {NaN};
happyyest2(cellfun(@ischar, happyyest2)) = {NaN};
happyyest3(cellfun(@ischar, happyyest3)) = {NaN};
happyyest4(cellfun(@ischar, happyyest4)) = {NaN};
happyyest5(cellfun(@ischar, happyyest5)) = {NaN};
happyyest6(cellfun(@ischar, happyyest6)) = {NaN};

happyyest1 = cell2mat(happyyest1);
happyyest2 = cell2mat(happyyest2);
happyyest3 = cell2mat(happyyest3);
happyyest4 = cell2mat(happyyest4);
happyyest5 = cell2mat(happyyest5);
happyyest6 = cell2mat(happyyest6);

happiest = max([happyyest1, happyyest2, happyyest3, happyyest4, happyyest5, happyyest6],[],2);

subjectiveData.anxious = anxious;
subjectiveData.satisfied = satisfied;
subjectiveData.happiest = happiest;

crowdsource = subjectiveData.crowdsource;
crowdsource(cellfun(@ischar, crowdsource)) = {NaN};
crowdsource = cell2mat(crowdsource);

recall = subjectiveData.recall;
recall(cellfun(@isnumeric, recall)) = {'empty'};
[b,i,recallIndex] = unique(recall);

close all;

anxietyFig = figure;
set(gcf,'Position',[10,10,1600,500]);

varQuality = cell(3,2);
distCell = cell(3,2);
distCell{1,1} = zeros(25,1);
distCell{2,1} = zeros(25,1);
distCell{3,1} = zeros(25,1);
distCell{1,2} = zeros(25,1);
distCell{2,2} = zeros(25,1);
distCell{3,2} = zeros(25,1);
mQuality = cell(3,2);

subplot(3,2,1)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 4,{'SubmissionDate','simserial','anxious'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.anxious(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.anxious(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.anxious(simIndex == indexI));
end
title('Weekly, Self');

subplot(3,2,3)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 2,{'SubmissionDate','simserial','anxious'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.anxious(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.anxious(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.anxious(simIndex == indexI));
end
title('Monthly, Self');

subplot(3,2,5)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 3,{'SubmissionDate','simserial','anxious'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.anxious(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.anxious(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.anxious(simIndex == indexI));
end
title('Seasonally, Self');

subplot(3,2,2)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 4,{'SubmissionDate','simserial','anxious'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.anxious(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.anxious(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.anxious(simIndex == indexI));
end
title('Weekly, Crowd');

subplot(3,2,4)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 2,{'SubmissionDate','simserial','anxious'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.anxious(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.anxious(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.anxious(simIndex == indexI));
end
title('Monthly, Crowd');

subplot(3,2,6)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 3,{'SubmissionDate','simserial','anxious'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.anxious(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.anxious(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.anxious(simIndex == indexI));
end
title('Seasonally, Crowd');

suptitle('Anxiety level, yesterday');

happinessFig = figure;
set(gcf,'Position',[10,10,1600,500]);

subplot(3,2,1)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 4,{'SubmissionDate','simserial','happiest'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.happiest(simIndex == indexI));
   hold on;
end
title('Weekly, Self');

subplot(3,2,3)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 2,{'SubmissionDate','simserial','happiest'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.happiest(simIndex == indexI));
   hold on;
end
title('Monthly, Self');

subplot(3,2,5)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 3,{'SubmissionDate','simserial','happiest'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.happiest(simIndex == indexI));
   hold on;
end
title('Seasonally, Self');

subplot(3,2,2)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 4,{'SubmissionDate','simserial','happiest'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.happiest(simIndex == indexI));
   hold on;
end
title('Weekly, Crowd');

subplot(3,2,4)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 2,{'SubmissionDate','simserial','happiest'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.happiest(simIndex == indexI));
   hold on;
end
title('Monthly, Crowd');

subplot(3,2,6)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 3,{'SubmissionDate','simserial','happiest'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.happiest(simIndex == indexI));
   hold on;
end
title('Seasonally, Crowd');

suptitle('Happiness level, yesterday');

satisfactionFig = figure;
set(gcf,'Position',[10,10,1600,500]);

subplot(3,2,1)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 4,{'SubmissionDate','simserial','satisfied'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.satisfied(simIndex == indexI));
   hold on;
end
title('Weekly, Self');

subplot(3,2,3)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 2,{'SubmissionDate','simserial','satisfied'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.satisfied(simIndex == indexI));
   hold on;
end
title('Monthly, Self');

subplot(3,2,5)
subDataset = subjectiveData(crowdsource == 0 & recallIndex == 3,{'SubmissionDate','simserial','satisfied'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.satisfied(simIndex == indexI));
   hold on;
end
title('Seasonally, Self');

subplot(3,2,2)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 4,{'SubmissionDate','simserial','satisfied'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.satisfied(simIndex == indexI));
   hold on;
end
title('Weekly, Crowd');

subplot(3,2,4)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 2,{'SubmissionDate','simserial','satisfied'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.satisfied(simIndex == indexI));
   hold on;
end
title('Monthly, Crowd');

subplot(3,2,6)
subDataset = subjectiveData(crowdsource == 1 & recallIndex == 3,{'SubmissionDate','simserial','satisfied'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.satisfied(simIndex == indexI));
   hold on;
end
title('Seasonally, Crowd');

suptitle('Satisfaction level, overall');

histFig = figure;

subplot(3,2,1)
a = hist(subjectiveData.anxious(recallIndex == 4 & crowdsource == 0));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,3)
a = hist(subjectiveData.anxious(recallIndex == 2 & crowdsource == 0));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,5)
a = hist(subjectiveData.anxious(recallIndex == 3 & crowdsource == 0));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,2)
a = hist(subjectiveData.anxious(recallIndex == 4 & crowdsource == 1));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,4)
a = hist(subjectiveData.anxious(recallIndex == 2 & crowdsource == 1));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,6)
a = hist(subjectiveData.anxious(recallIndex == 3 & crowdsource == 1));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);

subjectiveData = replacedata(subjectiveData, x2mdate(subjectiveData.SubmissionDate),'SubmissionDate');

subjectiveData.weekGroup = floor((subjectiveData.SubmissionDate - datenum(2015,12,13))/7);

boxFig = figure;

subplot(3,1,1)
a = boxplot(subjectiveData.anxious(recallIndex == 4),subjectiveData.weekGroup(recallIndex == 4));
subplot(3,1,2)
a = boxplot(subjectiveData.anxious(recallIndex == 2),subjectiveData.weekGroup(recallIndex == 2));
subplot(3,1,3)
a = boxplot(subjectiveData.anxious(recallIndex == 3),subjectiveData.weekGroup(recallIndex == 3));

boxFig = figure;

subplot(3,1,1)
a = boxplot(subjectiveData.satisfied(recallIndex == 4),subjectiveData.weekGroup(recallIndex == 4));
subplot(3,1,2)
a = boxplot(subjectiveData.satisfied(recallIndex == 2),subjectiveData.weekGroup(recallIndex == 2));
subplot(3,1,3)
a = boxplot(subjectiveData.satisfied(recallIndex == 3),subjectiveData.weekGroup(recallIndex == 3));

%want to look at box plots, by frequency, by week, by place
boxFig = figure;

subplot(2,1,1)
cellVar = cell(11,1)
anxVar1 = zeros(11,13);
for indexI = 0:max(subjectiveData.weekGroup)
    cellVar{indexI+1} = subjectiveData.anxious(recallIndex == 4 & subjectiveData.weekGroup == indexI & subjectiveData.anxious <= 10 & subjectiveData.anxious >= 0);
    anxVar1(:,indexI+1) = hist(subjectiveData.anxious(recallIndex == 4 & subjectiveData.weekGroup == indexI & subjectiveData.anxious <= 10 & subjectiveData.anxious >= 0),0:10);
end
anxVar1 = anxVar1 ./ (ones(11,1) * sum(anxVar1) );
distributionPlot(cellVar,'histOpt',2)
axis([0.5 12.5 0 .4]);
subplot(2,1,2)
cellVar = cell(11,1)
anxVar2 = zeros(11,13);
for indexI = 0:max(subjectiveData.weekGroup)
    cellVar{indexI+1} = subjectiveData.anxious(recallIndex == 2 & subjectiveData.weekGroup == indexI & subjectiveData.anxious <= 10 & subjectiveData.anxious >= 0);
    anxVar2(:,indexI+1) = hist(subjectiveData.anxious(recallIndex == 2 & subjectiveData.weekGroup == indexI & subjectiveData.anxious <= 10 & subjectiveData.anxious >= 0),0:10);
end
anxVar2 = anxVar2 ./ (ones(11,1) * sum(anxVar2) );
distributionPlot(cellVar,'histOpt',2)
axis([0.5 12.5 0 .4]);


hapVar1 = zeros(11,13);
for indexI = 0:max(subjectiveData.weekGroup)
    hapVar1(:,indexI+1) = hist(subjectiveData.happiest(recallIndex == 4 & subjectiveData.weekGroup == indexI & subjectiveData.happiest <= 10 & subjectiveData.happiest >= 0),0:10);
end
hapVar1 = hapVar1 ./ (ones(11,1) * sum(hapVar1) );
hapVar2 = zeros(11,13);
for indexI = 0:max(subjectiveData.weekGroup)
    hapVar2(:,indexI+1) = hist(subjectiveData.happiest(recallIndex == 2 & subjectiveData.weekGroup == indexI & subjectiveData.happiest <= 10 & subjectiveData.happiest >= 0),0:10);
end
hapVar2 = hapVar2 ./ (ones(11,1) * sum(hapVar2) );

satVar1 = zeros(11,13);
for indexI = 0:max(subjectiveData.weekGroup)
    satVar1(:,indexI+1) = hist(subjectiveData.satisfied(recallIndex == 4 & subjectiveData.weekGroup == indexI & subjectiveData.satisfied <= 10 & subjectiveData.satisfied >= 0),0:10);
end
satVar1 = satVar1 ./ (ones(11,1) * sum(satVar1) );
satVar2 = zeros(11,13);
for indexI = 0:max(subjectiveData.weekGroup)
    satVar2(:,indexI+1) = hist(subjectiveData.satisfied(recallIndex == 2 & subjectiveData.weekGroup == indexI & subjectiveData.satisfied <= 10 & subjectiveData.satisfied >= 0),0:10);
end
satVar2 = satVar2 ./ (ones(11,1) * sum(satVar2) );

%kstest(subjectiveData.anxious(recallIndex == 4 & crowdsource == 0),subjectiveData.anxious(recallIndex == 2 & crowdsource == 0));