img_height = 64;
img_width = 64;
dimension = img_height * img_width;


prompt= 'Enter the name of Dataset on which you want to test the algorithm? Yale, gtdb, faces96, MUCT, or Grimace: \n';
str = input(prompt,'s');

if(strcmp(str,'Yale'))
    num_e_test = 3;
    num_e_train =12;
    train_size=456;
    test_size=114;
    isrgb=0;
    no_of_classes=38;
    kernel='linear';
elseif(strcmp(str,'gtdb'))
    num_e_test = 3;
    num_e_train =12;
    train_size=600;
    test_size=150;
    isrgb=1;
    no_of_classes=50;
    kernel='linear';
elseif(strcmp(str,'faces96'))
    num_e_test = 4;
    num_e_train =16;
    train_size=1600;
    test_size=400;
    isrgb=1;
    no_of_classes=100;
    kernel='linear';
    img_height = 168;
    img_width = 192;
    dimension = img_height * img_width;
elseif(strcmp(str,'MUCT'))
    num_e_test = 1;
    num_e_train =14;
    train_size=1400;
    test_size=100;
    isrgb=1;
    no_of_classes=100;
    kernel='linear';
elseif(strcmp(str,'Grimace'))
    num_e_test = 4;
    num_e_train =16;
    train_size=288;
    test_size=72;
    isrgb=1;
    no_of_classes=18;
    kernel='linear';
else
    error('Not Found');
end      


%% Load Data
[train_data, test_data] = loadDataset(img_height,img_width,str,isrgb,train_size,test_size,num_e_train,num_e_test);

%% Mean Face
mean_face = mean(train_data, 2);
figure(1);
imagesc(reshape(mean_face, img_height, img_width));
colormap('gray');
title('''Mean'' Face');

%% PCA
Xtr = bsxfun(@minus, train_data, mean_face);
eigfaces=PCA(Xtr,no_of_classes);
eig_indx=size(eigfaces,2);
%% Transform Training Data into weight vector

eigf=eigfaces';
[eigfaces,eig_indx]=BBOEE(eigf,dimension,eig_indx,2,Xtr);
eigfaces=eigfaces(:,1:eig_indx);
Tr = eigfaces'*Xtr;

 
%% Transform Test Data into weight vector
Xte = bsxfun(@minus, test_data, mean_face);
Te = eigfaces'*Xte;

SVM(Tr, Te, num_e_test, num_e_train, train_size, test_size, no_of_classes, kernel);
