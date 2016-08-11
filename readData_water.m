clear all;
close all;

[~,~,r] = xlsread('DrinkingWater.xlsx');

r{1,1} = 'ID';
mainDrinkingData = cell2dataset(r);

[~,~,r] = xlsread('DrinkingWater_source.xlsx');

r{1,1} = 'ID';
subDrinkingData = cell2dataset(r);

subDrinkingData = replacedata(subDrinkingData, regexprep(subDrinkingData.KEY,'/source\[.\]',''),'KEY');

[bMain,i,j] = unique(mainDrinkingData.KEY);
[n, bin] = histc(j, unique(j));
multiple = find(n > 1);
for indexI = 1:length(multiple)
index    = find(ismember(bin, multiple(indexI))); 
bin(index(2:end)) = [];
mainDrinkingData(index(2:end),:) = [];
end

[bMain,i,j] = unique(mainDrinkingData.KEY);

%%%%temporary code to filter out data that doesn't match the main table...
% [bSub,i,j] = unique(subDrinkingData.KEY);
% [bothTables, inMain, inSub] = intersect(bMain, bSub);
% [keepSub, inSub, ~] = intersect(subDrinkingData.KEY, bothTables);
% subDrinkingData = subDrinkingData(inSub,:);
% [keepMain, inMain, ~] = intersect(mainDrinkingData.KEY, bothTables);
% mainDrinkingData = mainDrinkingData(inMain,:);
%%%%end temporary code, comment out when data bug is fixed

fullDrinkingData = join(subDrinkingData, mainDrinkingData, 'KEY');

crowdsource = fullDrinkingData.crowdsource;

recall = fullDrinkingData.recall;
recall(cellfun(@isnumeric, recall)) = {'empty'};
[b,i,recallIndex] = unique(recall);

varQuality = cell(3,2);
distCell = cell(3,2);
distCell{1,1} = zeros(25,1);
distCell{2,1} = zeros(25,1);
distCell{3,1} = zeros(25,1);
distCell{1,2} = zeros(25,1);
distCell{2,2} = zeros(25,1);
distCell{3,2} = zeros(25,1);
mQuality = cell(3,2);
qualityFig = figure;
set(gcf,'Position',[10,10,1600,500]);

subplot(3,2,1)
subDataset = fullDrinkingData(crowdsource == 0 & recallIndex == 3,{'SubmissionDate','simserial','how_quality'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.how_quality(simIndex == indexI));
   hold on;
   varQuality{1,1}(end+1) = var(subDataset.how_quality(simIndex == indexI));
   mQuality{1,1}(end+1) = mean(subDataset.how_quality(simIndex == indexI));
   distCell{1,1}(length(subDataset.how_quality(simIndex == indexI))) =  distCell{1,1}(length(subDataset.how_quality(simIndex == indexI))) + 1;
end
title('Weekly, Self');

subplot(3,2,3)
subDataset = fullDrinkingData(crowdsource == 0 & recallIndex == 1,{'SubmissionDate','simserial','how_quality'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.how_quality(simIndex == indexI));
   hold on;
   varQuality{2,1}(end+1) = var(subDataset.how_quality(simIndex == indexI));
   mQuality{2,1}(end+1) = mean(subDataset.how_quality(simIndex == indexI));
   distCell{2,1}(length(subDataset.how_quality(simIndex == indexI))) =  distCell{2,1}(length(subDataset.how_quality(simIndex == indexI))) + 1;
end
title('Monthly, Self');

subplot(3,2,5)
subDataset = fullDrinkingData(crowdsource == 0 & recallIndex == 2,{'SubmissionDate','simserial','how_quality'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.how_quality(simIndex == indexI));
   hold on;
   varQuality{3,1}(end+1) = var(subDataset.how_quality(simIndex == indexI));
   mQuality{3,1}(end+1) = mean(subDataset.how_quality(simIndex == indexI));
   distCell{3,1}(length(subDataset.how_quality(simIndex == indexI))) =  distCell{3,1}(length(subDataset.how_quality(simIndex == indexI))) + 1;
end
title('Seasonally, Self');

subplot(3,2,2)
subDataset = fullDrinkingData(crowdsource == 1 & recallIndex == 3,{'SubmissionDate','simserial','how_quality'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.how_quality(simIndex == indexI));
   hold on;
   varQuality{1,2}(end+1) = var(subDataset.how_quality(simIndex == indexI));
   mQuality{1,2}(end+1) = mean(subDataset.how_quality(simIndex == indexI));
   distCell{1,2}(length(subDataset.how_quality(simIndex == indexI))) =  distCell{1,2}(length(subDataset.how_quality(simIndex == indexI))) + 1;
end
title('Weekly, Crowd');

subplot(3,2,4)
subDataset = fullDrinkingData(crowdsource == 1 & recallIndex == 1,{'SubmissionDate','simserial','how_quality'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.how_quality(simIndex == indexI));
   hold on;
   varQuality{2,2}(end+1) = var(subDataset.how_quality(simIndex == indexI));
   mQuality{2,2}(end+1) = mean(subDataset.how_quality(simIndex == indexI));
   distCell{2,2}(length(subDataset.how_quality(simIndex == indexI))) =  distCell{2,2}(length(subDataset.how_quality(simIndex == indexI))) + 1;
end
title('Monthly, Crowd');

subplot(3,2,6)
subDataset = fullDrinkingData(crowdsource == 1 & recallIndex == 2,{'SubmissionDate','simserial','how_quality'});
sim = subDataset.simserial;
sim(cellfun(@isnumeric, sim)) = {'empty'};
[b,i,simIndex] = unique(sim);

for indexI = 1:max(simIndex)
   plot(subDataset.SubmissionDate(simIndex == indexI), subDataset.how_quality(simIndex == indexI));
   hold on;
   varQuality{3,2}(end+1) = var(subDataset.how_quality(simIndex == indexI));
   mQuality{3,2}(end+1) = mean(subDataset.how_quality(simIndex == indexI));
   distCell{3,2}(length(subDataset.how_quality(simIndex == indexI))) =  distCell{3,2}(length(subDataset.how_quality(simIndex == indexI))) + 1;
end
title('Seasonally, Crowd');

suptitle('Quality');


histFig = figure;

subplot(3,2,1)
a = hist(fullDrinkingData.how_quality(recallIndex == 3 & crowdsource == 0));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,3)
a = hist(fullDrinkingData.how_quality(recallIndex == 1 & crowdsource == 0));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,5)
a = hist(fullDrinkingData.how_quality(recallIndex == 2 & crowdsource == 0));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,2)
a = hist(fullDrinkingData.how_quality(recallIndex == 3 & crowdsource == 1));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,4)
a = hist(fullDrinkingData.how_quality(recallIndex == 1 & crowdsource == 1));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);
subplot(3,2,6)
a = hist(fullDrinkingData.how_quality(recallIndex == 2 & crowdsource == 1));
a = a/sum(a);
bar(a);
axis([0.5 10.5 0 0.25]);

fullDrinkingData = replacedata(fullDrinkingData, x2mdate(fullDrinkingData.SubmissionDate),'SubmissionDate');

fullDrinkingData.weekGroup = floor((fullDrinkingData.SubmissionDate - datenum(2015,12,13))/7);

%want to look at box plots, by frequency, by week, by place
boxFig = figure;

subplot(3,2,1)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 3 & crowdsource == 0),fullDrinkingData.weekGroup(recallIndex == 3 & crowdsource == 0));
subplot(3,2,3)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 1 & crowdsource == 0),fullDrinkingData.weekGroup(recallIndex == 1 & crowdsource == 0));
subplot(3,2,5)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 2 & crowdsource == 0),fullDrinkingData.weekGroup(recallIndex == 2 & crowdsource == 0));
subplot(3,2,2)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 3 & crowdsource == 1),fullDrinkingData.weekGroup(recallIndex == 3 & crowdsource == 1));
subplot(3,2,4)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 1 & crowdsource == 1),fullDrinkingData.weekGroup(recallIndex == 1 & crowdsource == 1));
subplot(3,2,6)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 2 & crowdsource == 1),fullDrinkingData.weekGroup(recallIndex == 2 & crowdsource == 1));

boxFig = figure;

subplot(3,1,1)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 3),fullDrinkingData.weekGroup(recallIndex == 3));
subplot(3,1,2)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 1),fullDrinkingData.weekGroup(recallIndex == 1));
subplot(3,1,3)
a = boxplot(fullDrinkingData.how_quality(recallIndex == 2),fullDrinkingData.weekGroup(recallIndex == 2));

qualVar1 = zeros(5,13);
cellQual1 = cell(13,1);
cellQual2 = cell(13,1);
cellQual3 = cell(13,1);

for indexI = 0:max(fullDrinkingData.weekGroup)
    qualVar1(:,indexI+1) = hist(fullDrinkingData.how_quality(recallIndex == 3 & fullDrinkingData.weekGroup == indexI & fullDrinkingData.how_quality <= 5 & fullDrinkingData.how_quality >= 1),1:5);
    cellQual1{indexI+1} = fullDrinkingData.how_quality(recallIndex == 3 & fullDrinkingData.weekGroup == indexI & fullDrinkingData.how_quality <= 5 & fullDrinkingData.how_quality >= 1);
end
qualVar1 = qualVar1 ./ (ones(5,1) * sum(qualVar1) );
qualVar2 = zeros(5,13);
for indexI = 0:max(fullDrinkingData.weekGroup)
    qualVar2(:,indexI+1) = hist(fullDrinkingData.how_quality(recallIndex == 1 & fullDrinkingData.weekGroup == indexI & fullDrinkingData.how_quality <= 5 & fullDrinkingData.how_quality >= 1),1:5);
    cellQual2{indexI+1} = fullDrinkingData.how_quality(recallIndex == 1 & fullDrinkingData.weekGroup == indexI & fullDrinkingData.how_quality <= 5 & fullDrinkingData.how_quality >= 1);
end
qualVar2 = qualVar2 ./ (ones(5,1) * sum(qualVar2) );
qualVar3 = zeros(5,13);
for indexI = 0:max(fullDrinkingData.weekGroup)
    qualVar3(:,indexI+1) = hist(fullDrinkingData.how_quality(recallIndex == 2 & fullDrinkingData.weekGroup == indexI & fullDrinkingData.how_quality <= 5 & fullDrinkingData.how_quality >= 1),1:5);
    cellQual3{indexI+1} = fullDrinkingData.how_quality(recallIndex == 2 & fullDrinkingData.weekGroup == indexI & fullDrinkingData.how_quality <= 5 & fullDrinkingData.how_quality >= 1);
end
qualVar3 = qualVar3 ./ (ones(5,1) * sum(qualVar3) );

ksResults = zeros(13,1);
for indexI = 1:13
   ksResults(indexI) = kstest2(cellQual1{indexI},cellQual2{indexI});
end
%kstest(fullDrinkingData.how_quality(recallIndex == 3 & crowdsource == 0),fullDrinkingData.how_quality(recallIndex == 1 & crowdsource == 0));