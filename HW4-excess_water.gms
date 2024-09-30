$ontext
CEE 6410 - Water Resources Systems Analysis
Chapter 2 Problem #3 from Bishop et all 1999

THE PROBLEM:

Direct quote from textbook:

"An aqueduct constructed to supply water to industrial users has an excess capacity in the
months of June, July, and August of 14,000 acft, 18,000 acft, and 6,000 acft, respectively.
It is proposed to develop not more than 10,000 acres of new land by utilizing the excess
aqueduct capacity for irrigation water deliveries. Two crops, hay and grain, are to be
grown. Their monthly water requirements and expected net returns are given in the following table:"

                Monthly Water Requirement (acre-ft/acre)
        June        July        August      Return($/acre)
Hay     2           1           1           $100
Grain   1           2           0           $120

Determine how many acres of each crop to plant in order to maximize monetary returns.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Patrick Archibald
A02268222@usu.edu
September 30, 2024
$offtext

* 1. DEFINE the SETS
SETS crops crops to choose from /Hay, Grain/
     resources water in each month and land /WaterJune, WaterJuly, WaterAugust, Land/;

* 2. DEFINE input data
PARAMETERS
   c(crops) Objective function values for each crop ($ per acre)
         /Hay 100,
         Grain 120/
   b(resources) Constraint totals (acre-ft per month on water and acres for land)
          /WaterJune 14000,
           WaterJuly  18000,
           WaterAugust 6000,
           Land 10000/;

TABLE A(crops,resources) Coefficients here. Crops on each row and resources in columns.
                 WaterJune      WaterJuly       WaterAugust     Land
 Hay                2               1               1             1
 Grain              1               2               0             1;

* 3. DEFINE the variables
VARIABLES X(crops) acres planted
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($). This is the objective function value
   RES_CONSTRAIN(resources) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(crops,c(crops)*X(crops));
RES_CONSTRAIN(resources) ..    SUM(crops,A(crops,resources)*X(crops)) =L= b(resources);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
