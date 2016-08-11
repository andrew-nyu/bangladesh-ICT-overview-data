clear all;
close all;

[~,~,r] = xlsread('employment.xlsx');

r{1,1} = 'ID';
mainJobData = cell2dataset(r);

[~,~,r] = xlsread('employment_work_done.xlsx');

r{1,1} = 'ID';
subJobData = cell2dataset(r);

subJobData = replacedata(subJobData, regexprep(subJobData.KEY,'/work_done\[.\]',''),'KEY');

[bMain,i,j] = unique(mainJobData.KEY);
[n, bin] = histc(j, unique(j));
multiple = find(n > 1);
for indexI = 1:length(multiple)
index    = find(ismember(bin, multiple(indexI))); 
bin(index(2:end)) = [];
mainJobData(index(2:end),:) = [];
end

[bMain,i,j] = unique(mainJobData.KEY);

%%%%temporary code to filter out data that doesn't match the main table...
[bSub,i,j] = unique(subJobData.KEY);
[bothTables, inMain, inSub] = intersect(bMain, bSub);
while(size(inSub,1) > 0)
    [~, inSub] = setdiff(subJobData.KEY, bothTables);
    subJobData(inSub,:) = [];
end
while(size(inMain,1) > 0)
    [~, inMain] = setdiff(mainJobData.KEY, bothTables);
    mainJobData(inMain,:) = [];
end
%%%%end temporary code, comment out when data bug is fixed

fullJobData = join(subJobData, mainJobData, 'KEY');

crowdsource = fullJobData.crowdsource;

recall = fullJobData.recall;
recall(cellfun(@isnumeric, recall)) = {'empty'};
[b,i,recallIndex] = unique(recall);

days_work = fullJobData.days_work;
days_work(cellfun(@ischar, days_work)) = {NaN};
days_work = cell2mat(days_work);
days_work(isnan(days_work)) = 0;

hours_work = fullJobData.hours_work;
hours_work(cellfun(@ischar, hours_work)) = {NaN};
hours_work = cell2mat(hours_work);
hours_work(isnan(hours_work)) = 0;

wage = fullJobData.wages_cash;
wage(cellfun(@ischar, wage)) = {NaN};
wage = cell2mat(wage);
wage(isnan(wage)) = 0;

fullJobData.personHours = days_work .* hours_work;

%fullJobData.personHours = hours_work;
fullJobData.hourlyWage = wage ./ fullJobData.personHours;
fullJobData.wage = wage;


jobHoursMat = zeros(0,2);
jobWageMat = zeros(0,2);
hhIncomeMat = zeros(0,2);

[b,i,j] = unique(fullJobData.imei);
for indexI = 1:max(j)
   jobHoursMat(indexI,1) = sum(fullJobData.personHours(j == indexI));
   jobHoursMat(indexI,2) = min(recallIndex(j == indexI));
   jobWageMat(indexI,1) = mean(fullJobData.hourlyWage(j == indexI));
   jobWageMat(indexI,2) = min(recallIndex(j == indexI));
   hhIncomeMat(indexI,1) = sum(fullJobData.wage(j == indexI));
   hhIncomeMat(indexI,2) = min(recallIndex(j == indexI));
end

jobHoursMat(isnan(jobHoursMat(:,1)),:) = [];
jobWageMat(isnan(jobWageMat)) = 0;
jobWageMat(isinf(jobWageMat)) = 0;

f=1;