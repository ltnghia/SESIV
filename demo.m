clear
clc

addpath(genpath('.'))

dir_img =       'DAVIS2017_TrainVal/JPEGImages/480p';
index_file =    'DAVIS2017_TrainVal/ImageSets/SESSIV/val.txt';
dir_gt_ins =    'DAVIS2017_TrainVal/SESSIV_GT/Video_Instance';
dir_gt_sem=     'DAVIS2017_TrainVal/SESSIV_GT/Semantic';

videos = importdata(index_file);
measures = {'FS', 'JS'};

dir_result = './Result';
dir_mask = './Mask';


exportMatchIOU(dir_result, dir_gt_ins, dir_mask);
[eval, raw_eval] = eval_semantic_result(measures, index_file, dir_mask, dir_gt_ins, dir_result, dir_gt_sem);
JS=mean(eval.JS.mean);
FS=mean(eval.FS.mean);
OS=mean([mean(eval.JS.mean),mean(eval.FS.mean)]);
disp(['JS = ' num2str(JS)]);
disp(['FS = ' num2str(FS)]);
disp(['OS = ' num2str(OS)]);







