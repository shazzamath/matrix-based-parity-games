%{
game_graph = [1,0,0,0,0;
              1,0,0,0,0;
              0,1,0,0,0;
              1,1,0,0,0;
              1,0,0,1,0];

priorities = [7,5,3,6,4];
subgame = [1,1,1,1,1];
ownsplit = [0,0,0,1,1];
------------------------------------------
game_graph = [0,0,0,0,1,0,0,1;
              0,0,0,0,0,1,0,0;
              0,0,0,0,0,0,1,1;
              0,0,0,0,0,0,1,0;
              0,1,0,0,0,0,0,1;
              0,0,0,1,1,0,0,0;
              0,0,0,1,0,1,0,0;
              1,0,1,0,0,0,0,0];

priorities = [4,3,6,5,0,2,8,1];
subgame = [1,1,1,1,1,1,1,1];
ownsplit = [0,0,0,0,1,1,1,1];

%}


%{
myDir is the location of the parity games where 1st row is ownership
vector, 2nd row is priority vector, row 3 and 4 make up the values of i
and j such that (i, j) = 1 in the adjacency matrix representation
%}

count = 0;
myDir = "pgsolver_random";	
myFiles = dir(fullfile(myDir,'*.csv'));
num_of_files = length(myFiles);
times = zeros(1,num_of_files);
sizes = zeros(1,num_of_files);
files_done = string(zeros(1,num_of_files));
for k = 1:num_of_files
    baseFileName = myFiles(k).name;
	fullFileName = fullfile(myDir, baseFileName);
    count = count+1;
    disp(count);
    fprintf(1, 'Now reading %s\n', baseFileName);
    
    imp = readmatrix(fullFileName);
    size = nnz(~isnan(imp(1,:)));
    ownsplit = sparse(imp(1,1:size));
    priorities = imp(2,1:size);
    i = imp(3,:);
    j = imp(4,:);
    v = ones(1,length(i));
    game_graph = sparse(i,j,v,size,size);
    subgame = sparse(ones(1, size));
    
    
    
    disp("Running Zielonkas");
    f = @() zielonkas(game_graph, priorities,ownsplit,subgame);
    time_elap = timeit(f);
    disp(time_elap);
    sizes(k) = length(subgame);
    times(k) = time_elap;
    files_done(k) = baseFileName;
    
end

writematrix([files_done;times],'result.csv');