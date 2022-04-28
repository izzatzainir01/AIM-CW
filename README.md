## Running the code
1. Open Matlab.
2. Open the correct directory (below the Toolstrip, above the code Editor).
3. Open the `exampleexperiment.m` file.
4. Press `F5` or the Run button in the Toolstrip to run the code.
5. Wait until the code finishes running.
6. Observe the newly created data/overwritten files in the `my_data/` directory.

## Viewing the .csv files
### On MS Excel
1. Simply open any of the `.csv` files with MS Excel.
2. Observe the data.

### On other apps
1. Depending on the app, you may have to remove the first line of every `.csv` file before opening them with your app.
2. If the app has the option to, make sure the delimiter is set to `;` when opening it.
3. Observe the data

## Understanding the .csv files
There are 2 different types of `.csv` files.
- Dimensional results (`FSMapXX.csv`): Each dimensional results file displays the output of the `exampleexperiment.m` after each dimension.
- All results (`FSMapAll.csv`): The all results file displays the output of the entire experiment, including a sum of the total scores of each dimension at the very end.

## Converting to .xlsx
Unfortunately I wasn't able to implement a `.csv` to `.xlsx` converter automatically. Therefore, you would have to convert every `.csv` file one by one.
