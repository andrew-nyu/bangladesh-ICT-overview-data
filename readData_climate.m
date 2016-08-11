clear all;
close all;

[~,~,r] = xlsread('ClimateEvent.xlsx');

r{1,1} = 'ID';
mainClimateData = cell2dataset(r);

[b,i,j] = unique(mainClimateData.imei);

mainClimateData.hhid = j;

monthInstances = zeros(13, 3);
monthRisks = zeros(13, 3);
monthSeverity = zeros(13, 3);
monthResponses = zeros(13, 1);

seasonInstances = zeros(13, 3);
seasonRisks = zeros(13, 3);
seasonSeverity = zeros(13, 3);
seasonResponses = zeros(13, 1);

monthMentioned = zeros(length(b),3);
seasonMentioned = zeros(length(b),3);

monthIMEI = zeros(length(b),1);
seasonIMEI = zeros(length(b),1);

for indexI = 1:size(mainClimateData,1)
   if(mainClimateData.recall_length(indexI) > 30)
       seasonIMEI(mainClimateData.hhid(indexI)) = 1;
       seasonResponses(mainClimateData.week_number(indexI)) = seasonResponses(mainClimateData.week_number(indexI)) + 1;
       if(~isnan(mainClimateData.experience_events{indexI}))
           temp = mainClimateData.experience_events{indexI};
           if(~isnumeric(temp))
            temp = str2mat(regexp(temp,'\s','split'));
           end
           if(isnumeric(temp))
           for indexJ = 1:length(temp)
              seasonInstances(mainClimateData.week_number(indexI),temp(indexJ)) = seasonInstances(mainClimateData.week_number(indexI),temp(indexJ)) + 1;
              seasonRisks(mainClimateData.week_number(indexI),1) = seasonRisks(mainClimateData.week_number(indexI),1) + mainClimateData.flooding_risk(indexI);
              seasonRisks(mainClimateData.week_number(indexI),2) = seasonRisks(mainClimateData.week_number(indexI),2) + mainClimateData.drought_risk(indexI);
              seasonRisks(mainClimateData.week_number(indexI),3) = seasonRisks(mainClimateData.week_number(indexI),3) + mainClimateData.cyclone_risk(indexI);
              
              seasonSeverity(mainClimateData.week_number(indexI),1) = seasonSeverity(mainClimateData.week_number(indexI),1) + mainClimateData.flooding_severity(indexI);
              seasonSeverity(mainClimateData.week_number(indexI),2) = seasonSeverity(mainClimateData.week_number(indexI),2) + mainClimateData.drought_severity(indexI);
              seasonSeverity(mainClimateData.week_number(indexI),3) = seasonSeverity(mainClimateData.week_number(indexI),3) + mainClimateData.cyclone_severity(indexI);
             
              seasonMentioned(mainClimateData.hhid(indexI), temp(indexJ)) = 1;
           end
           end
       end
       
   else
       monthIMEI(mainClimateData.hhid(indexI)) = 1;
       monthResponses(mainClimateData.week_number(indexI)) = monthResponses(mainClimateData.week_number(indexI)) + 1;
       if(~isnan(mainClimateData.experience_events{indexI}))
           temp = mainClimateData.experience_events{indexI};
           if(~isnumeric(temp))
            temp = str2mat(regexp(temp,'\s','split'));
           end
           if(isnumeric(temp))
           for indexJ = 1:length(temp)
              monthInstances(mainClimateData.week_number(indexI),temp(indexJ)) = monthInstances(mainClimateData.week_number(indexI),temp(indexJ)) + 1;
              monthRisks(mainClimateData.week_number(indexI),1) = monthRisks(mainClimateData.week_number(indexI),1) + mainClimateData.flooding_risk(indexI);
              monthRisks(mainClimateData.week_number(indexI),2) = monthRisks(mainClimateData.week_number(indexI),2) + mainClimateData.drought_risk(indexI);
              monthRisks(mainClimateData.week_number(indexI),3) = monthRisks(mainClimateData.week_number(indexI),3) + mainClimateData.cyclone_risk(indexI);
              
              monthSeverity(mainClimateData.week_number(indexI),1) = monthSeverity(mainClimateData.week_number(indexI),1) + mainClimateData.flooding_severity(indexI);
              monthSeverity(mainClimateData.week_number(indexI),2) = monthSeverity(mainClimateData.week_number(indexI),2) + mainClimateData.drought_severity(indexI);
              monthSeverity(mainClimateData.week_number(indexI),3) = monthSeverity(mainClimateData.week_number(indexI),3) + mainClimateData.cyclone_severity(indexI);
              
              monthMentioned(mainClimateData.hhid(indexI), temp(indexJ)) = 1;
           end
           end
       end
   end
end

seasonFraction = seasonInstances ./ (seasonResponses * ones(1,3));
seasonAveRisk = seasonRisks ./ (seasonResponses * ones(1,3));
seasonAveSeverity = seasonSeverity ./ (seasonResponses * ones(1,3));

monthFraction = monthInstances ./ (monthResponses * ones(1,3));
monthAveRisk = monthRisks ./ (monthResponses * ones(1,3));
monthAveSeverity = monthSeverity ./ (monthResponses * ones(1,3));

monthFracTotal = sum(monthMentioned)/sum(monthIMEI);
seasonFracTotal = sum(seasonMentioned)/sum(seasonIMEI);

diffFloodRisk = kstest2(mainClimateData.flooding_risk(mainClimateData.recall_length <= 30), mainClimateData.flooding_risk(mainClimateData.recall_length > 30));
diffFloodSev = kstest2(mainClimateData.flooding_severity(mainClimateData.recall_length <= 30), mainClimateData.flooding_severity(mainClimateData.recall_length > 30));

diffDroughtRisk = kstest2(mainClimateData.drought_risk(mainClimateData.recall_length <= 30), mainClimateData.drought_risk(mainClimateData.recall_length > 30));
diffDroughtSev = kstest2(mainClimateData.drought_severity(mainClimateData.recall_length <= 30), mainClimateData.drought_severity(mainClimateData.recall_length > 30));

diffCycloneRisk = kstest2(mainClimateData.cyclone_risk(mainClimateData.recall_length <= 30), mainClimateData.cyclone_risk(mainClimateData.recall_length > 30));
diffCycloneSev = kstest2(mainClimateData.cyclone_severity(mainClimateData.recall_length <= 30), mainClimateData.cyclone_severity(mainClimateData.recall_length > 30));

mdiffFloodRisk = [mean(mainClimateData.flooding_risk(mainClimateData.recall_length <= 30)), mean(mainClimateData.flooding_risk(mainClimateData.recall_length > 30))];
mdiffFloodSev = [mean(mainClimateData.flooding_severity(mainClimateData.recall_length <= 30)), mean(mainClimateData.flooding_severity(mainClimateData.recall_length > 30))];

mdiffDroughtRisk = [mean(mainClimateData.drought_risk(mainClimateData.recall_length <= 30)), mean(mainClimateData.drought_risk(mainClimateData.recall_length > 30))];
mdiffDroughtSev = [mean(mainClimateData.drought_severity(mainClimateData.recall_length <= 30)), mean(mainClimateData.drought_severity(mainClimateData.recall_length > 30))];

mdiffCycloneRisk = [mean(mainClimateData.cyclone_risk(mainClimateData.recall_length <= 30)), mean(mainClimateData.cyclone_risk(mainClimateData.recall_length > 30))];
mdiffCycloneSev = [mean(mainClimateData.cyclone_severity(mainClimateData.recall_length <= 30)), mean(mainClimateData.cyclone_severity(mainClimateData.recall_length > 30))];