$ontext
CEE 6410 - Water Resources Systems Analysis
Homework 5 - Reservoir Operation

THE PROBLEM:

A reservoir is designed to be used for hydropower and irrigation. At least 1 unit of water needs to
be in the river in each month at point A (end of the system). Hydropower turbines have a capacity of
4 units of water per month and other releases bypass the turbines. There is no upper limit on usable
irrigation water. The reservoir has a capacit of 9 units of water, with an initial storage of 5 units.
The ending storage must be equal to or greater than the beginning storage. Benefits per unit of water
and average inflows to the reservoir are shown below.

Month       Inflow Units        Hydropower Benefits ($/unit)      Irrigation Benefits ($/unit)
1               2                       1.6                                 1.0
2               2                       1.7                                 1.2
3               3                       1.8                                 1.9
4               4                       1.9                                 2.0
5               3                       2.0                                 2.2
6               2                       2.0                                 2.2


Patrick Archibald
A02268222@usu.edu
October 4, 2024
$offtext

* 1. DEFINE the SETS
SET months time component for duration of the model / Month1, Month2, Month3,
                                                      Month4, Month5, Month6 /;

* 2. DEFINE input data
PARAMETERS
   inflow(months) inflow values (units per month)
          /Month1 2, Month2 2, Month3 3,
           Month4 4, Month5 3, Month6 2/
   hb(months) hydrobenefits (dollars per unit)
          /Month1 1.6, Month2 1.7, Month3 1.8,
           Month4 1.9, Month5 2.0, Month6 2.0/
   ib(months) irrigation benefits (dollars per unit)
          /Month1 1.0, Month2 1.2, Month3 1.9,
           Month4 2.0, Month5 2.2, Month6 2.2/
   storageInitial / 5 /;

* 3. DEFINE the variables
VARIABLES storage(months) units left in reservoir for storage in each month (number)
          hydro(months) units used for hydropower in each month (number)
          spill(months) units spilling from reservoir and by passing hydropower (number)
          irr(months) units of water used for irrigation in each month (number)
          flowA(months) units of water in the river at A in each month (number)
          profitfunction objective function ($);

* Non-negativity constraints
POSITIVE VARIABLES storage, hydro, spill
                   irr, flowA;

* 4. COMBINE variables and data in equations
EQUATIONS
   ObjectiveFunction objective function
   M1Storage mass balance in month 1
   M2toM6BalanceStorage mass balance of reservoir months 2-6
   ResConstraint constraint on reservoir capacity
   HydroConstraint constraint on hydropower capacity
   IrrigationDiversion inflows to diversion equal outflows from diversion
   RiverAtAConstraint constraint on water in river at A
   EndStorage constraint on reservoir storage at simulation end;

ObjectiveFunction..                 profitfunction =E= SUM(months,hb(months)*hydro(months))+
                                                       SUM(months,ib(months)*irr(months));
M1Storage..                         storage("Month1") =E= storageInitial + inflow("Month1")
                                                          - spill("Month1") - hydro("Month1");
M2toM6BalanceStorage(months)$(ord(months) > 1)..        storage(months) =E= storage(months-1) +
                                                        inflow(months) - spill(months) - hydro(months);

ResConstraint(months)..             storage(months) =L= 9;
HydroConstraint(months)..           hydro(months) =L= 4;
IrrigationDiversion(months)..       hydro(months) + spill(months) =E= irr(months) + flowA(months);
RiverAtAConstraint(months)..        flowA(months) =G= 1;

EndStorage..                        storage("Month6") =G= storageInitial;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL RESPROBLEM /ALL/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE RESPROBLEM USING LP MAXIMIZING profitfunction;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
