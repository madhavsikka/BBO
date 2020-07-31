

function W_pca = PCA(X, NumberClasses)

TotalImages = size(X, 2);
ClassSize = TotalImages / NumberClasses;   % Number of images per individual
Eigenvectors = TotalImages - NumberClasses; % no. of Eigenvectors required after PCA
DiscriminantVectors = (Eigenvectors - 1); % no. of final eigenvalues required 



% L is the surrogate of covariance matrix C = X * X'
L = X' * X;

% Diagonal elements of D are the eigenvalues for both L = X' * X and best K eigenvalues of C = X * X'
[V, D] = eig(L);

% Flip left-right to place largest eigenvalues in the leftmost column
V = fliplr(V);
D = fliplr(D);

%%Eliminating eigenvectors with small eigenvalues


L_eig_vec = V(:, 1 : Eigenvectors);

%% Calculating the eigenvectors of covariance matrix 'L' it will be equal to the top K eienvectors of C 
V_PCA = X * L_eig_vec;


%%Projecting image onto new eigenspace
P_PCA = V_PCA' * X;

%% Calculating the mean of each class in the new eigenspace
m_PCA = mean(P_PCA, 2); % Total mean in eigenspace
m = zeros(Eigenvectors,NumberClasses);
Sw = zeros(Eigenvectors,Eigenvectors); % ;Initialization of Within Scatter Matrix
Sb = zeros(Eigenvectors,Eigenvectors); % Initialization of Between Scatter Matrix

for i = 1 : NumberClasses
    m(:,i) = mean( ( P_PCA(:,((i-1)*ClassSize+1):i*ClassSize) ), 2 )';

    S  = zeros(Eigenvectors,Eigenvectors);
    for j = ( (i-1)*ClassSize+1 ) : ( i*ClassSize )
        S = S + (P_PCA(:,j)-m(:,i))*(P_PCA(:,j)-m(:,i))';
    end

    Sw = Sw + S; % Calculating Within Scatter Matrix
    Sb = Sb + (m(:,i)-m_PCA) * (m(:,i)-m_PCA)'; %Calculating Between Scatter Matrix
end

%%%%%%%%%%%%%%%%%%%%%%%% Calculating Fisher discriminant basis's
% We want to maximize the Between Scatter Matrix, while minimising the
% Within Scatter Matrix. Thus, a cost function J is defined, so that this condition is satisfied.
[J_eig_vec, J_eig_val] = eig(Sb,Sw); % Cost function J = inv(Sw) * Sb

J_eig_vec = fliplr(J_eig_vec);

%%%%%%%%%%%%%%%%%%%%%%%% Eliminating zero eigens and sorting in descend order
V_Fisher = J_eig_vec(:, 1 : DiscriminantVectors);

% compute final projection matrix
W_pca = V_PCA * V_Fisher;