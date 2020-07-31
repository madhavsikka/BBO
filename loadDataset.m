

function [train_mat, test_mat] = loadDataset(img_height, img_width,data_dir_name,isrgb,train_size,test_size,num_e_train,num_e_test)

data_dirs = dir(data_dir_name);
dimension = img_height*img_width;
train_mat = zeros(dimension, train_size);
test_mat = zeros(dimension, test_size);
tr_indx = 0;
test_indx = 0;

s = RandStream('mt19937ar','Seed',0);

for i = 1:numel(data_dirs)
    dir_name = data_dirs(i).name;
    if(strcmp(data_dir_name,'Yale'))
        if (length(dir_name) < 5 || ~strcmp('yaleB', dir_name(1:5)))
            continue;
        end
    else    
        if (length(dir_name) < 1 || ~strcmp('s', dir_name(1:1)))
            continue;
        end
    end    
    img_dir = fullfile(data_dir_name, dir_name);
%     fprintf('%s',img_dir);
    fprintf("%s /n",dir_name);
    if(strcmp(data_dir_name,'MUCT') || strcmp(data_dir_name,'gtdb') || strcmp(data_dir_name,'faces96') || strcmp(data_dir_name,'Grimace'))
        img_list = dir(fullfile(img_dir, '*.jpg'));
    elseif(strcmp(data_dir_name,'ORL'))
        img_list = dir(fullfile(img_dir, '*.pgm'));
    elseif(strcmp(data_dir_name, 'Yale'))
        img_list = dir(fullfile(img_dir, '*.png'));
    else
        fprintf('File Not available')
        break;
    end    
    randnum = randperm(s, (num_e_test + num_e_train), num_e_test);
    for j = 1:(num_e_test + num_e_train) 
        img_name = img_list(j).name;
        image_read=imread(fullfile(img_dir, img_name));
        im = imresize(image_read, [img_height, img_width]);
        if(isrgb==1)
            im=rgb2gray(im);
        end
        img = reshape(double(im), dimension, 1);
        if (find(randnum == j))
         test_indx = test_indx + 1;
         test_mat(:, test_indx) = img;
        else
         tr_indx = tr_indx + 1;
         train_mat(:, tr_indx) = img;
        end
    end
end

end

