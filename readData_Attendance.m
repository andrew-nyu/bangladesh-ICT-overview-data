clear all;
close all;

[~,~,r] = xlsread('schoolAttendance.xlsx');

r{1,1} = 'ID';
mainSchoolData = cell2dataset(r);

[~,~,r] = xlsread('schoolAttendance_missed_school.xlsx');

r{1,1} = 'ID';
subSchoolData = cell2dataset(r);

subSchoolData = replacedata(subSchoolData, regexprep(subSchoolData.KEY,'/missed_school\[.\]',''),'KEY');

[bMain,i,j] = unique(mainSchoolData.KEY);
[n, bin] = histc(j, unique(j));
multiple = find(n > 1);
for indexI = 1:length(multiple)
index    = find(ismember(bin, multiple(indexI))); 
bin(index(2:end)) = [];
mainSchoolData(index(2:end),:) = [];
end

[bMain,i,j] = unique(mainSchoolData.KEY);

%%%%temporary code to filter out data that doesn't match the main table...
[bSub,i,j] = unique(subSchoolData.KEY);
[bothTables, inMain, inSub] = intersect(bMain, bSub);
while(size(inSub,1) > 0)
    [~, inSub] = setdiff(subSchoolData.KEY, bothTables);
    subSchoolData(inSub,:) = [];
end
while(size(inMain,1) > 0)
    [~, inMain] = setdiff(mainSchoolData.KEY, bothTables);
    mainSchoolData(inMain,:) = [];
end
%%%%end temporary code, comment out when data bug is fixed

fullSchoolData = join(subSchoolData, mainSchoolData, 'KEY');

days_ill = fullSchoolData.days_ill;
days_ill(cellfun(@ischar, days_ill)) = {0};
fullSchoolData = replacedata(fullSchoolData,cell2mat(days_ill), 'days_ill');

[b,i,j] = unique(fullSchoolData.recall);
recall(j == 2) = 3;
recall(j == 1) = 2;
recall(j == 3) = 1;

numWeeks = max(fullSchoolData.week_number);

aveDaysIllReported = zeros(numWeeks,3);
aveDaysIllReported1 = zeros(numWeeks,3);
aveDaysIllReported2 = zeros(numWeeks,3);
aveDaysIllReported3 = zeros(numWeeks,3);
aveDaysIllReported4 = zeros(numWeeks,3);
aveDaysIllReported5 = zeros(numWeeks,3);
aveDaysIllReported6 = zeros(numWeeks,3);
aveDaysIllReported7 = zeros(numWeeks,3);
numResponses = zeros(numWeeks,3);
numResponses1 = zeros(numWeeks,3);
numResponses2 = zeros(numWeeks,3);
numResponses3 = zeros(numWeeks,3);
numResponses4 = zeros(numWeeks,3);
numResponses5 = zeros(numWeeks,3);
numResponses6 = zeros(numWeeks,3);
numResponses7 = zeros(numWeeks,3);

for indexI = 1:size(fullSchoolData,1)
    if (fullSchoolData.week_number(indexI) < numWeeks+1)
        aveDaysIllReported(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
        numResponses(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
        if(~isnan(fullSchoolData.reasons_miss{indexI}))
            temp = fullSchoolData.reasons_miss{indexI};
            if(~isnumeric(temp))
                temp = str2mat(regexp(temp,'\s','split'));
            end
            if(isnumeric(temp))
                for indexJ = 1:length(temp)
                    if(temp(indexJ) == 1)
                        numResponses1(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses1(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported1(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported1(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                    if(temp(indexJ) == 2)
                        numResponses2(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses2(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported2(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported2(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                    if(temp(indexJ) == 3)
                        numResponses3(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses3(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported3(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported3(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                    if(temp(indexJ) == 4)
                        numResponses4(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses4(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported4(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported4(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                    if(temp(indexJ) == 5)
                        numResponses5(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses5(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported5(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported5(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                    if(temp(indexJ) == 6)
                        numResponses6(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses6(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported6(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported6(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                    if(temp(indexJ) == 7)
                        numResponses7(fullSchoolData.week_number(indexI), recall(indexI)) = numResponses7(fullSchoolData.week_number(indexI), recall(indexI)) + 1;
                        aveDaysIllReported7(fullSchoolData.week_number(indexI), recall(indexI)) = aveDaysIllReported7(fullSchoolData.week_number(indexI), recall(indexI)) + fullSchoolData.days_ill(indexI);
                    end
                end
            end
        end
    end
end

[b,i,j] = unique(mainSchoolData.recall);
recall(j == 2) = 3;
recall(j == 1) = 2;
recall(j == 3) = 1;

numResponsesHH = zeros(numWeeks,3);

for indexI = 1:size(mainSchoolData,1)
    numResponsesHH(mainSchoolData.week_number(indexI), recall(indexI)) = numResponsesHH(mainSchoolData.week_number(indexI), recall(indexI)) + 1;
end

aveDaysPerSickPersonPerWeek = aveDaysIllReported ./ numResponses ./ (ones(numWeeks,1) * [7 30 30]) * 7;

aveDaysPerHHPerWeek = aveDaysIllReported ./ numResponsesHH ./ (ones(numWeeks,1) * [7 30 30]) * 7;

aveDays1PerWeek = aveDaysIllReported1 ./ numResponses1 ./ (ones(numWeeks,1) * [7 30 30]) * 7;
aveDays2PerWeek = aveDaysIllReported2 ./ numResponses2 ./ (ones(numWeeks,1) * [7 30 30]) * 7;
aveDays3PerWeek = aveDaysIllReported3 ./ numResponses3 ./ (ones(numWeeks,1) * [7 30 30]) * 7;
aveDays4PerWeek = aveDaysIllReported4 ./ numResponses4 ./ (ones(numWeeks,1) * [7 30 30]) * 7;
aveDays5PerWeek = aveDaysIllReported5 ./ numResponses5 ./ (ones(numWeeks,1) * [7 30 30]) * 7;
aveDays6PerWeek = aveDaysIllReported6 ./ numResponses6 ./ (ones(numWeeks,1) * [7 30 30]) * 7;
aveDays7PerWeek = aveDaysIllReported7 ./ numResponses7 ./ (ones(numWeeks,1) * [7 30 30]) * 7;

plot(aveDays1PerWeek(:,1),'ko-')
hold on
plot(aveDays1PerWeek(:,2),'kv--')
plot(aveDays1PerWeek(:,3),'ks:')
xlabel('Week of Data Collection','FontSize',12)
ylabel('Days per week per reported illness','FontSize',12);
legend({'Asking weekly (7 day recall)','Asking monthly (30 day recall)','Asking seasonally (30 day recall)'},'FontSize',12);
axis([2 13 0 3.5])