clear all;
close all;

[~,~,r] = xlsread('RangpurIDs.xlsx');

r{1,1} = 'ID';
rangpurID = cell2dataset(r);

[~,~,r] = xlsread('RangpurPrimaryResp.xlsx');

r{1,1} = 'ID';
rangpurBIHS = cell2dataset(r);

[~,~,r] = xlsread('rangpurCrowd.xlsx');

rangpurCrowd = cell2dataset(r);

[~,~,r] = xlsread('mainSampleDem.xlsx');

rangpurMain = cell2dataset(r);

[inBoth, inRangpur, inBIHS] = intersect(rangpurID.ID, rangpurBIHS.ID);

rangpurBIHS = rangpurBIHS(inBIHS,:);

[b,i,j] = unique(rangpurBIHS.b1_08);

recodeEd = [14 2 4 5 6 7 8 9 12 10 16 0 0];

rangpurBIHS.yearsEd = recodeEd(j)';

[b,i,j] = unique(rangpurBIHS.b1_01);
j(j == 2) = 0;  %2 is male here, 1 is female; 
rangpurBIHS.gender = j;


[b,i,j] = unique(rangpurCrowd.gender);
j(j == 1) = 0;
j(j == 2) = 1;
rangpurCrowd.gender = j;

[b,i,j] = unique(rangpurMain.sex);
j(j == 1) = 0;
j(j == 2) = 1;
rangpurMain.gender = j;

highest_class = rangpurMain.highest_class;
highest_class(cellfun(@ischar, highest_class)) = {NaN};
highest_class = cell2mat(highest_class);
%highest_class(isnan(highest_class)) = 0;

temp = rangpurMain.education;
temp(temp == 99) = 0;
temp(temp == 1) = 0;
temp(temp == 3) = 11;
temp(temp == 4) = 13;
temp(temp == 5) = 14;
temp(temp == 6) = 16;
temp(temp == 7) = 10;
temp(temp == 2) = highest_class(temp == 2);

rangpurMain.yearsEd = temp;

highest_class = rangpurCrowd.highest_class;
highest_class(cellfun(@ischar, highest_class)) = {NaN};
highest_class = cell2mat(highest_class);


relationship = rangpurCrowd.relationship;
relationship(cellfun(@ischar, relationship)) = {NaN};
rel = cell2mat(relationship);
rangpurCrowd.rel = rel;

temp = rangpurCrowd.education;
temp(temp == 99) = 0;
temp(temp == 1) = 0;
temp(temp == 3) = 11;
temp(temp == 4) = 13;
temp(temp == 5) = 14;
temp(temp == 6) = 16;
temp(temp == 7) = 10;
temp(temp == 2) = highest_class(temp == 2);
rangpurCrowd.yearsEd = temp;

rangpurCrowd(rangpurCrowd.yearsEd > 16,:) =[];
rangpurCrowd(rangpurCrowd.age > 100,:) =[];
rangpurMain(rangpurMain.age > 100,:) = [];
rangpurMain(isnan(rangpurMain.yearsEd),:) = [];

%%%%%make comparisons - age vs education first

ageInc = 10;
edInc = 5;

rangpurBIHSMat = zeros(100/ageInc, 20/edInc);
rangpurMainMat = zeros(100/ageInc, 20/edInc);
rangpurCrowdMat = zeros(100/ageInc, 20/edInc);


for indexI = 1:length(rangpurBIHS)
   rangpurBIHSMat(floor(rangpurBIHS.b1_02(indexI)/ageInc)+1, floor(rangpurBIHS.yearsEd(indexI)/edInc)+1) = rangpurBIHSMat(floor(rangpurBIHS.b1_02(indexI)/ageInc)+1, floor(rangpurBIHS.yearsEd(indexI)/edInc)+1) + 1;
end

rangpurBIHSMat = rangpurBIHSMat/ sum(sum(rangpurBIHSMat));

for indexI = 1:length(rangpurMain)
   rangpurMainMat(floor(rangpurMain.age(indexI)/ageInc)+1, floor(rangpurMain.yearsEd(indexI)/edInc)+1) = rangpurMainMat(floor(rangpurMain.age(indexI)/ageInc)+1, floor(rangpurMain.yearsEd(indexI)/edInc)+1) + 1;
end

rangpurMainMat = rangpurMainMat/ sum(sum(rangpurMainMat));

for indexI = 1:length(rangpurCrowd)
   rangpurCrowdMat(floor(rangpurCrowd.age(indexI)/ageInc)+1, floor(rangpurCrowd.yearsEd(indexI)/edInc)+1) = rangpurCrowdMat(floor(rangpurCrowd.age(indexI)/ageInc)+1, floor(rangpurCrowd.yearsEd(indexI)/edInc)+1) + 1;
end

rangpurCrowdMat = rangpurCrowdMat/ sum(sum(rangpurCrowdMat));

barMat = [sum(rangpurBIHSMat); sum(rangpurCrowdMat); sum(rangpurMainMat) ];

edMat = zeros(16,max(rangpurCrowd.week_number));
edAvg = zeros(16,1);
for indexI = 1:max(rangpurCrowd.week_number)
   edMat(:,indexI) = hist(rangpurCrowd.yearsEd(rangpurCrowd.week_number == indexI),1:16);
   edAvg(indexI) = mean(rangpurCrowd.yearsEd(rangpurCrowd.week_number == indexI));
end

plot(3:15, edAvg(3:15),'ko')
set(gca,'FontSize',12)
xlabel('Week of Data Collection','FontSize',12)
ylabel('Average Years Education in Crowdsourced Sample','FontSize',12)
[B,BINT,R,RINT,STATS] = regress(edAvg(3:15)', [ones(13,1) 3:15]);
hold on;
plot([1 16], B(1) + B(2) *[1 16],'k');

legend('Average Years Education', 'Best Fit Line');

