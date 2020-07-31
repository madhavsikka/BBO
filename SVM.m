function [predictedLabel, accuracyPercentage] = SVM(Tr, Te, num_e_test, num_e_train, train_size, test_size, no_of_classes, kernel)

X_train = Tr';
X_test = Te';

for i=1:test_size
   label_te(i) = ceil(i/num_e_test);
end

for i=1:train_size
   label_tr(i) = ceil(i/num_e_train); 
end


SVMModel = cell(no_of_classes,1);
label = zeros(no_of_classes,test_size);

trainingClassLabelsMatrix = full(ind2vec(label_tr,no_of_classes));

for index=1:no_of_classes
    SVMModel{index} = fitcsvm(X_train,trainingClassLabelsMatrix(index,:),'KernelFunction',kernel, 'Standardize',true);
end

%predict values
for index=1:no_of_classes
    label(index,:) = predict(SVMModel{index},X_test);
end

%transform into index
predictedLabel=vec2ind(label);

%calculate accuracy
accuracy = sum(label_te == predictedLabel)/length(label_te);
accuracyPercentage = 100*accuracy;
fprintf('Accuracy = %f%%\n',accuracyPercentage)

end