$ontext
CEE 5410 Fall 2024
Chapter 7 Problem #1

A farmer plans to develop water for irrigation. He is considering two possible sources of
water: a gravity diversion from a possible reservoir with two alternative capacities and/or a
pump from a lower river diversion (refer to Figure 7.3). Between the reservoir and pump
site the river base flow increases by 2 acft/day due to groundwater drainage into the river.
Ignore losses from the reservoir. The river flow into the reservoir and the farmer's demand
during each of two six-month seasons of the year are given in Table 7.5. Revenue is estimated
at $300 per year per acre irrigated.

Assume that there are only two possible sizes of reservoir: a high dam that has capacity of
700 acft or a low dam with capacity of 300 acft. The capital costs are $10,000/year and
$6,000/year for the high and low dams, respectively (no operating cost). The pump capacity
is fixed at 2.2 acft/day with a capital cost (if it is built) of $8,000/year and operating
cost of $20/acft.

Patrick Archibald
A02268222@usu.edu
October 14, 2024
$offtext

* 1. DEFINE the SETS
SETS seasons two seasons of the year /season1, season2/
     choice  choices of what infrastructure to built /HighDam, LowDam, PumpChoice/;

* 2. DEFINE input data
PARAMETERS
   Qin(seasons) inflow in each season (ac-ft)
                /season1 600, season2 200/
   IrrDem(seasons) irrigation demand in each season (ac-ft per acre)
                /season1 1, season2 3/
   CapitalCost(choice) capital cost for each option ($)
                /HighDam 10000, LowDam 6000, PumpChoice 8000/
   CapHigh       high reservoir capacity (ac-ft)
                /700/
   CapLow        low reservoir capacity (ac-ft)
                /300/
   PumpCap      pump capacity (ac-ft per day)
                /2.2/
   PumpOpCost   pump operating cost ($ per ac-ft)
                /20/
   Revenue      revenue from crops ($ per acre per year)
                /300/
   Days         seasons changed to days (assume 182.5 days = 6 months)
                /182.5/;

* 3. DEFINE the variables
VARIABLES
   IrrAcre(seasons)           total irrigated acres
   IrrWat(seasons)            total water sent to irrigation
   PumpOperatingCostVar       variable just for operating cost for pump
   BinVar(choice)    binary variables (1 is yes and 0 is no)
   TotalCost         total capital and operating costs
   GrossRev          gross revenue from crops
   NetRev            net revenue;

BINARY VARIABLES BinVar;
* Non-negativity constraints
POSITIVE VARIABLES IrrAcre, IrrWat;

* 4. COMBINE variables and data in equations
EQUATIONS
   COST            total cost ($)
   GROSS_REVENUE   gross revenue from crops ($)
   NET_REVENUE     net revenue (gross - costs in $)
   DEFINE_PUMP_COST     pump cost variable definition
   IRRWAT_CAPACITY_HIGH   capacity constraint on water available with high dam
   IRRWAT_CAPACITY_LOW    capacity constraint on water available with low dam
   IRRWAT_CAPACITY_PUMP   capacity constraint on water available with pump
   MUT_EXCLUSIVE   mutually exclusive constraint
   ACRE_TOTAL(seasons)      acreage to be planted based on water demand;

COST.. TotalCost =E= SUM(choice, BinVar(choice) * CapitalCost(choice)) + PumpOperatingCostVar;
GROSS_REVENUE(seasons)..        GrossRev =E= IrrAcre(seasons)*Revenue;
NET_REVENUE..          GrossRev - TotalCost =E= NetRev;
DEFINE_PUMP_COST..      PumpOperatingCostVar =E= BinVar("PumpChoice")*SUM(seasons, IrrWat(seasons)*PumpOpCost);
IRRWAT_CAPACITY_HIGH(seasons)..      IrrWat(seasons) =L= BinVar("HighDam")*CapHigh;
IRRWAT_CAPACITY_LOW(seasons)..       IrrWat(seasons) =L= BinVar("LowDam")*CapLow;
IRRWAT_CAPACITY_PUMP(seasons)..      IrrWat(seasons) =L= BinVar("PumpChoice")*PumpCap*Days;
MUT_EXCLUSIVE..        SUM(choice, BinVar(choice)) =L= 1;
ACRE_TOTAL(seasons).. IrrAcre(seasons) =E= IrrWat(seasons) / IrrDem(seasons);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL Ch7P1 /ALL/;

* 6. Solve the Model as an LP (relaxed IP)
SOLVE Ch7P1 USING MIP MAXIMIZING NetRev;
