# salesforce Leads queries.......

# stage by no of leads
select o.Stage, sum(l.`Total Leads`) as no_of_leads from opportunity_table o join lead1 l on o.`Opportunity ID`=l.`Converted Opportunity ID` 
group by o.Stage order by no_of_leads desc;
# top 10 Source by no of leads
select `Lead Source`,sum(`Total Leads`)as no_of_leads from lead1 group by `Lead Source` order by no_of_leads desc limit 10;
# bottom 10 source by no of leads
select `Lead Source`, sum(`Total Leads`) as no_of_leads from lead1 group by `Lead Source` order by no_of_leads  asc limit 10;
# industry by no of leads
select Industry, sum(`Total Leads`) as no_of_leads from lead1 group by Industry order by no_of_leads desc;
# total leads
select sum(`Total Leads`) as Total_Leads from lead1;
# converted accounts
select sum(`# Converted Accounts`) as Total_Converted_Acc from lead1;
# converted opportunities
select sum(`# Converted Opportunities`) as Total_Converted_Opp from lead1;
# conversion rate
select concat(format(sum(`# Converted Accounts`)*100/sum(`Total Leads`),2),"%") as Conversion_rate from lead1;
# expected amount
select concat(format(sum(o.`Expected Amount`)/1000000,2)," M") as Expected_Amt_from_ConvOpp from opportunity_table o 
join lead1 l on o.`Opportunity ID`=l.`Converted Opportunity ID`;

# salesforce opportunity queries....

# Expected amount
select concat(format(sum(`Expected Amount`)/1000000,2),"M") as Expected_Amount from opportunity_table;

# Active opportunities
select count(`Opportunity ID`) as Active_Opportunities from opportunity_table where Stage not in ("Closed Won","Closed Lost");

# Conversion rate
select concat(round(count(case when Stage="Closed Won" then `Opportunity ID` end)*100/ count(`Opportunity ID`),2),"%") 
as Conversion_rate from opportunity_table;

# Loss rate
select concat(round(count(case when Stage="Closed Lost" then `Opportunity ID` end)*100/count(`Opportunity ID`),2),"%") 
as Loss_rate from opportunity_table;

# Expected amount vs actual amount
select year(`Close Date`) as year1,
concat(format(sum(`Expected Amount`)/1000000,2),"M") as Expected_Amount,
concat(format(sum(case when Stage="Closed Won" then Amount end)/1000000,2),"M") as Actual_Amount 
from opportunity_table where year(`Close Date`) not in (2025,2030) group by year(`Close Date`) order by year1;

# Active vs total opportunities
select year(`Close Date`) as year1,
count(case when Stage not in ("Closed Won","Closed Lost") then `Opportunity ID` end) as Active_Opportunities, 
count(`Opportunity ID`) as total_opportunities from opportunity_table
where year(`Close Date`) not in (2025,2030) group by year(`Close Date`) order by year1;

# Closed won vs total opportunities
select year(`Close Date`) as year1,
count(case when Stage="Closed Won" then `Opportunity ID` end) as Closed_Won,
count(`Opportunity ID`)as total_opportunities from opportunity_table
where year(`Close Date`) not in (2025,2030) group by year(`Close Date`) order by year1;

# Total closed vs closed won opportunities
select year(`Close Date`) as year1,
count(case when Stage in ("Closed Won","Closed Lost") then `Opportunity ID` end) as Total_Closed,
count(case when Stage="Closed Won" then `Opportunity ID` end) as Closed_Won from opportunity_table
where year(`Close Date`) not in (2025,2030) group by year(`Close Date`) order by year1;

# Opportunity type by expected amount
select `Opportunity Type` as Opportunity_type, concat(format(sum(`Expected Amount`)/1000000,2),"M") as Expected_Amount 
from opportunity_table where `Opportunity Type` is not null group by `Opportunity Type`;

# Industry by opportunities
select Industry, count(`Opportunity ID`) as Total_Opportunities from opportunity_table group by Industry order by Total_Opportunities desc limit 10;