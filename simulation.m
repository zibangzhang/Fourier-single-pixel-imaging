% Initialized: 2013/10/28 by Zibang Zhang
% Rev 1: 2015/1/22 by Zibang Zhang
% Rev 2: 2016/6/23 by Zibang Zhang
% Rev 3: 2016/12/25 by Zibang Zhang
% Rev 4: 2018/07/10 by Zibang Zhang

%% simulating single-pixel imaging with phase-shifting sinusoid illumination
close all
clear all
clc
TimeStamp = datestr(now, 'YYmmDD_HHMMSS');

%% SWITCH
SW_NOISE = 0;                                                              % 0: noiseless, 1: noisy

%% Parameters
nStepPS = 4;                                                               % n-step phase-shifting
Phaseshift = 90;                                                           % phase shift
Amplitude = 1;                                                             % amplitude of sin. pattern
SpectralCoverage = 0.2;                                                      % e.g. sampling ratio
SamplingPath = 'circular';                                                  % sprial, diamond, circular

% Get input image
[imgFile pathname] = uigetfile({'*.bmp;*.jpg;*.tif;*.png;*.gif'','...
    'All Image Files';'*.*','All Files'});                                 
InputImg = im2double(imread([pathname imgFile]));    
figure,imshow(InputImg);title('Input image'); axis image;                

[mRow, nCol] = size(InputImg);                                           

[fxMat, fyMat] = meshgrid([0:1:nCol-1]/nCol, [0:1:mRow-1]/mRow);           % generate coordinates in Fourier domain (not neccessary)
fxMat = fftshift(fxMat);                                                   
fyMat = fftshift(fyMat);                                                   

OrderMat = getOrderMat(mRow, nCol, SamplingPath);                              % generate sampling path in Fourier domain
[nCoeft,tmp] = size(OrderMat);                                            
nCoeft = round(nCoeft * SpectralCoverage);                                

InitPhaseArr = getInitPhaseArr(nStepPS, Phaseshift);                       
IntensityMat = zeros(mRow, nCol, nStepPS);                                 

RealFourierCoeftList = getRealFourierCoeftList(mRow, nCol);                

if SW_NOISE
    ReponseNoise = rand(nCoeft * nStepPS) * 2;                             % add noise
end

%% Main loop for simulating time-varying patterns illumiantion and single-pixel detection
tic;                                                                       
                                                                           
for iCoeft = 1:nCoeft                                                      
    iRow = OrderMat(iCoeft,1);                                             
    jCol = OrderMat(iCoeft,2);                                             
    
    fx = fxMat(iRow,jCol);                                                 
    fy = fyMat(iRow,jCol);                                                 

    IsRealCoeft = existVectorInMat( [iRow jCol], RealFourierCoeftList );   
    
     for iStep = 1:nStepPS;                                                
        if IsRealCoeft == 1 && iStep > 2                                   
            if nStepPS == 3                                                
                IntensityMat(iRow,jCol,iStep) = IntensityMat(iRow,jCol,2); 
            end
            if nStepPS == 4                                                
                IntensityMat(iRow,jCol,iStep) = 0;                         
            end
            continue;                                                      
        end
        
        [ Pattern ] = getFourierPattern( Amplitude, mRow, nCol, fx, fy, InitPhaseArr(iStep) );
        
        IntensityMat(iRow, jCol, iStep) = sum(sum(InputImg .* Pattern));
    end
end

toc;                                                                     

%% Show and save results
[img, spec] = getFSPIReconstruction( IntensityMat, nStepPS, Phaseshift );  

figure, imshow(img); caxis([0 1]); axis image; colormap gray; title('Reconstructed Img');
figure, specshow(spec);                                                     % show Fourier spectrum in a log scale

PSNR = psnr(img, InputImg);                                                
SSIM = ssim(img, InputImg);
RMSE = rmse(InputImg, img);

fprintf('PNSR = %f\nSSIM = %f\nRMSE = %f\n', PSNR, SSIM, RMSE);

%% Saving results
ErrorImg = InputImg - img;                                                           
figure, imagesc(ErrorImg); axis image; colormap jet; colorbar; title('error image'); 

TrueSpec = fftshift(fft2(InputImg));                                       

SpecAbsDiff = abs(spec) - abs(TrueSpec);                                   
SpecRealDiff = real(spec) - real(TrueSpec);                                
SpecImagDiff = imag(spec) - imag(TrueSpec);                                

figure, imagesc(SpecAbsDiff); axis image; colormap jet; title('spec abs diff'); colorbar;   
figure, imagesc(SpecRealDiff); axis image; colormap jet; title('spec real diff'); colorbar;
figure, imagesc(SpecImagDiff); axis image; colormap jet; title('spec imag diff'); colorbar;

ResultFolderName = sprintf('[%s]FSI_Simulation_mRow=%d_nCol=%d_nStep=%d_PS=%d', TimeStamp, mRow, nCol, nStepPS, Phaseshift);

mkdir(ResultFolderName);
ResultFileName = 'results.mat';
ResultFilePath = fullfile(ResultFolderName, ResultFileName);
save(ResultFilePath);