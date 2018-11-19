# CCM analyses

1. Use [SeasonalSplines.R](SeasonalSplines.R) to generate the seasonality file for all climate variables.
2. Run [CCMSplines.R](CCMSplines.R) with original data and seasonality files as inputs to perform the CCM analyses with surrogates for each variable against the number of expected cases as a function of time for prediction (tp). Note that this function also uses `make_pred_nozero.R`.
3. After completing the results with different times for prediction (tp, `TimeForPred` parameter) and establishing the appropriate lag for each variable, run [CCMCoefficients.R](CCMCoefficients.R).
This result will show the interaction strength for each driver variable.
