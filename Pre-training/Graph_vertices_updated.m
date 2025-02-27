%The graph vertex update module is carried out using the BCT toolkit, and the relevant functions are shown in https://github.com/brainlife/BCT/tree/main/BCT
for st=0:50
    A = load(['./floyd' num2str(100-st) '_' num2str(st) '.mat'])
    matrix = A.Z;
    for op=1:161
        new_matrix=zeros(164,164);
        for i=1:164
            for j=1:164
                if matrix(op,i,j) <= 0
                    new_matrix(i,j) = 0;
                else
                    new_matrix(i,j) = matrix(op,i,j);
                end
            end
        end
        save(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'], 'new_matrix');
    end
end

% Get the feature path
L_tree_real = {};
for st=0:50
    for op=1:161
        B = load(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat']);
        D=distance_bin(B.W);  % Call distance_bin.m to get the distance matrix
        [lambda,efficiency,ecc,radius,diameter] = charpath(D,0,1);  % Call CHARPATH.m to calculate the feature path length
        L_real = lambda; % Obtain the feature path length
        L_tree_real{end+1} = num2str(L_real); 
        save(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'], 'L_real');
    end
end

% The clustering coefficient is obtained
for st=0:50
    for op=1:161
        A = load(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat']);  % Loads the matrix with the spurious connections removed
        W = weight_conversion(A.new_matrix, 'binarize'); % A weighted matrix is obtained
        save(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'],'W');

        B = load(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat']);
        C = clustering_coef_wu(B.W);  % Calculate the clustering coefficient
 
        C_real = mean(C);

        C_tree_real{end+1} = num2str(C_real); 
        C_tree{end+1} = num2str(C);   

      save(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'], 'C');
      save(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'],'C_real')
    end
   
end

% Get the small world coefficient
for st=0:50
    Smallworld = {}
    for op=1:161
        C_real=load(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'])
        L_real=load(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'])
        MATRIX = load(['./floyd' num2str(100-st) '_' num2str(st) '_' num2str(op) '.mat'], 'new_matrix');
        randMI = randmio_und_signed(MATRIX.new_matrix,1);
        randW = weight_conversion(randMI, 'binarize');
        C = clustering_coef_wu(randW)
        C_rand = mean(C)
        D=distance_bin(randMI)
        [lambda,efficiency,ecc,radius,diameter] = charpath(D,0,1);
        L_rand = lambda;
        CC_real=C_real.C_real(1,1)
        LL_real=L_real.L_real(1,1)
        Sw=(CC_real/C_rand)/(LL_real/L_rand)
        Smallworld{end+1}=num2str(Sw)
    end
    save(['./floyd' num2str(100-st) '_' num2str(st) '.mat'], 'Smallworld');
end