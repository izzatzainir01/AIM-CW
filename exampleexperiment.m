% runs an entire experiment for benchmarking MY_OPTIMIZER
% on the noise-free testbed. fgeneric.m and benchmarks.m
% must be in the path of Matlab/Octave
% CAPITALIZATION indicates code adaptations to be made

addpath('./');      % should point to fgeneric.m etc.
datapath = 'data';  % different folder for each experiment
opt.algName = 'Particle Swarm Optimization';
opt.comments = 'PUT MORE DETAILED INFORMATION, PARAMETER SETTINGS ETC';
maxfunevals = '5000'; % 10*dim is a short test-experiment taking a few minutes
                          % INCREMENT maxfunevals successively to larger value(s)
minfunevals = 'dim + 2';  % PUT MINIMAL SENSIBLE NUMBER OF EVALUATIONS for a restart
maxrestarts = 1e4;        % SET to zero for an entirely deterministic algorithm

more off;  % in octave pagination is on by default

t0 = clock;
rand('state', 696969);

for dim = [2,3,5,10,20]  % small dimensions first, for CPU reasons
    data_path = sprintf("my_data/FSMap%02d.csv", dim);
    fileID = fopen(data_path, 'w');
    fprintf(fileID, "Benchmarks;Instance 1;Instance 2;Instance 3;Instance 4;Instance 5;Instance 6;Instance 7;Instance 8;Instance 9;Instance 10;Instance 11;Instance 12;Instance 13;Instance 14;Instance 15;;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores;Scores");
    for ifun = benchmarks('FunctionIndices')  % or benchmarksnoisy(...)
        fprintf(fileID, "\nf%d", ifun);
        for iinstance = [1:15]  % first 15 function instances
            fgeneric('initialize', ifun, iinstance, datapath, opt);

            % independent restarts until maxfunevals or ftarget is reached
            for restarts = 0:maxrestarts
                MY_OPTIMIZER('fgeneric', dim, fgeneric('ftarget'), ...
                    eval(maxfunevals) - fgeneric('evaluations'));
                if fgeneric('fbest') < fgeneric('ftarget') || ...
                        fgeneric('evaluations') + eval(minfunevals) > eval(maxfunevals)
                    break;
                end
            end

            evaluations = fgeneric('evaluations');
            delta_ftarget = fgeneric('fbest') - fgeneric('ftarget');

            % Check if new_data is below 1.00e-14 or above 1.00e+03 and adjust values respectively
            if delta_ftarget < 1.00e-14
                delta_ftarget = 1.00e-14;
            elseif delta_ftarget > 1.00e+03
                delta_ftarget = 1.00e+03;
            end

            fprintf(['f%d in %d-D, instance %d: FEs=%d with %d restarts,' ...
                ' fbest-ftarget=%.4e, elapsed time [h]: %.2f\n'], ...
                ifun, dim, iinstance, ...
                evaluations, ...
                restarts, ...
                delta_ftarget, ...
                etime(clock, t0)/60/60);

            fgeneric('finalize');

            % Write data to data.csv
            fprintf(fileID, ";%.4e", delta_ftarget);
        end
        disp(['      Date and Time: ' num2str(clock, ' %.0f')]);

        % Write formula for scores
        fprintf(fileID, ";");
        for letter = 'B' : 'P'
            fprintf(fileID, ";=FLOOR.XCL(-LOG10(%c%d),1)", letter, ifun + 1);
        end
    end
    fprintf('\n---- DIMENSION %d-D DONE ----\n\n', dim);

    % Get total score
    fprintf(fileID, "\n");
    for letter = 'A' : 'Q'
        fprintf(fileID, ";");
    end
    fprintf(fileID, "Total;=SUM(R2:AF25)");
end
